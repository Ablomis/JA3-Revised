function AIPlayAttacks(unit, context, dbg_action, force_or_skip_action)
    if g_AIExecutionController then
      g_AIExecutionController:Log("Unit %s (%d) start attack sequence", unit.unitdatadef_id, unit.handle)
    end
    local enemies = context.enemies
    for i = #enemies, 1, -1 do
      if not IsValidTarget(enemies[i]) then
        table.remove(enemies, i)
      end
    end
    local remaining_free_ap = unit.free_move_ap
    unit:RemoveStatusEffect("FreeMove")
    AIUpdateContext(context, unit)
    if g_AIExecutionController then
      g_AIExecutionController:Log("  Num enemies: %d", #enemies)
      g_AIExecutionController:Log("  Action Points: %d", unit.ActionPoints)
    end
    local dest = not force_or_skip_action and context.ai_destination or GetPackedPosAndStance(unit)
    context.dest_ap[dest] = context.dest_ap[dest] or unit.ActionPoints
    AIPrecalcDamageScore(context, {dest}, context.target_locked or (context.dest_target or empty_table)[dest])
    local signature_action
    if dbg_action then
      context.action_states = context.action_states or {}
      context.action_states[dbg_action] = {}
      dbg_action:PrecalcAction(context, context.action_states[dbg_action])
      if dbg_action:IsAvailable(context, context.action_states[dbg_action]) then
        signature_action = dbg_action
      elseif force_or_skip_action then
        table.insert(failed_actions, dbg_action.BiasId or dbg_action.class)
        return
      end
    end
    if not context.reposition and not unit:HasStatusEffect("Numbness") and not signature_action then
      signature_action = AIChooseSignatureAction(context)
    end
    local default_attack = context.default_attack
    local default_attack_vr = "AIAttack"
    if default_attack and default_attack.FiringModeMember and default_attack.FiringModeMember == "AttackShotgun" then
      default_attack_vr = "AIDoubleBarrel"
    end
    local voice_response = signature_action and (signature_action:GetVoiceResponse() or "") or default_attack_vr
    if voice_response == "" then
      voice_response = nil
    end
    if signature_action then
      if g_AIExecutionController then
        g_AIExecutionController:Log("  Signature Action: %s", signature_action:GetEditorView())
      end
      signature_action:OnActivate(unit)
      if voice_response then
        context.action_states[signature_action].args = context.action_states[signature_action].args or {}
        context.action_states[signature_action].args.voiceResponse = voice_response
      end
      local status = signature_action:Execute(context, context.action_states[signature_action])
      context.ap_after_signature = unit.ActionPoints
      if status then
        return status
      end
      AIReloadWeapons(unit)
      context.max_attacks = context.max_attacks - 1
    elseif g_AIExecutionController then
      g_AIExecutionController:Log("  No Signature Action chosen")
    end
    local target = (context.dest_target or empty_table)[dest]
    if signature_action and (not IsValidTarget(target) or IsKindOf(target, "Unit") and target:IsIncapacitated()) then
      if context.archetype.TargetChangePolicy == "restart" then
        return "restart"
      end
      context.dest_ap[dest] = unit.ActionPoints
      context.target_locked = nil
      AIPrecalcDamageScore(context, {dest})
      target = context.dest_target[dest]
    end
    if IsValidTarget(target) then
      if g_AIExecutionController then
        g_AIExecutionController:Log("  Target: %s", IsKindOf(target, "Unit") and target.unitdatadef_id or target.class)
      end
      local attacks, aim = AICalcAttacksAndAim(context, unit.ActionPoints)
      if context.default_attack.id == "Bombard" and AICheckIndoors(dest) then
        attacks = 0
      end
      local args = {target = target, voiceResponse = voice_response}
      if 1 < attacks then
        unit:SequentialActionsStart()
      end
      if g_AIExecutionController then
        g_AIExecutionController:Log("  Executing %d attacks...", attacks)
      end
      local body_parts = AIGetAttackTargetingOptions(unit, context, target)
      for i = 1, attacks do
        args.aim = aim[i]
        args.target_spot_group = nil
        if body_parts and 0 < #body_parts then
          local pick = table.weighted_rand(body_parts, "chance", InteractionRand(1000000, "Combat"))
          if pick then
            args.target_spot_group = pick.id
          end
        end
        Sleep(0)
        local result = AIPlayCombatAction(context.default_attack.id, unit, nil, args)
        context.max_attack = context.max_attacks - 1
        if g_AIExecutionController then
          g_AIExecutionController:Log("  Attack %d result: %s", i, tostring(result))
        end
        if IsSetpiecePlaying() then
          unit:SequentialActionsEnd()
          return
        end
        AIReloadWeapons(unit)
        if not (result and i ~= attacks and IsValidTarget(unit)) or context.max_attacks <= 0 then
          break
        end
        while IsKindOf(target, "Unit") and target:IsGettingDowned() do
          WaitMsg("UnitDowned", 20)
        end
        if not IsValidTarget(target) or IsKindOf(target, "Unit") and target:IsIncapacitated() then
          if context.archetype.TargetChangePolicy == "restart" then
            unit:SequentialActionsEnd()
            return "restart"
          end
          context.dest_ap[dest] = unit.ActionPoints
          context.target_locked = nil
          AIPrecalcDamageScore(context, {dest})
          target = context.dest_target[dest]
          if not IsValidTarget(target) then
            break
          end
        end
        Sleep(0)
      end
      unit:SequentialActionsEnd()
    elseif unit:HasStatusEffect("StationedMachineGun") and CombatActions.MGPack:GetUIState({unit}) == "enabled" then
      unit:SequentialActionsEnd()
      AIPlayCombatAction("MGPack", unit)
      return "restart"
    elseif unit:HasStatusEffect("StationeSniper") and CombatActions.SniperPack:GetUIState({unit}) == "enabled" then
        unit:SequentialActionsEnd()
        AIPlayCombatAction("SniperPack", unit)
        return "restart"
    elseif g_AIExecutionController then
      g_AIExecutionController:Log("  No target")
    end
    unit:SequentialActionsEnd()
    while not unit:IsIdleCommand() do
      WaitMsg("Idle", 50)
    end
    if unit.ActionPoints + remaining_free_ap == context.start_ap and not unit:HasStatusEffect("ManningEmplacement") then
      if context.closest_dest then
        unit:GainAP(remaining_free_ap)
        local dest = context.closest_dest
        local x, y, z, stance_idx = stance_pos_unpack(dest)
        local move_stance_idx = context.dest_combat_path[dest]
        local cpath = context.combat_paths[move_stance_idx]
        local pt = SnapToPassSlab(x, y, z)
        local path = pt and cpath and cpath:GetCombatPathFromPos(pt)
        if path then
          local goto_stance = StancesList[move_stance_idx]
          if goto_stance ~= unit.stance then
            AIPlayChangeStance(unit, goto_stance, point(point_unpack(path[2])))
          end
          local goto_ap = unit.ActionPoints
          context.ai_destination = path[1]
          AIPlayCombatAction("Move", unit, goto_ap, {
            goto_pos = point(point_unpack(path[1])),
            fallbackMove = true,
            goto_stance = stance_idx
          })
        end
      elseif unit:GetDist(context.unit_pos) < const.SlabSizeX / 2 then
        local revert = true
        if context.archetype.FallbackAction == "overwatch" then
          revert = not AIPlaceFallbackOverwatch(unit, context)
        end
        if revert then
          table.insert(g_UnawareQueue, unit)
        end
      end
    end
  end