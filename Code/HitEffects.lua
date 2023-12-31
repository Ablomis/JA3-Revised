function OnMsg.DamageTaken(attacker, target, dmg, hit_descr)
    ap_penalty = RevisedConfigValues.APPenaltyOnHit
    if target:GetStatusEffect("SpentAP") then
        ap_penalty = target:GetEffectValue("spent_ap") +1
    else target:AddStatusEffect("SpentAP") 
    end
    target:SetEffectValue("spent_ap", ap_penalty)

    local roll = target:Random(100)
    print(roll)
    print(dmg)
    local threshold = MulDivRound(dmg,RevisedConfigValues.UnconsciousMult,100)
    print(threshold)
    if(roll<threshold) then
        print('KO')
        target:AddStatusEffect('Unconscious')
        target:SetEffectValue('unconscious_recovery_turn', (g_Combat and g_Combat.current_turn or 1) + const.Combat.UnconsciousDelay)
    end
end