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

function Unit:SniperSetup(action_id, cost_ap, args)
    print('SniperSetup')
    self.interruptable = false
    if self.stance ~= "Prone" then
      self:DoChangeStance("Prone")
    end
    self:AddStatusEffect("StationedSniper")
    self:UpdateHidden()
    self:FlushCombatCache()
    self:RecalcUIActions(true)
    ObjModified(self)
    return self:SniperTarget(action_id, cost_ap, args)
  end

  function Unit:SniperTarget(action_id, cost_ap, args)
    print('SniperTarget')
    args.permanent = true
    args.num_attacks = self:GetNumMGInterruptAttacks()
    self.interruptable = false
    return self:OverwatchAction(action_id, cost_ap, args)
  end
  function Unit:SniperPack()
    self:InterruptPreparedAttack()
    self:RemoveStatusEffect("StationedSniper")
    self:UpdateHidden()
    self:FlushCombatCache()
    self:RecalcUIActions(true)
    if HasPerk(self, "KillingWind") then
      self:RemoveStatusEffect("FreeMove")
      self:AddStatusEffect("FreeMove")
    end
    ObjModified(self)
  end

  local add_weapon_attacks = function(actions, unit, weapon)
    if IsKindOf(weapon, "MachineGun") and not unit:HasStatusEffect("StationedMachineGun") then
      table.insert_unique(actions, "MGSetup")
    elseif IsKindOf(weapon, "SniperRifle") and not unit:HasStatusEffect("StationedSnipern") then
        table.insert_unique(actions, "SniperSetup")
    elseif IsKindOf(weapon, "HeavyWeapon") then
      table.insert_unique(actions, weapon:GetBaseAttack())
    elseif IsKindOf(weapon, "Firearm") then
      for _, id in ipairs(weapon.AvailableAttacks or empty_table) do
        table.insert_unique(actions, id)
      end
    elseif IsKindOf(weapon, "MeleeWeapon") then
      if weapon.Charge then
        table.insert_unique(actions, "Charge")
      else
        table.insert_unique(actions, "Brutalize")
      end
    elseif not weapon then
      table.insert_unique(actions, "Brutalize")
    end
  end

  function Unit:EnumUIActions()
    local actions = {}
    if g_Combat or IsUnitPrimarySelectionCoOpAware(self) and not g_Overwatch[self] then
      local action = self:GetDefaultAttackAction()
      actions[1] = action.id
      local main_weapon, offhand_weapon = self:GetActiveWeapons()
      add_weapon_attacks(actions, self, main_weapon)
      if IsKindOf(main_weapon, "FlareGun") or IsKindOf(offhand_weapon, "FlareGun") then
        add_weapon_attacks(actions, self, offhand_weapon)
      end
      if self:GetThrowableKnife() then
        actions[#actions + 1] = "KnifeThrow"
      end
      if table.find(actions, "DualShot") then
        table.insert_unique(actions, "LeftHandShot")
        table.insert_unique(actions, "RightHandShot")
      end
      if IsKindOf(main_weapon, "FirearmBase") then
        for slot, sub in sorted_pairs(main_weapon.subweapons) do
          add_weapon_attacks(actions, self, sub)
        end
        if main_weapon:HasComponent("EnableFullAuto") then
          table.insert_unique(actions, "AutoFire")
        end
      end
      if #actions == 0 then
        actions[1] = "UnarmedAttack"
      end
    end
    for _, skill in ipairs(Presets.CombatAction.SignatureAbilities) do
      local id = skill.id
      if string.match(id, "DoubleToss") then
        id = "DoubleToss"
      end
      if id and self:HasStatusEffect(id) then
        actions[#actions + 1] = skill.id
      end
    end
    ForEachPresetInGroup("CombatAction", "Default", function(def)
      actions[#actions + 1] = def.id
    end)
    if g_Combat or IsUnitPrimarySelectionCoOpAware(self) then
      if self:GetItemInSlot("Handheld A", "Grenade", 1, 1) then
        actions[#actions + 1] = "ThrowGrenadeA"
      end
      if self:GetItemInSlot("Handheld A", "Grenade", 2, 1) then
        actions[#actions + 1] = "ThrowGrenadeB"
      end
      if self:GetItemInSlot("Handheld B", "Grenade", 1, 1) then
        actions[#actions + 1] = "ThrowGrenadeC"
      end
      if self:GetItemInSlot("Handheld B", "Grenade", 2, 1) then
        actions[#actions + 1] = "ThrowGrenadeD"
      end
      if GetUnitEquippedMedicine(self) then
        actions[#actions + 1] = "Bandage"
      end
      if GetUnitEquippedDetonator(self) then
        actions[#actions + 1] = "RemoteDetonation"
      end
    end
    actions[#actions + 1] = "ItemSkills"
    return actions
  end

  function IsOverwatchAction(actionId)
    print('is overwatch action')
    return actionId == "Overwatch" or actionId == "DanceForMe" or actionId == "EyesOnTheBack" or actionId == "MGSetup" or actionId == "MGRotate" or actionId == "SniperSetup" or actionId == "SniperRotate"
  end

  function Unit:RecalcUIActions(force)
    local actions
    if self:GetBandageTarget() then
      actions = {
        "StopBandaging"
      }
    elseif self:HasStatusEffect("StationedMachineGun") or self:HasStatusEffect("ManningEmplacement") or self:HasStatusEffect("StationedSnipern") then
      actions = {}
      local action = self:GetDefaultAttackAction()
      actions[#actions + 1] = action.id
      ForEachPresetInGroup("CombatAction", "MachineGun", function(def)
        if def.id ~= "MGSetup" or def.id ~="SniperSetup" then
          actions[#actions + 1] = def.id
        end
      end)
      actions[#actions + 1] = "Reload"
      actions[#actions + 1] = "Unjam"
    else
      actions = self:EnumUIActions()
      if not actions then
        return
      end
    end
    local ui_actions = {}
    local vis_idx = 1
    local old_actions = self.ui_actions
    self.ui_actions = ui_actions
    if actions then
      table.sort(actions, function(a, b)
        local actionA = CombatActions[a]
        local actionB = CombatActions[b]
        return actionA.SortKey < actionB.SortKey
      end)
      local firingModes = {}
      for i = 1, #actions do
        local id = actions[i]
        local caction = CombatActions[id]
        local state = "hidden"
        local firingModeId = caction.FiringModeMember
        if firingModeId then
          if caction.ShowIn == "CombatActions" and (g_Combat or #(Selection or empty_table) == 1 or caction.MultiSelectBehavior ~= "hidden") then
            local target = caction.RequireTargets and caction:GetDefaultTarget(self)
            state = caction:GetVisibility({self}, target)
          end
          if state ~= "hidden" then
            if not firingModes[firingModeId] then
              firingModes[firingModeId] = {}
            end
            table.insert(firingModes[firingModeId], id)
            ui_actions[id] = state
          end
        end
      end
      local dual_shot_state
      for modeName, mode in pairs(firingModes) do
        if modeName == "AttackDual" then
          for i, m in ipairs(mode) do
            if ui_actions[m] == "enabled" then
              dual_shot_state = "enabled"
            end
          end
        end
      end
      for modeName, mode in pairs(firingModes) do
        local defaultFireMode = mode[1]
        if 1 < #mode and (modeName ~= "AttackDual" or dual_shot_state ~= "hidden") then
          ui_actions[modeName] = "enabled"
          local defaultAction = self:GetDefaultAttackAction(false, "force_ungrouped")
          if defaultAction.FiringModeMember == modeName and ui_actions[defaultAction.id] == "enabled" then
            defaultFireMode = defaultAction.id
          else
            for i, m in ipairs(mode) do
              if ui_actions[m] == "enabled" then
                defaultFireMode = m
                break
              end
            end
          end
        else
          ui_actions[modeName] = "disabled"
        end
        if modeName ~= "AttackDual" and dual_shot_state == "enabled" then
          ui_actions[modeName] = "hidden"
          for i, m in ipairs(mode) do
            ui_actions[m] = "hidden"
          end
        elseif dual_shot_state ~= "enabled" and modeName == "AttackDual" then
          for i, m in ipairs(mode) do
            ui_actions[m] = "hidden"
          end
        end
        mode.take_idx_from = mode[1]
        ui_actions[modeName .. "default"] = defaultFireMode
      end
      local doubleTossCount = 0
      local grenadeModes = {}
      for i = 1, #actions do
        local id = actions[i]
        local caction = CombatActions[id]
        local state = "hidden"
        if caction.ShowIn == "CombatActions" or caction.ShowIn == "SignatureAbilities" then
          if ui_actions[id] then
            state = ui_actions[id]
          elseif g_Combat or #(Selection or empty_table) == 1 or caction.MultiSelectBehavior ~= "hidden" then
            local target = caction.RequireTargets and CombatActionGetOneAttackableEnemy(caction, self)
            state = caction:GetVisibility({self}, target)
          end
        end
        if state ~= "hidden" then
          local action_type
          if string.match(id, "DoubleToss") then
            action_type = "DoubleToss"
          elseif string.match(id, "ThrowGrenade") then
            action_type = "ThrowGrenade"
          end
          if action_type then
            grenadeModes[action_type] = grenadeModes[action_type] or {}
            local weapon = caction:GetAttackWeapons(self)
            if not weapon or grenadeModes[action_type][weapon.class] then
              state = "hidden"
              if action_type == "DoubleToss" then
                doubleTossCount = doubleTossCount + 1
                if doubleTossCount == 4 then
                  state = "disabled"
                end
              end
            end
            if weapon then
              grenadeModes[action_type][weapon.class] = grenadeModes[action_type][weapon.class] or {}
              local equipped = self.current_weapon == "Handheld A" and (id == "ThrowGrenadeA" or id == "ThrowGrenadeB") or self.current_weapon == "Handheld B" and (id == "ThrowGrenadeC" or id == "ThrowGrenadeD")
              grenadeModes[action_type][weapon.class][id] = equipped
            end
          end
        end
        if state ~= "hidden" then
          local firingModeId = caction.FiringModeMember
          if firingModeId and ui_actions[firingModeId] == "enabled" then
            if firingModes[firingModeId].take_idx_from == id then
              table.insert(ui_actions, vis_idx, firingModeId)
              vis_idx = vis_idx + 1
            end
          elseif CombatActions[id].group ~= "Hidden" then
            table.insert(ui_actions, vis_idx, id)
            vis_idx = vis_idx + 1
          end
          ui_actions[id] = state
        elseif caction.ShowIn ~= "Special" and not caction.ShowIn then
          ui_actions[#ui_actions + 1] = id
        end
      end
      for action, _ in pairs(grenadeModes) do
        for grenadeType, _ in pairs(grenadeModes[action]) do
          for actionName, _ in pairs(grenadeModes[action][grenadeType]) do
            if grenadeModes[action][grenadeType][actionName] and not table.find(ui_actions, actionName) then
              for otherActionName, _ in pairs(grenadeModes[action][grenadeType]) do
                if table.find(ui_actions, otherActionName) then
                  ui_actions[otherActionName] = nil
                  ui_actions[actionName] = "enabled"
                  ui_actions[table.find(ui_actions, otherActionName)] = actionName
                  break
                end
              end
            end
          end
        end
      end
    end
    for i, id in ipairs(ui_actions) do
      local caction = CombatActions[id]
      if caction.group == "SignatureAbilities" then
        if ui_actions[13] then
          do
            local swapped = table.remove(ui_actions, 13)
            ui_actions[i] = swapped
            ui_actions[13] = id
          end
          break
        end
        table.remove(ui_actions, i)
        if #ui_actions < 12 then
          for j = #ui_actions + 1, 12 do
            ui_actions[j] = "empty"
          end
        end
        ui_actions[13] = id
        break
      end
    end
    if 14 < vis_idx then
      for i, itemSkill in ipairs(itemCombatSkillsList) do
        if ui_actions[itemSkill] then
          local actionIdx = table.find(ui_actions, itemSkill)
          if actionIdx then
            table.remove(ui_actions, actionIdx)
            vis_idx = vis_idx - 1
          end
        end
      end
      vis_idx = vis_idx + 1
    else
      ui_actions.ItemSkills = false
    end
    if self == Selection[1] then
      local allMatch = false
      if old_actions then
        allMatch = true
        for i, a in ipairs(old_actions) do
          if ui_actions[i] ~= a or old_actions[a] ~= ui_actions[a] then
            allMatch = false
            break
          end
        end
      end
      if not allMatch or force then
        ObjModified("combat_bar")
      end
    end
    return ui_actions
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

  function Unit:OverwatchAction(action_id, cost_ap, args)
    self:EndInterruptableMovement()
    args = table.copy(args)
    args.OverwatchAction = true
    if self.opportunity_attack then
      local action = CombatActions[action_id]
      local results, attack_args = action:GetActionResults(self, args)
      self:AimTarget(attack_args, results, true)
      self:SetCommand("PreparedAttackIdle")
      return
    end
    local target = args.target
    if not IsPoint(target) and not IsValid(target) then
      if g_Combat then
        self:GainAP(cost_ap)
        CombatActionInterruped(self)
      end
      return
    end
    local action = CombatActions[action_id]
    local weapon = action:GetAttackWeapons(self)
    if not weapon then
      self:InterruptPreparedAttack()
      return
    end
    local dlg = GetInGameInterfaceModeDlg()
    if dlg and dlg:HasMember("dont_return_camera_on_close") and not g_AIExecutionController then
      dlg.dont_return_camera_on_close = true
    end
    local wasInterruptable
    if not g_Combat then
      wasInterruptable = self.interruptable
      if wasInterruptable then
        self:EndInterruptableMovement()
      end
      if not self:HasStatusEffect("ManningEmplacement") then
        self:UninterruptableGoto(self:GetVisualPos())
      else
        local handle = self:GetEffectValue("hmg_emplacement")
        local obj = handle and HandleToObject[handle]
        if obj then
          local visual = obj.weapon and obj.weapon:GetVisualObj()
          local fire_spot = visual:GetSpotBeginIndex("Unit")
          local fire_pos = visual:GetSpotPos(fire_spot)
          self:SetPos(fire_pos)
        end
      end
      self:SetTargetDummyFromPos()
      self:UpdateAttachedWeapons()
      self:ExplorationStartCombatAction(action_id, self:GetMaxActionPoints(), args)
    end
    local target_pos = IsValid(target) and target:GetPos() or target
    local results, attack_args = action:GetActionResults(self, args)
    args.step_pos = attack_args.step_pos
    args.stance = attack_args.stance
    args.can_use_covers = false
    self:SetCombatBehavior("OverwatchAction", {
      action_id,
      cost_ap,
      args
    })
    if not g_Combat or args.permanent then
      self:SetBehavior("OverwatchAction", {
        action_id,
        cost_ap,
        args
      })
    end
    local overwatch = CalcEarlyOverwatchEntry(self, action_id, weapon, args, attack_args, target_pos)
    self:UpdateOverwatchVisual(overwatch)
    if not args.activated then
      self:ProvokeOpportunityAttacks("attack interrupt")
    end
    if attack_args.stance and self.stance ~= attack_args.stance then
      self:DoChangeStance(attack_args.stance)
    end
    self:PrepareToAttack(attack_args, results)
    if not args.activated then
      self:ProvokeOpportunityAttacks("attack reaction")
      PlayFX("OverwatchActivate", "start", self)
    end
    local step_pos = attack_args.step_pos
    local stance = attack_args.stance
    local attacker_pos3D = attack_args.step_pos
    if not attacker_pos3D:IsValidZ() then
      attacker_pos3D = attacker_pos3D:SetTerrainZ()
    end
    local aoe_params = action and action:GetAimParams(self, weapon) or weapon:GetAreaAttackParams(action_id, self)
    local distance = Clamp(attacker_pos3D:Dist(target_pos), aoe_params.min_range * const.SlabSizeX, aoe_params.max_range * const.SlabSizeX)
    local cone_angle = aoe_params.cone_angle
    local target_angle = CalcOrientation(step_pos, target_pos)
    local expiration_turn = args.expiration_turn
    if not expiration_turn then
      if args.permanent then
        expiration_turn = -1
      else
        expiration_turn = (g_Combat and g_Combat.current_turn or 1) + 1
      end
    end
    if 10800 <= cone_angle then
      self.return_pos = false
    end
    args.triggered_by = args.triggered_by or {}
    args.expiration_turn = expiration_turn
    g_Overwatch[self] = {
      pos = step_pos,
      stance = stance,
      angle = target_angle,
      cone_angle = cone_angle,
      target_pos = target_pos,
      dist = distance,
      dir = SetLen(target_pos - step_pos, guim),
      aim = Min((args.aim_ap or 0) / const.Scale.AP, weapon.MaxAimActions),
      action_id = self:GetDefaultAttackAction("ranged", "ungrouped", nil, true, "ignore").id,
      origin_action_id = action_id,
      triggered_by = args.triggered_by,
      permanent = args.permanent,
      expiration_turn = expiration_turn,
      num_attacks = args.num_attacks or 1,
      orient = CalcOrientation(step_pos, target_pos),
      weapon_id = weapon.id
    }
    self:UpdateOverwatchVisual()
    local enemies = table.ifilter(GetAllEnemyUnits(self), function(_, enemy)
      return enemy:GetDist(step_pos) <= distance
    end)
    if 0 < #enemies then
      local maxvalue, los_values = CheckLOS(enemies, step_pos, distance, stance, cone_angle, target_angle, false)
      for i, los in ipairs(los_values) do
        if los then
          if enemies[i]:HasStatusEffect("Hidden") then
            CombatLog("short", T({
              353305209140,
              "<LogName> was revealed by enemy overwatch",
              enemies[i]
            }))
            enemies[i]:RemoveStatusEffect("Hidden")
          end
          if HasPerk(self, "Spotter") then
            enemies[i]:AddStatusEffect("Marked")
          end
        end
      end
    end
    if action_id ~= "MGSetup" and action_id ~= "MGRotate" then
      self.ActionPoints = 0
      Msg("UnitAPChanged", self, action_id)
    elseif action_id ~= "SniperSetup" and action_id ~= "SnperRotate" then
        self.ActionPoints = 0
        Msg("UnitAPChanged", self, action_id)
    end
    Msg("OverwatchChanged", self)
    args.activated = true
    if wasInterruptable then
      self:BeginInterruptableMovement()
    end
    self:SetCommand("PreparedAttackIdle")
  end