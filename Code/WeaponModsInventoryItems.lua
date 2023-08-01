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
      "InventoryItem"
    },
    properties = {
      {
        id = "Type",
        category = "Caliber",
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
        category = "Caliber",
        id = "MagazineSize",
        name = "Magazine Size",
        help = "Number of bullets in a single clip",
        editor = "number",
        default = 30,
        template = true,
        min = 1,
        max = 500,
        modifiable = true
      },
      {
        id = "Amount",
        category = "Caliber",
        template = true,
        default = 0,
        editor = "number"
      },
      {
        category = "Caliber",
        id = "Caliber",
        editor = "combo",
        default = false,
        template = true,
        items = function(self)
          return PresetGroupCombo("Caliber", "Default")
        end
      },
    }
}




