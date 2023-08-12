UndefineClass("_556_Basic")
DefineClass._556_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_basic",
  DisplayName = T(798472357246, "5.56 mm Standard"),
  DisplayNamePlural = T(124208305458, "5.56 mm Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T(114938435533, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  MaxStacks = 500,
  Caliber = "556",
  Mass= 4.0,
  BaseVelocity = 961,
  CritChance = 55,
  PenetrationClass = 2,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 2, target_prop = "PenetrationClass"}),
  }
},

UndefineClass("_556_AP")
DefineClass._556_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_armor_piercing",
  DisplayName = T(350757861829, "5.56 mm Armor Piercing"),
  DisplayNamePlural = T(684111621521, "5.56 mm Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(259826736002, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(850324784601, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "556",
  Mass= 4.0,
  BaseVelocity = 961,
  CritChance = 55,
  PenetrationClass = 2,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 4, target_prop = "PenetrationClass"})
  }
},

UndefineClass("_556_HP")
DefineClass._556_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_hollow_point",
  DisplayName = T(359801302480, "5.56 mm Hollow Point"),
  DisplayNamePlural = T(769486263588, "5.56 mm Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(271563525530, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(333746477431, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "556",
  Mass= 4.0,
  BaseVelocity = 961,
  CritChance = 55,
  PenetrationClass = 2,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {mod_add = -1, target_prop = "PenetrationClass"})
  }
},

UndefineClass("_556_Match")
DefineClass._556_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_match",
  DisplayName = T(122498717966, "5.56 mm Match"),
  DisplayNamePlural = T(844110421786, "5.56 mm Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(526351062603, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "556",
  Mass= 4.0,
  BaseVelocity = 961,
  CritChance = 55,
  PenetrationClass = 2,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 2, target_prop = "AimAccuracy"},
    PlaceObj("CaliberModification", {mod_add = 2, target_prop = "PenetrationClass"}))
  },AppliedEffects = {"Bleeding"}
},

UndefineClass("_556_Tracer")
DefineClass._556_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_tracer",
  DisplayName = T(284056004939, "5.56 mm Tracer"),
  DisplayNamePlural = T(365899241502, "5.56 mm Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T(152355210284, "5.56 Ammo for Assault Rifles, SMGs, and Machine Guns."),
  AdditionalHint = T(
    [[
      <bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
      <bullet_point> Increased bonus from Aiming]]
    ),
  MaxStacks = 500,
  Caliber = "556",
  Mass= 4.0,
  BaseVelocity = 961,
  CritChance = 55,
  PenetrationClass = 2,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 1,target_prop = "AimAccuracy"},
    PlaceObj("CaliberModification", {mod_add = 2, target_prop = "PenetrationClass"}))
  },
  AppliedEffects = {"Exposed"}
}


