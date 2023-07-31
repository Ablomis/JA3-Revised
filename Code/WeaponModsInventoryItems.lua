DefineClass.WeaponMod = {
    __parents = {
      "InventoryItem","ItemWithCondition"
    },
    properties = {
      {
        id = "Slot",
        template = true,
        default = 'Scope',
        editor = "combo",
        items = function(self)
            return {
              "Muzzle",
              "Barrel",
              "Stock",
              "Side",
              "Under",
              "Scope"
            }
          end
      }
    }
}



