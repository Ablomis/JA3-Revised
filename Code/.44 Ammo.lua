UndefineClass("_44CAL_HP")
DefineClass._44CAL_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_hollow_point",
  DisplayName = T(977456132570, ".44 Hollow Point"),
  DisplayNamePlural = T(731855162750, ".44 Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(835810395897, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(201599652663, [[
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "44CAL",
  Damage = 18,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"})
  },
  AppliedEffects = {"Bleeding"}
}

UndefineClass("_44CAL_Basic")
DefineClass._44CAL_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_basic",
  DisplayName = T(265523538284, ".44 Standard"),
  DisplayNamePlural = T(385077418533, ".44 Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T(595708803192, ".44 Ammo for Revolvers and Rifles."),
  MaxStacks = 500,
  Caliber = "44CAL",
  Damage = 18,
  AppliedEffects = {"Bleeding"}
}

UndefineClass("_44CAL_HP")
DefineClass._44CAL_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_hollow_point",
  DisplayName = T(977456132570, ".44 Hollow Point"),
  DisplayNamePlural = T(731855162750, ".44 Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(835810395897, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(201599652663, [[
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "44CAL",
  Damage = 18,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"})
  },
  AppliedEffects = {"Bleeding"}
}

UndefineClass("_44CAL_Match")
DefineClass._44CAL_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_match",
  DisplayName = T(249943286285, ".44 Match"),
  DisplayNamePlural = T(987921160651, ".44 Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(888766429002, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "44CAL",
  Damage = 18,
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    })
  },
  AppliedEffects = {"Bleeding"}
}

UndefineClass("_44CAL_Shock")
DefineClass._44CAL_Shock = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/44_cal_bullets_shock",
  DisplayName = T(183749046877, ".44 Shock"),
  DisplayNamePlural = T(299199326767, ".44 Shock"),
  colorStyle = "AmmoHPColor",
  Description = T(661797428567, ".44 Ammo for Revolvers and Rifles."),
  AdditionalHint = T(628229272101, [[
<bullet_point> Reduced range
<bullet_point> High Crit chance
<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "44CAL",
  Damage = 18,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "WeaponRange"
    })
  },
  AppliedEffects = {"Exposed", "Bleeding"}
}