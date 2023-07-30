function Combat:ShouldEndCombat(killed_units)
    killed_units = killed_units or empty_table
    local player_team
    for _, team in ipairs(g_Teams) do
      if team.side == "player1" or team.side == "player2" then
        local alive
        for _, unit in ipairs(team.units) do
          if not unit:IsDead() and not table.find(killed_units, unit) then
            alive = true
            break
          end
        end
        if alive then
          player_team = team
          break
        end
      end
    end
    if not player_team then
      return true
    end
    for _, team in ipairs(g_Teams) do
      if team:IsEnemySide(player_team) then
        for _, unit in ipairs(team.units) do
          if not unit:IsDead() and not table.find(killed_units, unit) then
            return false
          end
        end
      end
    end
    return true
  end