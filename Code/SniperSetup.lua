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

 