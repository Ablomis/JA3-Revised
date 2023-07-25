function Grenade:GetMaxAimRange(unit)
    local str = IsKindOf(unit, "Unit") and unit.Strength or 100
    local range = MulDivRound(self.BaseRange, Max(0, 100 - str), 100) + MulDivRound(self.ThrowMaxRange, Min(100, str), 100)
    return Max(1, range)
end

  function Grenade:GetAreaAttackParams(action_id, attacker, target_pos, step_pos)
    target_pos = target_pos or self:GetPos()
    local aoeType = self.aoeType
    local max_range = self.AreaOfEffect
    if aoeType == "fire" then
      max_range = 2
    end
    local params = {
      attacker = false,
      weapon = self,
      target_pos = target_pos,
      step_pos = target_pos,
      stance = "Prone",
      min_range = self.AreaOfEffect,
      max_range = max_range,
      center_range = self.CenterAreaOfEffect,
      damage_mod = 100,
      attribute_bonus = 0,
      can_be_damaged_by_attack = true,
      aoe_type = aoeType,
      explosion = true,
      explosion_fly = self.DeathType == "BlowUp"
    }
    if self.coneShaped then
      params.cone_length = self.AreaOfEffect * const.SlabSizeX
      params.cone_angle = self.coneAngle * 60
      
      params.target_pos = RotateRadius(params.cone_length, CalcOrientation(step_pos or attacker, target_pos), target_pos)
      if not params.target_pos:IsValidZ() or params.target_pos:z() - terrain.GetHeight(params.target_pos) <= 10 * guic then
        params.target_pos = params.target_pos:SetTerrainZ(10 * guic)
      end
    end

    if IsKindOf(attacker, "Unit") then
      params.attacker = attacker
      params.attribute_bonus = GetGrenadeDamageBonus(attacker)
    end
    return params
  end

  function Grenade:CalcTrajectory(attack_args, target_pos, angle, max_bounces)
    local attacker = attack_args.obj
    local anim_phase = attacker:GetAnimMoment(attack_args.anim, "hit") or 0
    local attack_offset = attacker:GetRelativeAttachSpotLoc(attack_args.anim, anim_phase, attacker, attacker:GetSpotBeginIndex("Weaponr"))
    local step_pos = attack_args.step_pos

    print('Pos: ',target_pos)
    local PI = 3.14159265359
    local error_r = MulDivRound(attacker:Random(5000), 100-attacker.Dexterity, 100) * sqrt(attacker:Random(1000000))*0.001
    print('ErrorR:',error_r)
    local theta = attacker:Random(10000)*0.0001 * 2.0 * PI
    print('Theta:',theta)

    local error_x = target_pos:x() + error_r * cos(theta)/4096
    print('ErrorX:',error_x)
    local error_y = target_pos:y() + error_r * sin(theta)/4096
    print('ErrorY:',error_y)

    target_pos=target_pos:SetX(error_x)
    target_pos=target_pos:SetY(error_y)

    print('Adjusted pos: ',target_pos)

    if not step_pos:IsValidZ() then
      step_pos = step_pos:SetTerrainZ()
    end
    local pos0 = step_pos:SetZ(step_pos:z() + attack_offset:z())
    if not angle then
      if target_pos:z() - pos0:z() > const.SlabSizeZ / 2 then
        angle = const.Combat.GrenadeLaunchAngle_Incline
      else
        angle = const.Combat.GrenadeLaunchAngle
      end
    end
    local sina, cosa = sincos(angle)
    local aim_pos = pos0 + Rotate(point(cosa, 0, sina), CalcOrientation(pos0, target_pos))
    local grenade_pos = GetAttackPos(attack_args.obj, step_pos, axis_z, attack_args.angle, aim_pos, attack_args.anim, anim_phase, attack_args.weapon_visual)
    if grenade_pos:Equal2D(target_pos) then
      return empty_table
    end
    local dir = target_pos - grenade_pos
    local bounce_diminish = 40
    local vec
    local can_bounce = self.CanBounce
    if attack_args.can_bounce ~= nil then
      can_bounce = attack_args.can_bounce
    end
    max_bounces = can_bounce and max_bounces or 0
    if can_bounce then
      max_bounces = 1
    end
    if 0 < max_bounces then
      local coeff = 1000
      local d = 10 * bounce_diminish
      for i = 1, max_bounces do
        coeff = coeff + d
        d = MulDivRound(d, bounce_diminish, 100)
      end
      local bounce_target_pos = grenade_pos + MulDivRound(dir, 1000, coeff)
      vec = CalcLaunchVector(grenade_pos, bounce_target_pos, angle, const.Combat.Gravity)
    else
      vec = CalcLaunchVector(grenade_pos, target_pos, angle, const.Combat.Gravity)
    end
    local time = MulDivRound(grenade_pos:Dist2D(target_pos), 1000, Max(vec:Len2D(), 1))
    if time == 0 then
      return empty_table
    end
    local trajectory = CalcBounceParabolaTrajectory(grenade_pos, vec, const.Combat.Gravity, time, 20, max_bounces, bounce_diminish)
    return trajectory
  end