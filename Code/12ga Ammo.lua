UndefineClass("_12gauge_Buckshot")
DefineClass._12gauge_Buckshot = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_buckshot",
  DisplayName = T(252069434763, "12-gauge Buckshot"),
  DisplayNamePlural = T(227315315032, "12-gauge Buckshot"),
  colorStyle = "AmmoBasicColor",
  Description = T(505402985632, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(104397963477, "<bullet_point> Inflicts <em>Bleeding</em>"),
  MaxStacks = 500,
  Caliber = "12gauge",
  Mass=3.5,
  BaseVelocity = 403,
  CritChance = 60,
  PenetrationClass = 0,
  Projectiles = 9,
  Modifications = {

  },
}

UndefineClass("_12gauge_Flechette")
DefineClass._12gauge_Flechette = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_flechette",
  DisplayName = T(812367261617, "12-gauge Sabot"),
  DisplayNamePlural = T(125497062275, "12-gauge Sabot"),
  colorStyle = "AmmoMatchColor",
  Description = T(732291740225, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(114102212532, [[
<bullet_point> Longer range
<bullet_point> Narrow attack cone
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "12gauge",
  Mass=3.5,
  BaseVelocity = 403,
  CritChance = 60,
  PenetrationClass = 0,
  Projectiles = 9,
  Modifications = {

  },
}

UndefineClass("_12gauge_Saltshot")
DefineClass._12gauge_Saltshot = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_saltshot",
  DisplayName = T(267395126102, "12-gauge Saltshot"),
  DisplayNamePlural = T(598926526992, "12-gauge Saltshot"),
  colorStyle = "AmmoTracerColor",
  Description = T(865200495495, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(331667140330, [[
<bullet_point> Low damage
<bullet_point> Shorter range
<bullet_point> Wide attack cone
<bullet_point> Inflicts <em>Inaccurate</em>]]),
  MaxStacks = 500,
  Caliber = "12gauge",
  Mass=3.5,
  BaseVelocity = 403,
  CritChance = 60,
  PenetrationClass = 0,
  Projectiles = 9,
  Modifications = {

  },
  AppliedEffects = {"Inaccurate"}
}

UndefineClass("_12gauge_Breacher")
DefineClass._12gauge_Breacher = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/12_gauge_bullets_breacher",
  DisplayName = T(838899636996, "12-gauge Breacher"),
  DisplayNamePlural = T(644219397636, "12-gauge Breacher"),
  colorStyle = "AmmoAPColor",
  Description = T(641022773748, "12-gauge ammo for Shotguns."),
  AdditionalHint = T(109230359975, [[
<bullet_point> Very short range
<bullet_point> Wide attack cone
<bullet_point> Improved armor penetration
<bullet_point> Prevents Grazing hits due to opponents Taking Cover
<bullet_point> Inflicts <em>Suppressed</em>]]),
  MaxStacks = 500,
  Caliber = "12gauge",
  Mass=3.5,
  BaseVelocity = 403,
  CritChance = 60,
  PenetrationClass = 0,
  Projectiles = 9,
  Modifications = {

  },
  AppliedEffects = {"Suppressed"}
}


