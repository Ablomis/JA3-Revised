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
    elseif self:HasStatusEffect("StationeSniper") then
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