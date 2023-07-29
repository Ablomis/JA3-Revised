function Unit:GotoSlab(pos, distance, min_distance, move_anim_type, follow_target, use_stop_anim, interrupted)
  Msg("UnitAnyMovementStart", self)
  if use_stop_anim == nil then
    use_stop_anim = true
  end
  if use_stop_anim ~= false and self.move_stop_anim_len == 0 then
    use_stop_anim = false
  end
  self:SetTargetDummy(false)
  if 0 < self:TimeToPosInterpolationEnd() then
    local cur_pos = self:GetVisualPos()
    if not self:IsValidZ() then
      cur_pos = cur_pos:SetInvalidZ()
    end
    self:SetPos(cur_pos)
  end
  local dest, follow_pos
  if not pos and IsValid(follow_target) then
    dest = self:GetClosestMeleeRangePos(follow_target)
    follow_pos = follow_target:GetPos()
  elseif not pos then
    local tunnel_param = {
      unit = self,
      player_controlled = self.team and self.team:IsPlayerControlled()
    }
    dest = GetCombatPathDestinations(self, nil, nil, nil, tunnel_param, nil, 2 * const.SlabSizeX, false, false, true)
    for i, packed_pos in ipairs(dest) do
      dest[i] = point(point_unpack(packed_pos))
    end
  elseif IsPoint(pos) then
    if self:GetPathFlags(const.pfmVoxelAligned) ~= 0 then
      dest = self:GetVoxelSnapPos(pos)
    end
  elseif self:GetPathFlags(const.pfmVoxelAligned) ~= 0 then
    for i = 1, #pos do
      local pt = self:GetVoxelSnapPos(pos[i])
      if pt then
        dest = dest or {}
        table.insert_unique(dest, pt)
      end
    end
  end
  dest = dest or pos
  local status = self:FindPath(dest, distance, min_distance)
  if self:GetPathPointCount() == 0 then
    if status == 0 then
      return true
    end
    return
  end
  if self:HasStatusEffect("StationedMachineGun") then
    self:MGPack()
  elseif self:HasStatusEffect("StationedSniper") then
        self:SniperPack()
  elseif self:HasStatusEffect("ManningEmplacement") then
    self:LeaveEmplacement()
  elseif self:HasPreparedAttack() then
    self:InterruptPreparedAttack()
  end
  self:SetTargetDummy(false)
  self:SetActionInterruptCallback(function(self)
    self:SetCommand("GotoSlab")
  end)
  self.goto_interrupted = interrupted
  self:PushDestructor(function(self)
    self:SetActionInterruptCallback()
    self.move_follow_target = nil
    self.move_follow_dest = nil
    self.goto_interrupted = nil
  end)
  self.move_follow_target = follow_target
  self.move_follow_dest = dest
  self:SetFootPlant(true)
  self.goto_target = pos
  local pfStep = self.Step
  local pfSleep = self.MoveSleep
  local target, target_time
  local is_moving = false
  Msg("UnitGoToStart", self)
  while true do
    self:TunnelsUnblock()
    if follow_pos and IsValid(follow_target) then
      if IsKindOf(follow_target.traverse_tunnel, "SlabTunnelLadder") then
        follow_target = false
        break
      end
      if 0 < follow_target:GetDist(follow_pos) then
        dest = self:GetClosestMeleeRangePos(follow_target)
        target = false
        follow_pos = follow_target:GetPos()
        self.move_follow_dest = dest
      end
    end
    if not target or self:GetPathPointCount() == 0 then
      status = self:FindPath(dest, distance, min_distance)
      if self:GetPathPointCount() == 0 then
        if status == 0 then
          status = pfFinished
        end
        break
      end
      local tunnel_start_idx = pf.GetPathNextTunnelIdx(self, const.TunnelMaskTraverseWait)
      if tunnel_start_idx then
        local tunnel_entrance = pf.GetPathPoint(self, tunnel_start_idx)
        local tunnel_exit = pf.GetPathPoint(self, tunnel_start_idx - 2)
        local last_target = target or self:GetPos()
        target = nil
        if (last_target == tunnel_entrance or type(last_target) == "table" and table.find(last_target, tunnel_entrance)) and CanUseTunnel(tunnel_entrance, tunnel_exit, self) then
          self:TunnelBlock(tunnel_entrance, tunnel_exit)
          self:TunnelBlock(tunnel_exit, tunnel_entrance)
          local tunnel_start_idx2 = pf.GetPathNextTunnelIdx(self, const.TunnelMaskTraverseWait, tunnel_start_idx - 2)
          if tunnel_start_idx2 then
            local tunnel_entrance2 = pf.GetPathPoint(self, tunnel_start_idx2)
            local tunnel_exit2 = pf.GetPathPoint(self, tunnel_start_idx2 - 2)
            target = GetAlternateRoutesStartPoints(self, tunnel_entrance2, tunnel_exit2, const.TunnelMaskTraverseWait)
          else
            target = dest
          end
        end
        if not target then
          target = GetAlternateRoutesStartPoints(self, tunnel_entrance, tunnel_exit, const.TunnelMaskTraverseWait)
        end
      elseif target ~= dest then
        target = dest
      end
      target_time = now()
      if target ~= dest then
        self:FindPath(target)
      end
      local pcount = self:GetPathPointCount()
      local next_pt = 1 < pcount and pf.GetPathPoint(self, pcount - 1) or nil
      if next_pt and not next_pt:IsValid() then
        next_pt = 2 < pcount and pf.GetPathPoint(self, pcount - 2) or nil
      end
      local angle = next_pt and CalcOrientation(self.target_dummy or self, next_pt)
      self:UpdateMoveAnim(nil, move_anim_type, next_pt)
      local move_anim = GetStateName(self:GetMoveAnim())
      self:PlayTransitionAnims(move_anim, angle)
      self:GotoTurnOnPlace(next_pt)
    end
    local target_distance, target_min_distance
    if target == dest then
      target_distance = distance
      target_min_distance = min_distance
    else
    end
    local wait
    status = pfStep(self, target, target_distance, target_min_distance)
    if 0 < status then
      if not is_moving then
        is_moving = true
        self:StartMoving()
      end
      while 0 < status do
        if not use_stop_anim or not self:GotoStopCheck() then
          pfSleep(self, status)
        end
        self:GotoAction()
        if follow_pos and IsValid(follow_target) and 0 < follow_target:GetDist(follow_pos) then
          if IsKindOf(follow_target.traverse_tunnel, "SlabTunnelLadder") then
            status = pfFinished
            dest = self:GetPos()
            target = dest
            break
          end
          local newdest = self:GetClosestMeleeRangePos(follow_target)
          if newdest ~= dest then
            dest = newdest
            target = newdest
          end
        end
        status = pfStep(self, target, target_distance, target_min_distance)
      end
    end
    if status == pfFinished and target == dest then
      break
    end
    if status == pfFinished and target_time ~= now() then
      target = nil
    elseif status == pfTunnel then
      self:ClearEnumFlags(const.efResting)
      local tunnel = pf.GetTunnel(self)
      if not tunnel then
        status = pfFailed
        break
      end
      if not self:InteractTunnel(tunnel) then
        status = pfFailed
        break
      end
      if not IsValid(tunnel) then
        tunnel = pf.GetTunnel(self)
      end
      local tunnel_in_use = IsValid(tunnel) and tunnel.tunnel_type & const.TunnelMaskTraverseWait ~= 0 and not CanUseTunnel(tunnel:GetEntrance(), tunnel:GetExit(), self)
      if IsValid(tunnel) and not tunnel_in_use then
        if not is_moving then
          is_moving = true
          self:StartMoving()
        end
        local use_stop_anim = self.move_stop_anim_len > 0 and (pf.GetPathNextTunnelIdx(self, const.TunnelMaskWalkStopAnim) or 1) == self:GetPathPointCount()
        self:TraverseTunnel(tunnel, nil, nil, true, false, use_stop_anim)
        self:GotoAction()
      else
        target = nil
        wait = tunnel_in_use
      end
    elseif target ~= dest then
      wait = true
    else
      break
    end
    if wait then
      local anim = self:GetWaitAnim()
      if self:GetState() ~= anim then
        self:SetState(anim, const.eKeepComponentTargets)
      end
      local target_pos
      if IsPoint(target) then
        target_pos = target
      elseif IsValid(target) then
        target_pos = target:GetPos()
      else
        for i, p in ipairs(target) do
          if i == 1 or IsCloser(self, p, target_pos) then
            target_pos = p
          end
        end
      end
      if target_pos and not target_pos:Equal2D(self:GetPosXYZ()) then
        self:Face(target_pos)
      end
      if is_moving then
        is_moving = false
        self:StopMoving()
      end
      self:ClearPath()
      pfSleep(self, 200)
      self:GotoAction()
    end
  end
  self:PopAndCallDestructor()
  self.goto_target = false
  if is_moving then
    self:StopMoving()
  end
  Msg("UnitMovementDone", self)
  Msg("UnitGoTo", self)
  ObjModified(self)
  return status == pfFinished
end
function Unit:UninterruptableGoto(pos, straight_line)
  local wasInterruptable = self.interruptable
  if wasInterruptable then
    self:EndInterruptableMovement()
  end
  pos = self:GetVoxelSnapPos(pos) or pos
  self.goto_target = pos
  self:UpdateMoveAnim()
  if straight_line then
    self:Goto(pos, "sl")
  else
    self:Goto(pos)
  end
  self.goto_target = false
  Msg("UnitMovementDone", self)
  if wasInterruptable then
    self:BeginInterruptableMovement()
  end
end
function Unit:Step(...)
  self:UpdateMoveSpeed()
  local status = AnimMomentHook.Step(self, ...)
  if 0 < status then
    if not self.combat_path then
      local target_dummy = {
        obj = self,
        anim = self:GetWaitAnim(),
        phase = 0,
        pos = self:GetPos(),
        angle = self:GetAngle()
      }
      local interrupts = self:CheckProvokeOpportunityAttacks("move", {target_dummy})
      self:ProvokeOpportunityAttacksWarning("move", interrupts)
      self:ProvokeOpportunityAttacks("move", target_dummy)
    end
    self:UpdateInWaterFX()
  end
  return status
end
function Unit:Goto(...)
  local pfStep = self.Step
  self:SetTargetDummy(false)
  self:UpdateMoveAnim()
  local status = pfStep(self, ...)
  if 0 <= status or status == pfTunnel then
    local topmost_goto, is_moving
    if not self.goto_target then
      topmost_goto = true
      self.goto_target = (...)
    end
    local pfSleep = self.MoveSleep
    while true do
      if 0 < status then
        if not is_moving then
          is_moving = true
          self:StartMoving()
        end
        pfSleep(self, status)
      elseif status == pfTunnel then
        local tunnel = pf.GetTunnel(self)
        if not tunnel then
          status = pfFailed
          break
        end
        if not is_moving then
          is_moving = true
          self:StartMoving()
        end
        if not self:InteractTunnel(tunnel) then
          status = pfFailed
          break
        end
        if IsValid(tunnel) then
          self:TraverseTunnel(tunnel)
        end
      else
        break
      end
      status = pfStep(self, ...)
    end
    if is_moving then
      self:StopMoving()
    end
    if topmost_goto then
      self.goto_target = false
    end
    CombatPathReset(self)
    ObjModified(self)
  end
  local res = status == pfFinished
  Msg("UnitGoTo", self)
  return res
end
function Unit:IsInterruptable()
  return self.interruptable or self:IsIdleCommand()
end
function Unit:IsInterruptableMovement()
  return not self.interruptable or self.goto_target or self.move_attack_in_progress
end
function Unit:InterruptCommand(...)
  self:Interrupt("SetCommand", ...)
end
function NetSyncEvents.InterruptCommand(unit, ...)
  unit:InterruptCommand(...)
end
function Unit:SetActionInterruptCallback(func)
  self.action_interrupt_callback = func
end
function Unit:Interrupt(func, ...)
  if self:IsInterruptable() then
    if not func and self.action_interrupt_callback then
      func = self.action_interrupt_callback
      self.action_interrupt_callback = false
    end
    if not func then
      return
    end
    if type(func) ~= "function" then
      func = self[func]
    end
    if func then
      func(self, ...)
    end
    return
  end
  self.interrupt_callback = pack_params(func or false, ...)
end
function Unit:BeginInterruptableMovement()
  self.interruptable = true
  local callback = self.interrupt_callback
  if callback then
    self.interrupt_callback = false
    self:Interrupt(unpack_params(callback))
  end
end
function Unit:EndInterruptableMovement()
  self.interruptable = false
end
function Unit:IsEnemyPresent()
  if g_Combat then
    return true
  end
  local dlg = GetInGameInterfaceModeDlg()
  if dlg and dlg:HasMember("teams") then
    for i, t in ipairs(dlg.teams) do
      if not t.player_ally then
        return true
      end
    end
  end
  return false
end
function Unit:GetVoxelSnapPos(pos, angle, stance)
  pos = pos or self:GetPos()
  if not pos or not pos:IsValid() then
    return
  end
  stance = stance or self.stance
  local face_pos = pos + RotateRadius(const.SlabSizeX, angle or self:GetAngle(), pos)
  pos = SnapToPassSlabSegment(pos, face_pos, const.TunnelMaskWalk)
  if not pos then
    return
  elseif stance == "Prone" then
    local prone_angle = FindProneAngle(self, pos, angle)
    return pos, prone_angle
  end
  return pos, angle or self:GetAngle()
end
function Unit:GetGridCoords()
  local x, y, z = self:GetPosXYZ()
  return PosToGridCoords(x, y, z)
end
function PosToGridCoords(x, y, z)
  z = z or terrain.GetHeight(x, y)
  local gx, gy, gz = WorldToVoxel(x, y, z)
  while true do
    local wx, wy, wz = VoxelToWorld(gx, gy, gz)
    if z > wz then
      gz = gz + 1
    else
      break
    end
  end
  return gx, gy, gz
end
function Unit:EnterCombat()
  local wasInterruptable = self.interruptable
  if wasInterruptable then
    self:EndInterruptableMovement()
  end
  self:UninterruptableGoto(self:GetVisualPos())
  self:SetTargetDummyFromPos()
  self:UpdateAttachedWeapons()
  if HasPerk(self, "SharpInstincts") then
    if self.stance == "Standing" then
      self:DoChangeStance("Crouch")
    end
    self:ApplyTempHitPoints(CharacterEffectDefs.SharpInstincts:ResolveValue("tempHP"))
  end
  if self:HasStatusEffect("ManningEmplacement") and self == SelectedObj then
    self:FlushCombatCache()
    self:RecalcUIActions(true)
    ObjModified("combat_bar")
  end
  Msg("UnitEnterCombat", self)
  if wasInterruptable then
    self:BeginInterruptableMovement()
  end
