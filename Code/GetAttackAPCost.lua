function Unit:GetAttackAPCost(action, weapon, action_ap_cost, aim, delta)
  if not weapon then
    return 0
  end
  local min, max = self:GetBaseAimLevelRange(action, weapon)
  aim = Clamp(aim or 0, min, max) - min
  delta = delta or 0
  local aimCost = const.Scale.AP
  if GameState.RainHeavy then
    aimCost = MulDivRound(aimCost, 100 + const.EnvEffects.RainAimingMultiplier, 100)
  end
  local ap = 0
  if IsKindOf(weapon, "HeavyWeapon") then
    ap = action_ap_cost or weapon.AttackAP
    if HasPerk(self, "HeavyWeaponsTraining") then
      ap = HeavyWeaponsTrainingCostMod(ap)
    end
  elseif IsKindOf(weapon, "Firearm") then
    ap = action_ap_cost or weapon.ShootAP
    if IsKindOf(weapon, "MachineGun") and HasPerk(self, "HeavyWeaponsTraining") then
      ap = HeavyWeaponsTrainingCostMod(ap)
    end
    ap = ap + aim * aimCost + delta
    if(self.aim_attack_args) then
      if not (self:GetLastAttack()==self.aim_attack_args.target) then
        ap = ap+weapon.ReadyAP
      end
    end
  elseif IsKindOf(weapon, "Grenade") then
    ap = (action_ap_cost or weapon.AttackAP) + aim * aimCost + delta
    if self:HasStatusEffect("FirstThrow") then
      local costReduction = CharacterEffectDefs.Throwing:ResolveValue("FirstThrowCostReduction") * const.Scale.AP
      ap = Max(1 * const.Scale.AP, ap - costReduction)
    end
  elseif IsKindOf(weapon, "MeleeWeapon") then
    ap = (action_ap_cost or weapon.AttackAP) + delta
    if self:HasStatusEffect("FirstThrow") and action.ActionType == "Ranged Attack" then
      local costReduction = CharacterEffectDefs.Throwing:ResolveValue("FirstThrowCostReduction") * const.Scale.AP
      ap = Max(1 * const.Scale.AP, ap - costReduction)
    end
    ap = ap + aim * aimCost
  else
    ap = -1
  end
  local remainingAP = self:GetUIActionPoints() / 1000 * 1000
  if GameState.RainHeavy and ap > remainingAP and 0 < aim then
    local diff = abs(remainingAP - ap)
    if aimCost > diff and diff >= const.Scale.AP then
      ap = remainingAP
      aimCost = 1000
    end
  end
  return ap, aimCost
end