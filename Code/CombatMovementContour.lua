function GenerateAttackContour(attack, attacker, combatPath, customCombatPath)
  combatPath = combatPath or GetCombatPath(attacker)
  local borderline_attack, borderline_attack_voxels, borderline_turns, borderline_turns_voxels = {}, {}, {}, {}
  local voxels = {}
  local reload = CombatActions.Reload
  local attackerAP, attackAP
  if not customCombatPath and CombatActions.Move:GetUIState({attacker}) ~= "enabled" then
    return borderline_attack, borderline_attack_voxels, borderline_turns, borderline_turns_voxels
  end
  if customCombatPath then
    for voxel, ap in pairs(combatPath.paths_ap) do
      if 0 < ap or GetPassSlab(point_unpack(voxel)) then
        table.insert(voxels, voxel)
      end
    end
    borderline_attack = 0 < #voxels and GetRangeContour(voxels) or false
    borderline_attack_voxels[1] = voxels
  else
    if attack:GetUIState({attacker}) == "enabled" and not attacker:IsWeaponJammed() then
      local actionCost, displayActionCost = attack:GetAPCost(attacker)
      if displayActionCost then
        actionCost = displayActionCost
      end
      attackAP = actionCost
      attackerAP = attacker:GetUIActionPoints() - actionCost + attacker.free_move_ap
      if attacker:OutOfAmmo() and attack.ActionType == "Ranged Attack" then
        attackerAP = attackerAP -- - reload:GetAPCost(attacker)
      end
    end
    if attackerAP and 0 < attackerAP then
      for voxel, ap in pairs(combatPath.paths_ap) do
        if ap <= attackerAP and (0 < ap or GetPassSlab(point_unpack(voxel))) then
          table.insert(voxels, voxel)
        end
      end
    end
    borderline_attack_voxels[1] = voxels
    borderline_attack = false
    if 0 < #voxels then
      local contour_width = const.ContoursWidth_BorderlineAttack
      local radius2D
      local offset = const.ContoursOffset_BorderlineAttack
      local offsetz = const.ContoursOffsetZ_BorderlineAttack
      borderline_attack = GetRangeContour(voxels, contour_width, radius2D, offset, offsetz) or false
    end
    local attack_voxels = voxels
    voxels = {}
    local min = -1
    for turn = 1, 1 + const.Combat.CombatPathTurnsAhead do
      local max = attacker:GetUIActionPoints() + attacker.free_move_ap + (turn - 1) * attacker:GetMaxActionPoints()
      for voxel, ap in pairs(combatPath.paths_ap) do
        if ap > min and ap <= max and (0 < ap or GetPassSlab(point_unpack(voxel))) then
          table.insert(voxels, voxel)
        end
      end
      if 0 < #voxels then
        borderline_turns_voxels[turn] = voxels
        local contour_width = const.ContoursWidth_BorderlineTurn
        local radius2D
        local offset = const.ContoursOffset_BorderlineTurn
        local offsetz = const.ContoursOffsetZ_BorderlineTurn
        borderline_turns[turn] = GetRangeContour(voxels, contour_width, radius2D, offset, offsetz)
      end
      min = max
    end
  end
  return borderline_attack, borderline_attack_voxels, borderline_turns, borderline_turns_voxels, attackAP
end
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