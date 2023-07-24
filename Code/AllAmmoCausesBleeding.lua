function BleedingUnarmored(unit)
    if not unit:HasStatusEffect("Armored") then
      unit:AddStatusEffect("Bleeding")
    end
    end