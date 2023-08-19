function OnMsg.DamageTaken(self, attacker, target, dmg, hit_descr)
    ap_penalty = RevisedConfigValues.APPenaltyOnHit
    if target:GetStatusEffect("SpentAP") then
        ap_penalty = target:GetEffectValue("spent_ap") +1
    else target:AddStatusEffect("SpentAP") 
    end
    target:SetEffectValue("spent_ap", ap_penalty)

    local roll = target:Random(100)
    local threshold = MulDivRound(target.HitPoints,RevisedConfigValues.UnconsciousMult,100)
    if(roll>threshold) then
        target:AddStatusEffect('Unconscious')
        target:SetEffectValue('unconscious_recovery_turn', (g_Combat and g_Combat.current_turn or 1) + const.Combat.UnconsciousDelay)
    end
end