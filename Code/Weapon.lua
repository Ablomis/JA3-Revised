--function FirearmBase:GetAccuracy(distance, unit, action)
--    local base_accuracy = self.AimAccuracy
--    local k
--    k = (100 - base_accuracy)/(0.0001*self.WeaponRange^3)
--    local accuracy = round(100 - 0.0001 * k * ((distance/1000)^3),1)
--  return accuracy
--end
function FindWeaponUpgradeTarget(item, mod)
    if not IsKindOfClasses(mod, "WeaponMod") or not IsKindOf(item, "Firearm") then
      return false
    end
    return item
end
function IsWeaponAvailableForUpgrade(weapon, modForWeapon)
    for _, slot in ipairs(weapon.ComponentSlots) do
        if(slot.SlotType == modForWeapon.Slot) then
            return true
        end
    end
    return false
end
function IsWeaponUpgradeTarget(drag_item, target_item)
    local target = FindWeaponUpgradeTarget(target_item, drag_item)
    return target and IsWeaponAvailableForUpgrade(target, drag_item)
end

function GetAvailableComponents(unit, slot, available_components)
    local mod_list = {}
    unit:ForEachItemInSlot("Inventory", function(item)
        if item:IsKindOf("WeaponMod") and item.Slot==slot then
            for k,v in pairs(available_components) do
                if(v==item.Name) then
                    table.insert(mod_list, item)  
                end   
            end
        end
      end,mod_list)
      return mod_list
end