end
function Unit:ExitCombat()
  if self:IsNPC() and not self.dummy and (not self:IsDead() or self.immortal) and self.retreating then
    local markers = MapGetMarkers("Entrance")
    local nearest, dist
    for _, marker in ipairs(markers) do
      local d = self:GetDist(marker)
      if not nearest or dist > d then
        nearest, dist = marker, d
      end
    end
    self:SetCommand("ExitMap", nearest)
  end
  self.ActionPoints = self:GetMaxActionPoints()
  if self:IsDowned() then
    self:SetCommand("DownedRally")
  elseif not self:IsDead() then
    self:PushDestructor(function()
      local weapon = self:GetActiveWeapons("Firearm")
      local weapons = self:GetEquippedWeapons(self.current_weapon, "Firearm")
      local needs_reload
      local i = 1
      while not needs_reload and i <= #weapons do
        local weapon = weapons[i]
        if weapon and (weapon.ammo and weapon.ammo.Amount or 0) < weapon.MagazineSize then
          needs_reload = true
          break
        end
        for slot, sub in sorted_pairs(weapons[i].subweapons) do
          if IsKindOf(sub, "Firearm") then
            weapons[#weapons + 1] = sub
          end
        end
        i = i + 1
      end
      if needs_reload then
        Sleep(self:Random(1000))
        local _, err = CombatActions.Reload:GetUIState({self})
        if err == AttackDisableReasons.NoAmmo then
          if not weapon.ammo or weapon.ammo.Amount == 0 then
            PlayVoiceResponse(self, "NoAmmo")
          else
            PlayVoiceResponse(self, "AmmoLow")
          end
        else
          RunCombatAction("ReloadMultiSelection", self, 0, {reload_all = true})
        end
      end
    end)
    self:LeaveEmplacement(false, "exit combat")
    if self.combat_behavior == "Bandage" then
      self:EndCombatBandage(nil, "instant")
    elseif self.behavior == "Bandage" then
      self:SetBehavior()
    end
    if g_Pindown[self] then
      self:InterruptPreparedAttack()
    end
    if self:IsNPC() and self.spawner then
      local x, y, z = self:GetGridCoords()
      local sx, sy, sz = PosToGridCoords(self.spawner:GetPosXYZ())
      if x == sx and y == sy and z == sz then
        local spawner_angle = self.spawner:GetAngle()
        self:SetAngle(spawner_angle)
      end
    end
    if self:IsMerc() then
      local allEnemies = GetAllEnemyUnits(self)
      local aliveEnemies = 0
      for _, enemy in ipairs(allEnemies) do
        if not enemy:IsDead() and not enemy:IsDefeatedVillain() then
          aliveEnemies = aliveEnemies + 1
        end
      end
      if aliveEnemies == 0 then
        self:DoChangeStance("Standing")
      end
    elseif self.species == "Human" and self.stance ~= "Standing" then
      self:DoChangeStance("Standing")
    end
    self:PopAndCallDestructor()
    if self:IsIdleCommand() then
      self:SetCommand("Idle")
    end
    self:UpdateAttachedWeapons()
  elseif self.immortal then
    self:ReviveOnHealth()
    self:ChangeStance(false, 0, "Standing")
    self:SetCommand("Idle")
  end
end
function Unit:GetStepActionFX()
  return self.is_moving and (self.move_step_fx or "StepRun") or "StepWalk"
end
function Unit:OnAnimMoment(moment, anim)
  anim = anim or GetStateName(self)
  local couldBeGendered = not self.fx_actor_class and moment == "start"
  local animFxName = FXAnimToAction(anim)
  local fxTarget = self.anim_moment_fx_target or nil
  if not couldBeGendered or not PlayFX(animFxName, moment, self.gender, fxTarget) then
    PlayFX(animFxName, moment, self, fxTarget)
  end
  local anim_moments_hook = self.anim_moments_hook
  if type(anim_moments_hook) == "table" and anim_moments_hook[moment] then
    local method = moment_hooks[moment]
    return self[method](self, anim)
  end
end
function Unit:GetCommandParam(name, command)
  command = command or self.command
  return self.command_specific_params and self.command_specific_params[command] and self.command_specific_params[command][name]
end
function Unit:GetCommandParamsTbl(command)
  command = command or self.command
  self.command_specific_params = self.command_specific_params or {}
  self.command_specific_params[command] = self.command_specific_params[command] or {}
  return self.command_specific_params[command]
end
function Unit:SetCommandParamValue(command, param, value)
  local param_tbl = self:GetCommandParamsTbl(command)
  param_tbl[param] = value
end
function Unit:SetCommandParams(command, params)
  command = command or self.command
  self.command_specific_params = self.command_specific_params or {}
  if params then
    self.command_specific_params[command] = params
    if params.weapon_anim_prefix then
      self:UpdateAttachedWeapons()
    end
  end
end
local idle_commands = {
  [false] = true,
  Idle = true,
  IdleSuspicious = true,
  AimIdle = true,
  PreparedAttackIdle = true,
  PreparedBombardIdle = true,
  Dead = true,
  VillainDefeat = true,
  Hang = true,
  Downed = true,
  Cower = true,
  CombatBandage = true,
  ExitMap = true,
  OverheardConversationHeadTo = true
}
local prepared_attacks = {OverwatchAction = true, PinDown = true}
function Unit:IsUsingPreparedAttack()
  return prepared_attacks[self.combat_behavior]
end
function Unit:IsIdleCommand(check_pending)
  return idle_commands[self.command or false] and (not check_pending or not self.pending_aware_state and not HasCombatActionInProgress(self))
end
function Unit:Idle()
  NetUpdateHash("sync loading state", GameState.sync_loading)
  SetCombatActionState(self, nil)
  self.being_interacted_with = false
  if not self.move_attack_in_progress then
    self.move_attack_target = nil
  end
  if self:IsDead() then
    if self.behavior == "Despawn" then
      self:SetCommand("Despawn")
    elseif self.behavior ~= "Hang" and self.behavior ~= "Dead" then
      self:SetBehavior("Dead")
      self:SetCombatBehavior("Dead")
    end
  else
    if self.stance == "Prone" and self:GetValidStance("Prone") ~= "Prone" then
      self:DoChangeStance("Crouch")
    end
    if g_Combat and self:CanCower() and self.team.side == "neutral" and not g_Combat:ShouldEndCombat() then
      self:SetCommand("Cower")
    end
  end
  self:UpdateInWaterFX()
  if self:IsDead() then
    if self.behavior == "Hang" then
      self:SetCommand("Hang")
    else
      self:SetCommand("Dead")
    end
  elseif self:HasStatusEffect("Unconscious") then
    self:SetCommand("Downed")
  elseif IsSetpieceActor(self) then
    self:SetCommand("SetpieceIdle", true)
  elseif self:HasStatusEffect("Suspicious") then
    if g_Combat then
      self:RemoveStatusEffect("Suspicious")
    else
      return self:SuspiciousRoutine()
    end
  elseif self:HasCommandsInQueue() then
    return
  elseif g_Combat and self.combat_behavior then
    self:SetCommand(self.combat_behavior, table.unpack(self.combat_behavior_params or empty_table))
  elseif not g_Combat and self.behavior and not self:HasStatusEffect("Suspicious") then
    local enemy = self:GetCommandParam("idle_forcing_dist")
    if not IsValid(enemy) or not self:IdleForcingDist(enemy) then
      self:SetCommandParamValue(self.command, "idle_forcing_dist", nil)
      self:SetCommand(self.behavior, table.unpack(self.behavior_params or empty_table))
    end
  end
  local anim_style = self:GetIdleStyle()
  local base_idle = anim_style and anim_style:GetMainAnim() or self:GetIdleBaseAnim()
  local can_reposition = not g_Combat or not self:IsAware()
  local pos, orientation_angle
  if self.return_pos then
    pos = self.return_pos
    local voxel = SnapToVoxel(self)
    if not pos:Equal2D(voxel) then
      orientation_angle = CalcOrientation(pos, voxel)
    end
  else
    pos = GetPassSlab(self) or self:GetPos()
  end
  local dummy_orientation_angle = self:GetPosOrientation(pos, nil, self.stance, true, can_reposition)
  orientation_angle = orientation_angle or self.auto_face and dummy_orientation_angle or self:GetPosOrientation(pos, nil, self.stance, false, can_reposition)
  local dummy_orientation_angle = self.auto_face and orientation_angle or self:GetPosOrientation(pos, nil, self.stance, true, can_reposition)
  self:SetTargetDummy(pos, dummy_orientation_angle, base_idle, 0)
  if g_Combat and (not self:IsNPC() or self:IsAware()) then
    Msg("Idle", self)
  end
  if self.aim_action_id and not HasCombatActionInProgress(self) then
    self:SetCommand("AimIdle")
  end
  self:SetWeaponLightFx(false)
  self:SetIK("AimIK", false)
  if self.play_sequential_actions then
    self:SetCommand("SequentialActionsIdle")
  end
  self:EndInterruptableMovement()
  self:PlayTransitionAnims(base_idle, orientation_angle)
  self:AnimatedRotation(orientation_angle, base_idle)
  self:BeginInterruptableMovement()
  self:SetCommandParamValue("Idle", "move_anim", "WalkSlow")
  if self:ShouldBeIdle() then
    self.cur_idle_style = anim_style and anim_style.Name or nil
    if anim_style then
      local anim = self:GetStateText()
      if anim_style:HasAnimation(anim) then
        if self:GetAnimPhase() ~= 0 and not self:IsAnimEnd() then
          Sleep(self:TimeToAnimEnd())
        end
      elseif anim == anim_style.Start then
        Sleep(self:TimeToAnimEnd())
      elseif (anim_style.Start or "") ~= "" and IsValidAnim(self, anim_style.Start) then
        self:SetState(anim_style.Start, const.eKeepComponentTargets)
        Sleep(self:TimeToAnimEnd())
      end
      self:SetState(anim_style:GetRandomAnim(self), const.eKeepComponentTargets)
    elseif self:GetAnimPhase(1) == 0 or self:IsAnimEnd() or not IsAnimVariant(self:GetStateText(), base_idle) then
      self:SetRandomAnim(base_idle, const.eKeepComponentTargets, nil, true)
    end
    Sleep(self:TimeToAnimEnd())
  else
    self:IdleRoutine()
  end
end
function Unit:IdleSuspicious()
  if self.stance == "Standing" and self.species == "Human" then
    local anim
    if self.gender == "Male" then
      anim = self:TryGetActionAnim("IdlePassive2", self.stance)
    else
      local weapon = self:GetWeaponAnimPrefix()
      if weapon == "nw" or self.carry_flare then
        anim = self:TryGetActionAnim("IdlePassive", self.stance)
      elseif weapon == "mk" then
        anim = self:TryGetActionAnim("IdlePassive6", self.stance)
      else
        anim = self:TryGetActionAnim("IdlePassive2", self.stance)
      end
    end
    if self.carry_flare then
      anim = string.gsub(anim, "^%a*_", "nw_")
    end
    anim = self:ModifyWeaponAnim(anim)
    self:SetState(anim)
    Sleep(self:TimeToAnimEnd())
  end
  self:SetCommand("Idle")
end
function Unit:TakeSlabExploration()
  local pos, angle = self:GetVoxelSnapPos()
  if not pos then
    return
  end
  local vx, vy = SnapToVoxel(self:GetVisualPosXYZ())
  if not pos:Equal2D(vx, vy) then
    self:Goto(pos, "sl")
    pos, angle = self:GetVoxelSnapPos()
  end
  self:SetPos(pos)
  self:SetOrientationAngle(angle)
end
function OnMsg.GatherFXMoments(list)
  table.insert_unique(list, "start")
  table.insert_unique(list, "end")
  table.insert(list, "action_start")
  table.insert(list, "action_end")
  table.insert(list, "WeaponGripStart")
  table.insert(list, "WeaponGripEnd")
end
function Unit:OnMomentWeaponGripStart()
  self:SetWeaponGrip(true)
end
function Unit:OnMomentWeaponGripEnd()
  self:SetWeaponGrip(false)
end
function Unit:SequentialActionsStart()
  self.play_sequential_actions = true
end
function Unit:SequentialActionsEnd()
  if not self.play_sequential_actions then
    return
  end
  self.play_sequential_actions = false
  if self.command == "SequentialActionsIdle" then
    self:SetCommand("Idle")
  end
end
function Unit:SequentialActionsIdle()
  Halt()
end
function Unit:ReturnToCover(prefix)
  local pos = self.return_pos
  if not pos then
    return false
  end
  if not IsCloser(self, pos, const.SlabSizeX / 2) and CanOccupy(self, pos) and IsPassSlabStep(self, pos) then
    local voxel = SnapToVoxel(self)
    local angle = pos:Equal2D(voxel) and self:GetAngle() or CalcOrientation(pos, voxel)
    self:SetTargetDummyFromPos(pos, angle)
    local side = AngleDiff(self:GetVisualOrientationAngle(), angle) < 0 and "Left" or "Right"
    prefix = prefix or string.match(self:GetStateText(), "^(%a+_).*") or self:GetWeaponAnimPrefix()
    local anim = string.format("%s%s_Aim_End", prefix, side)
    self:SetIK("AimIK", false)
    self:SetFootPlant(true)
    if IsValidAnim(self, anim) then
      if self:CanQuickPlayInCombat() then
        self:SetPos(pos)
        self:SetOrientationAngle(angle)
      else
        anim = self:ModifyWeaponAnim(anim)
        self:SetPos(pos, self:GetAnimDuration(anim))
        self:RotateAnim(angle, anim)
      end
    else
      local msg = string.format("Missing animation \"%s\" for \"%s\"", anim, self.unitdatadef_id)
      StoreErrorSource(self, msg)
      self:SetPos(pos)
      self:SetOrientationAngle(angle)
    end
  end
  self.return_pos = false
  return true
end
function Unit:MovePlayAnimSpeedUpdate(anim, anim_flags, crossfade, dest)
  self:SetState(anim, anim_flags or 0, crossfade or -1)
  repeat
    self:SetAnimSpeed(1, self:CalcMoveSpeedModifier())
    local t = self:TimeToAnimEnd()
    if dest then
      self:SetPos(dest, t)
    end
  until not WaitWakeup(t)
end
function Unit:MovePlayAnim(anim, pos1, pos2, anim_flags, crossfade, ground_orient, angle, start_offset, end_offset, sleep_mod, acceleration)
  if not anim or not self:HasState(anim) then
    self:SetPos(pos2)
    self:SetFootPlant(true)
    return
  end
  if not angle then
    if pos1:Equal2D(pos2) then
      angle = self:GetAngle()
    else
      angle = CalcOrientation(pos1, pos2)
    end
  end
  if not pos1:IsValidZ() then
    pos1 = pos1:SetTerrainZ()
  end
  local pos2_3d = pos2:IsValidZ() and pos2 or pos2:SetTerrainZ()
  local t = self:GetVisualDist(pos1) == 0 and 100 or 0
  self:SetPos(pos1)
  self:SetFootPlant(false, t)
  self:SetOrientationAngle(angle, t)
  self:SetState(anim, anim_flags or const.eKeepComponentTargets, crossfade or -1)
  local anim_full_step = GetEntityStepVector(self:GetEntity(), anim)
  local use_animation_step = pos1 ~= pos2_3d and anim_full_step:Len() > 10 * guic
  local duration = GetAnimDuration(self:GetEntity(), anim)
  local phase1 = self:GetAnimMoment(anim, "start") or 0
  local phase2 = self:GetAnimMoment(anim, "end")
  if not phase2 then
    local hit = self:GetAnimMoment(anim, "hit")
    phase2 = (hit or duration) - 200
  end
  if phase1 > phase2 then
    phase2 = phase1
  end
  start_offset = start_offset or point30
  end_offset = end_offset or point30
  if 0 < phase1 then
    local action_phase1 = self:GetAnimMoment(anim, "action_start")
    if action_phase1 then
      action_phase1 = Min(action_phase1, phase1)
    else
      action_phase1 = phase1 / 2
    end
    if 0 < action_phase1 then
      local v = use_animation_step and self:GetStepVector(anim, angle, 0, action_phase1) or point30
      local dest = pos1 + v + start_offset
      local t = self:TimeToPhase(1, action_phase1) or 0
      self:SetPos(dest, t)
      Sleep(t)
    end
    local v = use_animation_step and self:GetStepVector(anim, angle, 0, phase1) or point30
    local dest = pos1 + v + start_offset
    local t = self:TimeToPhase(1, phase1) or 0
    self:SetPos(dest, t)
    Sleep(t)
  end
  local v = use_animation_step and self:GetStepVector(anim, angle, phase2, duration - phase2) or point30
  local phase2_pos = pos2_3d - v + end_offset
  local t = phase1 < phase2 and self:TimeToPhase(1, phase2) or 0
  if t == 0 then
    self:SetPos(phase2_pos)
    if ground_orient then
      self:SetGroundOrientation(angle, t)
    end
  else
    local anim_speed, new_anim_speed
    if use_animation_step and self:IsCommandThread() then
      local extra_step_z = pos2_3d:z() - (pos1:z() + anim_full_step:z())
      local scale = 1000
      if anim_full_step:Len2D() > abs(anim_full_step:z()) then
        local extra_dist_2d = pos1:Dist2D(pos2) - anim_full_step:Len2D()
        if extra_dist_2d > const.SlabSizeX / 4 then
          local anim_dist2d = abs(self:GetStepVector(anim, 0, phase1, phase2 - phase1):x())
          scale = 0 < anim_dist2d and MulDivRound(1000, anim_dist2d + extra_dist_2d, anim_dist2d) or 1000000
          scale = Min(scale, 1500)
        end
        local fall_time = extra_step_z < 0 and self:GetGravityFallTime(abs(pos2_3d:z() - pos1:z()), -4000, const.Combat.Gravity) or 0
        if fall_time > phase2 - phase1 then
          scale = Max(scale, MulDivRound(1000, fall_time, phase2 - phase1))
        end
      elseif extra_step_z < 0 and anim_full_step:z() <= -const.SlabSizeZ / 2 then
        scale = MulDivRound(1000, pos2_3d:z() - pos1:z(), anim_full_step:z())
      end
      if scale ~= 1000 then
        anim_speed = self:GetAnimSpeed(1)
        new_anim_speed = MulDivRound(anim_speed, 1000, scale)
        self:SetAnimSpeed(1, new_anim_speed)
        t = self:TimeToPhase(1, phase2) or 0
      end
    end
    local acc = acceleration and self:GetAccelerationAndStartSpeed(phase2_pos, 0, t) or 0
    self:SetAcceleration(acc)
    self:SetPos(phase2_pos, t)
    if ground_orient then
      self:SetGroundOrientation(angle, t)
    end
    if acceleration or anim_speed then
      self:PushDestructor(function(self)
        if IsValid(self) then
          self:SetAcceleration(0)
          if anim_speed and self:GetAnimSpeed(1) == new_anim_speed then
            self:SetAnimSpeed(1, anim_speed)
          end
        end
      end)
    end
    Sleep(t)
    if acceleration or anim_speed then
      self:PopAndCallDestructor()
    end
  end
  local action_phase2 = self:GetAnimMoment(anim, "action_end")
  if action_phase2 then
    action_phase2 = Max(action_phase2, phase2)
  else
    action_phase2 = phase2
  end
  if phase2 < action_phase2 then
    local v = self:GetStepVector(anim, angle, action_phase2, duration - action_phase2)
    local dest = pos2_3d - v + end_offset
    local t = self:TimeToPhase(1, action_phase2) or 0
    self:SetPos(dest, t)
    Sleep(t)
  end
  t = self:TimeToAnimEnd()
  if 999999999 <= t then
    t = 0
  end
  if sleep_mod then
    t = MulDivRound(t, sleep_mod, 100)
  end
  self:SetPos(pos2_3d, t)
  Sleep(t)
  self:SetPos(pos2)
  self:SetFootPlant(true)
end
function Unit:CanFaceEnemy(enemy)
  return not enemy:IsDead() and not enemy:IsDowned() and not enemy:HasStatusEffect("Hidden")
end
function Unit:IsConsideredEnemy(unit)
  if self:IsOnEnemySide(unit) then
    return true
  end
  for _, groupname in ipairs(self.Groups) do
    local group_modifiers = gv_AITargetModifiers[groupname]
    for group, _ in pairs(group_modifiers) do
      if table.find(unit.Groups, group) then
        return true
      end
    end
  end
end
function Unit:GetClosestEnemy(pos)
  if not IsValid(self) then
    return
  end
  pos = SnapToVoxel(pos or self)
  local face_targets = {}
  local threshold = const.SlabSizeX / 2
  local closest_enemy, min_dist
  local visibility = g_Visibility[self]
  for _, unit in ipairs(visibility) do
    if IsValid(unit) and (not min_dist or IsCloser(unit, pos, min_dist)) then
      local enemy = self:IsConsideredEnemy(unit)
      if IsValidTarget(unit) and enemy and self:CanFaceEnemy(unit) then
        table.insert(face_targets, unit)
        local dist = unit:GetDist(pos)
        if not closest_enemy or min_dist > dist then
          closest_enemy = unit
          min_dist = dist + threshold
        end
      end
    end
  end
  if not closest_enemy then
    return
  end
  if 1 < #face_targets then
    local cur_angle = self:GetAngle()
    local closest_adiff = abs(AngleDiff(CalcOrientation(pos, closest_enemy), cur_angle))
    for _, unit in ipairs(face_targets) do
      if unit ~= closest_enemy and IsCloser(unit, pos, min_dist) then
        local adiff = abs(AngleDiff(CalcOrientation(pos, unit), cur_angle))
        if closest_adiff > adiff then
          closest_enemy = unit
          closest_adiff = adiff
        end
      end
    end
  end
  return closest_enemy
end
function Unit:IsUsingCover()
  local cover = GetHighestCover(self)
  return cover and (cover == 2 or cover == 1 and self.stance ~= "Standing")
end
function Unit:GetCoverToClosestEnemy(pos)
  pos = pos or self:GetVoxelSnapPos()
  if not pos or not pos:IsValid() then
    return
  end
  local enemies = table.copy(GetEnemies(self))
  local closest_enemy, closest_angle, closest_face_target, closest_dist
  local ow_target = self:GetOverwatchTarget()
  for _, groupname in ipairs(self.Groups) do
    local group_modifiers = gv_AITargetModifiers[groupname]
    for target_group, mod in pairs(group_modifiers) do
      for _, obj in ipairs(Groups[target_group]) do
        if IsKindOf(obj, "Unit") then
          table.insert_unique(enemies, obj)
        end
      end
    end
  end
  local update_closest = function(check_pos, angle)
    for _, enemy in ipairs(enemies) do
      local dist = IsValid(enemy) and enemy:GetDist(check_pos)
      if dist and (not closest_dist or dist < closest_dist) then
        closest_enemy = enemy
        closest_dist = dist
        closest_angle = angle
        closest_face_target = check_pos
      end
    end
  end
  local covers
  if self:IsEnemyPresent() then
    covers = GetCoversAt(pos)
  end
  if not next(covers) then
    if ow_target then
      return false, ow_target
    end
    if #enemies == 0 then
      return
    else
      update_closest(pos or self:GetPos())
      return false, closest_enemy
    end
  end
  local covers_count = table.count(covers)
  if covers_count == 1 then
    local angle, cover = next(covers)
    return cover, pos + GetCoverOffset(angle)
  end
  if #enemies == 0 then
    local angle, cover = next(covers)
    return cover, pos + GetCoverOffset(angle)
  end
  for angle, cover in sorted_pairs(covers) do
    local cover_center = pos + GetCoverOffset(angle)
    update_closest(cover_center, angle)
  end
  local cover = covers[(closest_angle + 10800) % 21600]
  return cover, closest_face_target
end
function Unit:GetPosOrientation(pos, angle, stance, auto_face, can_reposition)
  pos = pos or GetPassSlab(self) or self:GetPos()
  if not pos:IsValid() then
    return 0
  end
  local bandage_target = self:GetBandageTarget()
  if not angle then
    angle = self:GetVisualOrientationAngle()
    if self.last_orientation_angle and abs(AngleDiff(angle, self.last_orientation_angle)) < 300 then
      angle = self.last_orientation_angle
    end
  end
  stance = stance or self.stance
  if self:HasStatusEffect("ManningEmplacement") then
    auto_face = false
  elseif IsValid(bandage_target) then
    auto_face = true
  end
  if auto_face == nil then
    auto_face = self.auto_face
  end
  if g_Combat and auto_face and self:IsAware() and not self:HasStatusEffect("Exposed") then
    local to_face = IsValid(bandage_target) and bandage_target or self:GetClosestEnemy(pos)
    if to_face then
      angle = CalcOrientation(pos, to_face.return_pos or to_face)
    end
    if self.species == "Human" and (stance == "Standing" or stance == "Crouch") and GetHighestCover(pos) == const.CoverHigh then
      local face_angle
      if to_face then
        local action = self:GetDefaultAttackAction("ranged")
        if action and action.AimType ~= "melee" then
          local lof_args = {
            action_id = action.id,
            obj = self,
            step_pos = pos,
            stance = "Standing",
            aimIK = false,
            prediction = true
          }
          local lof_data = CheckLOF(to_face, lof_args)
          if lof_data and not IsCloser2D(pos, lof_data.step_pos, const.SlabSizeX / 2) then
            face_angle = CalcOrientation(pos, lof_data.step_pos)
          end
        end
      end
      face_angle = face_angle or GetUnitOrientationToHighCover(pos, angle)
      if face_angle then
        angle = face_angle
      end
    end
  end
  if self.body_type == "Large animal" then
    local can_reposition = can_reposition ~= false or not self:IsEqualPos(pos)
    local snap_angle, fallback = FindLargeUnitAngle(self, pos, angle, can_reposition)
    angle = snap_angle or fallback or angle
  elseif self.species == "Human" and stance == "Prone" then
    angle = FindProneAngle(self, pos, angle)
  end
  return angle
end
function Unit:SetTargetDummyFromPos(pos, angle, can_reposition)
  pos = pos or GetPassSlab(self) or self:GetPos()
  if not pos:IsValid() or self:IsDead() then
    return self:SetTargetDummy(false)
  end
  local orientation_angle = self:GetPosOrientation(pos, angle, self.stance, true, can_reposition)
  local anim_style = GetAnimationStyle(self, self.cur_idle_style)
  local base_idle = anim_style and anim_style:GetMainAnim() or self:GetIdleBaseAnim()
  return self:SetTargetDummy(pos, orientation_angle, base_idle, 0)
end
function Unit:SetTargetDummy(pos, orientation_angle, anim, phase, stance, ground_orient)
  local dummy = self.target_dummy
  if dummy and dummy.locked then
    return
  end
  local changed
  if pos ~= false then
    pos = pos or GetPassSlab(self) or self:GetPos()
    if not orientation_angle then
      orientation_angle = self:GetOrientationAngle()
      if self.stance == "Prone" then
        orientation_angle = FindProneAngle(self, nil, orientation_angle, 3600)
      end
    end
    anim = anim or self:GetStateText()
    phase = phase or self:GetAnimPhase()
    stance = stance or self.stance
    if ground_orient == nil then
      ground_orient = select(2, self:GetFootPlantPosProps(stance))
    end
    if not dummy then
      if self.body_type == "Large animal" then
        dummy = PlaceObject("TargetDummyLargeAnimal", {obj = self})
      else
        dummy = PlaceObject("TargetDummy", {obj = self})
      end
      self.target_dummy = dummy
      changed = changed or "uninit"
    end
    if changed or not dummy:IsEqualPos(pos) then
      dummy:SetPos(pos)
      changed = changed or "pos"
    end
    if changed or dummy:GetStateText() ~= anim then
      dummy:SetState(anim)
      dummy:SetAnimSpeed(1, 0)
      changed = changed or "animation"
    end
    if changed or dummy:GetAnimPhase() ~= phase then
      dummy:SetAnimPhase(1, phase)
      changed = changed or "phase"
    end
    local prev_angle, prev_axisx, prev_axisy, prev_axisz
    if not changed then
      prev_angle, prev_axisx, prev_axisy, prev_axisz = dummy:GetAngle(), dummy:GetVisualAxisXYZ()
    end
    if dummy.stance ~= stance then
      dummy.stance = stance
      changed = changed or "stance"
    end
    if ground_orient then
      dummy:ChangePathFlags(const.pfmGroundOrient)
      dummy:SetGroundOrientation(orientation_angle, 0)
    else
      dummy:ChangePathFlags(0, const.pfmGroundOrient)
      dummy:SetAxisAngle(axis_z, orientation_angle)
    end
    if not changed then
      local new_angle, new_axisx, new_axisy, new_axisz = dummy:GetAngle(), dummy:GetVisualAxisXYZ()
      if new_angle ~= prev_angle or new_axisx ~= prev_axisx or new_axisy ~= prev_axisy or new_axisz ~= prev_axisz then
        changed = true
      end
    end
    dummy:ClearEnumFlags(const.efResting)
  elseif dummy then
    changed = true
    DoneObject(dummy)
    self.target_dummy = false
  end
  if changed then
    Msg("TargetDummiesChanged", self)
    return true
  end
  return false
end
function Unit:GenerateTargetDummiesFromPath(path)
  path = path or self.combat_path
  local dummies = {}
  local base_idle = self:GetIdleBaseAnim(self.stance)
  local AddDummyPos = function(pos, angle, insert_idx, last_step_pos)
    if pos ~= last_step_pos then
      table.insert(dummies, {
        obj = self,
        anim = base_idle,
        phase = 0,
        pos = pos,
        angle = angle,
        stance = self.stance,
        insert_idx = insert_idx
      })
    end
  end
  local p1 = self:GetPos()
  local angle = self:GetOrientationAngle()
  local dummy = self.target_dummy
  if dummy and dummy:GetPos() == p1 then
    table.insert(dummies, {
      obj = self,
      anim = dummy:GetStateText(),
      phase = dummy:GetAnimPhase(1),
      pos = dummy:GetPos(),
      angle = dummy:GetAngle(),
      insert_idx = #path + 1
    })
  else
    AddDummyPos(p1, angle)
  end
  for i = #path, 1, -1 do
    local p0 = p1
    p1 = point(point_unpack(path[i]))
    if p0 ~= p1 then
      if not p0:Equal2D(p1) then
        angle = CalcOrientation(p0, p1)
      end
      local tunnel = pf.GetTunnel(p0, p1)
      if not tunnel then
        ForEachWalkStep(p0, p1, AddDummyPos, angle, i + 1, p1)
      end
      AddDummyPos(p1, angle)
    end
  end
  return dummies
end
function Unit:IsOnEnemySide(other)
  return self.team and other.team and band(self.team.enemy_mask, other.team.team_mask) ~= 0
end
function Unit:IsOnAllySide(other)
  return self.team and other.team and band(self.team.ally_mask, other.team.team_mask) ~= 0
end
function Unit:IsPlayerAlly()
  return self.team and self.team.player_ally
end
function Unit:ReportStatusEffectsInLog()
  return const.DbgStatusEffects and (not self.team or self.team.side ~= "neutral")
end
local visibility_spots = {
  "Head",
  "Neck",
  "Shoulderl",
  "Shoulderr",
  "Ribsupperl",
  "Ribsupperr",
  "Ribslowerl",
  "Ribslowerr",
  "Pelvisl",
  "Pelvisr",
  "Groin",
  "Shoulderl",
  "Shoulderr",
  "Elbowl",
  "Elbowr",
  "Wristl",
  "Wristr",
  "Kneel",
  "Kneer",
  "Anklel",
  "Ankler"
}
local visibility_spot_indices = {}
function Unit:GetVisibilitySpotIndices()
  local entity = self:GetEntity()
  local current_state = self:GetState()
  local states = visibility_spot_indices[entity]
  local indices = states and states[current_state]
  if not indices then
    states = states or {}
    visibility_spot_indices[entity] = states
    indices = {}
    local n = 1
    for i = 1, #visibility_spots do
      local spot_name = visibility_spots[i]
      local first, last = GetSpotRange(entity, 0, spot_name)
      for idx = first, last do
        indices[n] = idx
        n = n + 1
      end
    end
    states[current_state] = indices
  end
  return indices or empty_table
end
function Unit:IsNPC()
  local unit_data = UnitDataDefs[self.unitdatadef_id]
  return not unit_data or not IsMerc(unit_data)
end
function Unit:IsMerc()
  local unit_data = UnitDataDefs[self.unitdatadef_id]
  return unit_data and IsMerc(unit_data)
end
function Unit:IsCivilian()
  return self.team and self.team.side and self.team.side == "neutral" and self.species == "Human"
end
function Unit:GetSightRadius(other, base_sight, step_pos)
  local modifier = 100
  local hidden = IsKindOf(other, "Unit") and other:HasStatusEffect("Hidden")
  local sight = base_sight or not (not self:IsAware() or hidden) and const.Combat.AwareSightRange or const.Combat.UnawareSightRange
  local night_time = GameState.Night or GameState.Underground
  if IsIlluminated(other, nil, nil, step_pos) then
    night_time = false
  end
  if self:HasStatusEffect("Distracted") or self:HasStatusEffect("Blinded") then
    return MulDivRound(sight, const.Combat.SightModMinValue, 100) * const.SlabSizeX, hidden, night_time
  elseif self:HasStatusEffect("Suspicious") then
    modifier = modifier + (self:GetEffectValue("suspicious_sight_mod") or 0)
  elseif not self:IsAware() and self:HasStatusEffect("HighAlert") then
    modifier = modifier + (CharacterEffectDefs.Suspicious:ResolveValue("sight_modifier_max") or 0)
  end
  if IsKindOf(other, "Unit") and not other:IsDead() and not other:IsDowned() then
    if hidden then
      local steath_mod = Max(0, MulDivRound(other.Agility - self.Wisdom, const.Combat.SightModStealthStatDiff, 100))
      if other.stance == "Prone" then
        steath_mod = steath_mod + const.Combat.SightModHiddenProne
      end
      local perk = other:GetStatusEffect("Stealthy")
      if perk then
        steath_mod = steath_mod + perk:ResolveValue("stealthy_detection")
      end
      modifier = modifier - steath_mod
    end
    if HasPerk(other, "NaturalCamouflage") then
      modifier = modifier + CharacterEffectDefs.NaturalCamouflage:ResolveValue("sight_mod")
    end
    local armor = other:GetItemInSlot("Torso", "Armor")
    if armor and armor.Camouflage then
      modifier = modifier - const.Combat.CamoSightPenalty
    end
  end
  local env_factors = other and GetVoxelStealthParams(step_pos or other) or 0
  if band(env_factors, const.vsFlagTallGrass) ~= 0 then
    modifier = modifier + const.EnvEffects.BrushSightMod
  end
  if night_time and other then
    local darknessMod = const.EnvEffects.DarknessSightMod
    modifier = modifier + darknessMod
  end
  if GameState.Fog then
    modifier = modifier + const.EnvEffects.FogSightMod
  end
  if GameState.DustStorm then
    modifier = modifier + const.EnvEffects.DustStormSightMod
  end
  if GameState.FireStorm then
    modifier = modifier + const.EnvEffects.FireStormSightMod
  end
  if IsKindOf(other, "Unit") then
    local ox, oy, oz
    if step_pos then
      ox, oy, oz = PosToGridCoords(step_pos:xyz())
    else
      ox, oy, oz = other:GetGridCoords()
    end
    local x, y, z = self:GetGridCoords()
    if oz >= z + const.EnvEffects.SightHeightDiffThreshold then
      modifier = modifier + const.EnvEffects.SightHeightDiffMod
    elseif g_Exploration and z > oz + const.EnvEffects.SightHeightDiffThreshold then
      modifier = modifier + -(const.EnvEffects.SightHeightDiffMod * 2)
    end
  end
  modifier = Clamp(modifier, const.Combat.SightModMinValue, const.Combat.SightModMaxValue)
  local sightAmount = MulDivRound(sight, modifier, 100) * const.SlabSizeX
  if self.command == "IdleSuspicious" then
    sightAmount = sightAmount + const.SlabSizeX / 4
  end
  return sightAmount, hidden, night_time
end
function Unit:CanSee(other, overridePos, overrideStance)
  local sight = self:GetSightRadius(other)
  local target = other
  if IsKindOf(other, "Unit") and other.visibility_override then
    target = stance_pos_pack(other.visibility_override.pos, StancesList[other.stance])
  elseif IsPoint(overridePos) then
    self = stance_pos_pack(overridePos, StancesList[overrideStance or self.stance])
  end
  if CheckLOS(target, self, sight) then
    return true
  end
  return false
end
function Unit:Face(...)
  if self.ground_orient then
    self:SetGroundOrientation(...)
  else
    CObject.Face(self, ...)
  end
end
function Unit:SetOrientationAngle(angle, ...)
  if self.ground_orient then
    self:SetGroundOrientation(angle, ...)
    self.last_orientation_angle = angle
  else
    CObject.SetAngle(self, angle, ...)
    self.last_orientation_angle = nil
  end
end
function Unit:GetOccupiedPos()
  return self.target_dummy and self.target_dummy:GetPos()
end
function Unit:GetVisualVoxels(pos, stance, voxels)
  local x, y, z
  voxels = voxels or {}
  if pos then
    if type(pos) == "number" then
      x, y, z = point_unpack(pos)
    elseif IsPoint(pos) and pos:IsValid() then
      x, y, z = pos:xyz()
    else
      return voxels
    end
  else
    if not self:IsValidPos() then
      return voxels
    end
    x, y, z = self:GetPosXYZ()
  end
  z = z or terrain.GetHeight(x, y)
  local snapped_z = select(3, VoxelToWorld(WorldToVoxel(x, y, z)))
  if z - snapped_z > const.SlabSizeZ / 2 then
    z = z + const.SlabSizeZ
  end
  x, y, z = WorldToVoxel(x, y, z)
  voxels[1] = point_pack(x, y, z)
  local head_voxel
  if self.species == "Human" then
    if (stance or self.stance) == "Prone" then
      head_voxel = voxels[1]
    else
      head_voxel = point_pack(x, y, z + 1)
      voxels[#voxels + 1] = head_voxel
    end
  elseif self.species == "Crocodile" then
    local angle = self:GetOrientationAngle()
    local sina, cosa = sincos(angle)
    local slabsize = const.SlabSizeX
    local dx = MulDivRound(slabsize, cosa, 4096)
    local dy = MulDivRound(slabsize, sina, 4096)
    if dx > slabsize / 2 then
      dx = 1
    elseif dx < -slabsize / 2 then
      dx = -1
    end
    if dy > slabsize / 2 then
      dy = 1
    elseif dy < -slabsize / 2 then
      dy = -1
    end
    voxels[#voxels + 1] = point_pack(x + dx, y + dy, z)
    voxels[#voxels + 1] = point_pack(x - dx, y - dy, z)
  end
  return voxels, head_voxel or voxels[1]
end
function Unit:ChangeStance(action_id, cost_ap, stance, args)
  if self.stance == stance then
    return
  end
  if self.species ~= "Human" then
    return
  end
  local pfclass = CalcPFClass(self.team and self.team.side, stance, self.body_type)
  local pos = GetPassSlab(self, pfclass)
  if not pos then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  self:SetPos(pos)
  local wasInterruptable = self.interruptable
  if wasInterruptable then
    self:EndInterruptableMovement()
  end
  PlayFX("ChangeStance", "start", self)
  self:PushDestructor(function(self)
    PlayFX("ChangeStance", "end", self)
  end)
  local angle = args and args.angle
  if stance == "Prone" then
    angle = FindProneAngle(self, nil, angle)
  end
  if angle then
    self:SetOrientationAngle(angle, 100)
  end
  self:DoChangeStance(stance)
  self:PopAndCallDestructor()
  if wasInterruptable then
    self:BeginInterruptableMovement()
  end
end
local AnimationStance = {nw_Standing_MortarIdle = "Crouch", nw_Standing_MortarFire = "Crouch"}
function Unit:GetHitStance()
  return AnimationStance[self:GetStateText()] or self.stance
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
  if effects.BandagingDowned or effects.Revealed or effects.StationedMachineGun or effects.ManningEmplacement then
    return false
  end
  return true
end
function Unit:GetStanceToStealth(stance)
  stance = stance or self.stance
  if self.species == "Human" and stance == "Standing" and not HasPerk(self, "FleetingShadow") then
    return "Crouch"
  end
  return stance
end
function Unit:Hide()
  local stance = self:GetStanceToStealth()
  if not self:CanStealth(stance) then
    return
  end
  local wasInterruptable
  if stance ~= self.stance then
    wasInterruptable = self.interruptable
    if wasInterruptable then
      self:EndInterruptableMovement()
    end
    self:DoChangeStance(stance)
  end
  self:AddStatusEffect("Hidden")
  self:UpdateMoveAnim()
  PlayVoiceResponse(self, "BecomeHidden")
  if wasInterruptable then
    self:BeginInterruptableMovement()
  end
end
function Unit:Unhide()
  self.goto_hide = false
  self.goto_stance = false
  self:RemoveStatusEffect("Hidden")
  self:UpdateMoveAnim()
end
function Unit:CanTakeCover()
  return self.species == "Human" and self.stance ~= "Prone" and 0 < (GetHighestCover(self.return_pos or self) or 0)
end
function Unit:TakeCover()
  if not self:CanTakeCover() then
    return
  end
  self:InterruptPreparedAttack()
  self:AddStatusEffect("Protected")
  UpdateTakeCoverAction()
  self:DoChangeStance("Crouch")
  ObjModified(self)
end
function OnMsg.UnitAnyMovementStart(unit)
  unit:RemoveStatusEffect("Protected")
  UpdateTakeCoverAction()
end
function OnMsg.UnitStanceChanged(unit)
  if unit.stance ~= "Crouch" then
    unit:RemoveStatusEffect("Protected")
  end
end
local sneak_ui_update_thread = false
function OnMsg.UnitStealthChanged(obj)
  if obj == SelectedObj or table.find(Selection or empty_table, obj) then
    sneak_ui_update_thread = sneak_ui_update_thread or CreateGameTimeThread(function()
      while obj.command == "ExitCombat" do
        Sleep(100)
      end
      ObjModified("combat_bar")
      sneak_ui_update_thread = false
    end)
  end
end
function Unit:UpdateHidden()
  if self.species ~= "Human" then
    if self:CanStealth() then
      if not self:HasStatusEffect("Hidden") then
        self:AddStatusEffect("Hidden")
        PlayVoiceResponse(self, "BecomeHidden")
      end
    else
      self:RemoveStatusEffect("Hidden")
    end
  elseif not self:CanStealth() then
    self:RemoveStatusEffect("Hidden")
  end
  self:UpdateFXClass()
end
function Unit:UpdateFXClass()
  if not self.visible then
    self.fx_actor_class = "Hidden"
  elseif IsMerc(self) then
    self.fx_actor_class = "ImportantUnit"
  elseif self.species ~= "Human" then
    self.fx_actor_class = self.species
  elseif self:IsAmbientUnit() then
    self.fx_actor_class = "AmbientUnit"
  else
    self.fx_actor_class = nil
  end
end
function OnMsg.GetCustomFXInheritActorRules(rules)
  rules[#rules + 1] = "ImportantUnit"
  rules[#rules + 1] = "Unit"
end
function OnMsg.UnitMovementDone(obj)
  if GameState.sync_loading then
    return
  end
  obj:RemoveStatusEffect("Focused")
  for _, unit in ipairs(g_Units) do
    unit:UpdateHidden()
  end
  NetUpdateHash("UnitMovement", obj, obj:GetPos())
end
function OnMsg.SyncLoadingDone()
  for _, unit in ipairs(g_Units) do
    unit:UpdateHidden()
  end
end
function OnMsg.ExplorationStart()
  for _, unit in ipairs(g_Units) do
    unit:UpdateHidden()
  end
end
function Unit:GotoChangeStance(stance)
  if not stance or self.stance == stance then
    return
  end
  if not self:CanSwitchStance(stance) then
    return
  end
  local prev_stance = self.stance
  self.stance = stance
  ObjModified(self)
  self:UpdateMoveAnim()
  self:ChangePathFlags(const.pfDirty)
  self:UpdateHidden()
  ObjModified(self)
  if stance == "Prone" or prev_stance == "Prone" then
    local base_idle = self:GetIdleBaseAnim()
    PlayTransitionAnims(self, base_idle)
  end
  Msg("UnitStanceChanged", self)
end
function Unit:DoChangeStance(stance)
  self.stance = stance
  self.aim_results = false
  self.aim_attack_args = false
  ObjModified(self)
  self:SetFootPlant(true)
  self:SetTargetDummyFromPos()
  self:UpdateMoveAnim()
  local base_idle = self:GetIdleBaseAnim()
  local angle = (self.target_dummy or self):GetAngle()
  PlayTransitionAnims(self, base_idle, angle)
  if not g_Combat and self.command ~= "ExitCombat" and self.command ~= "TakeCover" then
    self:GotoSlab(self:GetPos())
  end
  self:UpdateHidden()
  ObjModified(self)
  Msg("UnitStanceChanged", self)
end
local stance_to_stance_def
function FindStanceToStanceDef(start_stance, end_stance)
  stance_to_stance_def = nil
  ForEachPresetInGroup("StanceToStanceAP", "Default", function(def, group, start_stance, end_stance)
    if def.start_stance == start_stance and def.end_stance == end_stance then
      stance_to_stance_def = def
    end
  end, start_stance, end_stance)
  return stance_to_stance_def
end
function GetStanceToStanceAP(start_stance, end_stance)
  if start_stance == end_stance then
    return 0
  end
  local def = FindStanceToStanceDef(start_stance, end_stance)
  if def then
    return def.ap_cost
  end
end
function Unit:GetStanceToStanceAP(stance, ownStanceOverride)
  local currentStance = ownStanceOverride or self.stance
  if stance == currentStance then
    return -1
  end
  if HasPerk(self, "HitTheDeck") and stance == "Prone" then
    return 0
  end
  return GetStanceToStanceAP(currentStance, stance) or 0
end
function Unit:GetArchetype()
  local arch = Archetypes[self.script_archetype]
  if arch then
    return arch
  end
  return Archetypes[self.current_archetype] or Archetypes.Soldier
end
function Unit:GetCurrentArchetype()
  return Archetypes[self.current_archetype] or Archetypes.Soldier
end
function Unit:GetEquippedQuickItems(class, slot_name)
  local items = {}
  self:ForEachItemInSlot(slot_name, class, function(item, s, l, t, items)
    if not item:IsWeapon() then
      items[#items + 1] = item
    end
  end, items)
  return items
end
function Unit:GetActiveWeapons(class, strict_order)
  if class == "UnarmedWeapon" then
    self.unarmed_weapon = self.unarmed_weapon or g_UnarmedWeapon
    return self.unarmed_weapon, nil, {
      self.unarmed_weapon
    }
  end
  if self:GetStatusEffect("ManningEmplacement") then
    local handle = self:GetEffectValue("hmg_emplacement")
    local obj = HandleToObject[handle]
    if obj and obj.weapon and (not class or IsKindOf(obj.weapon, class)) then
      obj.weapon.emplacement_weapon = true
      return obj.weapon, nil, {
        obj.weapon
      }
    end
  end
  self.combat_cache = self.combat_cache or {}
  local key = string.format("active_weapons_%s%s", class or "all", strict_order and "-strict" or "")
  local weapons = self.combat_cache[key]
  if not weapons then
    weapons = {}
    local firearms = {}
    self.combat_cache[key] = weapons
    local equipped
    if IsSetpiecePlaying() and IsSetpieceActor(self) then
      equipped = self:GetEquippedWeapons("SetpieceWeapon")
    end
    if not equipped or #equipped == 0 then
      equipped = self:GetEquippedWeapons(self.current_weapon)
    end
    for _, o in ipairs(equipped) do
      local match = not class or class ~= "Firearm" or not IsKindOfClasses(o, "HeavyWeapon", "FlareGun")
      match = match and (not class or IsKindOf(o, class))
      if match then
        table.insert(weapons, o)
      end
      if IsKindOf(o, "FirearmBase") then
        table.insert(firearms, o)
      end
    end
    for _, item in ipairs(firearms) do
      for slot, weapon in sorted_pairs(item.subweapons) do
        local match = not class or class ~= "Firearm" or not IsKindOfClasses(weapon, "HeavyWeapon", "FlareGun")
        match = match and (not class or IsKindOf(weapon, class))
        if match then
          table.insert(weapons, weapon)
        end
      end
    end
  end
  if not strict_order then
    local weapon1Exhausted = not self:CanUseWeapon(weapons[1])
    local weapon2Exhausted = not self:CanUseWeapon(weapons[2])
    local weapon2IsntSubWeapon = weapons[1] and weapons[2] and not weapons[2].parent_weapon
    if weapons[1] and weapons[2] and weapon1Exhausted and not weapon2Exhausted and weapon2IsntSubWeapon then
      weapons[1], weapons[2] = weapons[2], weapons[1]
    end
  end
  return weapons[1], weapons[2], weapons
end
function FindWeaponInSlotById(unit, slot, item_id)
  local weapons = unit:GetEquippedWeapons(slot)
  for _, weapon in ipairs(weapons) do
    if weapon.id == item_id then
      return weapon
    end
    if IsKindOf(weapon, "Firearm") then
      for slot, sub in sorted_pairs(weapon.subweapons) do
        if sub.id == item_id then
          return sub
        end
      end
    end
  end
end
function UnitProperties:GetWeaponByDefIdOrDefault(class, def_id, packed_pos, item_id)
  if packed_pos then
    local weapon = self:GetItemAtPackedPos(packed_pos)
    return weapon
  else
    local weapons = self:GetEquippedWeapons(self.current_weapon)
    local alt_slot = self.current_weapon == "Handheld A" and "Handheld B" or "Handheld A"
    table.iappend(weapons, self:GetEquippedWeapons(alt_slot))
    table.iappend(weapons, self:GetEquippedWeapons("Inventory"))
    local n = #weapons
    for i = 1, n do
      local weapon = weapons[i]
      if IsKindOf(weapon, "FirearmBase") then
        for _, sub in sorted_pairs(weapon.subweapons) do
          weapons[#weapons + 1] = sub
        end
      end
    end
    local matched
    if def_id then
      matched = table.ifilter(weapons, function(idx, item)
        return IsKindOf(item, def_id)
      end)
    end
    if #(matched or empty_table) == 0 then
      matched = weapons
    end
    if item_id then
      for _, weapon in ipairs(matched) do
        if weapon.id == item_id then
          return weapon
        end
      end
    end
    return matched[1]
  end
end
function Unit:OutOfAmmo(weapon, amount)
  weapon = weapon or self:GetActiveWeapons()
  return weapon and weapon:HasMember("ammo") and (not weapon.ammo or weapon.ammo.Amount < (amount or 1))
end
function Unit:IsWeaponJammed(weapon)
  weapon = weapon or self:GetActiveWeapons()
  return IsKindOf(weapon, "Firearm") and weapon.jammed
end
function Unit:CanUseWeapon(weapon, num_shots)
  if not weapon then
    return false, AttackDisableReasons.NoWeapon
  elseif weapon.Condition <= 0 then
    return false, AttackDisableReasons.WeaponBroken
  end
  if IsKindOf(weapon, "Firearm") then
    if weapon.jammed then
      return false, AttackDisableReasons.WeaponJammed
    elseif not weapon.ammo or weapon.ammo.Amount < (num_shots or 1) then
      return false, AttackDisableReasons.OutOfAmmo
    end
  end
  return true
end
AttackDisableReasons = {
  NoAP = T(526265371339, "<error>Insufficient AP</error>"),
  NoWeapon = T(379423324402, "<error>No active weapon</error>"),
  WeaponJammed = T(522229430242, "<error>The weapon is jammed</error>"),
  WeaponBroken = T(187856566334, "<error>The weapon is broken</error>"),
  OutOfAmmo = T(694516627561, "<error>Out of ammo</error>"),
  InsufficientAmmo = T(48284763278, "<error>Not enough ammo</error>"),
  InvalidTarget = T(332327094836, "<error>Invalid target</error>"),
  InvalidSelfTarget = T(858041242091, "<error>Cannot target self</error>"),
  NoTeamSight = T(308212362965, "<error>Out of team sight</error>"),
  NoTeamSightLivewire = T(316258123370, "<error>Out of sight (Livewire)</error>"),
  NoTarget = T(282471750002, "<error>No target</error>"),
  NoBandageTarget = T(409300745676, "<error>No target. Mercs with lowered max HP are healed in the Sat View.</error>"),
  OutOfRange = T(460146513440, "<error>Out Of Range</error>"),
  ExtremeRange = T(990882650338, "<error>Extreme range</error>"),
  CantReach = T(533577783995, "<error>Can't reach</error>"),
  NoLoS = T(871138850086, "<error>No line of sight</error>"),
  InsufficientMeds = T(589775173410, "<error>Not enough Meds</error>"),
  FullHP = T(270490338639, "<error>At full health</error>"),
  NoLockpick = T(179588362502, "<error>Can't pick a lock without a lockpick</error>"),
  NoCrowbar = T(871669664824, "<error>You need a crowbar to attempt to break this</error>"),
  NoCutters = T(457726671611, "<error>You need a wire cutter.</error>"),
  OnlyStanding = T(589960103330, "<error>Only available in Standing stance</error>"),
  Cooldown = T(591766545566, "<error>This action can be used once per turn</error>"),
  BandagingDowned = T(216477918933, "<error>Currently treating a downed ally</error>"),
  NoAmmo = T(958927508781, "<error>Out of ammo for this weapon</error>"),
  FullClip = T(342527613232, "<error>This weapon is already fully loaded</error>"),
  FullClipHaveOther = T(193803534966, "<error>This weapon is already fully loaded. You can change the ammo type from the inventory.</error>"),
  SignatureRecharge = T(422255119652, "<error>Can only be used once per conflict</error>"),
  SignatureRechargeOnKill = T(895217484195, "<error>Recharges on kill with another attack.</error>"),
  Water = T(389919921473, "<error>Not allowed in water</error>"),
  Stairs = T(377843918366, "<error>Not allowed on stairs</error>"),
  Impassable = T(150460717914, "<error>Impassable</error>"),
  Occupied = T(173250243531, "<error>Occupied</error>"),
  Indoors = T(927774491188, "<error>Cannot use indoors</error>"),
  InEnemySight = T(749326574456, "<error>You cannot sneak while in enemy sight.</error>"),
  Revealed = T(393250883796, "<error>You revealed yourself to the enemies and cannot sneak this turn.</error>"),
  CannotSneak = T(637272145762, "<error>You cannot sneak at this time.</error>"),
  WrongWeapon = T(734977105577, "<error>Wrong active weapon.</error>"),
  RangedWeapon = T(464635588615, "<error>Requires a Firearm.</error>"),
  MacheteWeapon = T(899395755721, "<error>Requires a Machete.</error>"),
  KnifeWeapon = T(270404087675, "<error>Requires a Knife.</error>"),
  CombatOnly = T(607543203128, "<error>Must be used during combat</error>"),
  RequiresMachineGun = T(293921437394, "<error>Requires a Machine Gun</error>"),
  RequiresUnarmed = T(252038182681, "<error>Must be Unarmed</error>"),
  NotInCover = T(553368221470, "<error>Only available in cover spots</error>"),
  AlreadyActive = T(492570194020, "Already active"),
  NotInMeleeRange = T(863084049025, "<error>Approach to attack</error>"),
  NotInBandageRange = T(576945352567, "<error>Approach to bandage</error>"),
  NotSneaking = T(465045630742, "<error>Must be sneaking</error>"),
  MinDist = T(753745088840, "<error>Too close</error>"),
  NoLine = T(127026985840, "<error>Straight path required</error>"),
  TooFar = T(137552442717, "<error>Too Far</error>"),
  UsingMachineGun = T(504207281345, "<error>Currently operating a machine gun</error>"),
  NoFireArc = T(698332993342, "<error>No fire arc</error>")
}
function GetUnitNoApReason(unit)
  if unit:GetBandageTarget() then
    return AttackDisableReasons.BandagingDowned
  end
  return AttackDisableReasons.NoAP
end
function Unit:SetEffectValue(id, value)
  self.effect_values = self.effect_values or {}
  self.effect_values[id] = value
end
function Unit:GetEffectValue(id)
  return self.effect_values and self.effect_values[id]
end
function Unit:GetEffectExpirationTurn(id, key)
  local store_key = string.format("%s:%s", id, key)
  return self.effect_values and self.effect_values[store_key] or -1
end
function Unit:SetEffectExpirationTurn(id, key, turn)
  local store_key = string.format("%s:%s", id, key)
  self.effect_values = self.effect_values or {}
  self.effect_values[store_key] = Max(turn, self.effect_values[store_key] or -1)
end
function Unit:CanAttack(target, weapon, action, aim, goto_pos, skip_ap_check, is_free_aim)
  if GetInGameInterfaceMode() == "IModeDeployment" then
    return false
  end
  if action.ActionType ~= "Melee Attack" and action.ActionType ~= "Ranged Attack" then
    return false
  end
  local args = {
    target = target,
    goto_pos = goto_pos,
    aim = aim
  }
  if action then
    if action.ActionType == "Melee Attack" and target == self then
      return false, AttackDisableReasons.InvalidSelfTarget
    end
    if action.ActionType == "Melee Attack" and action.AimType ~= "melee-charge" and IsValid(target) then
      if IsKindOf(target.traverse_tunnel, "SlabTunnelLadder") then
        return false, AttackDisableReasons.InvalidTarget
      end
      if not IsMeleeRangeTarget(self, goto_pos, nil, target) then
        local attack_pos = self:GetClosestMeleeRangePos(target)
        if not IsMeleeRangeTarget(self, attack_pos, nil, target) then
          return false, AttackDisableReasons.CantReach
        end
        local reason = g_Combat and AttackDisableReasons.CantReach or AttackDisableReasons.TooFar
        if attack_pos then
          local cost = action:GetAPCost(self, args)
          if cost < 0 or cost > self.ActionPoints then
            return false, reason
          end
        else
          return false, reason
        end
      end
    end
    if action.ActionType == "Ranged Attack" and target == self then
      return false, AttackDisableReasons.InvalidTarget
    end
    if not (action.id ~= "UnarmedAttack" and action.id ~= "ExplodingPalm" and (action.id ~= "Brutalize" or weapon)) or action.id == "MarkTarget" then
      weapon = self:GetActiveWeapons("UnarmedWeapon")
    end
    local cooldown_turn = self:GetEffectExpirationTurn(action.id, "cooldown")
    if action.group == "SignatureAbilities" then
      local recharge = self:GetSignatureRecharge(action.id)
      if recharge then
        if recharge.on_kill then
          return false, AttackDisableReasons.SignatureRechargeOnKill
        end
        return false, AttackDisableReasons.SignatureRecharge
      end
    end
    if g_Combat and cooldown_turn >= g_Combat.current_turn then
      return false, AttackDisableReasons.Cooldown
    elseif not skip_ap_check and not self:HasAP(action:GetAPCost(self, args), action.id, args) then
      return false, GetUnitNoApReason(self)
    end
    if action.id == "OnMyTarget" then
      return true
    elseif action.id == "MGBurstFire" then
      if IsKindOf(target, "Unit") and not CombatActionTargetFilters.MGBurstFire(target, {self}) then
        return false, AttackDisableReasons.OutOfRange
      end
    elseif action.id == "Bombard" or action.id == "FireFlare" then
      if self.indoors then
        return false, AttackDisableReasons.Indoors
      end
    elseif action.id == "PinDown" and not CombatActionTargetFilters.Pindown(target, self, weapon) then
      return false, AttackDisableReasons.InvalidTarget
    end
  end
  if not weapon then
    return false, AttackDisableReasons.NoWeapon
  elseif 0 >= (weapon.Condition or 100) then
    return false, AttackDisableReasons.WeaponBroken
  end
  if IsKindOf(weapon, "Grenade") or IsKindOf(weapon, "HeavyWeapon") and weapon.trajectory_type == "parabola" then
    if action and target then
      local range = action:GetMaxAimRange(self, weapon)
      if goto_pos then
        if goto_pos:Dist(target) > range * const.SlabSizeX then
          return false, AttackDisableReasons.OutOfRange
        end
      elseif self:GetDist(target) > range * const.SlabSizeX then
        return false, AttackDisableReasons.OutOfRange
      end
      local results = action:GetActionResults(self, args)
      if not results.trajectory or #results.trajectory == 0 then
        return false, AttackDisableReasons.NoFireArc
      end
    end
    return true
  end
  local fireArm = IsKindOf(weapon, "Firearm")
  if fireArm and weapon.jammed then
    return false, AttackDisableReasons.WeaponJammed
  end
  local ammo_amount = fireArm and weapon:GetAutofireShots(action) or 1
  local min_ammo_amount = action:ResolveValue("min_shots")
  if fireArm and not ammo_amount then
    local params = weapon:GetAreaAttackParams(action.id, self)
    ammo_amount = params and params.used_ammo
  end
  ammo_amount = Min(ammo_amount or 1, min_ammo_amount or ammo_amount or 1)
  if action.ActionType ~= "Other" and self:OutOfAmmo(weapon, ammo_amount) then
    return false, AttackDisableReasons.OutOfAmmo
  end
  if IsKindOf(weapon, "MeleeWeapon") and action.ActionType == "Ranged Attack" and target then
    local range = action:GetMaxAimRange(self, weapon)
    local attack_pos = goto_pos or self:GetPos()
    local target_pos = IsPoint(target) and target or target:GetPos()
    if attack_pos:Dist(target_pos) > range * const.SlabSizeX then
      return false, AttackDisableReasons.OutOfRange
    end
  end
  local optionalTargetAndNoTarget = not action.RequireTargets and not target
  local invalidObjectTarget = not action.RequireTargets and not IsValid(target) and not IsPoint(target)
  local pointTarget = not action.RequireTargets and IsPoint(target)
  if optionalTargetAndNoTarget or invalidObjectTarget or pointTarget then
    return true
  end
  local targetIsUnit = IsKindOf(target, "Unit")
  local targetIsTrap = IsKindOf(target, "Trap")
  local freeAimMeleeTarget = IsValid(target) and is_free_aim and action.ActionType == "Melee Attack"
  if not target and action.RequireTargets then
    return false, AttackDisableReasons.NoTarget
  end
  if not targetIsUnit and not targetIsTrap and not freeAimMeleeTarget then
    return false, AttackDisableReasons.InvalidTarget
  end
  if targetIsUnit and (target:IsDead() or target:IsDefeatedVillain()) then
    return false, AttackDisableReasons.InvalidTarget
  end
  return true, false
end
function Unit:GetMoveModifier(stance, action_id)
  stance = stance or self.stance
  action_id = action_id or "Move"
  local modValue = 0
  local effectId = self:HasStatusEffect("Slowed")
  if effectId then
    modValue = modValue + (self.StatusEffects[effectId]:ResolveValue("move_ap_modifier") or 0)
  end
  effectId = self:HasStatusEffect("Mobile")
  if effectId and action_id == "Move" then
    modValue = modValue - (self.StatusEffects[effectId]:ResolveValue("move_ap_modifier") or 0)
  end
  if self:HasStatusEffect("Hidden") then
    modValue = modValue + Hidden:ResolveValue("ap_cost_modifier")
  end
  if GameState.DustStorm then
    modValue = modValue + const.EnvEffects.DustStormMoveCostMod
  end
  return modValue
end
function Unit:GetUIScaledAP()
  return self:GetUIActionPoints() / const.Scale.AP
end
function Unit:GetUIScaledAPMax()
  local max = Max(self:GetMaxActionPoints(), self:GetUIActionPoints())
  return max / const.Scale.AP
end
function Unit:GatherCTHModifications(id, value, data)
  if not id then
    return
  end
  data.meta_text = data.meta_text or {}
  data.mod_mul = 100
  data.mod_add = 0
  data.base_chance = value
  Msg("GatherCTHModifications", self, id, data)
  value = MulDivRound(value + data.mod_add, data.mod_mul, 100)
  return value
end

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
    local skill = round(self.Dexterity/2,1)
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

function Unit:GetBestChanceToHit(target, action, args, lof)
  local best_idx, best_hit_chance
  local list = attack_data.lof
  for i, hit_data in ipairs(list) do
    if i == 1 or hit_data.ally_hits_count <= list[best_idx].ally_hits_count then
      args.target_spot_group = hit_data.target_spot_group
      local hit_chance = self:CalcChanceToHit(target, action, args, "chance_only")
      if i == 1 or hit_data.ally_hits_count < list[best_idx].ally_hits_count or best_hit_chance < hit_chance then
        best_idx, best_hit_chance = i, hit_chance
      end
    end
  end
  return best_hit_chance, best_idx
end
function Unit:IsPointBlankRange(target)
  if not IsValid(target) then
    return false
  end
  return IsCloser(target, self, const.Weapons.PointBlankRange * const.SlabSizeX + 1)
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
    if slot ~= "Inventory" and item.Condition > 0 and weapon.PenetrationClass < item.PenetrationClass and (item.ProtectedBodyParts or empty_table)[target_spot_group] then
      pierced = false
      return "break"
    end
  end)
  return pierced
end
function Unit:CalcCritChance(weapon, target, aim, attack_pos, target_spot_group, action)
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
  if IsKindOf(target, "Unit") and target:HasStatusEffect("Bleeding") and IsKindOf(weapon, "GutHookKnife") then
    return 100
  end
  local critChance = self:GetBaseCrit(weapon)
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
function Unit:GetCritDamageMod()
  local value = const.Weapons.CriticalDamage
  if HasPerk(self, "ColdHeart") then
    value = value + CharacterEffectDefs.ColdHeart:ResolveValue("crit_bonus")
  end
  return value
end
function TFormat.AimAPCost()
  local igi = GetInGameInterfaceModeDlg()
  if not igi then
    return -1
  end
  local attacker = igi.attacker
  local action = igi.action
  if not action then
    return -1
  end
  local weapon = action:GetAttackWeapons(attacker)
  local crosshair = igi.crosshair
  local aimLevel = crosshair and crosshair.aim or 0
  local actionCost, aimCost = attacker:GetAttackAPCost(action, weapon, nil, aimLevel + 1, action.ActionPointDelta)
  return aimCost / const.Scale.AP
end
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
function Unit:ResolveAttackParams(action_id, target, lof_params)
  local action = action_id and CombatActions[action_id]
  if action and action.AimType == "melee" then
    local attack_data = {
      obj = self,
      step_pos = self:GetOccupiedPos() or GetPassSlab(self) or self:GetPos(),
      target = target
    }
    return attack_data
  end
  lof_params = lof_params or {}
  lof_params.obj = self
  if not lof_params.action_id then
    lof_params.action_id = action_id
  end
  if lof_params.weapon == nil then
    lof_params.weapon = action and action:GetAttackWeapons(self) or false
  end
  if not lof_params.step_pos then
    lof_params.step_pos = self:GetOccupiedPos()
  end
  if lof_params.can_use_covers == nil then
    lof_params.can_use_covers = true
  end
  lof_params.prediction = true
  local attack_data = GetLoFData(self, target, lof_params)
  attack_data = attack_data or {
    obj = self,
    step_pos = self:GetOccupiedPos() or GetPassSlab(self) or self:GetPos(),
    target = target,
    stuck = true
  }
  return attack_data
end
function Unit:PrepareToAttack(attack_args, attack_results)
  if not self.visible then
    local targetIsUnit = attack_args.target and IsKindOf(attack_args.target, "Unit") and attack_args.target
    if targetIsUnit and targetIsUnit.visible then
      SnapCameraToObj(targetIsUnit, "force", GetFloorOfPos(SnapToPassSlab(targetIsUnit:GetVisualPos())))
    else
      return
    end
  end
  local showMiddle
  local dontMoveCamera, ccAttacker = StopCinematicCombatCamera()
  local updateLastUnitShoot = false
  if dontMoveCamera then
    updateLastUnitShoot = ccAttacker
  end
  local targetPos = not IsPoint(attack_args.target) and attack_args.target:GetVisualPos() or attack_args.target
  local notInGivenCommand = self.command ~= "OverwatchAction" and self.command ~= "MGSetup" and self.command ~= "MGTarget" and self.command ~= "SniperTarget" and self.command ~= "SniperSetup"
  local attackerPos = self:GetVisualPos()
  local isRetaliation = attack_args.opportunity_attack_type and attack_args.opportunity_attack_type == "Retaliation"
  local isAIControlled = not ActionCameraPlaying and not self:IsMerc() and g_AIExecutionController and (not self.opportunity_attack or #g_CombatCamAttackStack == 0)
  local mercPlayingAsAI = self:IsMerc() and g_AIExecutionController and g_AIExecutionController.units_playing and g_AIExecutionController.units_playing[self]
  local isAIControlledMerc = not ActionCameraPlaying and (isRetaliation or attack_args.gruntyPerk or mercPlayingAsAI)
  local cameraPosChanged, movedToShowAttacker
  if isAIControlled or isAIControlledMerc then
    if g_LastUnitToShoot ~= self and not dontMoveCamera then
      local midPoint = (attackerPos + targetPos) / 2
      local diffFloors = GetFloorOfPos(SnapToPassSlab(self)) ~= GetFloorOfPos(SnapToPassSlab(attack_args.target))
      showMiddle = not diffFloors and notInGivenCommand and DoPointsFitScreen({attackerPos, targetPos}, midPoint, 10)
      local posToShow = showMiddle and midPoint or attackerPos
      local cameraIsNear = DoPointsFitScreen({posToShow}, nil, const.Camera.BufferSizeNoCameraMov)
      if cameraIsNear and showMiddle then
        cameraIsNear = DoPointsFitScreen({attackerPos, targetPos}, nil, 10)
      end
      if not cameraIsNear then
        movedToShowAttacker = true
        SnapCameraToObj(posToShow, "force", GetFloorOfPos(SnapToPassSlab(showMiddle and targetPos or attackerPos)))
        if not self:CanQuickPlayInCombat() then
          Sleep(1000)
        end
      elseif not IsVisibleFromCamera(self) or GetFloorOfPos(SnapToPassSlab(self)) > cameraTac.GetFloor() then
        cameraTac.SetFloor(GetFloorOfPos(SnapToPassSlab(self)), hr.CameraTacInterpolatedMovementTime * 10, hr.CameraTacInterpolatedVerticalMovementTime * 10)
      end
      updateLastUnitShoot = self
    end
  elseif not ActionCameraPlaying and self.opportunity_attack and not isRetaliation then
    movedToShowAttacker = not DoPointsFitScreen({targetPos}, nil, const.Camera.BufferSizeNoCameraMov)
    CombatCam_ShowAttackNew(self, attack_args.target, nil, attack_results, dontMoveCamera)
  end
  if not g_AITurnContours[self.handle] and (isAIControlled or isAIControlledMerc or self.opportunity_attack and not isRetaliation) then
    local enemy = self.team.side == "enemy1" or self.team.side == "enemy2" or self.team.side == "neutralEnemy"
    g_AITurnContours[self.handle] = SpawnUnitContour(self, enemy and "CombatEnemy" or "CombatAlly")
    ShowBadgeOfAttacker(self, true)
  end
  self:AimTarget(attack_args, attack_results, true)
  if not self:CanQuickPlayInCombat() and movedToShowAttacker and (g_AIExecutionController or isRetaliation or attack_args.gruntyPerk or self.opportunity_attack) then
    local delay
    local consecutiveDelay = not dontMoveCamera and g_LastUnitToShoot == self
    if dontMoveCamera then
      delay = const.Combat.ShootDelayAfterAimCinematic
    elseif consecutiveDelay then
      delay = const.Combat.ConsecutiveShootDelayAfterAim
    else
      delay = const.Combat.ShootDelayAfterAim
    end
    Sleep(delay)
  end
  self:SetTargetDummy(nil, nil, attack_args.anim, 0, attack_args.stance)
  if not showMiddle then
    cameraPosChanged = not DoPointsFitScreen({targetPos}, nil, const.Camera.BufferSizeNoCameraMov)
  end
  if isAIControlled and notInGivenCommand and g_LastUnitToShoot ~= self or isAIControlledMerc then
    local interrupts = self:CheckProvokeOpportunityAttacks("attack interrupt", {
      self.target_dummy or self
    })
    local targetNotVisible = showMiddle and IsKindOf(attack_args.target, "Unit") and not IsVisibleFromCamera(attack_args.target)
    CombatCam_ShowAttackNew(self, attack_args.target, interrupts, attack_results, dontMoveCamera or showMiddle, targetNotVisible)
  elseif self:IsMerc() and not ActionCameraPlaying and not g_AIExecutionController then
    local interrupts = self:CheckProvokeOpportunityAttacks("attack interrupt", {
      self.target_dummy or self
    })
    if interrupts then
      CombatCam_ShowAttackNew(self, attack_args.target, interrupts, attack_results)
    else
      local cameraIsNear = DoPointsFitScreen({targetPos}, nil, const.Camera.BufferSizeNoCameraMov)
      if g_Combat and attack_results.explosion and (not attack_args.action_id or attack_args.action_id ~= "Bombard") and not cameraIsNear then
        SnapCameraToObj(targetPos, nil, GetFloorOfPos(SnapToPassSlab(targetPos)), 500)
        Sleep(500)
      end
    end
  end
  if not self:CanQuickPlayInCombat() then
    if g_AIExecutionController or isRetaliation or self.opportunity_attack then
      local delay
      local consecutiveDelay = not dontMoveCamera and g_LastUnitToShoot == self
      if dontMoveCamera then
        delay = const.Combat.ShootDelayCinematic
      elseif not cameraPosChanged then
        delay = const.Combat.ShootDelayTargetOnScreen
      elseif consecutiveDelay then
        delay = const.Combat.ConsecutiveShootDelay
      else
        delay = const.Combat.ShootDelay
      end
      Sleep(delay)
    elseif self.command ~= "PrepareBombard" and self.command ~= "OverwatchAction" then
      if cameraPosChanged then
        Sleep(const.Combat.ShootDelayNonAI)
      else
        Sleep(const.Combat.ShootDelayTargetOnScreen)
      end
    end
  end
  if updateLastUnitShoot then
    g_LastUnitToShoot = updateLastUnitShoot
  end
end
function Unit:CalcStealthKillChance(weapon, target, target_spot_group, aim)
  if not (IsValidTarget(target) and IsKindOf(target, "Unit")) or not weapon then
    return 0
  end
  local chance = Max(0, self.Dexterity - target.Wisdom)
  local min_chance = 1
  if HasPerk(target, "StealthKillDefense") then
    chance = chance - CharacterEffectDefs.StealthKillDefense:ResolveValue("kill_chance_mod")
  end
  if target_spot_group == "Head" or target_spot_group == "Neck" then
    chance = chance + const.Combat.HeadshotStealthKillChanceMod
  end
  if HasPerk(self, "Virtuoso") and IsFullyAimedAttack(aim) then
    chance = chance + CharacterEffectDefs.Virtuoso:ResolveValue("virtuosoStealthKillChance")
  end
  if HasPerk(self, "Infiltrator") then
    chance = chance + CharacterEffectDefs.Infiltrator:ResolveValue("stealthkill_chance")
  end
  if HasPerk(self, "Stealthy") then
    chance = chance + CharacterEffectDefs.Stealthy:ResolveValue("stealthkill")
    min_chance = CharacterEffectDefs.Stealthy:ResolveValue("stealthkill_minchance")
  end
  local stealthKillBonus = GetComponentEffectValue(weapon, "StealthKillBonusPerAim", "stealth_kill_bonus")
  if stealthKillBonus then
    chance = chance + (aim or 0) * (stealthKillBonus or 0)
  end
  if target:IsAware() then
    chance = MulDivRound(chance, 75, 100)
  elseif target:HasStatusEffect("Surprised") or target:HasStatusEffect("Suspicious") then
    chance = MulDivRound(chance, Max(0, 100 + CharacterEffectDefs.Surprised:ResolveValue("stealthkill_modifier")), 100)
  end
  if CheatEnabled("SkillCheck") then
    chance = 100
  end
  local weapon_pen_class = weapon:HasMember("PenetrationClass") and weapon.PenetrationClass or 1
  local armor_class = 0
  target:ForEachItem("Armor", function(item, slot)
    if slot ~= "Inventory" and item.ProtectedBodyParts and item.ProtectedBodyParts[target_spot_group] then
      armor_class = Max(armor_class, item.PenetrationClass)
    end
  end)
  if weapon_pen_class < armor_class and 0 < chance then
    chance = chance / 2
  end
  chance = Clamp(chance, min_chance, 100)
  return chance
end
function Unit:PrepareAttackArgs(action_id, args)
  action_id = action_id or self:GetDefaultAttackAction("ranged")
  args = args or empty_table
  local action = CombatActions[action_id]
  local weapon = args.weapon or action and action:GetAttackWeapons(self)
  local target = args.target
  local prediction = args.prediction or args.prediction == nil
  local aim_type = action and action.AimType
  local thermal_aim = IsKindOf(weapon, "Firearm") and IsFullyAimedAttack(args) and weapon:HasComponent("IgnoreGrazingHitsWhenFullyAimed")
  local attack_args = table.copy(args)
  attack_args.action_id = action_id
  attack_args.obj = self
  attack_args.weapon = weapon
  attack_args.target_pos = not attack_args.target_pos and IsPoint(target) and target
  attack_args.step_pos = attack_args.step_pos or self.return_pos or self:GetOccupiedPos() or GetPassSlab(self) or self:GetPos()
  attack_args.ignore_smoke = thermal_aim
  if attack_args.fire_relative_point_attack == nil then
    attack_args.fire_relative_point_attack = self.WeaponType == "Shotgun"
  end
  attack_args.prediction = prediction
  if aim_type ~= "melee" then
    attack_args.prediction = true
    local attack_data = GetLoFData(self, target, attack_args)
    if attack_data then
      for k, v in pairs(attack_data) do
        attack_args[k] = v
      end
    else
      attack_args.stuck = true
    end
    attack_args.prediction = prediction
  end
  attack_args.num_shots = attack_args.num_shots or 1
  attack_args.aoe_action_id = attack_args.aoe_action_id or false
  attack_args.aoe_fx_action = attack_args.aoe_fx_action or false
  attack_args.aoe_damage_type = attack_args.aoe_damage_type or "default"
  attack_args.aoe_damage_value = attack_args.aoe_damage_value or false
  attack_args.applied_status = attack_args.applied_status or false
  attack_args.damage_bonus = attack_args.damage_bonus or false
  attack_args.consumed_ammo = attack_args.consumed_ammo or false
  attack_args.aoe_damage_bonus = attack_args.aoe_damage_bonus or false
  attack_args.cth_loss_per_shot = attack_args.cth_loss_per_shot or false
  attack_args.fx_action = attack_args.fx_action or false
  attack_args.single_fx = attack_args.single_fx or false
  if weapon and aim_type == "cone" then
    local aoe_params = weapon:GetAreaAttackParams(action_id, self, attack_args.target_pos, attack_args.step_pos)
    for k, v in pairs(aoe_params) do
      attack_args[k] = v
    end
  end
  local is_stealth = attack_args.stealth_attack or self:HasStatusEffect("Hidden")
  local lethal_weapon = attack_args.target_spot_group == "Neck" and IsKindOf(weapon, "MeleeWeapon") and weapon.NeckAttackType == "lethal"
  if action and (is_stealth or lethal_weapon) then
    local stealth_targeted = is_stealth and action.StealthAttack and IsKindOf(target, "Unit") and IsValidTarget(target)
    local stealth_aoe, chance
    if stealth_targeted or stealth_aoe then
      local crosshair = GetInGameInterfaceModeDlg().crosshair
      local aim = args.aim or crosshair and crosshair.aim or 0
      chance = self:CalcStealthKillChance(weapon, target, attack_args.target_spot_group, aim)
      attack_args.stealth_attack = true
    end
    if lethal_weapon then
      local lethal_chance = 5 + Max(0, (self.Strength - target.Health) / 2)
      chance = Max(chance or 0, lethal_chance)
    end
    if stealth_targeted or lethal_weapon then
      if target:IsNPC() and not target.villain then
        attack_args.stealth_kill_chance = chance
        attack_args.stealth_bonus_crit_chance = 0
      else
        attack_args.stealth_kill_chance = 0
        attack_args.stealth_bonus_crit_chance = chance
      end
    end
  end
  return attack_args
end
function Unit:StartFireAnim(shot, attack_args, aim_pos, shotAnimDelay)
  if self:CanAimIK(attack_args.weapon) then
    aim_pos = aim_pos or shot and (shot.lof_pos2 or shot.target_pos) or attack_args.target_pos
    if aim_pos then
      self:SetIK("AimIK", aim_pos)
      if shotAnimDelay then
        Sleep(shotAnimDelay)
        shotAnimDelay = 0
      else
        Sleep(200)
      end
    end
  end
  if 0 < (shotAnimDelay or 0) then
    Sleep(shotAnimDelay)
  end
  local hit_moment = shot and shot.hit_moment or "hit"
  local anim = self:ModifyWeaponAnim(attack_args.anim)
  self:SetState(anim, const.eKeepComponentTargets, 0)
  local time_to_hit = self:TimeToMoment(1, hit_moment)
  if time_to_hit then
    Sleep(time_to_hit)
  end
end
function Unit:GetAttackRolls(num_shots, multishot, atk_value, crit_value)
  local attack_roll, crit_roll
  if not multishot or (num_shots or 1) <= 1 then
    attack_roll = atk_value or 1 + self:Random(100)
    crit_roll = crit_value or 1 + self:Random(100)
  else
    attack_roll, crit_roll = {}, {}
    for i = 1, num_shots do
      attack_roll[i] = atk_value or 1 + self:Random(100)
      crit_roll[i] = crit_value or 1 + self:Random(100)
    end
  end
  return attack_roll, crit_roll
end
function FXAnimToAction(anim)
  return "Anim:" .. anim
end
function FXActionToAnim(action)
  return remove_prefix(action, "Anim:") or action
end
function Unit:GetLogName()
  return self:GetDisplayName()
end
function Unit:SetAttackReason(reason, opportunity_attack)
  self.attack_reason = reason
  self.opportunity_attack = opportunity_attack
end
function Unit:GetAttackReasonText()
  return self.attack_reason and T({
    295729060245,
    "<em><name></em>: ",
    name = self.attack_reason
  }) or ""
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
    base_damage = weapon.Damage
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
function Unit:GodMode(mode, state)
  mode = mode or "god_mode"
  if state == nil then
    state = true
  end
  self[mode] = state
  if mode == "god_mode" then
    self.infinite_ap = state
    self.infinite_ammo = state
    self.infinite_dmg = state
    self.infinite_condition = state
    self.invulnerable = state
  end
  if self.infinite_ap then
    self:GainAP(self:GetMaxActionPoints())
  end
end
function Unit:ReloadAllEquipedWeapons(ammo_type)
  local reloaded
  self:ForEachItemInSlot("Handheld A", "Firearm", function(gun)
    if not (not ammo_type and gun.ammo) or gun.ammo.Amount < gun.MagazineSize then
      reloaded = self:ReloadWeapon(gun, ammo_type) or reloaded
    end
  end)
  self:ForEachItemInSlot("Handheld B", "Firearm", function(gun)
    if not (not ammo_type and gun.ammo) or gun.ammo.Amount < gun.MagazineSize then
      reloaded = self:ReloadWeapon(gun, ammo_type) or reloaded
    end
  end)
  return reloaded
end
function Unit:GetCoverPercentage(attackerPos, target_pos, stance)
  if g_Combat and self.combat_path then
    return false, false, 0
  end
  return GetCoverPercentage(target_pos or self:GetPos(), attackerPos, stance or self.stance)
end
function Unit:SetVisible(visible, force)
  visible = visible or not force and IsSetpiecePlaying() and g_SetpieceFullVisibility
  if visible then
    if g_Exploration and not self:IsDead() then
      if not self.visible then
        self:SetOpacity(100, 500)
      end
    else
      self:SetOpacity(100)
    end
    local hidden_parts = self.Headshot and self.species == "Human" and HeadshotHideParts
    self:SetEnumFlags(const.efVisible)
    for name, body_part in pairs(self.parts) do
      if hidden_parts and table.find(hidden_parts, name) then
        body_part:ClearEnumFlags(const.efVisible)
      else
        body_part:SetEnumFlags(const.efVisible)
      end
    end
    if self.prepared_attack_obj then
      self.prepared_attack_obj:SetEnumFlags(const.efVisible)
    end
  else
    if g_Exploration and not self:IsDead() then
      if self.visible then
        self:SetOpacity(0, 2000)
      end
    else
      self:ClearEnumFlags(const.efVisible)
      for _, body_part in pairs(self.parts) do
        body_part:ClearEnumFlags(const.efVisible)
      end
    end
    if self.prepared_attack_obj then
      self.prepared_attack_obj:ClearEnumFlags(const.efVisible)
    end
  end
  if self.melee_threat_contour then
    self.melee_threat_contour:SetVisible(visible)
  end
  if self.ui_badge then
    local badgeVisible = visible and not self:IsDead()
    self.ui_badge:SetVisible(badgeVisible, "unit")
  end
  if self.visible ~= visible then
    self:SetSoundMute(not visible)
    self:ForEachAttach("GrenadeVisual", function(obj)
      obj:SetSoundMute(not visible)
    end)
    self.visible = visible
    ObjModified(self)
  end
  if self.carry_flare then
    self:UpdateOutfit()
  end
  self:UpdateFXClass()
end
function Unit:GetVisibleEnemies()
  local visible = {}
  if self.team then
    local team_visible = g_Visibility[self.team] or empty_table
    for _, u in ipairs(team_visible) do
      if IsValidTarget(u) and self:IsOnEnemySide(u) then
        table.insert_unique(visible, u)
      end
    end
  end
  return visible
end
function Unit:OnGearChanged(isLoad)
  self.using_cumbersome = false
  NetUpdateHash("CumbersomeReset", self)
  self:ForEachItem(false, function(item, slot)
    if slot ~= "Inventory" and item.Cumbersome then
      self.using_cumbersome = true
      NetUpdateHash("CumbersomeSet", self)
    end
    item:ApplyModifiersList(item.applied_modifiers)
  end)
  if self.using_cumbersome and not HasPerk(self, "KillingWind") then
    if self:CanUseIroncladPerk() then
      if not isLoad then
        self:ConsumeAP(DivRound(self.free_move_ap, 2), "Move")
      end
    else
      self:RemoveStatusEffect("FreeMove")
    end
  end
  Msg("UnitAPChanged", self)
  ObjModified(self)
  ObjModified(self.Inventory)
end
function Unit:CanUseIroncladPerk()
  local canUse = HasPerk(self, "Ironclad")
  if canUse then
    local weapons = self:GetHandheldItems()
    for _, weapon in ipairs(weapons) do
      if weapon.Cumbersome then
        canUse = false
        break
      end
    end
  end
  return canUse
end
local is_attack_available = function(unit, action, sync)
  local weapon1, weapon2 = action:GetAttackWeapons(unit)
  local shots1 = action and IsKindOf(weapon1, "Firearm") and weapon1:GetAutofireShots(action)
  local shots2 = action and IsKindOf(weapon2, "Firearm") and weapon2:GetAutofireShots(action)
  local can_use1 = weapon1 and unit:CanUseWeapon(weapon1, shots1)
  local can_use2 = weapon2 and unit:CanUseWeapon(weapon2, shots2)
  if sync then
    NetUpdateHash("is_attack_available", unit, action.id, weapon1 and weapon1.class, weapon1 and weapon1.id, can_use1, weapon2 and weapon2.class, weapon2 and weapon2.id, can_use2)
  end
  if weapon1 and not can_use1 then
    return false
  end
  if weapon2 and not can_use2 then
    return false
  end
  return true
end
function Unit:GetDefaultAttackAction(force_ranged, force_ungrouped, weapon, sync, ignore_stealth)
  local weapon2
  if not weapon then
    weapon, weapon2 = self:GetActiveWeapons()
  end
  local id
  local weaponAttacks = not (not IsKindOf(weapon, "Firearm") or IsKindOfClasses(weapon, "HeavyWeapon", "FlareGun")) and weapon.AvailableAttacks or empty_table
  local weapon2Attacks = not (not IsKindOf(weapon2, "Firearm") or IsKindOfClasses(weapon2, "HeavyWeapon", "FlareGun")) and weapon2.AvailableAttacks or empty_table
  if not ignore_stealth and self:HasStatusEffect("Hidden") and (table.find(weaponAttacks, "SingleShot") or table.find(weapon2Attacks, "SingleShot")) then
    id = "SingleShot"
  end
  if 0 < #weaponAttacks and 0 < #weapon2Attacks then
    local dualShotAvail = table.find(weaponAttacks, "DualShot") and table.find(weapon2Attacks, "DualShot")
    id = dualShotAvail and "DualShot" or id
  end
  if IsKindOf(weapon, "MeleeWeapon") and force_ranged and weapon.CanThrow then
    id = "KnifeThrow"
  end
  if IsKindOf(weapon, "FlareGun") then
    weapon = nil
    if weapon2 and not IsKindOf(weapon2, "FlareGun") then
      weapon = weapon2
      weapon2 = nil
    end
  end
  id = id or weapon and weapon:GetBaseAttack(self, force_ranged) or "UnarmedAttack"
  local action = CombatActions[id]
  if force_ungrouped and is_attack_available(self, action, sync) then
    if sync then
      NetUpdateHash("GetDefaultAttackAction", self, id)
    end
    return action
  end
  local firingMode = action and action.FiringModeMember
  if firingMode and self.ui_actions and self.ui_actions[firingMode] == "enabled" then
    if not force_ungrouped then
      if sync then
        NetUpdateHash("GetDefaultAttackAction", self, firingMode)
      end
      return CombatActions[firingMode]
    end
    for id, state in sorted_pairs(self.ui_actions) do
      if type(id) == "string" then
        local ca = CombatActions[id]
        if ca and ca.FiringModeMember == firingMode and is_attack_available(self, ca, sync) then
          if sync then
            NetUpdateHash("GetDefaultAttackAction", self, ca.id)
          end
          return ca
        end
      end
    end
  end
  if sync then
    NetUpdateHash("GetDefaultAttackAction", self, action.id)
  end
  return action
end
local ResetIdleLookAt = function(unit)
  if not g_Combat then
    return
  end
  for _, u in ipairs(g_Units) do
    if u.command == "Idle" and u.target_dummy and u:IsAware() then
      local pos = GetPassSlab(u.target_dummy) or u.target_dummy:GetPos()
      if u:SetTargetDummyFromPos(pos, nil, false) then
        u:SetCommand("Idle")
      end
    end
  end
end
function UpdateIndoors(unit)
  if GameState.Underground then
    unit.indoors = true
    return
  end
  local volume = EnumVolumes(unit, "smallest")
  unit.indoors = not not volume
end
OnMsg.UnitMovementDone = ResetIdleLookAt
OnMsg.UnitDied = ResetIdleLookAt
OnMsg.VisibilityUpdate = ResetIdleLookAt
OnMsg.CoversChanged = ResetIdleLookAt
OnMsg.CombatObjectDied = ResetIdleLookAt
function OnMsg.EnterSector()
  for _, unit in ipairs(g_Units) do
    UpdateIndoors(unit)
  end
end
function OnMsg.UnitDied(dead_unit)
  dead_unit:PlaceBlood()
  if not g_Combat then
    return
  end
  for _, unit in ipairs(g_Units) do
    if unit.combat_behavior == "CombatBandage" then
      local target = unit.combat_behavior_params[1]
      if target == dead_unit then
        unit:EndCombatBandage()
      end
    end
  end
end
local UnitsUpdateCovers = function(bbox)
  MapForEach(bbox or "map", "Unit", function(u)
    if u:IsDead() or not u:IsAware() then
      return
    end
    if u:HasStatusEffect("Protected") and not GetCoversAt(u) then
      u:RemoveStatusEffect("Protected")
    end
    if u.command == "Idle" then
      u:SetCommand("Idle")
    end
  end)
end
OnMsg.CoversChanged = UnitsUpdateCovers
function OnMsg.CombatObjectDied(obj, bbox)
  UnitsUpdateCovers(bbox)
end
function Unit:SetHighlightColorModifier(visible)
  if not IsValid(self) then
    return "break"
  end
  if not visible then
    self.interactable_highlight_ctr = SpawnUnitContour(false, false, self.interactable_highlight_ctr)
  end
  local dead = self:IsDead()
  if not self:IsNPC() and not dead then
    return "break"
  end
  if dead then
    return Interactable.SetHighlightColorModifier(self, visible)
  end
  if visible == not not self.interactable_highlight_ctr then
    return "break"
  end
  self.interactable_highlight_ctr = SpawnUnitContour(self, "Interact", self.interactable_highlight_ctr)
  return "break"
end
if Platform.developer then
  function TestSpawnNPC(class, pos)
    local session_id = GenerateUniqueUnitDataId("TestNPC", gv_CurrentSectorId or "A1", class)
    return SpawnUnit(class, session_id, pos or GetCursorPos())
  end
end
function TFormat.ap(context_obj, value)
  return T({
    747393774818,
    "<num> AP",
    num = value / const.Scale.AP
  })
end
function TFormat.apn(context_obj, value)
  return T({
    867764319678,
    "<num>",
    num = type(value) == "number" and value / const.Scale.AP or value or ""
  })
end
function Unit:UpdatePFClass()
  if self.pfclass_overwritten then
    return
  end
  local side = self.team and self.team.side
  if (side == "player1" or side == "player2") and (self:HasStatusEffect("Panicked") or self:HasStatusEffect("Berserk")) then
    side = "enemy1"
  end
  local pfclass = CalcPFClass(side, self.stance, self.body_type)
  self:SetPfClass(pfclass)
end
function Unit:OverwritePFClass(pfclass)
  if pfclass then
    self.pfclass_overwritten = pfclass
    self:SetPfClass(pfclass)
  elseif self.pfclass_overwritten then
    self.pfclass_overwritten = false
    self:UpdatePFClass()
  end
end
SuppressTeamUpdate = false
function Unit:SetTeam(team)
  local old_team = self.team
  local aware = self:IsAware()
  self.team = team
  self:UpdatePFClass()
  if old_team and team ~= old_team and old_team.side == "neutral" and not team.player_team then
    self:AddStatusEffect("Unaware")
  end
  if old_team and team ~= old_team and IsValidTarget(self) then
    local next_unit
    if table.find(Selection or empty_table, self) then
      SelectionRemove(self)
      if #Selection == 0 then
        next_unit = true
      end
    end
    if SelectedObj == self or next_unit then
      local igi = GetInGameInterfaceModeDlg()
      if igi then
        igi:NextUnit()
      end
    end
    if aware and team.side ~= "player1" and team.side ~= "player2" and team.side ~= "neutral" and team.side ~= old_team.side then
      if g_Combat then
        self:AddStatusEffect("Surprised")
      else
        self:AddStatusEffect("Suspicious")
      end
      if old_team and not GameState.loading and not GameState.loading_savegame then
        for _, unit in ipairs(old_team.units) do
          PushUnitAlert("discovered", unit)
        end
        AlertPendingUnits()
      end
    end
  end
  Msg("UnitSideChanged", self, team)
  if not SuppressTeamUpdate then
    Msg("TeamsUpdated")
  end
end
function Unit:SetSide(side)
  if not g_Teams or #g_Teams == 0 then
    SetupDummyTeams()
  end
  local new_team = table.find_value(g_Teams, "side", side)
  SendUnitToTeam(self, new_team)
  self.CurrentSide = side
  if side ~= "neutral" then
    for command, params in pairs(self.command_specific_params) do
      params.weapon_anim_prefix = nil
    end
  end
  self:SyncWithSession("map")
end
function Unit:GetCombatMoveCost(pos)
  if point_pack(SnapToVoxel(pos:xyz())) == point_pack(SnapToVoxel(self:GetPosXYZ())) then
    return 0
  end
  local combatPath = GetCombatPath(self)
  local ap = combatPath:GetAP(pos)
  return ap
end
function Unit:GetClosestMeleeRangePos(target, stance, interaction)
  local closest_pos
  if g_Combat then
    local combatPath = GetCombatPath(self, stance)
    closest_pos = combatPath:GetClosestMeleeRangePos(target, true, interaction)
  else
    if target.behavior == "Visit" and IsKindOf(target.last_visit, "AL_SitChair") then
      return target.last_visit:GetPos()
    end
    local positions = GetMeleeRangePositions(self, target, nil, true)
    if positions then
      for i, packed_pos in ipairs(positions) do
        positions[i] = point(point_unpack(packed_pos))
      end
      local has_path, pf_closest_pos = pf.HasPosPath(self, positions)
      if has_path and table.find(positions, pf_closest_pos) and (interaction or IsMeleeRangeTarget(self, pf_closest_pos, stance, target)) then
        closest_pos = pf_closest_pos
      end
    end
  end
  return closest_pos
end
function Unit:CalcAttackCostRange(action, target, item_id)
  if action.group == "FiringModeMetaAction" then
    local _, firingModeActions = GetUnitDefaultFiringModeActionFromMetaAction(self, action)
    local max, min = 0, 1000 * const.Scale.AP
    for i, fm in ipairs(firingModeActions) do
      local mode_min, mode_max = self:CalcAttackCostRange(fm, target)
      max = Max(max, mode_max)
      min = Min(min, mode_min)
    end
    return min, max
  end
  local min_aim, max_aim = self:GetBaseAimLevelRange(action)
  local args = {target = target, item_id = item_id}
  local min, max, display_cost
  for aim = min_aim, max_aim do
    args.aim = aim
    local ap = action:GetAPCost(self, args)
    if 0 < ap then
      min = Min(min, ap)
      max = Max(max, ap)
    end
  end
  return min, max
end
function Unit:GetBaseAimLevelRange(action, target)
  if not action.IsAimableAttack then
    return 0, 0
  end
  local actionWep = action:GetAttackWeapons(self)
  local min, max = 0, 0
  if IsKindOfClasses(actionWep, "Firearm", "MeleeWeapon") then
    max = actionWep.MaxAimActions
  end
  if 0 < max then
    if HasPerk(self, "Instagib") and self:HasStatusEffect("InstagibBuff") then
      max = max + CharacterEffectDefs.Instagib:ResolveValue("bonusAims")
    end
    if IsKindOf(actionWep, "Firearm") then
      if actionWep:HasComponent("MinAim") then
        min = Max(min, GetComponentEffectValue(actionWep, "MinAim", "min_aim"))
      end
      local firstShotBoost = not self.performed_action_this_turn and GetComponentEffectValue(actionWep, "FirstShotIncreasedAim", "min_aim")
      if firstShotBoost then
        max = Max(max, firstShotBoost)
        min = max
      end
    end
  end
  return min, max
end
function Unit:GetAimLevelRange(action, target, goto_pos, is_free_aim)
  local minAim, maxCurrent, maxTotal
  minAim, maxTotal = self:GetBaseAimLevelRange(action, target)
  for i = 1, maxTotal do
    if action:GetUIState({self}, {
      target = target,
      aim = i,
      goto_pos = goto_pos,
      free_aim = is_free_aim
    }) ~= "enabled" then
      maxCurrent = i - 1
      break
    end
  end
  return minAim, maxCurrent or maxTotal, maxTotal
end
function Unit:JoinSquadAs(merc_id, squad)
  local unit = SpawnUnit(merc_id, merc_id, self:GetPos(), self:GetAngle())
  unit:ApplyAppearance(self.Appearance)
  unit:SetState(self:GetState(), 0, 0)
  unit:SetAnimPhase(1, self:GetAnimPhase())
  unit.stance = self.stance
  unit.current_weapon = self.current_weapon
  local weapon1, weapon2 = self:GetActiveWeapons(false, "strict")
  if IsKindOf(weapon1, "Firearm") then
    unit:Attach(weapon1:CreateVisualObj(unit), unit:GetSpotBeginIndex("Weaponr"))
  end
  if IsKindOf(weapon2, "Firearm") then
    unit:Attach(weapon2:CreateVisualObj(unit), unit:GetSpotBeginIndex("Weaponl"))
  end
  self.villain = false
  self.HitPoints = 0
  self:ClearHierarchyEnumFlags(const.efVisible)
  local tidx = g_Teams and table.find(g_Teams, "side", squad.Side)
  if tidx then
    table.insert(g_Teams[tidx].units, unit)
    unit:SetTeam(g_Teams[tidx])
    ObjModified(unit.team)
  end
  AddToGlobalUnits(unit)
  local unitCount, unitCountWithJoining = GetSquadUnitCountWithJoining(squad.UniqueId)
  if unitCountWithJoining >= const.Satellite.MercSquadMaxPeople then
    local oldSector, oldVisualPos = squad.CurrentSector, squad.VisualPos
    local name = SquadName:GetNewSquadName("player1")
    local squadParams = {
      Side = "player1",
      CurrentSector = oldSector,
      VisualPos = oldVisualPos,
      Name = name
    }
    local squad_id = CreateNewSatelliteSquad(squadParams, {merc_id})
    squad = gv_Squads[squad_id]
    Msg("UnitJoinedPlayerSquad", squad_id)
  else
    AddUnitsToSquad(squad, {merc_id}, nil, InteractionRand(nil, "Satellite"))
  end
  local newUd = gv_UnitData[unit.session_id]
  newUd.already_spawned_on_map = true
  unit.already_spawned_on_map = true
  local ud = gv_UnitData[self.session_id]
  if ud then
    RemoveUnitFromSquad(ud, "despawn")
  end
  if g_Combat then
    Msg("UnitEnterCombat", unit)
  end
  Msg("TeamsUpdated")
  DoneObject(self)
  Msg("UnitJoinedAsMerc", unit)
end
function OnMsg.UnitJoinedPlayerSquad()
  if g_Combat then
    ObjModified(g_Combat)
  else
    ForceUpdateCommonUnitControlUI()
  end
end
function GetBehaviorGroups()
  local marker_groups = {}
  for id, group in sorted_pairs(Groups) do
    for _, o in ipairs(group) do
      if IsKindOf(o, "WaypointMarker") or IsKindOf(o, "GridMarker") and (o.Type == "Position" or o.Type == "Entrance") then
        marker_groups[#marker_groups + 1] = id
        break
      end
    end
  end
  return marker_groups
end
MapVar("gv_UnitGroups", false)
MapVar("gv_NPCGroups", false)
MapVar("gv_TargetUnitGroups", false)
local groups_separator = "-----------------"
function GetUnitSpawnMarkerGroups()
  local marker_groups = {}
  MapForEach("map", "UnitMarker", function(marker, marker_groups)
    table.iappend(marker_groups, marker.Groups or empty_table)
  end, marker_groups)
  MapForEachMarker("Defender", false, function(marker, marker_groups)
    table.iappend(marker_groups, marker.Groups or empty_table)
  end, marker_groups)
  MapForEachMarker("DefenderPriority", false, function(marker, marker_groups)
    table.iappend(marker_groups, marker.Groups or empty_table)
  end, marker_groups)
  table.sort(marker_groups)
  for i = #marker_groups, 2, -1 do
    if marker_groups[i] == marker_groups[i - 1] then
      table.remove(marker_groups, i)
    end
  end
  return marker_groups
end
function GetUnitGroups()
  if not gv_UnitGroups then
    RecalcGroups()
  end
  return gv_UnitGroups
end
function GetTargetUnitCombo()
  if not gv_TargetUnitGroups then
    RecalcGroups()
  end
  return gv_TargetUnitGroups
end
local custom_unit_groups = {"EnemySquad", "Villains"}
g_AnyUnitGroups = {
  any = true,
  ["any merc"] = true,
  ["current unit"] = true,
  ["player mercs on map"] = true
}
function RecalcGroups()
  if GetMap() == "" then
    return
  end
  local groups = GetUnitSpawnMarkerGroups()
  groups[#groups + 1] = groups_separator
  local mercs = {}
  for k, v in pairs(UnitDataDefs) do
    if IsMerc(v) then
      mercs[#mercs + 1] = k
    end
  end
  table.sort(mercs)
  table.iappend(groups, mercs)
  groups[#groups + 1] = groups_separator
  local non_mercs = {}
  for k, v in pairs(UnitDataDefs) do
    if not IsMerc(v) then
      non_mercs[#non_mercs + 1] = k
    end
  end
  table.sort(non_mercs)
  table.iappend(groups, non_mercs)
  table.iappend(groups, custom_unit_groups)
  gv_UnitGroups = groups
  gv_TargetUnitGroups = table.keys2(g_AnyUnitGroups, "sorted")
  table.iappend(gv_TargetUnitGroups, groups)
end
function TFormat.GetNumAliveUnitsInGroup(context, groupName)
  return GetNumAliveUnitsInGroup(groupName)
end
function GetNumAliveUnitsInGroup(group)
  local num = 0
  for _, obj in ipairs(Groups[group]) do
    if IsKindOf(obj, "Unit") and not obj:IsDead() then
      num = num + 1
    end
  end
  return num
end
OnMsg.NewMapLoaded = RecalcGroups
OnMsg.GameExitEditor = RecalcGroups
function OnMsg.UnitDied()
  ObjModified(gv_Quests)
end
GameVar("DeadGroupsInSectors", {})
function UpdateDeadGroups(groups)
  local deadGroups = DeadGroupsInSectors[gv_CurrentSectorId] or {}
  for _, group in ipairs(groups) do
    local allDead = GetNumAliveUnitsInGroup(group) == 0
    if allDead then
      deadGroups[group] = "all"
    else
      deadGroups[group] = "any"
    end
  end
  DeadGroupsInSectors[gv_CurrentSectorId] = deadGroups
end
function OnMsg.UnitDieStart(unit)
  UpdateDeadGroups(unit.Groups)
end
function OnMsg.VillainDefeated(unit)
  UpdateDeadGroups(unit.Groups)
end
function OnMsg.GatherFXActions(list)
  table.insert(list, "StepRun")
  table.insert(list, "StepWalk")
  table.insert(list, "StepRunCrouch")
  table.insert(list, "StepRunProne")
  table.insert(list, "Interact")
  for i, combat_action in ipairs(Presets.CombatAction.Interactions) do
    table.insert(list, combat_action.id)
  end
end
function OnMsg.GatherFXActors(list)
  table.insert(list, "Unit")
end
function Unit:AutoRemoveCombatEffects()
  local effect_ids = table.map(self.StatusEffects or empty_table, "class")
  for _, id in ipairs(effect_ids) do
    local def = CharacterEffectDefs[id]
    if def and def.RemoveOnEndCombat then
      self:RemoveStatusEffect(id, "all")
    end
  end
end
local ExitCombatUninterruptable = {
  Visit = true,
  EnterMap = true,
  Cower = true
}
function OnMsg.CombatEnd(combat)
  MapForEach("map", "Unit", function(unit)
    unit:AutoRemoveCombatEffects()
    if not unit:IsDead() and g_Overwatch[unit] and not g_Overwatch[unit].permanent then
      unit:InterruptPreparedAttack()
      unit:RemovePreparedAttackVisuals()
    end
    if not unit:IsDead() or unit.immortal then
      local overwatch = g_Overwatch[unit]
      if not ExitCombatUninterruptable[unit.command] and (not overwatch or not overwatch.permanent) then
        unit:InterruptCommand("ExitCombat")
      end
    end
  end)
end
function Unit:IsAdjacentTo(other, check_pos)
  local x, y, z
  if check_pos then
    x, y, z = PosToGridCoords(check_pos:xyz())
  else
    x, y, z = self:GetGridCoords()
  end
  local ox, oy, oz = other:GetGridCoords()
  return abs(x - ox) <= 1 and abs(y - oy) <= 1 and abs(z - oz) <= 1
end
function Unit:CanSurround(other, check_pos)
  if not self:IsOnEnemySide(other) or self:IsDead() or self:IsDowned() then
    return false
  end
  if self:HasStatusEffect("Suppressed") then
    return false
  end
  local pos = check_pos or self:GetPos()
  if other:GetPos() == pos then
    return false
  end
  if check_pos then
    if not CheckLOS(other, self, self:GetSightRadius()) then
      return false
    end
  elseif not HasVisibilityTo(self, other) then
    return false
  end
  local adjacent = self:IsAdjacentTo(other, check_pos)
  local in_range = false
  local w1, w2, weapons = self:GetActiveWeapons()
  for _, weapon in ipairs(weapons) do
    if IsKindOf(weapon, "Firearm") or IsKindOf(weapon, "MeleeWeapon") and weapon.CanThrow then
      in_range = in_range or other:GetDist(pos) <= weapon.WeaponRange * const.SlabSizeX
    elseif IsKindOf(weapon, "MeleeWeapon") and not in_range then
      in_range = adjacent
    end
  end
  return in_range
end
function Unit:IsSurrounded(unitReplace)
  if not (g_Visibility and g_Combat) or self:IsDead() then
    return
  end
  local pos = unitReplace and unitReplace[self] or self:GetPos()
  local enemy_pos = {}
  local angle = 7200
  local cosa = MulDivRound(cos(angle), guim * guim, 4096)
  for _, u in ipairs(g_Units) do
    if u:CanSurround(self, unitReplace and unitReplace[u]) then
      enemy_pos[#enemy_pos + 1] = unitReplace and unitReplace[u] or u:GetPos()
    end
  end
  if #enemy_pos < 2 then
    return
  end
  local pts = ConvexHull2D(enemy_pos)
  for i = 1, #pts - 1 do
    local v1 = pts[i]:Equal2D(pos) and point30 or SetLen(pts[i] - pos, guim)
    for j = i + 1, #pts do
      local v2 = pts[j]:Equal2D(pos) and point30 or SetLen(pts[j] - pos, guim)
      local dp = Dot2D(v1, v2)
      if cosa > dp then
        return true
      end
    end
  end
end
function InterpolateCoverEffect(coverage, full_value, exposed_value)
  local threshold = 40
  if 80 <= coverage then
    return full_value
  elseif coverage < threshold then
    return exposed_value
  end
  return exposed_value + MulDivRound(full_value - exposed_value, coverage - threshold, threshold)
end
function Unit:ApplyHitDamageReduction(hit, weapon, hit_body_part, ignore_cover, ignore_armor, record_breakdown)
  local damage = hit.damage or 0
  local dmg = damage
  local armor_decay, armor_pierced = {}, {}
  local weapon_pen_class = weapon:HasMember("PenetrationClass") and weapon.PenetrationClass or 1
  self:ForEachItem("Armor", function(item, slot)
    if 0 < dmg and slot ~= "Inventory" and item.ProtectedBodyParts and item.ProtectedBodyParts[hit_body_part] then
      local dr, degrade = 0, 0
      if not ignore_armor and 0 < item.Condition then
        dr = item.DamageReduction
        degrade = item.Degradation
        if weapon_pen_class < item.PenetrationClass then
          dr = dr + item.AdditionalReduction
          degrade = MulDivRound(degrade, const.Combat.ArmorDegradePercent, 100)
        else
          armor_pierced[item] = true
        end
      else
        armor_pierced[item] = true
      end
      dr = MulDivRound(dr, Min(100, 50 + item.Condition), 100)
      local scaled = dmg * (100 - dr)
      local result = scaled / 100
      if 0 < scaled % 100 and armor_pierced[item] then
        result = result + 1
      end
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
function Unit:IsArmored(target_spot_group)
  if self:IsDead() then
    return false
  end
  local armorFound = false
  self:ForEachItem("Armor", function(item, slot)
    if slot ~= "Inventory" and (not target_spot_group or item.ProtectedBodyParts and item.ProtectedBodyParts[target_spot_group]) then
      armorFound = item
      return "break"
    end
  end)
  local iconName = false
  if armorFound then
    local classId = PenetrationClassIds[armorFound.PenetrationClass]
    iconName = classId:lower() .. "_armor"
  end
  return armorFound, iconName, "UI/Hud/"
end
function Unit:ApplyDamageAndEffects(attacker, damage, hit, armor_decay)
  if self:IsDead() or not IsValid(self) then
    return
  end
  if damage and 0 < damage or hit.setpiece then
    self:TakeDamage(damage or 0, attacker, hit)
  end
  local invulnerable = self:IsInvulnerable()
  if not invulnerable then
    local effects = hit.effects
    if type(effects) == "string" and effects ~= "" then
      self:AddStatusEffect(effects)
    else
      for _, effect in ipairs(effects) do
        if effect and effect ~= "" then
          self:AddStatusEffect(effect)
        end
      end
    end
  end
  local was_wounded = self:HasStatusEffect("Wounded")
  if hit.direct_shot then
    local spot, params = CalcStainParamsFromShot(self, attacker, hit)
    if spot then
      self:AddStain("Blood", spot, params)
    end
  elseif not was_wounded then
    local spot
    if hit.melee_attack then
      spot = GetRandomStainSpot(hit.spot_group)
    else
      spot = GetRandomStainSpot()
    end
    if spot then
      self:SetEffectValue("wounded_stain_spot", spot)
    end
  end
  self:SetEffectValue("wounded_stain_spot", nil)
  if hit.explosion and not self:HasStainType("Blood") then
    local spot = GetRandomStainSpot()
    self:AddStain("Soot", spot)
  end
  if not invulnerable then
    local change = false
    for item, degrade in pairs(armor_decay) do
      item.Condition = self:ItemModifyCondition(item, -degrade)
      if IsKindOf(item, "TransmutedItemProperties") and item.RevertCondition == "damage" then
        item.RevertConditionCounter = item.RevertConditionCounter - 1
        if item.RevertConditionCounter == 0 then
          local slot_name = self:GetItemSlot(item)
          local new, prev = item:MakeTransmutation("revert")
          armor_decay[new] = degrade
          armor_decay[item] = false
          self:RemoveItem(slot_name, item)
          self:AddItem(slot_name, new)
          DoneObject(prev)
          change = true
        end
      end
    end
    if change then
      self:UpdateOutfit()
    end
  end
end
function Unit:SwapActiveWeapon(action_id, cost_ap)
  local igi = GetInGameInterfaceModeDlg()
  if IsKindOf(igi, "IModeCombatBase") and igi.attacker == self then
    InvokeShortcutAction(igi, "ExitAttackMode", igi)
  end
  if self.current_weapon == "Handheld A" then
    self.current_weapon = "Handheld B"
  else
    self.current_weapon = "Handheld A"
  end
  self:OnSetActiveWeapon(action_id, cost_ap)
end
function Unit:OnSetActiveWeapon(action_id, cost_ap)
  if not self.current_weapon then
    return
  end
  if HasPerk(self, "Scoundrel") and g_Combat then
    self:ActivatePerk("Scoundrel")
    PlayVoiceResponse(self, "Scoundrel")
  end
  if not GameState.loading then
    local should_interrupt
    local overwatch = g_Overwatch[self]
    if overwatch then
      local weapons = self:GetEquippedWeapons(self.current_weapon, "Firearm")
      should_interrupt = true
      for _, weapon in ipairs(weapons) do
        should_interrupt = should_interrupt and weapon.id ~= overwatch.weapon_id
      end
    end
    local pindown = g_Pindown[self]
    if not should_interrupt and pindown then
      local weapons = self:GetEquippedWeapons(self.current_weapon, "Firearm")
      should_interrupt = true
      for _, weapon in ipairs(weapons) do
        should_interrupt = should_interrupt and weapon.id ~= pindown.weapon_id
      end
    end
    if not should_interrupt and self.prepared_bombard_zone then
      local weapons = self:GetEquippedWeapons(self.current_weapon, "HeavyWeapon")
      should_interrupt = true
      for _, weapon in ipairs(weapons) do
        should_interrupt = should_interrupt and weapon.id ~= self.prepared_bombard_zone.weapon_id
      end
    end
    if should_interrupt then
      self:InterruptPreparedAttack()
    end
  end
  self:UpdateOutfit(self.Appearance)
  self:RecalcUIActions()
  self.lastFiringMode = false
  self:SetAimTarget(false, false)
  if not cost_ap or cost_ap == 0 then
    Msg("UnitAPChanged", self, action_id)
  end
  Msg("UnitSwappedWeapon", self)
  ObjModified(self)
end
function Unit:StartAI(debug_data, forced_behavior)
  if not IsValid(self) or self:IsDead() or self.ai_context or self:HasStatusEffect("Unconscious") then
    return
  end
  AIReloadWeapons(self)
  local proto_context = {}
  self:SelectArchetype(proto_context)
  local archetype = self:GetArchetype()
  local scores, available = {}, {}
  local total = 0
  AIUpdateBiases()
  for i, behavior in ipairs(archetype.Behaviors) do
    local weight_mod, disable, priority
    if behavior:MatchUnit(self) then
      weight_mod, disable, priority = AIGetBias(behavior.BiasId, self)
      priority = priority or behavior.Priority
    else
      weight_mod, disable, priority = 0, true, false
    end
    if debug_data then
      debug_data.behaviors = debug_data.behaviors or {}
      debug_data.behaviors[i] = {
        name = behavior:GetEditorView(),
        priority = priority,
        disable = disable,
        behavior = behavior,
        index = i
      }
    end
    if not disable then
      local score = MulDivRound(behavior:Score(self, debug_data), weight_mod, 100)
      if debug_data then
        debug_data.behaviors[i].score = score
      end
      if 0 < score then
        if priority and not forced_behavior then
          forced_behavior = behavior
          break
        end
        scores[#scores + 1] = score
        available[#available + 1] = behavior
        total = total + score
      end
    end
  end
  if total == 0 and not forced_behavior then
    printf("unit of %s archetype failed to select a behavior!", archetype.id)
    return
  end
  local roll = InteractionRand(total, "AIBehavior", self)
  local selected
  if not forced_behavior then
    for i, behavior in ipairs(available) do
      local score = scores[i]
      if roll <= score then
        selected = behavior
        break
      end
      roll = roll - score
    end
  end
  proto_context.behavior = forced_behavior or selected or available[#available]
  AICreateContext(self, proto_context)
  if self.ai_context.behavior then
    self.ai_context.behavior:OnStart(self)
  end
  return true
end
function UpdateSurrounded()
  for _, unit in ipairs(g_Units) do
    if unit:IsSurrounded() then
      unit:AddStatusEffect("Flanked")
    else
      unit:RemoveStatusEffect("Flanked")
    end
  end
end
function RollSkillCheck(unit, skill, modifier, add)
  modifier = modifier or 100
  add = add or 0
  local roll = 1 + unit:Random(100)
  local adjustRoll = GameDifficulties[Game.game_difficulty]:ResolveValue("rollSkillCheckBonus") or 0
  roll = roll + adjustRoll
  roll = Min(roll, 95)
  local value = MulDivRound(unit[skill], modifier, 100) + add
  local pass = roll < value or CheatEnabled("SkillCheck")
  local t_res = pass and Untranslated("<em>Pass</em>") or Untranslated("<em>Fail</em>")
  local meta = unit:GetPropertyMetadata(skill)
  local t_skill = meta.name
  if modifier ~= 100 then
    if 0 < add then
      t_skill = T({
        816405633181,
        "<percent(n1)> <skill>+<n2>",
        n1 = modifier,
        n2 = add,
        skill = meta.name
      })
    elseif add < 0 then
      t_skill = T({
        656059859333,
        "<percent(n1)> <skill><n2>",
        n1 = modifier,
        n2 = add,
        skill = meta.name
      })
    else
      t_skill = T({
        570928040607,
        "<percent(number)> <skill>",
        number = modifier,
        skill = meta.name
      })
    end
  elseif 0 < add then
    t_skill = T({
      481345361355,
      "<skill>+<number>",
      number = add,
      skill = meta.name
    })
  elseif add < 0 then
    t_skill = T({
      945399039468,
      "<skill><number>",
      number = add,
      skill = meta.name
    })
  end
  CombatLog("debug", T({
    Untranslated("<em><name><em> Skill check (<em><skill></em>) <roll>/<target>: <result>"),
    name = unit:GetLogName(),
    skill = t_skill,
    roll = roll,
    target = value,
    result = t_res
  }))
  return pass
end
function SkillCheck(unit, skill, threshold, dont_report_fails)
  if not unit or not IsKindOf(unit, "UnitPropertiesStats") then
    return "error"
  end
  local stat = unit[skill]
  if not stat then
    return "error"
  end
  if threshold <= stat or CheatEnabled("SkillCheck") then
    CombatLog("debug", "(success) " .. unit.session_id .. " " .. skill .. " check (" .. stat .. " / " .. threshold .. ")")
    PlayFX("SkillCheck", "success", unit, skill)
    return "success", stat - threshold, stat
  end
  PlayFX("SkillCheck", "fail", unit, skill)
  if not dont_report_fails then
    CombatLog("debug", "(fail) " .. unit.session_id .. " " .. skill .. " check (" .. stat .. " / " .. threshold .. ")")
  end
  return "fail", threshold - stat, stat
end
function SpawnUnit(class, session_id, pos, angle, groups, spawner, entrance)
  session_id = session_id or class
  NetUpdateHash("SpawnUnit", class, session_id, pos)
  local unit_data = CreateUnitData(class, session_id, InteractionRand(nil, "Satellite"))
  local unit_group = UnitDataDefs[unit_data.class].group
  local unit = Unit:new({
    unitdatadef_id = unit_data.class,
    group = unit_group,
    session_id = session_id,
    spawner = spawner,
    entrance_marker = entrance
  })
  AddToGlobalUnits(unit)
  for _, group in ipairs(groups) do
    unit:AddToGroup(group)
  end
  if angle then
    unit:SetAngle(angle)
  end
  if pos then
    unit:SetPos(pos)
  end
  if unit:IsNPC() and not unit.dummy then
    if IsKindOf(spawner, "UnitMarker") then
      for _, effect in ipairs(spawner.status_effects) do
        if CharacterEffectDefs[effect] then
          unit:AddStatusEffect(effect)
        end
      end
    end
    if IsKindOf(spawner, "GridMarker") and spawner.Suspicious or IsKindOf(entrance, "GridMarker") and entrance.Suspicious then
      unit:AddStatusEffect("HighAlert")
      if not spawner or spawner.Side ~= "neutral" then
        unit:AddStatusEffect("Unaware")
      end
    else
      local data = gv_UnitData[session_id]
      local squad_idx = data and data.Squad and table.find(g_SquadsArray, "UniqueId", data.Squad)
      local squad = squad_idx and g_SquadsArray[squad_idx]
      if squad and squad.militia then
        unit:AddStatusEffect("HighAlert")
      elseif not spawner or spawner.Side ~= "neutral" then
        unit:AddStatusEffect("Unaware")
      end
    end
  end
  unit:SetTargetDummyFromPos()
  return unit
end
function ValidateUnitGroupForEffectExec(group, effect, trigger_obj)
  local units = Groups[group]
  if Platform.developer and GameState.entered_sector and not units then
    local trigger_obj_idx = 1
    local errs = {}
    local sector_ids, effect_classes = {}, {}
    local addErr = function(effect, parents, obj)
      if effect:HasMember("Group") and effect.Group == group then
        if obj == trigger_obj then
          trigger_obj_idx = #errs + 1
        end
        if IsKindOf(obj, "QuestsDef") then
          errs[#errs + 1] = {
            obj,
            string.format("Effect %s with invalid group %s in quest %s", effect.class, group, obj.id)
          }
        elseif IsKindOf(obj, "SatelliteSector") then
          sector_ids[#sector_ids + 1] = obj.Id
          effect_classes[#effect_classes + 1] = effect.class
        elseif IsKindOf(obj, "GridMarker") then
          errs[#errs + 1] = {
            obj,
            string.format("Effect %s with invalid group %s in marker", effect.class, group)
          }
        end
      end
    end
    for id, quest in sorted_pairs(Quests) do
      if quest.TCEs and next(quest.TCEs) then
        for _, tce in ipairs(quest.TCEs) do
          tce:ForEachSubObject("Effect", addErr, quest)
        end
      end
    end
    local campaign_preset = Game.Campaign and CampaignPresets[Game.Campaign]
    for _, sector in ipairs(campaign_preset and campaign_preset.Sectors) do
      for _, event in ipairs(sector.Events) do
        sector:ForEachSubObject("Effect", addErr, sector)
      end
    end
    if next(sector_ids) then
      errs[#errs + 1] = {
        campaign_preset,
        string.format("Effects - %s - with invalid group %s in sectors: %s", table.concat(effect_classes, ", "), group, table.concat(sector_ids, ", "))
      }
    end
    MapForEachMarker("GridMarker", nil, function(marker)
      marker:ForEachSubObject("Effect", addErr, marker)
    end)
    errs[1], errs[trigger_obj_idx] = errs[trigger_obj_idx], errs[1]
    for _, err in ipairs(errs) do
      StoreErrorSource(err[1], err[2])
    end
  end
  return units or empty_table
end
OnMsg.VisibilityUpdate = UpdateSurrounded
OnMsg.CombatApplyVisibility = UpdateSurrounded
OnMsg.CombatStart = UpdateSurrounded
OnMsg.CombatEnd = UpdateSurrounded
function OnMsg.CombatStart(dynamic_data)
  local transfer_keys = {
    "hmg_emplacement",
    "spent_ap",
    "PrisonDoor",
    "CellLeaveBanters"
  }
  for _, unit in ipairs(g_Units) do
    if unit.team.side == "neutral" and not unit.behavior then
      unit:SetBehavior("GoBackAfterCombat", {
        unit:GetPos()
      })
    end
    if not dynamic_data then
      local values = {}
      for i, key in ipairs(transfer_keys) do
        values[i] = unit:GetEffectValue(key)
      end
      unit.effect_values = nil
      for i, key in ipairs(transfer_keys) do
        if values[i] ~= nil then
          unit:SetEffectValue(key, values[i])
        end
      end
      if unit.carry_flare then
        unit:RoamDropFlare()
      end
    end
    unit.marked_target_attack_args = nil
    unit.neutral_retal_attacked = nil
  end
end
DefineClass.DummyUnit = {
  __parents = {
    "AppearanceObject"
  },
  flags = {gofPermanent = true, gofUnitLighting = false},
  properties = {
    {
      category = "Dummy Unit",
      id = "UnitLighting",
      name = "Unit Lighting",
      editor = "bool",
      default = false
    },
    {
      category = "Dummy Unit",
      id = "FreezePhase",
      name = "Freeze Phase",
      editor = "number",
      default = false,
      slider = true,
      min = 0,
      max = function(obj)
        return GetAnimDuration(obj:GetEntity(), obj.anim) - 1
      end,
      help = "The unit will be freezed at this frame."
    }
  },
  entity = "Male",
  Appearance = "Raider_01"
}
function DummyUnit:GameInit()
  self:UpdateFreezePhase()
end
function DummyUnit:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "FreezePhase" or prop_id == "anim" then
    self:UpdateFreezePhase()
  end
end
function DummyUnit:UpdateFreezePhase()
  local phase = self:GetProperty("FreezePhase")
  if phase then
    self:SetAnimPose(self.anim, phase)
    self:SetAnimSpeedModifier(0)
  else
    self:SetAnimSpeedModifier(1000)
  end
end
function DummyUnit:SetStateText(state)
  AppearanceObject.SetStateText(self, state)
  self:SetProperty("anim", state)
end
function DummyUnit:SetUnitLighting(value)
  if value then
    self:SetHierarchyGameFlags(const.gofUnitLighting)
  else
    self:ClearHierarchyGameFlags(const.gofUnitLighting)
  end
  RecreateRenderObjects()
end
function DummyUnit:GetUnitLighting(value)
  return self:GetGameFlags(const.gofUnitLighting) ~= 0
end
function ErnyTown_HangUnit(group_id)
  local group = Groups[group_id]
  local units = {}
  for _, o in ipairs(group) do
    if IsKindOf(o, "Unit") then
      table.insert(units, o)
    end
  end
  if #units ~= 1 then
    StoreErrorSource(point30, "There should be exactly one unit of the group " .. group_id)
    return
  end
  local unit = units[1]
  unit:SetCommand("Hang")
  unit:SetGroups(false)
end
function OnMsg.ValidateMap()
  if Game and not g_IdleAnimActionStances then
    FillIdleAnimActionsAndStances()
  end
end
if FirstLoad then
  g_IdleAnimActionStances = false
end
local GetAllEntitiesValidAnimations = function()
  local dummy = PlaceObject("Unit", {
    NetUpdateHash = empty_func,
    IsSyncObject = function(self)
      return false
    end
  })
  dummy:ClearGameFlags(const.gofSyncObject)
  dummy:SetCommand(false)
  dummy:SetPos(point30)
  local anims = {}
  for id, app in sorted_pairs(AppearancePresets) do
    if app.Body then
      dummy:ApplyAppearance(AppearancePresets[id])
      if IsValidEntity(dummy:GetEntity()) then
        dummy:SetState("idle")
        local dummy_anims = ValidAnimationsCombo(dummy)
        for _, a in ipairs(dummy_anims) do
          anims[a] = true
        end
      end
    end
  end
  DoneObject(dummy)
  return anims
end
function FillIdleAnimActionsAndStances()
  g_IdleAnimActionStances = {
    no_weapon = {
      g_StanceActionDefault,
      [g_StanceActionDefault] = {
        g_StanceActionDefault
      }
    },
    weapon = {
      g_StanceActionDefault,
      [g_StanceActionDefault] = {
        g_StanceActionDefault
      }
    }
  }
  local anims = GetAllEntitiesValidAnimations()
  for a, _ in sorted_pairs(anims) do
    local prefix, stance, action = string.match(a, "(.*)_(.*)_(.*)")
    if prefix and stance and action then
      local key = prefix == "civ" and "no_weapon" or "weapon"
      table.insert_unique(g_IdleAnimActionStances[key], stance)
      g_IdleAnimActionStances[key][stance] = g_IdleAnimActionStances[key][stance] or {
        g_StanceActionDefault
      }
      table.insert_unique(g_IdleAnimActionStances[key][stance], action)
    end
  end
end
function GetIdleAnimStances(use_weapons)
  return g_IdleAnimActionStances[use_weapons and "weapon" or "no_weapon"]
end
function GetIdleAnimStanceActions(use_weapons, stance)
  return g_IdleAnimActionStances[use_weapons and "weapon" or "no_weapon"][stance]
end
function Unit:ResolveUIAction(idx)
  local id = self.ui_actions and self.ui_actions[idx]
  return id and self.ui_actions[id] and CombatActions[id]
end
function Unit:IsAware(check_pending)
  if self.team and self.team.side == "neutral" or self.command == "Die" or self:IsDead() then
    return false
  end
  if check_pending and (self.pending_aware_state == "aware" or self.pending_aware_state == "surprised" or self:HasStatusEffect("Surprised")) then
    return true
  end
  return not self:HasStatusEffect("Unaware") and not self:HasStatusEffect("Suspicious") and not self:HasStatusEffect("Surprised")
end
function Unit:IsSuspicious()
  if self:IsDead() or self.command == "Die" then
    return false
  end
  return self:HasStatusEffect("Suspicious")
end
function Unit:AddToInventory(item_id, amount, callback)
  if not item_id then
    return 0
  end
  amount = amount or 1
  local unit_amount = 0
  self:ForEachItemInSlot("Inventory", "InventoryStack", function(curitm, slot_name, item_left, item_top)
    if curitm and item_id and curitm.class == item_id and curitm.Amount < curitm.MaxStacks then
      local to_add = Min(curitm.MaxStacks - curitm.Amount, amount)
      curitm.Amount = curitm.Amount + to_add
      Msg("InventoryAddItem", self, curitm, to_add)
      amount = amount - to_add
      unit_amount = unit_amount + to_add
      if amount <= 0 then
        if callback then
          callback(self, curitm, unit_amount)
        end
        return "break"
      end
    end
  end)
  local itm
  while 0 < amount do
    local item = PlaceInventoryItem(item_id)
    local is_stack = IsKindOf(item, "InventoryStack")
    if self:AddItem("Inventory", item) then
      local to_add = 1
      if is_stack then
        to_add = Min(item.MaxStacks, amount)
        item.Amount = to_add
      end
      unit_amount = unit_amount + to_add
      amount = amount - to_add
      unit_amount = unit_amount + to_add
      Msg("InventoryAddItem", self, item, to_add)
      itm = item
    else
      DoneObject(item)
      break
    end
  end
  if callback and itm and 0 < unit_amount then
    callback(self, itm, unit_amount)
  end
  ObjModified(self)
  return amount
end
function Unit:DropItemContainer(item_id, amount, callback)
  if amount <= 0 then
    return
  end
  local item = PlaceInventoryItem(item_id)
  local is_stack = IsKindOf(item, "InventoryStack")
  if is_stack then
    item.Amount = amount
  end
  local container = GetDropContainer(self, false, item)
  if container then
    local pos, res = container:AddItem("Inventory", item)
    if pos and callback then
      callback(self, item, amount)
    end
  end
end
function Unit:DropItemsInContainer(items, callback)
  local container = GetDropContainer(self)
  if not container then
    return
  end
  for i = #items, 1, -1 do
    local item = items[i]
    if not container:CanAddItem("Inventory", item) then
      container = GetDropContainer(self, false, item)
    end
    local pos, reason = container:AddItem("Inventory", item)
    if pos then
      if callback then
        callback(self, item, IsKindOf("InventoryStack") and item.Amount or 1)
      end
      table.remove(items, i)
    end
  end
end
function Unit:SetHighlightReason(reason, enable)
  self.highlight_reasons = self.highlight_reasons or {}
  self.highlight_reasons[reason] = enable
  self:UpdateHighlightMarking()
  if self.session_id then
    ObjModified(self.session_id .. "_combat_badge")
  end
  if reason == "deploy_predict" and self.ui_badge then
    self.ui_badge:SetVisible(not enable, "deploy_predict")
  end
end
function Unit:UpdateHighlightMarking()
  if WaitRecalcVisibility then
    return
  end
  local marking = false
  if not self.visible or IsSetpiecePlaying() or CheatEnabled("IWUIHidden") then
    marking = -1
  end
  if not marking then
    local pov_team = GetPoVTeam()
    local enemyTurn = g_Combat and g_Teams[g_CurrentTeam] ~= pov_team
    local playing = not IsMerc(self) and g_AIExecutionController and table.find(g_AIExecutionController.currently_playing, self)
    if enemyTurn and not playing then
      marking = -1
    end
  end
  if not marking then
    local reasons = self.highlight_reasons
    if reasons["dark voxel"] then
      marking = 3
    elseif reasons["area target"] then
      marking = 3
    elseif reasons.melee then
      marking = 3
    elseif reasons["melee-target"] then
      marking = 3
    elseif reasons["bandage-target"] then
      marking = 0
    elseif reasons.concealed then
      if HasThermalVision(Selection) then
        marking = 10
      else
        marking = 9
      end
    elseif reasons.obscured then
      marking = 7
    elseif reasons.visibility then
      local pov_team = GetPoVTeam()
      if pov_team:IsEnemySide(self.team) then
        local enemyTurn = g_Combat and g_Teams[g_CurrentTeam] ~= pov_team
        local playing = g_AIExecutionController and table.find(g_AIExecutionController.currently_playing, self)
        local seen = enemyTurn or playing
        if not seen then
          for _, unit in ipairs(Selection) do
            if HasVisibilityTo(unit, self) then
              seen = true
              break
            end
          end
        end
        marking = seen and 3 or 1
      elseif reasons.faded or g_Combat and not g_Combat:ShouldEndCombat() then
        if pov_team:IsAllySide(self.team) then
          marking = 0
        else
          marking = 2
        end
      end
    elseif reasons.darkness then
      marking = 8
    elseif reasons.deploy_predict then
      marking = 5
    elseif reasons.can_be_interacted then
      marking = 11
    end
  end
  marking = marking or -1
  self:SetObjectMarking(marking)
  if marking < 0 then
    self:ClearHierarchyGameFlags(const.gofObjectMarking)
  else
    self:SetHierarchyGameFlags(const.gofObjectMarking)
  end
end
const.utWellRested = -1
const.utNormal = 0
const.utTired = 1
const.utExhausted = 2
const.utUnconscious = 3
UnitTirednessEffect = {
  [const.utWellRested] = "WellRested",
  [const.utNormal] = "Default",
  [const.utTired] = "Tired",
  [const.utExhausted] = "Exhausted",
  [const.utUnconscious] = "Unconscious"
}
function TFormat.tiredness(context_obj, value)
  local effect = UnitTirednessEffect[value]
  if effect and g_Classes[effect] then
    return g_Classes[effect].DisplayName
  elseif effect == "Default" then
    return T(714191851131, "Normal")
  end
  return ""
end
function UnitTirednessComboItems()
  local items = {}
  for k, v in sorted_pairs(UnitTirednessEffect) do
    items[#items + 1] = {name = v, value = k}
  end
  return items
end
function OnMsg.UnitRelationsUpdated()
  for _, unit in ipairs(g_Units) do
    unit:UpdateMeleeTrainingVisual()
  end
end
function SortUnitsMap(units_map)
  if not units_map or not next(units_map) then
    return units_map
  end
  local first_key = next(units_map)
  if next(units_map, first_key) == nil then
    return {
      {
        id = first_key.session_id,
        unit = first_key,
        data = units_map[first_key]
      }
    }
  end
  local positions = {}
  for unit, data in pairs(units_map) do
    positions[#positions + 1] = {
      id = unit.session_id,
      unit = unit,
      data = data
    }
  end
  table.sortby(positions, "id")
  return positions
end
function Unit:GetBodyParts(attack_weapon)
  local list = Presets.TargetBodyPart.Default
  if self.species == "Human" then
    local head = list.Head
    if IsKindOf(attack_weapon, "MeleeWeapon") then
      head = list.Neck
    end
    return {
      head,
      list.Arms,
      list.Torso,
      list.Groin,
      list.Legs
    }
  end
  return {
    list.Head,
    list.Torso,
    list.Legs
  }
end
function Unit:ShowMishapNotification(action)
  if self.team.player_team then
    local text = action:GetAttackWeapons(self).DisplayName
    HideTacticalNotification("playerAttack")
    ShowTacticalNotification("playerAttack", false, T({
      989807512852,
      "<attack> Mishap",
      attack = text
    }))
  else
    local text = GetTacticalNotificationText("enemyAttack") or action:GetAttackWeapons(self).DisplayName
    HideTacticalNotification("enemyAttack")
    ShowTacticalNotification("enemyAttack", false, T({
      989807512852,
      "<attack> Mishap",
      attack = text
    }))
  end
  CreateFloatingText(self, T(371973388445, "Mishap!"), "FloatingTextMiss")
end
function Unit:GetValidStance(target_stance, pos)
  if target_stance == "Prone" then
    local side = self.team and self.team.side or "player1"
    local pfclass = CalcPFClass(side, "Prone", self.body_type)
    if not GetPassSlab(pos or self, pfclass) then
      return "Crouch"
    end
  end
  return target_stance
end
function Unit:CanSwitchStance(toDoStance, args)
  if self:IsStanceChangeLocked() then
    return false
  end
  local action
  if toDoStance == "Standing" then
    action = "StanceStanding"
  elseif toDoStance == "Crouch" then
    action = "StanceCrouch"
  elseif toDoStance == "Prone" then
    local unitOrGotoPos = args and args.goto_pos or self
    local in_water = terrain.IsWater(unitOrGotoPos)
    if in_water then
      return false, AttackDisableReasons.Water
    end
    local valid_stance = self:GetValidStance("Prone", unitOrGotoPos)
    if valid_stance ~= "Prone" then
      return false, AttackDisableReasons.Stairs
    end
    action = "StanceProne"
  end
  local cost = CombatActions[action]:GetAPCost(self, args)
  if cost < 0 then
    return false, "hidden"
  end
  if not self:UIHasAP(cost, action) then
    return false, GetUnitNoApReason(self)
  end
  return true
end
function Unit:IsStanceChangeLocked()
  if IsKindOf(self:GetActiveWeapons(), "MachineGun") and (self.behavior == "OverwatchAction" or self.combat_behavior == "OverwatchAction") then
    return true
  end
  if self:GetBandageTarget() then
    return true
  end
  return false
end
MapVar("g_AttackRevealQueue", false)
function Unit:AttackReveal(action, attack_args, results)
  local attacker = self
  local target = attack_args.target
  local killed = results.killed_units or empty_table
  if not g_Combat then
    g_AttackRevealQueue = {self}
  end
  if IsKindOf(target, "Unit") and not target:IsDead() and not table.find(killed, target) then
    if g_Combat then
      self:RevealTo(target)
    else
      g_AttackRevealQueue[#g_AttackRevealQueue + 1] = target
    end
  end
  for _, hit in ipairs(results) do
    local unit = IsKindOf(hit.obj, "Unit") and not hit.obj:IsIncapacitated() and hit.obj
    if unit and unit.team ~= self.team and not unit:IsDead() and not table.find(killed, unit) then
      if g_Combat then
        self:RevealTo(unit)
      else
        g_AttackRevealQueue[#g_AttackRevealQueue + 1] = unit
      end
    end
  end
end
function Unit:OnEnemySighted(other)
  if HasPerk(self, "AlwaysReady") and not self:HasStatusEffect("Hidden") and g_Combat and not g_Combat:ShouldEndCombat() and g_Teams[g_CurrentTeam] ~= self.team and not self:HasPreparedAttack() and not self:IsThreatened(nil, "overwatch") then
    self:TryActivateAlwaysReady(other)
  end
end
function Unit:GetMoveAPCost(dest)
  if not dest or not g_Combat and not g_StartingCombat then
    return 0
  end
  local move_cost = 0
  local path = GetCombatPath(self)
  move_cost = path and path:GetAP(dest)
  if not move_cost then
    return -1
  end
  return Max(0, move_cost - self.free_move_ap)
end
function Unit:HasNightVision()
  if HasPerk(self, "NightOps") then
    return true
  end
  local helm = self:GetItemInSlot("Head")
  return IsKindOf(helm, "NightVisionGoggles") and helm.Condition > 0
end
function NetSyncEvents.SetAutoFace(obj, auto_face)
  if not obj or obj.auto_face == auto_face then
    return
  end
  obj.auto_face = auto_face
  if auto_face and obj.command == "Idle" and obj.stance ~= "Prone" and not obj.interrupt_callback and not IsValidThread(obj.reorientation_thread) then
    obj.reorientation_thread = CreateGameTimeThread(function(obj)
      Sleep(obj:Random(500))
      if obj.auto_face and obj.command == "Idle" and (obj.stance == "Standing" or obj.stance == "Crouch") and not obj.interrupt_callback then
        obj:InterruptCommand("Idle")
      end
      obj.reorientation_thread = false
    end, obj)
  end
end
function OnMsg.SelectedObjChange()
  local obj = SelectedObj
  if not obj then
    return
  end
  if not obj.auto_face then
    return
  end
  if not (g_Combat and g_Teams) or g_Teams[g_CurrentTeam] ~= obj.team then
    return
  end
  if not obj:IsLocalPlayerControlled() then
    return
  end
  NetSyncEvent("SetAutoFace", obj, false)
end
function OnMsg.SelectionRemoved(obj)
  if not (g_Combat and g_Teams) or g_Teams[g_CurrentTeam] ~= obj.team then
    return
  end
  if not obj:IsLocalPlayerControlled() then
    return
  end
  if obj.stance == "Prone" then
    return
  end
  NetSyncEvent("SetAutoFace", obj, true)
end
function OnMsg:TurnEnded(team)
  for i, unit in ipairs(g_Teams[g_CurrentTeam].units) do
    unit.auto_face = true
  end
end
DefineClass.TargetDummy = {
  __parents = {
    "Movable",
    "SyncObject",
    "AppearanceObject"
  },
  flags = {
    efUnit = true,
    efVisible = false,
    efSelectable = false,
    efWalkable = false,
    efCollision = false,
    efPathExecObstacle = false,
    efResting = false,
    efApplyToGrids = false,
    efShadow = false,
    efSunShadow = false,
    gofOnRoof = false
  },
  __toluacode = empty_func,
  obj = false,
  stance = false,
  locked = false
}
DefineClass.TargetDummyLargeAnimal = {
  __parents = {
    "TargetDummy"
  }
}
function TargetDummy:Init()
  local obj = self.obj
  if obj then
    self:ApplyAppearance(obj.Appearance)
    pf.SetGroundOrientOffsets(self, table.unpack(obj:GetGroundOrientOffsets()))
  end
  self:SetDestlockRadius(obj and obj:GetDestlockRadius() or 0)
  self:SetCollisionRadius(0)
  self:SetAnimSpeed(1, 0)
  Msg("NewTargetDummy", self)
end
TargetDummy.InitPathfinder = empty_func
TargetDummy.EnterPathfinder = empty_func
TargetDummy.EnterPathfinder = empty_func
function SavegameSectorDataFixups.ClearTargetDummies(sector_data)
  local spawn_data = sector_data.spawn
  while true do
    local idx = table.find(spawn_data, "TargetDummy")
    if not idx then
      break
    end
    table.remove(spawn_data, idx + 1)
    table.remove(spawn_data, idx)
  end
end
function IsLastUnitInTeam(units)
  local lastStanding = false
  for _, unit in ipairs(units) do
    if not unit:IsDead() and not lastStanding then
      lastStanding = unit
    elseif not unit:IsDead() and lastStanding then
      return false
    end
  end
  return lastStanding
end
function SavegameSessionDataFixups.ExpFixup(data, metadata, lua_ver)
  local ud = data.gvars.gv_UnitData
  for _, data in pairs(ud) do
    if not data.Experience then
      local minXP = XPTable[data.StartingLevel]
      data.Experience = minXP
    end
    data:RemoveModifier("ExperienceBonus", "Experience")
  end
end
UndefineClass("AdditionalGroup")
DefineClass.AdditionalGroup = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "Weight",
      name = "Weight",
      editor = "number",
      min = 0,
      max = 100,
      default = 100,
      help = "Integer numbers.(0:never picked / 100:always picked)"
    },
    {
      id = "Exclusive",
      name = "Mutually Exclusive",
      editor = "bool",
      default = false,
      help = "If marked as exclusive, only one will be chosen from all marked as exclusive. NB: If only one is marked as exclusive and weight > 0, it will be ALWAYS picked."
    },
    {
      id = "Name",
      name = "Name",
      editor = "text",
      default = "",
      help = "The name of the group."
    }
  }
}
function AdditionalGroup:EditorView()
  return string.format("AdditionalGroup %s", self.Name and self.Name ~= "" and "- " .. self.Name or "")
end
function Unit:IsConcealedFrom(observer)
  return GameState.Fog and not self.indoors and not IsCloser(self, observer, const.EnvEffects.FogUnkownFoeDistance)
end
function Unit:IsObscuredFrom(observer)
  return GameState.DustStorm and not self.indoors and not IsCloser(self, observer, const.EnvEffects.DustStormUnkownFoeDistance)
end
function HasThermalVision(units)
  for _, unit in ipairs(units) do
    local _, _, weapons = unit:GetActiveWeapons()
    for _, weapon in ipairs(weapons) do
      if weapon:HasComponent("IgnoreConcealAndObscure") then
        return true
      end
    end
  end
end
function Unit:UIObscured()
  local side = not self.CurrentSide and self.team and self.team.side
  if not side or side == "player1" or side == "player2" or side == "ally" then
    return false
  end
  if not GameState.DustStorm then
    return false
  end
  local units = Selection or empty_table
  if #units == 0 then
    local team = GetPoVTeam()
    units = team and team.units
  end
  local obscured = true
  for _, unit in ipairs(units) do
    obscured = obscured and CheckSightCondition(unit, self, const.usObscured)
  end
  return obscured
end
function Unit:UIConcealed(skip_check)
  local side = not self.CurrentSide and self.team and self.team.side
  if not side or side == "player1" or side == "player2" or side == "ally" then
    return false
  end
  if not GameState.Fog then
    return false
  end
  if not skip_check and HasThermalVision(Selection) then
    return false
  end
  local concealed = true
  local units = Selection or empty_table
  if #units == 0 then
    local team = GetPoVTeam()
    units = team and team.units
  end
  for _, unit in ipairs(units) do
    concealed = concealed and CheckSightCondition(unit, self, const.usConcealed)
  end
  return concealed
end
function Unit:GetDisplayName()
  if self:UIObscured() or self:UIConcealed() then
    return T(393866533740, "???")
  end
  return UnitProperties.GetDisplayName(self)
end
function Unit:HasVisibleEffects()
  if self.team.neutral then
    return false
  end
  return StatusEffectObject.HasVisibleEffects(self)
end
function Unit:FastForwardCommand()
  if self.command == "ExitMap" then
    self:Despawn()
  end
end
function Unit:SetCommandIfNotDead(...)
  if self:IsDead() or self.command == "Die" then
    return
  end
  self:SetCommand(...)
end