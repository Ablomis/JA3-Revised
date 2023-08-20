
function OnMsg.TurnStart(unit)
    for _, unit in ipairs(g_Units) do
        if(IsPlayerEnemy(unit)) then
           unit.Health = Min(55 + unit:GetLevel()*5,100)
           unit.MaxAttacks=10
           unit.Dexterity = Min(60 + unit:GetLevel()*5,100)
       end
    end
end