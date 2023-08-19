
function OnMsg.ZuluGameLoaded(game)
    for _, unit in ipairs(g_Units) do
        if(IsPlayerEnemy(unit)) then
           unit.Health = Min(55 + unit:GetLevel()*5,100)
           unit.MaxAttacks=10
           unit.Dexterity = Min(50 + unit:GetLevel()*5,100)
       end
    end
end

function OnMsg.EnterSector()
    for _, unit in ipairs(g_Units) do
        if(IsPlayerEnemy(unit)) then
           unit.Health = Min(55 + unit:GetLevel()*5,100)
           unit.MaxHitPoints=unit.Health
           unit.HitPoints=unit.Health
           unit.MaxAttacks=10
           unit.Dexterity = Min(50 + unit:GetLevel()*5,100)
       end
    end
end