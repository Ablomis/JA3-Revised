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
              "Rail",
              "Muzzle"
            }
          end
      },
      {
        id = "Name",
        template = true,
        editor = "text",
        category = "General",
      }
    }
}

DefineClass.Mag = {
    __parents = {
      "InventoryItem"
    },
    properties = {
      {
        id = "Platform",
        category = "Caliber",
        template = true,
        default = 'AR15',
        editor = "combo",
        items = function(self)
            return {
              "MP5",
              "AR15",
              "FAMAS",
              'AK762',
              'AK545',
              "AUG",
              "M14",
              "GALIL",
              "FNFAL",
              "UZI",
              "MP40",
              "SVD",
              "HK21",
              "SAW",
              'HiPower',
              "Beretta",
              "Glock",
              "DesertEagle"
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
          return {
            "44CAL",
            "545x39",
            "762x54R",
            "9mm",
            "50BMG",
            "556",
            "762WP",
            "762NATO",
            "12gauge"
          }
        end
      },
      ammo = false,
      MaxStacks=2
    },
}




