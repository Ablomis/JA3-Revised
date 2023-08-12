function UnitProperties:GetMaxActionPoints()
    local level = self:GetLevel()
    return (7 + self:GetProperty("Agility") / 10 + level / 3) * const.Scale.AP
end 