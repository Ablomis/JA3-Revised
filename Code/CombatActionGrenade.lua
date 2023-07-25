function Grenade:GetAttackResults(action, attack_args)
local attacker = attack_args.obj
local explosion_pos = attack_args.explosion_pos
local trajectory = {}
local mishap
if not explosion_pos and attack_args.lof then
    local lof_idx = table.find(attack_args.lof, "target_spot_group", attack_args.target_spot_group)
    local lof_data = attack_args.lof[lof_idx or 1]
    local attack_pos = lof_data.attack_pos
    local target_pos = lof_data.target_pos
    if not attack_args.prediction and IsKindOf(self, "MishapProperties") then
    local chance = 101
    if CheatEnabled("AlwaysMiss") or chance > attacker:Random(100) then
        mishap = true
        local validPositionTries = 0
        local maxPositionTries = 5
        while validPositionTries < maxPositionTries do
        local dv = self:GetMishapDeviationVector(attacker)
        local deviatePosition = target_pos + dv
        local trajectory = self:CalcTrajectory(attack_args, deviatePosition)
        local finalPos = 0 < #trajectory and trajectory[#trajectory].pos
        if finalPos and self:ValidatePos(finalPos, attack_args) then
            attack_pos = trajectory[1].pos
            target_pos = deviatePosition
            break
        end
        validPositionTries = validPositionTries + 1
        end
    end
    end

    trajectory = self:GetTrajectory(attack_args, attack_pos, target_pos)
    if 0 < #trajectory then
    explosion_pos = trajectory[#trajectory].pos
    end
    explosion_pos = self:ValidatePos(explosion_pos, attack_args)
end
local results
if explosion_pos then
    local aoe_params = self:GetAreaAttackParams(action.id, attacker, explosion_pos, attack_args.step_pos)
    if attack_args.stealth_attack then
    aoe_params.stealth_attack_roll = not attack_args.prediction and attacker:Random(100) or 100
    end
    aoe_params.prediction = attack_args.prediction
    if aoe_params.aoe_type ~= "none" or IsKindOf(self, "Flare") then
    aoe_params.damage_mod = "no damage"
    end
    results = GetAreaAttackResults(aoe_params)
    local radius = aoe_params.max_range * const.SlabSizeX
    local explosion_voxel_pos = SnapToVoxel(explosion_pos) + point(0, 0, const.SlabSizeZ / 2)
    local impact_force = self:GetImpactForce()
    local unit_damage = {}
    for _, hit in ipairs(results) do
    local obj = hit.obj
    if obj and hit.damage ~= 0 then
        local dist = hit.obj:GetDist(explosion_voxel_pos)
        if IsKindOf(obj, "Unit") and not obj:IsDead() then
        unit_damage[obj] = (unit_damage[obj] or 0) + hit.damage
        if unit_damage[obj] >= obj:GetTotalHitPoints() then
            results.killed_units = results.killed_units or {}
            table.insert_unique(results.killed_units, obj)
        end
        end
        hit.impact_force = impact_force + self:GetDistanceImpactForce(dist)
        hit.explosion = true
    end
    end
else
    results = {}
end
results.trajectory = trajectory
results.explosion_pos = explosion_pos
results.weapon = self
results.mishap = mishap
results.no_damage = IsKindOf(self, "Flare")
return results
end

function MishapProperties:GetMishapDeviationVector(unit)
    local dex = unit.Dexterity
    local deviation = unit:RandRange(0, const.SlabSizeX * (2+(100-dex)/10))
    print(deviation)
    return Rotate(point(deviation, 0, 0), unit:Random(21600))
end