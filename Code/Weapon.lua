--function FirearmBase:GetAccuracy(distance, unit, action)
--    local base_accuracy = self.AimAccuracy
--    local k
--    k = (100 - base_accuracy)/(0.0001*self.WeaponRange^3)
--    local accuracy = round(100 - 0.0001 * k * ((distance/1000)^3),1)
--  return accuracy
--end
function FindWeaponUpgradeTarget(item, mod)
    if not IsKindOfClasses(mod, "WeaponMod") or not IsKindOf(item, "Firearm") then
      return false
    end
    return item
end
function IsWeaponAvailableForUpgrade(weapon, modForWeapon)
    for _, slot in ipairs(weapon.ComponentSlots) do
        if(slot.SlotType == modForWeapon.Slot) then
            return true
        end
    end
    return false
end
function IsWeaponUpgradeTarget(drag_item, target_item)
    local target = FindWeaponUpgradeTarget(target_item, drag_item)
    return target and IsWeaponAvailableForUpgrade(target, drag_item)
end

function GetAvailableComponents(unit, slot, weapon)
    local mod_list
    unit:ForEachItemInSlot("Inventory", function(item, slot, l, t, mod_list)
        if item:IsKindOf("WeaponMod") then
          unit:RemoveItem("Inventory", item)
          table.insert_unique(mod_list, item)
        end
      end,mod_list)
end