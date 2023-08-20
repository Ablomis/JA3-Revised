UndefineClass("AIActionSingleTargetShot")
DefineClass.AIActionSingleTargetShot = {
    __parents = {
      "AISignatureAction"
    },
    properties = {
      {
        id = "action_id",
        editor = "dropdownlist",
        items = {
          "SingleShot",
          "BurstFire",
          "AutoFire",
          "Buckshot",
          "DoubleBarrel",
          "KnifeThrow"
        },
        default = "SingleShot"
      },
      {
        id = "Aiming",
        editor = "choice",
        default = "None",
        items = function(self)
          return {
            "None",
            "Remaining AP",
            "Maximum"
          }
        end
      },
      {
        id = "AttackTargeting",
        help = "if any parts are set the unit will pick one of them randomly for each of its basic attacks; otherwise it will always use the default (torso) attacks",
        editor = "set",
        default = false,
        items = function(self)
          return table.keys2(Presets.TargetBodyPart.Default)
        end
      }
    },
    default_notification_texts = {
      AutoFire = T(730263043731, "Full Auto"),
      DoubleBarrel = T(937676786920, "Double Barrel Shot")
    }
  }