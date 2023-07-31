  function Unit:SniperTarget(action_id, cost_ap, args)
    args.permanent = true
    --args.num_attacks = self:GetNumMGInterruptAttacks()
    args.num_attacks=1
    self.interruptable = false
    return self:OverwatchAction(action_id, cost_ap, args, 1.5)
end

function Unit:SniperSetup(action_id, cost_ap, args)
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

  function Unit:ExplorationStartCombatAction(action_id, ap, args)
    local action = CombatActions[action_id]
    if g_Combat or not action then
      return
    end
    self.ActionPoints = self:GetMaxActionPoints()
  end
  