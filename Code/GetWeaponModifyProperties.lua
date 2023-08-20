function GetWeaponModifyProperties(item)
    local statList = {}
    statList[#statList + 1] = {
      max = 60,
      GetDamage = function(it)
        return item:GetDamageFromAmmo()
      end,
      Getbase_Damage = function(it)
        return item:GetDamageFromAmmo()
      end,
      id = "Damage",
      display_name = "Damage",
      Name = "Damage",
      description = "Weapon damage with current ammo"
    }
    statList[#statList + 1] = {
        max = 5,
        GetPenetration = function(it)
          return item.ammo.PenetrationClass or 0
        end,
        Getbase_Penetration = function(it)
            return item.ammo.PenetrationClass or 0
        end,
        id = "Penetration",
        display_name = "Penetration",
        Name = "Penetration",
        description = "Weapon penetration based on the current ammo"
    }
    statList[#statList + 1] = {
        max = 100,
        GetCritChance = function(it)
          return item:GetCritChanceFromAmmo()
        end,
        Getbase_CritChance = function(it)
          return item:GetCritChanceFromAmmo()
        end,
        id = "CritChance",
        display_name = "Crit Chance",
        Name = "Crit Chance",
        description = "Chance of weapon damaging vital organs"
    }
    local rangePreset = Presets.WeaponPropertyDef.Default.WeaponRange
    statList[#statList + 1] = {
      max = rangePreset.max_progress,
      bind_to = rangePreset.bind_to
    }
    statList[#statList + 1] = {
        max = 20,
        GetAccuracy = function(it)
          return Max(item.BaseAccuracy - 80,0)
        end,
        Getbase_Accuracy = function(it)
            return Max(item.BaseAccuracy - 80,0)
        end,
        id = "Accuracy",
        display_name = "Accuracy",
        Name = "Accuracy",
        description = "Base accuracy of the weapon at effective range"
    }
    local baseAttack = item:GetBaseAttack(false, "force")
    local baseAction = CombatActions[baseAttack]
    local baseAttackPreset = Presets.WeaponPropertyDef.Default.ShootAP
    statList[#statList + 1] = {
        GetShootAP = function(it)
          return baseAttackPreset:GetProp(it or item) / const.Scale.AP
        end,
        Getbase_ShootAP = function(it)
          return baseAttackPreset:Getbase_Prop(it or item) / const.Scale.AP
        end,
        max = 10,
        display_name = T({
          310685041358,
          "Attack Cost (<Name>)",
          Name = baseAction.DisplayNameShort or baseAction.DisplayName
        }),
        id = "ShootAP",
        reverse_bar = true,
        description = baseAttackPreset.description
    }
    statList[#statList + 1] = {
        max = 5,
        GetReadyAP = function(it)
          return item.ReadyAP/ const.Scale.AP
        end,
        Getbase_ReadyAP = function(it)
            return item.ReadyAP/ const.Scale.AP
        end,
        id = "ReadyAP",
        display_name = "Ready AP",
        Name = "Ready AP",
        reverse_bar = true,
        description = "AP required to ready the weapon"
    }

    return statList
  end