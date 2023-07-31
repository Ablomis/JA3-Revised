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
      },
      {
        id = "Mount",
        template = true,
        default = 'Rail',
        editor = "combo",
        items = function(self)
            return {
              "AK",
              "Rail"
            }
          end
      }
    }
}

DefineClass.Mag = {
    __parents = {
      "InventoryItem","ItemWithCondition"
    },
    properties = {
      {
        id = "Type",
        template = true,
        default = 'AR15',
        editor = "combo",
        items = function(self)
            return {
              "MP5",
              "AR15"
            }
          end
      },
      {
        id = "Capacity",
        template = true,
        default = 30,
        editor = "number"
      },
      {
        id = "Amount",
        template = true,
        default = 30,
        editor = "number"
      }
    }
}




