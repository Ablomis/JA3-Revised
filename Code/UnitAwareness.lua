function PushUnitAlert(trigger_type, ...)
    if CheatEnabled("DisableDiscoveryAlert") and trigger_type == "discovered" then
      return
    end
    local netUpdateParams = {
      ...
    }
    local cls = netUpdateParams[1] and netUpdateParams[1].class or ""
    local number = netUpdateParams[2] or 0
    NetUpdateHash("PushUnitAlert", trigger_type, cls, number)
    local alerted = {}
    local suspicious = 0
    local surprised = 0
    local pov_team = GetPoVTeam()
    local enemies = pov_team and pov_team.units and GetAllEnemyUnits(pov_team.units[1] or false)
    local enemies_alive
    for _, unit in ipairs(enemies) do
      if IsValidTarget(unit) then
        enemies_alive = true
        break
      end
    end
    if not enemies_alive then
      return 0, 0
    end
    if trigger_type == "attack" then
      local attacker = select(1, ...)
      local alerted_obj = select(2, ...)
      local from_stealth = select(3, ...)
      local hit_objs = select(4, ...)
      local aware_state = (from_stealth or HasPerk(attacker, "FoxPerk")) and "surprised" or "aware"
      dbg_awareness_log(attacker, " alerts: attack")
      local units = IsValid(alerted_obj) and {alerted_obj} or alerted_obj
      for _, unit in ipairs(units) do
        local state = unit:HasStatusEffect("Surprised") and "aware" or aware_state
        local is_aware = unit:IsAware() or unit.pending_aware_state == "aware"
        local reason
        if not (state ~= "surprised" or is_aware) or hit_objs and not table.find(hit_objs, unit) then
          reason = "arSurprised"
        else
          reason = "arAttack"
        end
        reason = "arSurprised"
        reason = T({
          Presets.AwareReasons.Default[reason].display_name,
          enemy = unit.Name,
          merc = attacker.Nick or attacker.Name
        })
        if unit:SetPendingAwareState(state, reason, attacker) then
          if state ~= "aware" then
            surprised = surprised + 1
          else
            alerted[#alerted + 1] = unit
          end
          dbg_awareness_log("  ", unit, " alerted")
        end
        if unit.pending_aware_state == "aware" and g_CurrentAttackActions[1] and g_CurrentAttackActions[1].attack_args and g_CurrentAttackActions[1].attack_args.target == unit then
          unit.pending_awareness_role = state == "surprised" and "surprised" or "attacked"
        end
      end
    elseif trigger_type == "death" then
      local actor = select(1, ...)
      dbg_awareness_log(actor, " alerts: dead")
      local units = table.ifilter(g_Units, function(_, u)
        return not u.dummy and u.team.side ~= "neutral" and not u:IsIncapacitated() and not u:IsAware()
      end)
      local los_any, los_targets = CheckLOS(units, actor)
      for i, unit in ipairs(units) do
        local sight = unit:GetSightRadius(actor)
        if los_targets[i] and sight >= unit:GetDist(actor) and unit:SetPendingAwareState("surprised", T({
          Presets.AwareReasons.Default.arSawDying.display_name,
          enemy = unit.Name
        })) then
          dbg_awareness_log("  ", unit, " is surprised")
          surprised = surprised + 1
        end
      end
    elseif trigger_type == "dead body" then
      local actor = select(1, ...)
      local units = select(2, ...)
      local los_any, los_targets = CheckLOS(units, actor)
      for i, unit in ipairs(units) do
        if not unit.seen_bodies[actor] then
          local sight = unit:GetSightRadius(actor)
          local aware_state = g_Combat and "surprised" or "suspicious"
          if los_targets[i] and sight >= unit:GetDist(actor) and unit:SetPendingAwareState(aware_state) then
            unit.suspicious_body_seen = actor:GetHandle()
            unit.seen_bodies[actor] = true
            dbg_awareness_log("  ", unit, " is suspicious")
            suspicious = suspicious + 1
          end
        end
      end
    elseif trigger_type == "noise" then
      local actor = select(1, ...)
      local radius = select(2, ...)
      local soundName = select(3, ...)
      if GameState.RainLight or GameState.RainHeavy then
        radius = MulDivRound(radius, Max(0, 100 + const.EnvEffects.RainNoiseMod), 100)
      end
      dbg_awareness_log(actor, " alerts: noise ", radius)
      g_NoiseSources[#g_NoiseSources + 1] = {
        actor = actor,
        pos = actor and actor:GetPos(),
        noise = radius
      }
      radius = radius * const.SlabSizeX
      local alerter = IsKindOf(actor, "Unit") and actor or nil
      local state = alerter and HasPerk(alerter, "FoxPerk") and "surprised" or "aware"
      for _, unit in ipairs(g_Units) do
        local dist = unit:GetDist(actor)
        local r = MulDivRound(radius, unit:HasStatusEffect("Distracted") and 66 or 100, 100)
        local aware = unit:IsAware("pending")
        local isPlayerAllyNotInCombat = not g_Combat and unit.team.side ~= "enemy1" and unit.team.side ~= "enemy2"
        if not isPlayerAllyNotInCombat and unit ~= actor and dist <= r and unit:SetPendingAwareState(state, T({
          Presets.AwareReasons.Default.arNoise.display_name,
          enemy = unit.Name,
          noise = soundName
        }), alerter) then
          if actor then
            unit.last_known_enemy_pos = actor:GetPos()
          end
          if state == "aware" then
            alerted[#alerted + 1] = unit
          else
            surprised = surprised + 1
          end
          dbg_awareness_log("  ", unit, " alerted")
        end
      end
    elseif trigger_type == "projector" then
      local actor = select(1, ...)
      local units = select(2, ...)
      local projector = select(3, ...)
      for i, unit in ipairs(units) do
        if IsCloser(unit, projector, ProjectorSuspiciousApplyRange) and unit:SetPendingAwareState("aware", T({
          Presets.AwareReasons.Default.arProjector.display_name,
          enemy = unit.Name
        }), actor) then
          surprised = surprised + 1
        end
      end
    elseif trigger_type == "sight" then
      local actor = select(1, ...)
      local seen = select(2, ...)
      local aware = actor:IsAware() or actor.pending_aware_state == "aware"
      local surprised = actor:HasStatusEffect("Surprised") or actor.pending_aware_state == "surprised"
      if actor:IsOnEnemySide(seen) and not aware and not surprised and actor:SetPendingAwareState("surprised") then
        suspicious = suspicious + 1
        dbg_awareness_log(actor, " is alerted (sight)")
      end
    elseif trigger_type == "thrown" then
      local obj = select(1, ...)
      local attacker = select(2, ...)
      local units = table.ifilter(g_Units, function(idx, unit)
        return not unit:IsAware("pending") and (not attacker or unit:IsOnEnemySide(attacker))
      end)
      local los_any, los_targets = CheckLOS(units, obj)
      for i, unit in ipairs(units) do
        local sight = unit:GetSightRadius(obj)
        if los_targets and los_targets[i] and sight >= unit:GetDist(obj) and unit:SetPendingAwareState("surprised", T({
          Presets.AwareReasons.Default.arThrownObject.display_name,
          enemy = unit.Name
        })) then
          dbg_awareness_log("  ", unit, " is surprised")
          surprised = surprised + 1
        end
      end
    elseif trigger_type == "script" then
      local units = select(1, ...)
      local state = select(2, ...)
      units = table.ifilter(units, function(idx, unit)
        return unit.team and not unit.team.neutral
      end)
      for _, unit in ipairs(units) do
        unit.pending_aware_state = state
        dbg_awareness_log(unit, " is alerted (script): ", state)
      end
      if state == "aware" then
        alerted = units
      end
    elseif trigger_type == "surprise" then
      local unit = select(1, ...)
      local from_suspicious = select(2, ...)
      local reason
      if from_suspicious then
        reason = T({
          Presets.AwareReasons.Default.arDeadBody.display_name,
          enemy = unit.Name
        })
      end
      if unit:SetPendingAwareState("aware", reason) then
        dbg_awareness_log(unit, " is alerted (surprise)")
        alerted[#alerted + 1] = unit
      end
    else
      if trigger_type == "discovered" then
        local unit = select(1, ...)
        local enemyUnits = GetAllEnemyUnits(unit)
        local alertedPeople = 0
        for i, enemyUnit in ipairs(enemyUnits) do
          if not enemyUnit:IsAware() and HasVisibilityTo(enemyUnit, unit) then
            alertedPeople = alertedPeople + 1
            CombatStarDetectedtVR(unit)
            if enemyUnit.pending_aware_state ~= "aware" and not enemyUnit:HasStatusEffect("Surprised") and enemyUnit:SetPendingAwareState("aware", T({
              Presets.AwareReasons.Default.arNotice.display_name,
              enemy = enemyUnit.Name,
              merc = unit.Nick or unit.Name
            }), unit) then
              alerted[#alerted + 1] = enemyUnit
              dbg_awareness_log(enemyUnit, " is alerted (combat-walk)")
            end
          end
        end
        if 0 < alertedPeople then
          unit:RemoveStatusEffect("Hidden")
        end
      else
      end
    end
    alerted = table.ifilter(alerted, function(idx, unit)
      return not unit.dummy and unit.pending_aware_state == "aware"
    end)
    if 0 < #alerted then
      local roles = {}
      PropagateAwareness(alerted, roles)
      for _, unit in ipairs(alerted) do
        if unit.pending_aware_state ~= "aware" and unit:SetPendingAwareState("aware") or roles[unit] == "alerter" then
          unit.pending_awareness_role = roles[unit] or "alerted"
        end
      end
    end
    if 0 < #alerted + surprised then
      local pendingType = 0 < #alerted and "alert" or "sus"
      if not g_UnitAwarenessPending or pendingType == "alert" then
        g_UnitAwarenessPending = pendingType
      end
    end
    return #alerted + surprised, suspicious
  end
  function TriggerUnitAlert(trigger_type, ...)
    local alerted, suspicious = PushUnitAlert(trigger_type, ...)
    AlertPendingUnits()
    return alerted, suspicious
  end