function FindWeaponReloadTarget(item, ammo)
    if not IsKindOfClasses(ammo, "Ammo", "Ordnance","Mag") or not IsKindOf(item, "Firearm") then
      return false
    end
    if IsKindOfClasses("Mag") and not item.Platform == ammo.Platform then
      return false
    end
    if item.Caliber == ammo.Caliber then
      return item
    end
    
    local sub = item:GetSubweapon("Firearm")
    if sub then
      return sub.Caliber == ammo.Caliber and sub
    end
  end
  function IsWeaponReloadTarget(drag_item, target_item)
    local target = FindWeaponReloadTarget(target_item, drag_item)
    return target and IsWeaponAvailableForReload(target, {drag_item})
  end
  function IsWeaponAvailableForReload(weapon, ammoForWeapon)
    if not ammoForWeapon or not IsKindOf(weapon, "Firearm") then
      return false
    end
    local anyAmmo
    local onlyAmmoIsCurrent
    if IsKindOfClasses(ammoForWeapon[1], "Ammo", "Ordnance") then 
        anyAmmo = 0 < #ammoForWeapon
        onlyAmmoIsCurrent = weapon.ammo and #ammoForWeapon == 1 and ammoForWeapon[1].class == weapon.ammo.class
    elseif IsKindOfClasses(ammoForWeapon[1], "Mag") then
        return true
    end
    local fullMag = weapon.ammo and weapon.ammo.Amount == weapon.MagazineSize
    if fullMag then
      if onlyAmmoIsCurrent or not anyAmmo then
        return false, AttackDisableReasons.FullClip
      else
        return true, AttackDisableReasons.FullClipHaveOther
      end
    elseif not anyAmmo then
      return false, AttackDisableReasons.NoAmmo
    end
    return true
  end
  function Firearm:Reload(ammo, suspend_fx, delayed_fx)
    local prev_ammo = self.ammo
    local prev_ammoAmount
    if(self.ammo) then prev_ammoAmount = self.ammo.Amount
    else prev_ammoAmount = 0
    end
    local prev_id = self.ammo and self.ammo.class
    local add = 0
    local change
    if not IsKindOfClasses(ammo, "Mag") then 
        if self.ammo and prev_id == ammo.class then
            add = Max(0, Min(ammo.Amount, self.MagazineSize - self.ammo.Amount))
            self.ammo.Amount = self.ammo.Amount + add
            ammo.Amount = ammo.Amount - add
            change = 0 < add
            ObjModified(self)
            return false, false, change
        else
            change = true
            if ammo and 0 < ammo.Amount then
                add = Min(ammo.Amount, self.MagazineSize)
                local item = PlaceInventoryItem(ammo.class)
                ammo.Amount = ammo.Amount - add
                self.ammo = item
                self.ammo.Amount = add
            end
            self:RemoveModifiers("ammo")
            for _, mod in ipairs(self.ammo.Modifications) do
                self:AddModifier("ammo", mod.target_prop, mod.mod_mul, mod.mod_add)
            end
        end
    elseif IsKindOfClasses(ammo, "Mag") then
        self.ammo = ammo.ammo
        if(self.ammo) then self.ammo.Amount = ammo.Amount end
        ammo.Amount = prev_ammoAmount
        ammo.ammo = prev_ammo
        self:RemoveModifiers("ammo")
        if(self.ammo) then
            for _, mod in ipairs(self.ammo.Modifications) do
                self:AddModifier("ammo", mod.target_prop, mod.mod_mul, mod.mod_add)
            end
        end
        ObjModified(self)
    end
    if not suspend_fx then
      CreateGameTimeThread(function(obj, delayed_fx)
        if delayed_fx then
          Sleep(InteractionRand(500, "ReloadDelay"))
        end
        if GetMercInventoryDlg() then
          PlayFX("WeaponLoad", "start", not obj.object_class and obj.weapon and obj.weapon.object_class, obj.class)
        else
          local vo = obj:GetVisualObj()
          local actor_class = vo.fx_actor_class
          vo.fx_actor_class = self.class
          PlayFX("WeaponReload", "start", vo)
          vo.fx_actor_class = actor_class
        end
      end, self, delayed_fx)
    end
    ObjModified(self)
    return prev_ammo, not suspend_fx, change
  end

  function Firearm:GetAreaAttackParams(action_id, attacker, target_pos, step_pos, stance)
    local params = {
      attacker = attacker,
      weapon = self,
      target_pos = target_pos,
      step_pos = step_pos,
      used_ammo = 1,
      damage_mod = 100,
      attribute_bonus = 0,
      dont_destroy_covers = true
    }
    if attacker then
      params.step_pos = step_pos or not attacker:IsValidPos() or GetPassSlab(attacker) or attacker:GetPos()
      params.stance = stance or attacker.stance
    end
    if action_id == "Buckshot" or action_id == "DoubleBarrel" or action_id == "BuckshotBurst" or action_id == "CancelShotCone" then
      if attacker then
        params.attribute_bonus = MulDivRound(const.Combat.BuckshotAttribBonus, attacker.Marksmanship, 100)
      end
      params.falloff_start = self.BuckshotFalloffStart
      params.falloff_damage = self.BuckshotFalloffDamage
      params.cone_angle = self.BuckshotConeAngle
      params.min_range = self.WeaponRange
      params.max_range = self.WeaponRange
    elseif action_id == "EyesOnTheBack" then
      local effect = attacker:GetStatusEffect("EyesOnTheBack")
      params.cone_angle = effect and effect:ResolveValue("cone_angle") * 60
      params.min_range = self:GetOverwatchConeParam("MinRange")
      params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "Overwatch" then
      params.cone_angle = self.OverwatchAngle
      params.min_range = self:GetOverwatchConeParam("MinRange")
      params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "MGRotate" or action_id == "MGSetup"  then
        params.cone_angle = self.OverwatchAngle*1
        params.min_range = self:GetOverwatchConeParam("MinRange")
        params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "SniperRotate" or action_id == "SniperSetup" then
        params.cone_angle = self.OverwatchAngle*2
        params.min_range = self:GetOverwatchConeParam("MinRange")
        params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "BulletHell" or action_id == "DanceForMe" then
      params.cone_angle = self.OverwatchAngle
      params.min_range = self:GetOverwatchConeParam("MinRange")
      params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "FireFlare" then
      params.min_range = self.ammo and self.ammo.AreaOfEffect or 0
      params.max_range = self.ammo and self.ammo.AreaOfEffect or 0
    end
    return params
  end

  function Firearm:GetOverwatchConeParam(param)
    if param == "Angle" then
      return self.OverwatchAngle
    elseif param == "MinRange" then
      return IsKindOfClasses(self, "Shotgun", "MachineGun","SniperRifle") and self.WeaponRange or 2
    elseif param == "MaxRange" then
      return IsKindOfClasses(self, "Shotgun", "MachineGun","SniperRifle") and self.WeaponRange or MulDivRound(self.WeaponRange, 75, 100)
    end
  end

  function GetBulletCount(weapon)
    if IsKindOf(weapon, "Firearm") then
      if weapon.emplacement_weapon then
        return false
      end
      return weapon.ammo and weapon.ammo.Amount or 0
    elseif IsKindOfClasses(weapon, "Grenade", "StackableMeleeWeapon") then
      return weapon.Amount or 0
    elseif IsKindOf(weapon, "Mag") then
      return weapon.Amount or 0
    else
      return false
    end
  end

  