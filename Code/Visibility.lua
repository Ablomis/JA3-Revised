function GetAreaAttackResults(aoe_params, damage_bonus, applied_status, damage_override)
    local prediction = aoe_params.prediction
    local attacker = aoe_params.attacker
    local step_pos = not aoe_params.step_pos and IsValid(attacker) and attacker:GetPos()
    local occupied_pos = not aoe_params.occupied_pos and IsKindOf(attacker, "Unit") and attacker:GetOccupiedPos()
    local stance = aoe_params.stance or IsKindOf(attacker, "Unit") and attacker.stance or "Standing"
    local target_pos = aoe_params.target_pos or step_pos
    local explosion = aoe_params.explosion
    local cone_angle = aoe_params.cone_angle or -1
    local range
    if aoe_params.max_range and aoe_params.min_range and aoe_params.max_range ~= aoe_params.min_range then
      range = Clamp(attacker:GetDist(target_pos), aoe_params.min_range * const.SlabSizeX, aoe_params.max_range * const.SlabSizeX)
    else
      range = aoe_params.max_range and aoe_params.max_range * const.SlabSizeX or -1
    end
    local weapon = aoe_params.weapon
    local dont_destroy_covers = aoe_params.dont_destroy_covers
    local targets, los_values = GetAreaAttackTargets(step_pos, stance, prediction, range, cone_angle, target_pos, occupied_pos, dont_destroy_covers)
    targets = table.ifilter(targets, function(idx, target)
      return not IsKindOf(target, "Landmine")
    end)
    if IsValid(attacker) and not aoe_params.can_be_damaged_by_attack then
      local idx = table.find(targets, attacker)
      if idx then
        table.remove(targets, idx)
        table.remove(los_values, idx)
      end
    end
    local results = {
      start_pos = step_pos,
      target_pos = target_pos,
      range = range,
      cone_angle = cone_angle,
      aoe_type = aoe_params.aoe_type,
      explosion = explosion
    }
    if #targets == 0 then
      return results, 0, 0, {}
    end
    local total_damage, friendly_fire_dmg = 0, 0
    if not step_pos:IsValidZ() then
      step_pos = step_pos:SetTerrainZ()
    end
    local impact_force = weapon:GetImpactForce()
    for i, obj in ipairs(targets) do
      local dmg_mod = aoe_params.damage_mod
      local nominal_dmg = attacker and IsKindOf(attacker, "Unit") and attacker:GetBaseDamage(weapon, obj) or weapon.BaseDamage
      if aoe_params.damage_override then
        nominal_dmg = aoe_params.damage_override
      end
      if not prediction then
        nominal_dmg = RandomizeWeaponDamage(nominal_dmg)
      end
      local hit = {}
      results[i] = hit
      hit.obj = obj
      hit.aoe = true
      hit.area_attack_modifier = GetAreaAttackHitModifier(obj, los_values[i])
      if explosion then
        local center_range = aoe_params.center_range or 1
        if 1 < center_range then
          hit.explosion_center = obj:GetDist(target_pos) <= center_range * const.SlabSizeX
        else
          hit.explosion_center = GetPassSlab(target_pos) == GetPassSlab(obj)
        end
      end
      if 0 < hit.area_attack_modifier then
        local dmg = 0
        if dmg_mod ~= "no damage" then
          dmg_mod = dmg_mod + aoe_params.attribute_bonus
          dmg = MulDivRound(nominal_dmg, Max(0, dmg_mod), 100)
        end
        if 0 < dmg and not explosion and IsValid(attacker) and aoe_params.falloff_damage and aoe_params.falloff_start then
          local dist = attacker:GetDist(obj)
          local falloff_factor = Clamp(0, 100, MulDivRound(dist, 100, range) - aoe_params.falloff_start)
          if 0 < falloff_factor then
            local damage_start, damage_end = dmg, MulDivRound(dmg, aoe_params.falloff_damage, 100)
            dmg = Max(1, MulDivRound(damage_start, 100 - falloff_factor, 100) + MulDivRound(damage_end, falloff_factor, 100))
          end
        end
        weapon:PrecalcDamageAndStatusEffects(attacker, obj, step_pos, dmg, hit, applied_status, nil, nil, nil, prediction)
        local damage
        if damage_override then
          damage = damage_override
        else
          damage = MulDivRound(hit.damage, 100 + (damage_bonus or 0), 100)
        end
        local dmg_mod = hit.area_attack_modifier
        if explosion and IsKindOf(obj, "Unit") then
          if obj.stance == "Prone" then
            dmg_mod = dmg_mod + const.Combat.ExplosionProneDamageMod
            if HasPerk(obj, "HitTheDeck") then
              local mod = CharacterEffectDefs.HitTheDeck:ResolveValue("explosiveLessDamage")
              dmg_mod = dmg_mod - mod
            end
          elseif obj.stance == "Crouch" then
            dmg_mod = dmg_mod + const.Combat.ExplosionCrouchDamageMod
          end
        end
        damage = MulDivRound(damage, Max(0, dmg_mod), 100)
        if aoe_params.stealth_attack_roll and IsKindOf(attacker, "Unit") and IsKindOf(obj, "Unit") and not obj.villain and not obj:IsDead() then
          if aoe_params.stealth_attack_roll < attacker:CalcStealthKillChance(weapon, obj) then
            damage = MulDivRound(obj:GetTotalHitPoints(), 100 + obj:Random(50), 100)
            hit.stealth_kill = true
          end
          hit.stealth_kill_chance = attacker:CalcStealthKillChance(weapon, obj)
        end
        hit.damage = damage
        if IsKindOf(attacker, "Unit") and IsKindOf(obj, "Unit") then
          total_damage = total_damage + damage
          if not obj:IsOnEnemySide(attacker) then
            friendly_fire_dmg = friendly_fire_dmg + damage
          end
        end
        hit.impact_force = impact_force + weapon:GetDistanceImpactForce(obj:GetDist(step_pos))
      else
        hit.damage = 0
        hit.stuck = true
        hit.armor_decay = empty_table
        hit.effects = empty_table
      end
      if aoe_params.explosion_fly and IsKindOf(hit.obj, "Unit") and hit.damage >= const.Combat.GrenadeMinDamageForFly then
        hit.explosion_fly = true
      end
    end
    results.total_damage = total_damage
    results.friendly_fire_dmg = friendly_fire_dmg
    results.hit_objs = targets
    return results, total_damage, friendly_fire_dmg, targets
  end
  if FirstLoad then
    g_InvisibleUnitOpacity = 0
    g_ExperimentalModeLOS = "slab block only"
  end
  config.SlabEntityList = ""
  function DbgCycleExperimentalLOS()
    config.SlabEntityList = ""
    if not g_ExperimentalModeLOS then
      g_ExperimentalModeLOS = "all visible"
      print("LOS: All enemies are visibles")
    elseif g_ExperimentalModeLOS == "all visible" then
      g_ExperimentalModeLOS = "slab block only"
      config.SlabEntityList = "Floor,Stairs,WallExt,WallInt,Door,TallDoor,Window,WindowBig,WindowVent,Roof"
      print("LOS: Only Slab objects block vision")
    else
      g_ExperimentalModeLOS = false
      print("LOS: Normal mode.")
    end
  end
  local IsVisibleTo = function(self, other)
    if g_ExperimentalModeLOS == "all visible" then
      return true
    end
    if not other.team:IsEnemySide(self.team) then
      return true
    end
    if self:CanSee(other) then
      return true
    end
    return false
  end