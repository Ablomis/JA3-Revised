function UnloadWeapon(item, squadBag)
    local ammo = item.ammo
    item.ammo = false
    if IsKindOf(item, "Mag") then
        ammo.Amount =  item.Amount
        item.Amount = 0
      end
    if ammo and ammo.Amount > 0 then
      squadBag:AddAndStackItem(ammo)
    end
    if IsKindOf(item, "Firearm") then
      item:OnUnloadWeapon()
    end
  end