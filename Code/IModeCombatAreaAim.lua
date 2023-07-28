function Targeting_AOE_Cone(dialog, blackboard, command, pt)
    pt = GetCursorPos("walkableFlag")
    local attacker = dialog.attacker
    local action = dialog.action
    if not blackboard.firing_mode_action then
      if action.group == "FiringModeMetaAction" then
        action = GetUnitDefaultFiringModeActionFromMetaAction(attacker, action)
      end
      blackboard.firing_mode_action = action
    end
    action = action.group == "FiringModeMetaAction" and blackboard.firing_mode_action or action
    if action.IsTargetableAttack and not dialog.context.free_aim then
      blackboard.gamepad_aim = false
      return Targeting_AOE_Cone_TargetRequired(dialog, blackboard, command, pt)
    end
    if dialog:PlayerActionPending(attacker) then
      command = "delete"
    end
    if command == "delete" then
      if blackboard.mesh then
        DoneObject(blackboard.mesh)
        blackboard.mesh = false
      end
      if blackboard.movement_avatar then
        UpdateMovementAvatar(dialog, point20, nil, "delete")
      end
      UnlockCamera("AOE-Gamepad")
      SetAPIndicator(false, "free-aim")
      ClearDamagePrediction()
      return
    end
    local shouldGamepadAim = GetUIStyleGamepad()
    local wasGamepadAim = blackboard.gamepad_aim
    if shouldGamepadAim ~= wasGamepadAim then
      if shouldGamepadAim then
        LockCamera("AOE-Gamepad")
        SnapCameraToObj(attacker, "force")
      else
        UnlockCamera("AOE-Gamepad")
      end
      blackboard.gamepad_aim = shouldGamepadAim
    end
    local weapon = action:GetAttackWeapons(attacker)
    local aoe_params = action:GetAimParams(attacker, weapon) or weapon and weapon:GetAreaAttackParams(action.id, attacker)
    if not aoe_params then
      return
    end
    local min_aim_range = aoe_params.min_range * const.SlabSizeX
    local max_aim_range = aoe_params.max_range * const.SlabSizeX
    local lof_params = {
      weapon = weapon,
      step_pos = dialog.move_step_position or attacker:GetOccupiedPos(),
      prediction = true
    }
    local attack_data = attacker:ResolveAttackParams(action.id, pt, lof_params)
    local attacker_pos3D = attack_data.step_pos
    if not attacker_pos3D:IsValidZ() then
      attacker_pos3D = attacker_pos3D:SetTerrainZ()
    end
    if not blackboard.movement_avatar then
      UpdateMovementAvatar(dialog, point20, nil, "setup")
      UpdateMovementAvatar(dialog, point20, nil, "update_weapon")
      blackboard.movement_avatar:SetVisible(false)
      blackboard.move_avatar_visible = false
      blackboard.move_avatar_time = RealTime()
    end
    if attacker:GetDist(attack_data.step_pos) > const.SlabSizeX / 2 then
      UpdateMovementAvatar(dialog, attack_data.step_pos, false, "update_pos")
      blackboard.movement_avatar:SetState(attacker:GetStateText())
      blackboard.movement_avatar:Face(pt)
      SetAreaMovementAvatarVisibile(dialog, blackboard, true, AreaTargetMoveAvatarVisibilityDelay)
    elseif blackboard.movement_avatar then
      SetAreaMovementAvatarVisibile(dialog, blackboard, false, AreaTargetMoveAvatarVisibilityDelay)
    end
    if blackboard.gamepad_aim then
      local currentLength = blackboard.gamepad_aim_length
      currentLength = currentLength or max_aim_range
      local gamepadState = GetActiveGamepadState()
      local ptRight = gamepadState.RightThumb
      if ptRight ~= point20 then
        local up = ptRight:y() < -1
        currentLength = currentLength + 500 * (up and -1 or 1)
        blackboard.gamepad_aim_length = Clamp(currentLength, min_aim_range, max_aim_range)
      end
      local ptLeft = gamepadState.LeftThumb
      if ptLeft == point20 then
        ptLeft = blackboard.gamepad_aim_last_pos or point20
      end
      blackboard.gamepad_aim_last_pos = ptLeft
      ptLeft = ptLeft:SetY(-ptLeft:y())
      ptLeft = Normalize(ptLeft)
      local cameraDirection = point(camera.GetDirection():xy())
      local directionAngle = atan(cameraDirection:y(), cameraDirection:x())
      directionAngle = directionAngle + 5400
      ptLeft = RotateAxis(ptLeft, axis_z, directionAngle)
      pt = attacker:GetPos() + SetLen(ptLeft, currentLength)
      local zoom = Lerp(800, hr.CameraTacMaxZoom * 10, currentLength, max_aim_range)
      cameraTac.SetZoom(zoom, 50)
    end
    local moved = dialog.target_as_pos ~= pt or blackboard.attacker_pos ~= attack_data.step_pos
    moved = moved or dialog.target_as_pos and dialog.target_as_pos:Dist(pt) > 8 * guim
    if not moved then
      return
    end
    local attacker_pos = attack_data.step_pos
    blackboard.attacker_pos = attacker_pos
    local aim_pt = lAoEGetAimPoint(attacker, pt, attacker_pos3D)
    dialog.target_as_pos = aim_pt
    local attack_distance = Clamp(attacker_pos3D:Dist(aim_pt), min_aim_range, max_aim_range)
    local args = {
      target = aim_pt,
      distance = attack_distance,
      step_pos = dialog.move_step_position
    }
    ApplyDamagePrediction(attacker, action, args)
    dialog:AttackerAimAnimation(pt)
    local cone2d = action.id == "Overwatch" or action.id == "DanceForMe" or action.id == "MGSetup" or action.id == "SniperSetup"
    local cone_target = cone2d and CalcOrientation(attacker_pos, aim_pt) or aim_pt
    local step_positions, step_objs, los_values
    if action.id == "EyesOnTheBack" then
      step_positions, step_objs, los_values = GetAOETiles(attacker_pos, attacker.stance, attack_distance)
      blackboard.mesh = CreateAOETilesCircle(step_positions, step_objs, blackboard.mesh, attacker_pos3D, attack_distance, los_values)
    else
      step_positions, step_objs, los_values = GetAOETiles(attacker_pos, attacker.stance, attack_distance, aoe_params.cone_angle, cone_target, "force2d")
      blackboard.mesh = CreateAOETilesSector(step_positions, step_objs, los_values, blackboard.mesh, attacker_pos3D, aim_pt, guim, attack_distance, aoe_params.cone_angle, false, aoe_params.falloff_start)
    end
    blackboard.mesh:SetColorFromTextStyle("WeaponAOE")
  end