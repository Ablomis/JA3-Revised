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

  function Firearm:GetDamageFromAmmo()
    local ammo = self.ammo or false
    if(ammo) then
      local bullet_energy = 0.5 * ammo.Mass * (MulDivRound(ammo.BaseVelocity,self.BarrelLengthMod,100)^2) /1000
      return round(bullet_energy * const.Combat.EnergyToDamageCoef + 0.5,1)
    else
      return self.Damage
    end
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
        params.attribute_bonus = MulDivRound(const.Combat.BuckshotAttribBonus, attacker.Marksmanship/2, 100)
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

  local compile_ignore_colliders = function(killed_colliders, colliders)
    if #(killed_colliders or empty_table) == 0 then
      return colliders
    end
    local list = table.icopy(killed_colliders)
    if IsValid(colliders) then
      table.insert_unique(list, colliders)
    else
      for _, obj in ipairs(colliders) do
        table.insert_unique(list, obj)
      end
    end
    return list
  end

  function Firearm:GetAttackResults(action, attack_args)
    local attacker = attack_args.obj
    local anim = attack_args.anim
    local prediction = attack_args.prediction
    local lof_idx = table.find(attack_args.lof, "target_spot_group", attack_args.target_spot_group or "Torso")
    local lof_data = attack_args.lof and attack_args.lof[lof_idx or 1]
    local target = attack_args.target or lof_data.target_pos
    local target_pos = not lof_data.target_pos and IsValid(target) and target:GetPos()
    if target_pos and not target_pos:IsValidZ() then
      target_pos = target_pos:SetTerrainZ()
    end
    local target_unit = IsKindOf(target, "Unit") and target
    local aoe_target_pos = target_unit and target_unit:GetPos() or target_pos
    local num_shots = attack_args.num_shots or 0
    local aoe_params = attack_args.aoe_action_id and self:GetAreaAttackParams(attack_args.aoe_action_id, attacker, aoe_target_pos, attack_args.step_pos)
    local consumed_ammo = attack_args.consumed_ammo
    if not consumed_ammo then
      consumed_ammo = 1
      consumed_ammo = Max(consumed_ammo, num_shots)
      consumed_ammo = Max(consumed_ammo, aoe_params and aoe_params.used_ammo or 0)
    end
    if action.id == "BulletHell" then
      target_pos = attack_args.step_pos + SetLen2D((target_pos - attack_args.step_pos):SetZ(0), aoe_params.max_range * const.SlabSizeX)
      if not target_pos:IsValidZ() then
        target_pos = target_pos:SetTerrainZ()
        target = target_pos
      end
    end
    local shot_attack_args = table.copy(attack_args)
    shot_attack_args.num_shots = num_shots
    shot_attack_args.target_pos = target_pos
    shot_attack_args.target_spot_group = shot_attack_args.target_spot_group or target_unit and g_DefaultShotBodyPart
    shot_attack_args.aim = shot_attack_args.aim or 0
    shot_attack_args.damage_bonus = shot_attack_args.damage_bonus or 0
    shot_attack_args.cth_loss_per_shot = shot_attack_args.cth_loss_per_shot or 0
    shot_attack_args.stealth_kill_chance = shot_attack_args.stealth_kill_chance or 0
    shot_attack_args.stealth_bonus_crit_chance = shot_attack_args.stealth_bonus_crit_chance or 0
    shot_attack_args.prediction = prediction
    shot_attack_args.occupied_pos = shot_attack_args.occupied_pos or attacker:GetOccupiedPos()
    shot_attack_args.can_use_covers = false
    shot_attack_args.output_collisions = true
    shot_attack_args.additional_colliders = target
    shot_attack_args.require_los = nil
    local fired, jammed, condition, ammo_type = self:PrecalcAmmoUse(attacker, consumed_ammo, prediction)
    if type(fired) == "number" and 0 < num_shots then
      num_shots = fired
      shot_attack_args.num_shots = fired
    end
    local cth, baseCth, modifiers
    local cth_action = shot_attack_args.used_action_id and CombatActions[shot_attack_args.used_action_id] or action
    if action.AlwaysHits then
      cth = 100
    elseif attack_args.chance_to_hit then
      cth, modifiers = attack_args.chance_to_hit, attack_args.chance_to_hit_modifiers
    else
      cth, baseCth, modifiers = attacker:CalcChanceToHit(target, cth_action, shot_attack_args)
    end
    local attack_results = {
      weapon = self,
      fired = fired,
      jammed = jammed,
      condition = condition,
      chance_to_hit = cth,
      chance_to_hit_modifiers = modifiers,
      stealth_attack = shot_attack_args.stealth_attack,
      stealth_kill_chance = shot_attack_args.stealth_kill_chance,
      attack_roll = shot_attack_args.attack_roll,
      crit_roll = shot_attack_args.crit_roll,
      ammo_type = ammo_type,
      aim = shot_attack_args.aim,
      dmg_breakdown = shot_attack_args.damage_breakdown and {} or false
    }
    if not shot_attack_args.opportunity_attack_type or HasPerk(attacker, "OpportunisticKiller") then
      attack_results.crit_chance = attacker:CalcCritChance(self, target, shot_attack_args.aim, shot_attack_args.step_pos, shot_attack_args.target_spot_groupt) + shot_attack_args.stealth_bonus_crit_chance
    else
      attack_results.crit_chance = 0
    end
    if prediction then
      if shot_attack_args.multishot then
        attack_results.attack_roll = {}
        attack_results.crit_roll = {}
        for i = 1, num_shots do
          attack_results.attack_roll[i] = 0
          attack_results.crit_roll[i] = 101
        end
      else
        attack_results.attack_roll = 0
        attack_results.crit_roll = 101
      end
      if 0 < shot_attack_args.stealth_kill_chance then
        shot_attack_args.stealth_kill_roll = 101
      end
    else
      if shot_attack_args.multishot then
        if type(attack_results.attack_roll) ~= "table" then
          attack_results.attack_roll = {}
          for i = 1, num_shots do
            attack_results.attack_roll[i] = 1 + attacker:Random(100)
          end
        end
        if type(attack_results.crit_roll) ~= "table" then
          attack_results.crit_roll = {}
          for i = 1, num_shots do
            attack_results.crit_roll[i] = 1 + attacker:Random(100)
          end
        end
      else
        attack_results.attack_roll = shot_attack_args.attack_roll or 1 + attacker:Random(100)
        attack_results.crit_roll = shot_attack_args.crit_roll or 1 + attacker:Random(100)
      end
      if 0 < shot_attack_args.stealth_kill_chance then
        shot_attack_args.stealth_kill_roll = shot_attack_args.stealth_kill_roll or 1 + attacker:Random(100)
      end
    end
    local step_pos3D = shot_attack_args.step_pos:IsValidZ() and shot_attack_args.step_pos or shot_attack_args.step_pos:SetTerrainZ()
    local distAttackerToTarget = step_pos3D:Dist(target_pos)
    local dispersion = self:GetMaxDispersion(distAttackerToTarget)
    local max_range = shot_attack_args.range
    max_range = max_range or Max(MulDivRound(self.WeaponRange, 150, 100), 20) * const.SlabSizeX
    max_range = Max(max_range, distAttackerToTarget + const.SlabSizeX)
    if not prediction then
      max_range = Max(max_range, 100 * const.SlabSizeX)
    end
    shot_attack_args.range = max_range
    local kill
    local roll = attack_results.attack_roll
    local miss, crit
    if shot_attack_args.multishot then
      miss, crit = true, false
    else
      crit = attack_results.crit_roll <= attack_results.crit_chance
      miss = roll > attack_results.chance_to_hit
    end
    local target_hit = false
    local out_of_range = true
    local num_hits, total_damage, friendly_fire_dmg, hit_objs = 0, 0, 0, {}
    local unit_damage = {}
    if not miss and 0 < shot_attack_args.stealth_kill_chance then
      kill = shot_attack_args.stealth_kill_roll <= shot_attack_args.stealth_kill_chance
    end
    local shot_lof_data = shot_attack_args.lof and shot_attack_args.lof[1]
    attack_results.step_pos = shot_lof_data and shot_lof_data.step_pos or shot_attack_args.step_pos
    attack_results.lof_pos1 = shot_lof_data and shot_lof_data.lof_pos1 or attack_results.step_pos
    attack_results.attack_pos = shot_lof_data and shot_lof_data.attack_pos or attack_results.step_pos
    attack_results.shots = {}
    attack_results.hit_objs = hit_objs
    attack_results.stealth_kill = kill
    attack_results.clear_attacks = 0
    local sfHit = 65536
    local sfCrit = 131072
    local sfLeading = 262144
    local sfCthMask = 255
    local sfRollMask = 65280
    local sfRollOffset = 8
    local num_hits, num_misses = 0, 0
    local shots_data = {}
    for i = 1, num_shots do
      local shot_miss, shot_crit, shot_cth
      if shot_attack_args.multishot then
        roll = attack_results.attack_roll[i]
        shot_cth = Max(0, attack_results.chance_to_hit - shot_attack_args.cth_loss_per_shot * (i - 1))
        print(shot_cth)
        shot_miss = roll > shot_cth
        shot_crit = not shot_miss and attack_results.crit_roll[i] <= attack_results.crit_chance
        miss = miss and shot_miss
        crit = crit or shot_crit
      else
        shot_cth = Max(0, attack_results.chance_to_hit - shot_attack_args.cth_loss_per_shot * (i - 1))
        print(shot_cth)
        shot_miss = (not kill or 1 < i) and roll > shot_cth
        shot_crit = crit and i == 1
      end
      local data = band(shot_cth, sfCthMask)
      data = bor(data, band(shift(roll, sfRollOffset), sfRollMask))
      data = bor(data, shot_miss and 0 or sfHit)
      data = bor(data, shot_crit and sfCrit or 0)
      data = bor(data, (shot_attack_args.multishot or i == 1) and sfLeading or 0)
      shots_data[i] = data
      num_hits = num_hits + (shot_miss and 0 or 1)
      num_misses = num_misses + (shot_miss and 1 or 0)
      if not prediction then
        NetUpdateHash("FirearmShot", attacker, target, shot_attack_args.action_id, shot_attack_args.stance, self.class, self.id, self == shot_attack_args.weapon, shot_attack_args.occupied_pos, shot_attack_args.step_pos, shot_attack_args.angle, shot_attack_args.anim, shot_attack_args.can_use_covers, shot_attack_args.ignore_smoke, shot_attack_args.penetration_class, shot_attack_args.range, shot_cth, roll, shot_miss)
      end
    end
    local precalc_shots, anyHitsTarget
    if not prediction then
      local hit_target_pts, miss_target_pts, disp_origin, disp_dir, lof_data
      if shot_lof_data then
        lof_data = shot_lof_data
      else
        lof_data = {
          target_pos = target_pos,
          lof_pos1 = attack_results.lof_pos1
        }
      end
      for i = 1, 20 do
        hit_target_pts, miss_target_pts, anyHitsTarget, disp_origin, disp_dir = self:CalcShotVectors(attacker, action.id, target, shot_attack_args, lof_data, 20 * guic, guim, guim, num_hits, num_misses)
        if num_hits <= #hit_target_pts and num_misses <= #miss_target_pts then
          break
        end
      end
      if num_hits > #hit_target_pts or num_misses > #miss_target_pts then
      else
        precalc_shots = {}
        for i = 1, num_shots do
          local shot_miss = band(shots_data[i], sfHit) == 0
          local target_tbl = shot_miss and miss_target_pts or hit_target_pts
          local shot_vector = table.remove(target_tbl)
          local shot_target_pos = shot_vector.target_pos
          local shot_attack_pos = shot_vector.attack_pos
          local t_offset = shot_target_pos - disp_origin
          precalc_shots[i] = {
            lof_pos1 = shot_vector.lof_pos1,
            attack_pos = shot_attack_pos,
            target_pos = shot_target_pos,
            shot_data = shots_data[i],
            shot_idx = i,
            dispersion = shot_vector.idx
          }
        end
        table.sort(precalc_shots, function(a, b)
          return a.dispersion < b.dispersion
        end)
      end
    end
    local misses
    local precalc_damage_data = {}
    local killed_colliders = {}
    for i = 1, num_shots do
      local precalc_shot = precalc_shots and precalc_shots[i]
      local shot_data = precalc_shot and precalc_shot.shot_data or shots_data[i]
      local shot_cth, shot_miss, shot_crit
      shot_cth = band(shot_data, sfCthMask)
      shot_miss = band(shot_data, sfHit) == 0
      shot_crit = band(shot_data, sfCrit) ~= 0
      roll = shift(band(shot_data, sfRollMask), -sfRollOffset)
      local leading_shot = band(shots_data[i], sfLeading) ~= 0
      local dmg_target = leading_shot and not shot_miss and target or false
      local attack_data, miss_target_pos, hit_data
      if precalc_shot then
        shot_attack_args.attack_pos = precalc_shot.attack_pos
        shot_attack_args.seed = attacker:Random()
        shot_attack_args.ignore_los = attack_args.ignore_los
        shot_attack_args.inside_attack_area_check = attack_args.inside_attack_area_check
        shot_attack_args.forced_hit_on_eye_contact = attack_args.forced_hit_on_eye_contact
        local shot_target
        if shot_miss then
          shot_target = precalc_shot.target_pos
          miss_target_pos = precalc_shot.target_pos
          shot_attack_args.ignore_colliders = compile_ignore_colliders(killed_colliders, target_unit)
          shot_attack_args.ignore_los = true
          shot_attack_args.inside_attack_area_check = false
          shot_attack_args.forced_hit_on_eye_contact = false
        else
          shot_target = attack_args.target_dummy or IsValid(target) and target or precalc_shot.target_pos
          shot_attack_args.ignore_colliders = compile_ignore_colliders(killed_colliders, attack_args.ignore_colliders)
        end
        attack_data = GetLoFData(attacker, shot_target, shot_attack_args)
      elseif shot_miss then
        if not prediction then
          local lof_idx = table.find(shot_attack_args.lof, "target_spot_group", shot_attack_args.target_spot_group)
          local lof_data = shot_attack_args.outside_attack_area_lof or shot_attack_args.lof[lof_idx or 1]
          local lof_pos1 = lof_data.lof_pos1
          while not misses or #misses.clear + #misses.obstructed == 0 do
            misses = self:CalcMissVectors(attacker, action.id, target, lof_pos1, lof_data.target_pos, dispersion)
            dispersion = dispersion + 20 * guic
          end
          miss_target_pos = self:PickMissTargetPos(attacker, misses, roll, shot_cth)
          local v = miss_target_pos - lof_pos1
          miss_target_pos = lof_pos1 + SetLen(v, max_range - const.SlabSizeX)
          shot_attack_args.fire_relative_point_attack = false
          shot_attack_args.ignore_colliders = compile_ignore_colliders(killed_colliders, target_unit)
          shot_attack_args.seed = attacker:Random()
          shot_attack_args.ignore_los = true
          shot_attack_args.inside_attack_area_check = false
          shot_attack_args.forced_hit_on_eye_contact = false
          attack_data = GetLoFData(attacker, miss_target_pos, shot_attack_args)
        end
      else
        shot_attack_args.fire_relative_point_attack = attack_args.fire_relative_point_attack
        shot_attack_args.ignore_colliders = compile_ignore_colliders(killed_colliders, attack_args.ignore_colliders)
        local target_dummy = attack_args.target_dummy or target
        shot_attack_args.seed = prediction and 0 or attacker:Random()
        shot_attack_args.ignore_los = attack_args.ignore_los
        shot_attack_args.inside_attack_area_check = attack_args.inside_attack_area_check
        shot_attack_args.forced_hit_on_eye_contact = attack_args.forced_hit_on_eye_contact
        attack_data = GetLoFData(attacker, target_dummy, shot_attack_args)
      end
      if attack_data then
        local lof_idx = table.find(attack_data.lof, "target_spot_group", shot_attack_args.target_spot_group)
        hit_data = attack_data.outside_attack_area_lof or attack_data.lof and attack_data.lof[lof_idx or 1]
      else
        local lof_idx = table.find(shot_attack_args.lof, "target_spot_group", shot_attack_args.target_spot_group)
        local lof_data = shot_attack_args.outside_attack_area_lof or shot_attack_args.lof[lof_idx or 1]
        hit_data = {
          obj = attacker,
          hits = empty_table,
          target_pos = miss_target_pos or lof_data.target_pos,
          attack_pos = lof_data.attack_pos
        }
      end
      if not shot_miss and (not precalc_shots and hit_data.stuck or precalc_shots and not anyHitsTarget) then
        attack_results.chance_to_hit = 0
        attack_results.obstructed = true
        local mods = attack_results.chance_to_hit_modifiers or {}
        mods[#mods + 1] = {
          {
            id = "NoLineOfFire",
            name = T(604792341662, "No Line of Fire"),
            value = 0
          }
        }
      end
      if not fired or jammed or shot_attack_args.chance_only and not shot_attack_args.damage_breakdown then
        return attack_results
      end
      hit_data.target = dmg_target
      hit_data.critical = shot_crit
      hit_data.record_breakdown = i == 1 and attack_results.dmg_breakdown or false
      for k, v in pairs(shot_attack_args) do
        if not hit_data[k] then
          hit_data[k] = v
        end
      end
      if shot_miss and IsValid(target) then
        for _, hit in ipairs(hit_data.hits) do
          if hit.obj == target then
            hit.stray = true
          end
        end
      end
      self:BulletCalcDamage(hit_data)
      if shot_attack_args.chance_only then
        return attack_results
      end
      local shot_target_hit = false
      for _, hit in ipairs(hit_data.hits) do
        local hit_obj = hit.obj
        if IsKindOf(hit_obj, "Unit") and not hit_obj:IsDead() then
          num_hits = num_hits + 1
          if not hit_objs[hit_obj] then
            hit_objs[#hit_objs + 1] = hit_obj
            hit_objs[hit_obj] = true
          end
          if kill and hit_obj == dmg_target then
            hit.damage = MulDivRound(target:GetTotalHitPoints(), 125, 100)
            hit.stealth_kill = true
          end
          total_damage = total_damage + hit.damage
          if not attacker:IsOnEnemySide(hit_obj) then
            friendly_fire_dmg = friendly_fire_dmg + hit.damage
          end
          unit_damage[hit_obj] = (unit_damage[hit_obj] or 0) + hit.damage
          if hit_obj == target_unit then
            shot_target_hit = true
          end
          if 0 < shot_attack_args.stealth_bonus_crit_chance and hit.critical then
            hit.stealth_crit = true
          end
        elseif IsKindOf(hit_obj, "Trap") and hit_obj == target then
          shot_target_hit = true
        end
        if IsKindOf(hit_obj, "CombatObject") then
          local dmg_data = precalc_damage_data[hit_obj] or {}
          precalc_damage_data[hit_obj] = dmg_data
          local hp, temp_hp = hit_obj:PrecalcDamageTaken(hit.damage, dmg_data.hp, dmg_data.temp_hp)
          dmg_data.hp = hp
          dmg_data.temp_hp = temp_hp
          if hp <= 0 then
            table.insert_unique(killed_colliders, hit_obj)
          end
        elseif IsKindOfClasses(hit_obj, "Destroyable", "Trap") then
          table.insert_unique(killed_colliders, hit_obj)
        end
      end
      target_hit = target_hit or shot_target_hit
      out_of_range = out_of_range and attack_data.outside_attack_area
      attack_results.shots[i] = {
        miss = shot_miss,
        cth = shot_cth,
        roll = roll,
        attack_pos = hit_data.attack_pos,
        target_pos = hit_data.target_pos,
        stuck_pos = hit_data.stuck_pos or hit_data.lof_pos2,
        hits = {},
        target_hit = shot_target_hit,
        out_of_range = attack_data.outside_attack_area,
        shot_target = not shot_miss and target_unit,
        allyHit = hit_data.allyHit,
        ammo_type = ammo_type,
        clear_attacks = hit_data.clear_attacks
      }
      if hit_data.allyHit then
        if attack_results.allyHit and attack_results.allyHit ~= hit_data.allyHit then
          attack_results.allyHit = "multiple"
        else
          attack_results.allyHit = hit_data.allyHit
        end
      end
      attack_results.clear_attacks = attack_results.clear_attacks + (hit_data.clear_attacks or 0)
      for _, hit in ipairs(hit_data.hits) do
        hit.direct_shot = true
        hit.shot_idx = i
        hit.weapon = self
        if hit.obj or hit.terrain then
          table.insert(attack_results, hit)
          table.insert(attack_results.shots[i].hits, hit)
        end
      end
    end
    attack_results.miss = miss
    attack_results.crit = crit
    if 1 < num_shots and not prediction then
      table.shuffle(attack_results.shots, InteractionRand(nil, "ShotOrder", attacker))
    end
    if not (0 < num_shots) or IsValid(target) then
    end
    local targetHitProjectile = target_hit
    if aoe_params then
      local damage_override = GetAoeDamageOverride(shot_attack_args, attacker, self, shot_attack_args.damage_bonus)
      aoe_params.prediction = shot_attack_args.prediction
      local hits, aoe_total_damage, aoe_friendly_fire_dmg = GetAreaAttackResults(aoe_params, shot_attack_args.aoe_damage_bonus, shot_attack_args.applied_status, damage_override)
      attack_results.area_hits = hits
      total_damage = total_damage + aoe_total_damage
      friendly_fire_dmg = friendly_fire_dmg + aoe_friendly_fire_dmg
      for _, hit in ipairs(hits) do
        hit.weapon = self
        if IsKindOf(hit.obj, "CombatObject") and not hit.obj:IsDead() then
          if IsKindOf(hit.obj, "Unit") and 0 < hit.damage then
            unit_damage[hit.obj] = (unit_damage[hit.obj] or 0) + hit.damage
          end
          local objIsTarget = hit.obj == target
          hit.obj_is_target = objIsTarget
          target_hit = target_hit or objIsTarget
          if not hit_objs[hit.obj] then
            hit_objs[#hit_objs + 1] = hit.obj
            hit_objs[hit.obj] = true
            num_hits = num_hits + 1
          else
            local direct_hit = find_first_hit(attack_results, hit.obj)
            if direct_hit then
              direct_hit.damage = direct_hit.damage + hit.damage
              hit.damage = 0
            end
          end
        end
      end
      if not prediction and 0 < (shot_attack_args.buckshot_scatter_fx or 0) then
        attack_results.cosmetic_hits = self:CalcBuckshotScatter(attacker, action, attack_results.attack_pos, target_pos, shot_attack_args.buckshot_scatter_fx, aoe_params)
      end
    end
    attack_results.num_hits = num_hits
    attack_results.total_damage = total_damage
    attack_results.friendly_fire_dmg = friendly_fire_dmg
    attack_results.target_hit = target_hit
    attack_results.target_hit_projectile = targetHitProjectile
    attack_results.out_of_range = out_of_range
    attack_results.unit_damage = unit_damage
    CompileKilledUnits(attack_results)
    if not prediction then
      NetUpdateHash("Firearm_GetAttackResults", attack_results.fired, attack_results.miss, attack_results.target_hit, attack_results.num_hits)
      g_LastAttackResults = attack_results
    end
    return attack_results
  end

function Firearm:BulletCalcDamage(hit_data)
  local attacker = hit_data.obj
  local target = hit_data.target
  local action = CombatActions[hit_data.action_id]
  local hits = hit_data.hits
  local record_breakdown = hit_data.record_breakdown
  local prediction = hit_data.prediction
  local dmg_mod = hit_data.damage_bonus or 0
  if type(dmg_mod) == "table" then
    dmg_mod = dmg_mod[obj]
  end
  if record_breakdown and dmg_mod then
    table.insert(record_breakdown, {
      name = action and action:GetActionDisplayName({attacker}) or T(328963668848, "Base"),
      value = dmg_mod
    })
  end
  local basedmg = attacker:GetBaseDamage(self, target, record_breakdown)
  local dmg = MulDivRound(basedmg, Max(0, 100 + (dmg_mod or 0)), 100)
  if not prediction then
    dmg = RandomizeWeaponDamage(dmg)
  end
  local target_reached
  local forced_target_hit = hit_data.forced_target_hit
  local impact_force = self:GetImpactForce()
  for idx, hit in ipairs(hits) do
    local stray = hit.stray
    local dmg = dmg
    local obj = hit.obj
    local is_unit
    if obj and IsKindOf(obj, "Unit") and not stray then
      is_unit = true
      stray = obj ~= target
      target_reached = target_reached or target and obj == target
      if not prediction and hit_data.critical == nil then
        local critChance = attacker:CalcCritChance(self, target, hit_data.aim, hit_data.step_pos, hit_data.target_spot_group or hit.spot_group, action)
        local critRoll = attacker:Random(100)
        hit_data.critical = critChance > critRoll
      end
      if not stray then
        hit.spot_group = hit_data.target_spot_group or hit.spot_group
      end
    end
    hit.stray = stray
    hit.critical = not stray and hit_data.critical
    hit.damage = dmg
    local breakdown = obj == target and record_breakdown
    self:PrecalcDamageAndStatusEffects(attacker, obj, hit_data.step_pos, hit.damage, hit, hit_data.applied_status, hit_data, breakdown, action, prediction)
    hit.impact_force = 0 < hit.damage and impact_force + self:GetDistanceImpactForce(hit.distance) or 0
    if idx < #hits and 0 < (hit.armor_prevented or 0) and not hit.ignored and (not forced_target_hit or target_reached) then
      local penetrated = false
      if is_unit and (not target or target_reached) then
        for item, degrade in pairs(hit.armor_decay) do
          if hit.armor_pen[item] then
            penetrated = true
            break
          end
        end
      end
      if not penetrated then
        for i = idx + 1, #hits do
          hits[i] = nil
        end
        hit_data.stuck_pos = hit.pos
        if hit_data.target_hit_idx and idx < hit_data.target_hit_idx then
          hit_data.target_hit_idx = nil
          hit_data.stuck = true
        end
        break
      end
    end
  end
end
