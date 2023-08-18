function InsideAttackArea(dialog, goto_pos)
  if dialog.action then
    return true
  end
  local mover = dialog.attacker
  local combatPath = GetCombatPath(mover)
  local costAP = combatPath and combatPath:GetAP(goto_pos)
  if not mover:IsWeaponJammed() and costAP then
    local actionAp = (dialog.action or mover:GetDefaultAttackAction()):GetAPCost(mover)
    local attackAP = 0 < actionAp and mover:GetUIActionPoints() + mover.free_move_ap - actionAp or 0
    --[[if mover:OutOfAmmo() then
      print('OutOfAmmo()')
      --print('AP:', CombatActions.Reload:GetAPCost(mover))
      attackAP = attackAP - CombatActions.Reload:GetAPCost(mover)
      print('AP',attackAP)
    end]]--
    return costAP <= attackAP
  end
  return false
end