function Unit:CalcChanceToHit(target, action, args, chance_only)
    if not IsPoint(target) and (not IsValid(target) or not IsKindOf(target, "CombatObject")) then
      return 0
    end
    local weapon1, weapon2 = action:GetAttackWeapons(self)
    local weapon = args and args.weapon or weapon1
    if not weapon or IsKindOf(weapon, "Medicine") then
      return 0
    end
    if CheatEnabled("AlwaysHit") then
      return 100
    elseif CheatEnabled("AlwaysMiss") then
      return 0
    end
    local target_spot_group = args and args.target_spot_group or nil
    if type(target_spot_group) == "table" then
      target_spot_group = target_spot_group.id
    end
    target_spot_group = target_spot_group or g_DefaultShotBodyPart
    if type(target_spot_group) == "string" then
      target_spot_group = Presets.TargetBodyPart.Default[target_spot_group]
    end
    local aim = args and args.aim or 0
    local opportunity_attack = args and args.opportunity_attack
    local attacker_pos = args and (args.step_pos or args.goto_pos) or self:GetPos()
    local target_pos = args and args.target_pos or IsPoint(target) and target or target:GetPos()
    local base = 0
    local modifiers = not chance_only and {}
    local skill  = round(35 + 0.00055 * ((self.Dexterity-70)^3) + 0.5,1)
    --local skill  = round(self.Dexterity/2,1)
    if action.id == "SteroidPunch" then
      skill = self.Strength
    end
    base = base + skill
    if args and not args.prediction then
      local effects = {}
      for i, effect in ipairs(self.StatusEffects) do
        effects[i] = effect.class
      end
      effects = table.concat(effects, ",")
      local target_effects = "-"
      if IsKindOf(target, "Unit") then
        target_effects = {}
        for i, effect in ipairs(target.StatusEffects) do
          target_effects[i] = effect.class
        end
        target_effects = table.concat(target_effects, ",")
      end
      NetUpdateHash("CalcChanceToHit_Base", self, target, action.id, weapon.class, weapon.id, base, effects, target_effects, weapon1 and weapon1.class, weapon1 and weapon1.id, weapon1 and weapon1.Condition, weapon1 and weapon1.MaxCondition, weapon2 and weapon2.class, weapon2 and weapon2.id, weapon2 and weapon2.Condition, weapon2 and weapon2.MaxCondition)
    end
    if modifiers then
      self.combat_cache = self.combat_cache or {}
      local key = "base_cth_" .. weapon.base_skill
      local skillmod = self.combat_cache[key]
      if not skillmod then
        local prop_meta = self:GetPropertyMetadata(weapon.base_skill)
        if prop_meta then
          skillmod = {
            name = prop_meta.name,
            value = skill
          }
        else
          skillmod = {
            name = T(462143455900, "Marksmanship"),
            value = skill
          }
        end
        self.combat_cache[key] = skillmod
      end
      table.insert(modifiers, skillmod)
    end
    local mod_data = {
      attacker = self,
      target = target,
      target_spot_group = target_spot_group,
      action = action,
      weapon1 = weapon1,
      weapon2 = weapon2,
      aim = aim,
      opportunity_attack = opportunity_attack,
      attacker_pos = attacker_pos,
      target_pos = target_pos
    }
    ForEachPreset("ChanceToHitModifier", function(mod)
      if mod.RequireTarget and not IsValidTarget(target) then
        return
      end
      local req_action = mod.RequireActionType
      if req_action == "Any Attack" then
        if action.ActionType == "Other" then
          return
        end
      elseif req_action == "Any Melee Attack" then
        if action.ActionType ~= "Melee Attack" then
          return
        end
      elseif req_action == "Any Ranged Attack" then
        if action.ActionType ~= "Ranged Attack" then
          return
        end
      elseif req_action ~= action.id then
        return
      end
      local lof = false
      local apply, value, nameOverride, metaText, idOverride = mod:CalcValue(self, target, target_spot_group, action, weapon, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
      if args and not args.prediction then
        NetUpdateHash("CalcChanceToHit_Modifier", mod.id, apply, value)
      end
      if not apply then
        return
      end
      mod_data.display_name = nameOverride or mod.display_name
      mod_data.meta_text = IsT(metaText) and {metaText} or metaText or nil
      value = self:GatherCTHModifications(mod.id, value, mod_data)
      if args and not args.prediction then
        NetUpdateHash("CalcChanceToHit_Modifier_Mods", mod.id, value)
      end
      local nameOverride = mod_data.display_name
      local metaText = #mod_data.meta_text > 0 and mod_data.meta_text
      base = base + value
      if modifiers then
        table.insert(modifiers, {
          name = nameOverride or mod.display_name,
          value = value,
          id = idOverride or mod.id,
          metaText = metaText
        })
      end
    end)
    for _, effect in ipairs(self.StatusEffects) do
      mod_data.display_name = effect.DisplayName
      mod_data.meta_text = nil
      local value = self:GatherCTHModifications(effect.class, 0, mod_data)
      if args and not args.prediction then
        NetUpdateHash("CalcChanceToHit_Effect_Mods", effect.class, value)
      end
      if value and value ~= 0 then
        base = base + value
        if modifiers then
          table.insert(modifiers, {
            name = mod_data.display_name,
            value = value,
            id = effect.id,
            metaText = mod_data.meta_text
          })
        end
      end
    end
    base = Max(0, base)
    local target_pos = IsPoint(target) and target or target:GetPos()
    local knife_throw = IsKindOf(weapon, "MeleeWeapon") and action.ActionType == "Ranged Attack"
    local penalty = weapon:GetAccuracy(attacker_pos:Dist(target_pos), self, action, knife_throw) - 100
  
    if action.ActionType == "Ranged Attack" and HasPerk(target, "LightningReaction") and target.stance ~= "Prone" and not target:HasStatusEffect("LightningReactionCounter") and not action.StealthAttack then
      if modifiers then
        modifiers[#modifiers + 1] = {
          name = T(530719772440, "Lightning Reactions"),
          value = -base,
          id = "Accuracy",
          uiHidden = true
        }
      end
      base = 0
    end
    local final = Clamp(base + penalty, 0, 100)
    if HasPerk(self, "Spiritual") then
      local minAcc = CharacterEffectDefs.Spiritual:ResolveValue("minAccuracy")
      final = Clamp(final, minAcc, 100)
    end
    if args and not args.prediction then
      NetUpdateHash("CalcChanceToHit_Final", final)
    end
    if chance_only then
      return final
    end
    if penalty ~= 0 then
      if action.ActionType == "Melee Attack" then
        modifiers[#modifiers + 1] = {
          name = T(660754354729, "Weapon Accuracy"),
          value = penalty,
          id = "Accuracy"
        }
      elseif penalty <= -100 then
        modifiers[#modifiers + 1] = {
          name = T(162704513413, "Out of Range"),
          value = penalty,
          id = "Range"
        }
      else
        modifiers[#modifiers + 1] = {
          name = T(301586030557, "Range"),
          value = penalty,
          id = "Range"
        }
      end
    end
    return final, base, modifiers, penalty
  end

  function Unit:CanStealth(stance)
    stance = stance or self.stance
    local is_stealthy_stance
    if self.species == "Human" then
      is_stealthy_stance = stance ~= "Standing"
      if HasPerk(self, "FleetingShadow") then
        is_stealthy_stance = true
      end
    elseif self.species == "Crocodile" then
      is_stealthy_stance = true
    end
    local effects = self.StatusEffects
    local visual_contact = self.enemy_visual_contact
    if g_Combat and effects.Spotted then
      visual_contact = false
    elseif not self:HasStatusEffect("Hidden") then
      local enemies = GetAllEnemyUnits(self)
      for _, enemy in ipairs(enemies) do
        visual_contact = visual_contact or HasVisibilityTo(enemy, self)
      end
    end
    if not (not visual_contact and is_stealthy_stance and not self:IsDead() and not self:IsDowned() and (self.command ~= "ExitCombat" or self:HasStatusEffect("Hidden")) and self:IsValidPos()) or self.team.side == "neutral" then
      return false
    end
    if effects.BandagingDowned or effects.Revealed or effects.StationedMachineGun or effects.StationedSniper or effects.ManningEmplacement then
      return false
    end
    return true
  end

  function Unit:IsStanceChangeLocked()
    if IsKindOf(self:GetActiveWeapons(), "MachineGun") and (self.behavior == "OverwatchAction" or self.combat_behavior == "OverwatchAction") then
      return true
    end
    if IsKindOf(self:GetActiveWeapons(), "SniperRifle") and (self.behavior == "OverwatchAction" or self.combat_behavior == "OverwatchAction") then
      return true
    end
    if self:GetBandageTarget() then
      return true
    end
    return false
  end

  function Unit:GetBaseDamage(weapon, target, breakdown)
    if self.infinite_dmg then
      return 10000
    end
    weapon = weapon or self:GetActiveWeapons()
    local mod = 100
    local base_damage = 0
    if self:HasStatusEffect("Focused") then
      local focusedMod = CharacterEffectDefs.Focused:ResolveValue("bonus_damage")
      mod = mod + focusedMod
      if breakdown then
        breakdown[#breakdown + 1] = {
          name = CharacterEffectDefs.Focused.DisplayName,
          value = focusedMod
        }
      end
    end
    if HasPerk(self, "Berserker") then
      local woundedEffect = self:GetStatusEffect("Wounded")
      if woundedEffect and 0 < woundedEffect.stacks then
        local stackCap = CharacterEffectDefs.Berserker:ResolveValue("stackCap")
        local damagePerStack = CharacterEffectDefs.Berserker:ResolveValue("damageBonus")
        local stacks = Min(woundedEffect.stacks, stackCap)
        local berserkerMod = damagePerStack * stacks
        mod = mod + berserkerMod
        if breakdown then
          breakdown[#breakdown + 1] = {
            name = CharacterEffectDefs.Berserker.DisplayName,
            value = berserkerMod
          }
        end
        if (self.side ~= "enemy1" or self.side ~= "enemy2") and g_Combat and not table.find(g_Combat.berserkVRsPerRole, self.role) then
          PlayVoiceResponse(self, "AIBerserkerPerk")
          table.insert(g_Combat.berserkVRsPerRole, self.role)
        end
      end
    end
    if IsKindOf(weapon, "Firearm") then
      local ammo = weapon.ammo or false
      if(ammo) then
        local bullet_energy = 0.5 * ammo.Mass * (MulDivRound(ammo.BaseVelocity,weapon.BarrelLengthMod,100)^2) /1000
        base_damage = round(bullet_energy * const.Combat.EnergyToDamageCoef + 0.5,1)
      else
        base_damage = weapon.Damage
      end
      if HasPerk(self, "WeaponPersonalization") and weapon:IsFullyModified() then
        local baseDamageBonus = CharacterEffectDefs.WeaponPersonalization:ResolveValue("baseDamageBonus")
        base_damage = base_damage + baseDamageBonus
      end
      if IsValidTarget(target) and self:GetDist(target) <= weapon.WeaponRange * const.SlabSizeX / 2 then
        local damageIncrease = GetComponentEffectValue(weapon, "HalfRangeDmgIncrease", "base_dmg_bonus")
        if damageIncrease then
          base_damage = base_damage + damageIncrease
        end
      end
    elseif IsKindOf(weapon, "Grenade") then
      if IsKindOf(weapon, "ThrowableTrapItem") then
        base_damage = weapon:GetBaseDamage()
      else
        base_damage = weapon.BaseDamage
      end
      mod = 100 + GetGrenadeDamageBonus(self)
    elseif IsKindOfClasses(weapon, "MeleeWeapon", "Ordnance") then
      base_damage = weapon.BaseDamage
    end
    return MulDivRound(base_damage, mod, 100)
  end

  function Unit:IsArmorPiercedBy(weapon, aim, target_spot_group, action)
    local pierced = true
    if target_spot_group == "Head" then
      local helm = self:GetItemInSlot("Head")
      if helm and IsKindOf(helm, "IvanUshanka") then
        return false
      end
    end
    if action and action.id == "KalynaPerk" then
      return true, "ignored"
    end
    if action and action.ActionType == "Melee Attack" then
      return true, "ignored"
    end
    self:ForEachItem("Armor", function(item, slot)
      if slot ~= "Inventory" and item.Condition > 0 and weapon.ammo.PenetrationClass < item.PenetrationClass and (item.ProtectedBodyParts or empty_table)[target_spot_group] then
        if(self:Random(100)<=item.Condition) then
          pierced = false
        end
        return "break"
      end
    end)
    return pierced
  end

  function Unit:CalcCritChance(weapon, target, aim, attack_pos, target_spot_group, action, distance )
    local distance = distance or 0
    if not IsKindOfClasses(weapon, "Firearm", "MeleeWeapon") then
      return 0
    end
    target_spot_group = target_spot_group or g_DefaultShotBodyPart
    if IsKindOf(target, "Unit") and not target:IsArmorPiercedBy(weapon, aim, target_spot_group, action) then
      return 0
    end
    if action and action.id == "TheGrim" then
      return 100
    end
    if IsKindOf(target, "Unit") and target:HasStatusEffect("Marked") or HasPerk(self, "BloodScent") and IsKindOf(weapon, "MeleeWeapon") then
      return 100
    end
    if IsKindOf(target, "Unit") and IsKindOf(weapon, "GutHookKnife") then
      return 100
    end

    local critChance = weapon.ammo.CritChance
    local k
    k = (critChance - const.Combat.MinCritChance)/(0.0001*weapon.WeaponRange^3)
    critChance = Min(Max(const.Combat.MinCritChance,round(critChance - 0.0001 * k * ((distance/10000-weapon.WeaponRange)^3),1)),critChance)
    print(critChance)

    if(target_spot_group=='Head') then
      critChance = const.Combat.HeadCritChance
    elseif(not target_spot_group=='Torso') then
      critChance = const.Combat.LimbCritChance
    end
    if HasPerk(self, "VitalPrecision") and aim == weapon.MaxAimActions then
      critChance = critChance + CharacterEffectDefs.VitalPrecision:ResolveValue("Crit Bonus")
    end
    if HasPerk(self, "SecondStoryMan") and IsKindOf(target, "Unit") then
      local highGroundMod = Presets.ChanceToHitModifier.Default.GroundDifference
      local applied = highGroundMod:CalcValue(self, target, nil, nil, weapon, nil, nil, nil, nil, self:GetPos(), target:GetPos())
      if applied then
        critChance = critChance + CharacterEffectDefs.SecondStoryMan:ResolveValue("critChance")
      end
    end
    if HasPerk(self, "InstantAutopsy") and self:IsPointBlankRange(target) then
      critChance = critChance + CharacterEffectDefs.InstantAutopsy:ResolveValue("crit_bonus")
    end
    if HasPerk(self, "WeaponPersonalization") and IsKindOf(weapon, "Firearm") and weapon:IsFullyModified() then
      critChance = critChance + CharacterEffectDefs.WeaponPersonalization:ResolveValue("critChanceBonus")
    end
    local extra = GetComponentEffectValue(weapon, "CritBonusSameTarget", "bonus_crit")
    if self:GetLastAttack() == target and extra then
      critChance = critChance + extra
    end
    local extraAimed = IsFullyAimedAttack(aim) and GetComponentEffectValue(weapon, "CritBonusWhenFullyAimed", "bonus_crit")
    if extraAimed then
      critChance = critChance + extraAimed
    end
    local crit_per_aim = const.Combat.AimCritBonus
    if HasPerk(self, "Deadeye") then
      crit_per_aim = crit_per_aim + CharacterEffectDefs.Deadeye:ResolveValue("crit_per_aim")
    end
    return critChance + (aim or 0) * crit_per_aim
  end

  function Unit:ApplyHitDamageReduction(hit, weapon, hit_body_part, ignore_cover, ignore_armor, record_breakdown)
    local damage = hit.damage or 0
    local dmg = damage
    local armor_decay, armor_pierced = {}, {}
    local weapon_pen_class = weapon.ammo.PenetrationClass or 1
    self:ForEachItem("Armor", function(item, slot)
      if 0 < dmg and slot ~= "Inventory" and item.ProtectedBodyParts and item.ProtectedBodyParts[hit_body_part] then
        local dr, degrade = 0, 0
        if not ignore_armor and 0 < item.Condition and self:Random(100)<=item.Condition then
          local pen_difference = weapon_pen_class - item.PenetrationClass
          if pen_difference < 0 then
            dr = Max(const.Combat.ArmorDamageReductionBase - pen_difference * const.Combat.ArmorDamageReductionAdditional, 95)
            degrade = const.Combat.ArmorDegradePercent
          else
            armor_pierced[item] = true
            dr = const.Combat.ArmorDamageReductionBase * item.PenetrationClass
          end
        else
          armor_pierced[item] = true
        end
        local scaled = dmg * (100 - dr)
        local result = scaled / 100
        --[[if 0 < scaled % 100 and armor_pierced[item] then
          result = result + 1
        end]]--
        if record_breakdown then
          if armor_pierced[item] then
            record_breakdown[#record_breakdown + 1] = {
              name = T({
                191288543859,
                "<em><DisplayName></em> (Pierced)",
                item
              }),
              value = -dr
            }
          else
            record_breakdown[#record_breakdown + 1] = {
              name = T({
                516752639882,
                "<em><DisplayName></em>",
                item
              }),
              value = -dr
            }
          end
        end
        dmg = Min(dmg, result)
        armor_decay[item] = Min(item.Condition, degrade)
      end
    end)
    local armor_prevented = damage - dmg
    if HasPerk(self, "HoldPosition") and (g_Overwatch[self] or g_Pindown[self]) then
      local statPercent = CharacterEffectDefs.HoldPosition:ResolveValue("percentHealth")
      local percent_reduction = MulDivRound(self.Health, statPercent, 100)
      if record_breakdown then
        record_breakdown[#record_breakdown + 1] = {
          name = CharacterEffectDefs.HoldPosition.DisplayName,
          value = -percent_reduction
        }
      end
      dmg = Max(0, MulDivRound(dmg, 100 - percent_reduction, 100))
    end
    local armor = next(armor_decay)
    hit.armor = armor and armor.DisplayName
    hit.armor_prevented = armor_prevented
    hit.damage = dmg
    hit.armor_decay = armor_decay
    hit.armor_pen = armor_pierced
  end