UndefineClass("_762NATO_Basic")
DefineClass._762NATO_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_basic",
  DisplayName = T(322933215553, "7.62 mm NATO Standard"),
  DisplayNamePlural = T(583057204862, "7.62 mm NATO Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T(959777870729, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  MaxStacks = 500,
  Caliber = "762NATO",
  Damage = 27,
  Mass=10.0,
  BaseVelocity=850,
  CritChance = 55,
  PenetrationClass = 4,
  Modifications = {PlaceObj("CaliberModification", {mod_add = 2, target_prop = "PenetrationClass"})}
}
,

UndefineClass("_762NATO_AP")
DefineClass._762NATO_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_armor_piercing",
  DisplayName = T(451239732490, "7.62 mm NATO Armor Piercing"),
  DisplayNamePlural = T(987128655410, "7.62 mm NATO Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(241536180521, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(850324784601, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "762NATO",
  Damage = 24,
  Mass=10.0,
  BaseVelocity=850,
  CritChance = 55,
  PenetrationClass = 4,
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 5,
      target_prop = "PenetrationClass"
    })
  }
}
,
UndefineClass("_762NATO_HP")
DefineClass._762NATO_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_hollow_point",
  DisplayName = T(669691454944, "7.62 mm NATO Hollow Point"),
  DisplayNamePlural = T(155427073305, "7.62 mm NATO Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(597109486171, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(447573359889, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "762NATO",
  Damage = 27,
  Mass=10.0,
  BaseVelocity=850,
  CritChance = 55,
  PenetrationClass = 4,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {mod_add = -2, target_prop = "PenetrationClass"})
  }
}
,
UndefineClass("_762NATO_Match")
DefineClass._762NATO_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_match",
  DisplayName = T(519353641191, "7.62 mm NATO Match"),
  DisplayNamePlural = T(900333933922, "7.62 mm NATO Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(411071812202, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "762NATO",
  Damage = 27,
  Mass=10.0,
  BaseVelocity=850,
  CritChance = 55,
  PenetrationClass = 4,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 2, target_prop = "AimAccuracy"}),
    PlaceObj("CaliberModification", {mod_add = 2, target_prop = "PenetrationClass"})
  }
}
,
UndefineClass("_762NATO_Tracer")
DefineClass._762NATO_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_nato_bullets_tracer",
  DisplayName = T(236045674209, "7.62 mm NATO Tracer"),
  DisplayNamePlural = T(365178345438, "7.62 mm NATO Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T(223701622960, "7.62 NATO ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(527792163999, "<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover"),
  MaxStacks = 500,
  Caliber = "762NATO",
  Damage = 27,
  Mass=10.0,
  BaseVelocity=850,
  CritChance = 55,
  PenetrationClass = 4,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 2, target_prop = "PenetrationClass"}),
    PlaceObj("CaliberModification", {mod_add = 1, target_prop = "AimAccuracy"})
  },
  AppliedEffects = {"Exposed"}
}
