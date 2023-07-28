DefineClass.AIActionSniperSetup = {
    __parents = {
      "AIActionBaseConeAttack"
    },
    properties = {
      {
        id = "cur_zone_mod",
        name = "Current Zone Modifier",
        editor = "number",
        scale = "%",
        default = 100,
        help = "Modifier applied when scoring the already set zone"
      }
    },
    action_id = "SniperSetup",
    hidden = false
}

  function IsOverwatchAction(actionId)
    return actionId == "Overwatch" or actionId == "DanceForMe" or actionId == "EyesOnTheBack" or actionId == "MGSetup" or actionId == "MGRotate" or actionId == "SniperSetup" or actionId == "SniperRotate"
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
    local notInGivenCommand = self.command ~= "OverwatchAction" and self.command ~= "MGSetup" and self.command ~= "MGTarget"and self.command ~= "SniperSetup" and self.command ~= "SniperTarget"
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
        print("StationedSniper")
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
