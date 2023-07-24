function BaseWeapon:PrecalcDamageAndStatusEffects(attacker, target, attack_pos, damage, hit, effect, attack_args, record_breakdown, action, prediction)
  if IsKindOf(target, "Unit") then
    local effects = EffectsTable(effect)
    local ignoreGrazing = IsFullyAimedAttack(attack_args) and self:HasComponent("IgnoreGrazingHitsWhenFullyAimed")
    local ignore_cover = (hit.aoe or hit.melee_attack or ignoreGrazing) and 100 or self.IgnoreCoverReduction
    local chance = 0
    local base_chance = 0
    if target:IsAware() and not target:HasStatusEffect("Exposed") and target:HasStatusEffect("Protected") and (not ignore_cover or ignore_cover <= 0) then
      local cover, any, coverage = target:GetCoverPercentage(attack_pos)
      base_chance = const.Combat.GrazingChanceInCover
      if target:HasStatusEffect("Protected") then
        base_chance = Protected:ResolveValue("base_chance")
      end
      chance = InterpolateCoverEffect(coverage, base_chance, 0)
      hit.grazing_reason = "cover"
    end
    if not ignoreGrazing and not hit.aoe then
      if target:IsConcealedFrom(attacker) then
        chance = chance + const.EnvEffects.FogGrazeChance
        hit.grazing_reason = "fog"
      end
      if target:IsObscuredFrom(attacker) then
        chance = chance + const.EnvEffects.DustStormGrazeChance
        hit.grazing_reason = "duststorm"
      end
    end
    if not prediction then
      local grazing_roll = target:Random(100)
      if chance > grazing_roll then
        hit.grazing = true
      else
        hit.grazing_reason = false
      end
    elseif chance ~= 0 then
      hit.grazing = true
    end
    if hit.grazing then
      hit.critical = nil
    end
    local ignore_armor = hit.aoe or IsKindOf(self, "MeleeWeapon")
    if not hit.stray or hit.aoe then
      if hit.critical then
        local crit_mod = IsKindOf(attacker, "Unit") and attacker:GetCritDamageMod() or const.Weapons.CriticalDamage
        damage = MulDivRound(damage, 100 + crit_mod, 100)
      end
      local data = {
        breakdown = record_breakdown or {},
        effects = {},
        base_damage = damage,
        damage_add = 0,
        damage_percent = 100,
        ignore_armor = false,
        ignore_body_part_damage = {},
        action_id = action and action.id,
        weapon = self,
        prediction = prediction
      }
      Msg("GatherDamageModifications", attacker, target, attack_args or {}, hit or {}, data)
      Msg("GatherTargetDamageModifications", attacker, target, attack_args or {}, hit or {}, data)
      damage = Max(0, MulDivRound(data.base_damage + data.damage_add, data.damage_percent, 100))
      if action.id == "BurstFire" then damage = damage*2
      elseif action.id == "AutoFire" then damage = damage*5
      elseif action.id == "RunAndGun" then damage = damage*4
      elseif action.id == "MGBurstFire" then damage=damage*3
      end
      for _, effect in ipairs(data.effects) do
        EffectTableAdd(effects, effect)
      end
      ignore_armor = ignore_armor or data.ignore_armor
      local part_def = hit.spot_group and Presets.TargetBodyPart.Default[hit.spot_group]
      if part_def then
        if not data.ignore_body_part_damage[part_def.id] then
          damage = MulDivRound(damage, 100 + part_def.damage_mod, 100)
          if record_breakdown then
            record_breakdown[#record_breakdown + 1] = {
              name = part_def.display_name,
              value = part_def.damage_mod
            }
          end
        end
        EffectTableAdd(effects, part_def.applied_effect)
      end
    else
      damage = MulDivRound(damage, 50, 100)
    end
    hit.damage = damage
    target:ApplyHitDamageReduction(hit, self, hit.spot_group or g_DefaultShotBodyPart, nil, ignore_armor, record_breakdown)
    if hit.grazing then
      hit.effects = {}
      hit.damage = Max(1, MulDivRound(hit.damage, const.Combat.GrazingHitDamage, 100))
    else
      hit.effects = effects
    end
  else
    local obj_dmg_mod = not hit.ignore_obj_damage_mod and self:HasMember("ObjDamageMod") and self.ObjDamageMod or 100
    if obj_dmg_mod ~= 100 then
      damage = MulDivRound(damage, obj_dmg_mod, 100)
      if record_breakdown then
        record_breakdown[#record_breakdown + 1] = {
          name = T({
            360767699237,
            "<em><DisplayName></em> damage modifier to objects",
            self
          }),
          value = obj_dmg_mod
        }
      end
    end
    if HasPerk(attacker, "CollateralDamage") and IsKindOfClasses(self, "HeavyWeapon", "MachineGun") then
      local collateralDamage = CharacterEffectDefs.CollateralDamage
      local damageBonus = collateralDamage:ResolveValue("objectDamageMod")
      damage = MulDivRound(damage, 100 + damageBonus, 100)
      if record_breakdown then
        record_breakdown[#record_breakdown + 1] = {
          name = collateralDamage.DisplayName,
          value = damageBonus
        }
      end
    end
    local pen_class = self:HasMember("PenetrationClass") and self.PenetrationClass or #PenetrationClassIds
    local armor_class = target and target.armor_class or 1
    if pen_class >= armor_class then
      hit.damage = damage or 0
      hit.armor_prevented = 0
    else
      hit.damage = 0
      hit.armor_prevented = damage or 0
    end
    if record_breakdown then
      if 0 < hit.damage then
        record_breakdown[#record_breakdown + 1] = {
          name = T(478438763504, "Armor (Pierced)")
        }
      else
        record_breakdown[#record_breakdown + 1] = {
          name = T(360312988514, "Armor"),
          value = -hit.armor_prevented
        }
      end
    end
  end
end