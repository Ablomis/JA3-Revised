UndefineClass(ArmorProperties)
DefineClass.ArmorProperties = {
    __parents = {
      "ItemWithCondition"
    },
    __generated_by_class = "ClassDef",
    properties = {
      {
        id = "Slot",
        editor = "combo",
        default = "Torso",
        template = true,
        items = function(self)
          return {
            "Head",
            "Torso",
            "Legs"
          }
        end
      },
      {
        category = "Combat",
        id = "PenetrationClass",
        editor = "number",
        default = 1,
        template = true,
        name = function(self)
          return "Penetration Class: " .. (PenetrationClassIds[self.PenetrationClass] or "")
        end,
        slider = true,
        min = 1,
        max = 5,
        modifiable = true
      },
      {
        category = "Combat",
        id = "DamageReduction",
        name = "Damage Reduction (Base)",
        help = "How much damage the armor absorbs when the attack lands in an area covered by the armor.",
        editor = "number",
        default = 10,
        template = true,
        scale = "%",
        slider = true,
        min = 0,
        max = 100
      },
      {
        category = "Combat",
        id = "AdditionalReduction",
        name = "Damage Reduction (Additional)",
        help = "Additional damage reduction applied when the effective Penetration Class of the attack is lower than the Penetration Class of the armor protecting the hit body part.",
        editor = "number",
        default = 10,
        template = true,
        scale = "%",
        slider = true,
        min = 0,
        max = 100
      },
      {
        category = "Combat",
        id = "ProtectedBodyParts",
        name = "Protected Body Parts",
        editor = "set",
        default = false,
        template = true,
        items = function(self)
          return PresetGroupCombo("TargetBodyPart", "Default")
        end
      },
      {
        category = "Combat",
        id = "Camouflage",
        editor = "bool",
        default = false,
        template = true
      },
      {
        category = "Combat",
        id = "Coverage",
        name = "Coverage",
        help = "What % of the body part it covers.",
        editor = "number",
        default = 50,
        template = true,
        scale = "%",
        slider = true,
        min = 0,
        max = 100
      }
    }
  }