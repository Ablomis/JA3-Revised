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

function GetAvailableComponents(unit, slot, weapon)
    local mod_list = {}
    unit:ForEachItemInSlot("Inventory", function(item)
        if item:IsKindOf("WeaponMod") and item.Slot==slot then
            table.insert(mod_list, item)
        end
      end,mod_list)
      return mod_list
end

function FindWeaponReloadTarget(item, ammo)
    if not IsKindOfClasses(ammo, "Ammo", "Ordnance","Mag") or not IsKindOf(item, "Firearm") then
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
    if IsKindOf(ammoForWeapon, "Ammo", "Ordnance") then 
        anyAmmo = 0 < #ammoForWeapon
        onlyAmmoIsCurrent = weapon.ammo and #ammoForWeapon == 1 and ammoForWeapon[1].class == weapon.ammo.class
    elseif IsKindOf(ammoForWeapon, "Mag") then
        anyAmmo = 0 < ammoForWeapon.ammo.Amount
        onlyAmmoIsCurrent = weapon.ammo and ammoForWeapon.ammo.Amount == 1 and ammoForWeapon.ammo.class == weapon.ammo.class
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
    --if(self.ammo) then prev_ammoAmount = self.ammo.Amount
    --else prev_ammoAmount = 0
    --end
    local prev_id = self.ammo and self.ammo.class
    local add = 0
    local change
    if true then 
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
    elseif IsKindOf(ammo, "Mag") then
        if self.ammo and prev_id == ammo.ammo.class then
            add = Max(0, Min(ammo.ammo.Amount, self.MagazineSize - self.ammo.Amount))
            self.ammo.Amount = self.ammo.Amount + add
            ammo.ammo.Amount = ammo.ammo.Amount - add
            change = 0 < add
            ObjModified(self)
            return false, false, change
        else
            change = true
            if ammo.ammo and 0 < ammo.ammo.Amount then
                --add = Min(ammo.ammo.Amount, self.MagazineSize)
                --local item = PlaceInventoryItem(ammo.class)
                --ammo.ammo.Amount = ammo.Amount - add
                self.ammo = ammo.ammo.Amount
                self.ammo.Amount = add
                ammo.ammo = prev_ammo
                ammo.ammo.Amount = prev_ammoAmount
            end
            self:RemoveModifiers("ammo")
            for _, mod in ipairs(self.ammo.Modifications) do
                self:AddModifier("ammo", mod.target_prop, mod.mod_mul, mod.mod_add)
            end
        end
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
  