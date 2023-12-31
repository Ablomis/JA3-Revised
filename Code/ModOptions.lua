function OnMsg.ApplyModOptions()
        RevisedConfigValues.CriticalDamage = CurrentModOptions['RevisedCriticalDamage']
        RevisedConfigValues.AimCritBonus = CurrentModOptions['RevisedAimCritBonus']
        RevisedConfigValues.AimCritScale = CurrentModOptions['RevisedAimCritScale']
        RevisedConfigValues.RevisedMaxCritDistance = CurrentModOptions['RevisedMaxCritDistance']
        RevisedConfigValues.ExposedCoverCTHPenalty = CurrentModOptions['RevisedExposedCoverPenalty']
        RevisedConfigValues.CoverCTHPenalty = CurrentModOptions['RevisedCoverPenalty']
        RevisedConfigValues.CrouchedCTHPenalty = CurrentModOptions['RevisedCrouchedPenalty']
        RevisedConfigValues.ProneCTHPenalty = CurrentModOptions['RevisedPronePenalty']
        RevisedConfigValues.MoveModifier = CurrentModOptions['RevisedMoveMod']
        RevisedConfigValues.APPenaltyOnHit = CurrentModOptions['RevisedAPPenaltyOnHit']
        RevisedConfigValues.UnconsciousMult = CurrentModOptions['RevisedUnconsciousMult']
        RevisedConfigValues.MagBaseReloadAP = CurrentModOptions['RevisedMagBaseReloadAP'] * 1000
        RevisedConfigValues.PointBlankBonus = CurrentModOptions['RevisedPointBlankBonus']
        RevisedConfigValues.MoveCTHPenaltyBase = CurrentModOptions['RevisedMoveCTHPenaltyBase']
        RevisedConfigValues.MoveCTHPenaltyTile = CurrentModOptions['RevisedMoveCTHPenaltyTile']
        --RevisedConfigValues.ReadyAP = CurrentModOptions['RevisedReadyAP']
end

