function AIStartCombatAction(action_id, unit, ap, args, ...)
    print(action_id)
    ap = ap or CombatActions[action_id]:GetAPCost(unit, args, ...)
    if not ap or ap < 0 or not unit:HasAP(ap, action_id) then
      return false
    end
    if ActionCameraPlaying then
      local waited
      if CurrentActionCamera.wait_signal then
        waited = true
        WaitMsg("ActionCameraWaitSignalEnd", 2000)
      end
      if remove_action_cam_actions[action_id] and g_Combat and g_Combat:IsVisibleByPoVTeam(unit) and not args.reposition then
        if not waited then
          Sleep(500)
        end
        RemoveActionCamera()
      end
    end
    if args and type(args) == "table" then
      if args.target then
        ShowBadgeOfAttacker(unit, true)
      end
      if args.voiceResponse then
        PlayVoiceResponseGroup(unit, args.voiceResponse)
      elseif unit.ai_context and unit.ai_context.movement_action then
        local vr = unit.ai_context.movement_action:GetVoiceResponse()
        if vr then
          PlayVoiceResponseGroup(unit, vr)
        end
      end
    end
    local willBeTracked, visibleMovement
    if action_id == "Move" then
      willBeTracked, visibleMovement = AddToCameraTrackingBehavior(unit, args)
      args.willBeTracked = willBeTracked
      args.visibleMovement = visibleMovement
    end
    StartCombatAction(action_id, unit, ap, args, ...)
    return true
  end

  function StandardAI:Think(unit, debug_data)
    print(unit)
    self:BeginStep("think", debug_data)
    local context = unit.ai_context
    self:BeginStep("destinations", debug_data)
    AIFindDestinations(unit, context)
    self:EndStep("destinations", debug_data)
    self:BeginStep("optimal location", debug_data)
    AIFindOptimalLocation(context, debug_data and debug_data.optimal_scores)
    self:EndStep("optimal location", debug_data)
    self:BeginStep("end of turn location", debug_data)
    AICalcPathDistances(context)
    if self.override_attack_id ~= "" then
      context.override_attack_id = self.override_attack_id
    end
    if self.override_cost_id and CombatActions[self.override_cost_id] then
      context.override_attack_cost = CombatActions[self.override_cost_id]:GetAPCost(unit)
    end
    AIPrecalcDamageScore(context)
    context.override_attack_id = nil
    context.override_attack_cost = nil
    unit.ai_context.ai_destination = AIScoreReachableVoxels(context, self.EndTurnPolicies, self.OptLocWeight, debug_data and debug_data.reachable_scores)
    self:EndStep("end of turn location", debug_data)
    self:BeginStep("movement action", debug_data)
    context.movement_action = AIChooseMovementAction(context)
    self:EndStep("movement action", debug_data)
    self:EndStep("think", debug_data)
    print('unit.id')
  end