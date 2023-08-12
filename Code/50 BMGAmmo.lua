UndefineClass("_50BMG_Basic")
DefineClass._50BMG_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/50bmg_basic",
  DisplayName = T(304613136713, ".50 Standard"),
  DisplayNamePlural = T(930163832052, ".50 Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T(340399158576, ".50 Ammo for Machine Guns, Snipers and Handguns."),
  MaxStacks = 500,
  Caliber = "50BMG",
  Mass=45,
  BaseVelocity = 908,
  CritChance = 75,
  PenetrationClass = 5,
}

UndefineClass("_50BMG_HE")
DefineClass._50BMG_HE = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/50bmg_he",
  DisplayName = T(638878429442, ".50 Explosive"),
  DisplayNamePlural = T(784235316318, ".50 Explosive"),
  colorStyle = "AmmoHPColor",
  Description = T(974086720946, ".50 Ammo for Machine Guns, Snipers and Handguns."),
  AdditionalHint = T(642232526717, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance]]),
  MaxStacks = 500,
  Caliber = "50BMG",
  Mass=45,
  BaseVelocity = 908,
  CritChance = 75,
  PenetrationClass = 5,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -4,
      target_prop = "PenetrationClass"
    })
  }
}

UndefineClass("_50BMG_Incendiary")
DefineClass._50BMG_Incendiary = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/50bmg_incendiary",
  DisplayName = T(727344246325, ".50 Frag"),
  DisplayNamePlural = T(468293090203, ".50 Frag"),
  colorStyle = "AmmoTracerColor",
  Description = T(196314399167, ".50 Ammo for Machine Guns, Snipers and Handguns."),
  AdditionalHint = T(662002010356, [[
<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
<bullet_point> Inflicts <em>Burning</em>]]),
  MaxStacks = 500,
  Caliber = "50BMG",
  Mass=45,
  BaseVelocity = 908,
  CritChance = 75,
  PenetrationClass = 5,
  Modifications = {},
  AppliedEffects = {"Exposed", "Burning"}
}

UndefineClass("_50BMG_SLAP")
DefineClass._50BMG_SLAP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/50bmg_slap",
  DisplayName = T(328537436087, ".50 SLAP"),
  DisplayNamePlural = T(152196917983, ".50 SLAP"),
  colorStyle = "AmmoAPColor",
  Description = T(189786149121, ".50 Ammo for Machine Guns, Snipers and Handguns."),
  AdditionalHint = T(424614747022, [[
<bullet_point> Improved armor penetration
<bullet_point> Slightly higher Crit chance]]),
  MaxStacks = 500,
  Caliber = "50BMG",
  Mass=45,
  BaseVelocity = 908,
  CritChance = 75,
  PenetrationClass = 5,
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 1,
      target_prop = "PenetrationClass"
    }),
    PlaceObj("CaliberModification", {mod_add = 15, target_prop = "CritChance"})
  }
}