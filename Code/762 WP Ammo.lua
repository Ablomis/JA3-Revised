UndefineClass("_762WP_Basic")
DefineClass._762WP_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_basic",
  DisplayName = T(814156249809, "7.62 mm WP Standard"),
  DisplayNamePlural = T(397359282724, "7.62 mm WP Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T(908352421544, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  MaxStacks = 500,
  Caliber = "762WP",
  Damage = 24,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 1,target_prop = "PenetrationClass"})},
    AppliedEffects = {"Bleeding"}
}
,
UndefineClass("_762WP_AP")
DefineClass._762WP_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_armor_piercing",
  DisplayName = T(967129689129, "7.62 mm WP Armor Piercing"),
  DisplayNamePlural = T(837647504259, "7.62 mm WP Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(910307381187, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  AdditionalHint = T(302328653162, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "762WP",
  Damage = 21,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 4,target_prop = "PenetrationClass"})
  },AppliedEffects = {"Bleeding"}
}
,
UndefineClass("_762WP_HP")
DefineClass._762WP_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_hollow_point",
  DisplayName = T(730378195306, "7.62 mm WP Hollow Point"),
  DisplayNamePlural = T(277143674333, "7.62 mm WP Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(220374487056, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  AdditionalHint = T(122052983336, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "762WP",
  Damage = 24,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {mod_add = -2,target_prop = "PenetrationClass"})
  },
  AppliedEffects = {"Bleeding"}
}
,
UndefineClass("_762WP_Match")
DefineClass._762WP_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_match",
  DisplayName = T(983548612559, "7.62 mm WP Match"),
  DisplayNamePlural = T(565381152146, "7.62 mm WP Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(587024333620, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "762WP",
  Damage = 24,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 2,target_prop = "AimAccuracy"}),
    PlaceObj("CaliberModification", {mod_add = 1,target_prop = "PenetrationClass"})
},AppliedEffects = {"Bleeding"}
}
,
UndefineClass("_762WP_Tracer")
DefineClass._762WP_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_tracer",
  DisplayName = T(731781267010, "7.62 mm WP Tracer"),
  DisplayNamePlural = T(277651293338, "7.62 mm WP Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T(164095007149, "7.62 Warsaw Pact ammo for Assault Rifles, SMGs, Machine Guns, and Snipers."),
  AdditionalHint = T(527792163999, "<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover"),
  MaxStacks = 500,
  Caliber = "762WP",
  Damage = 21,
  Modifications = {PlaceObj("CaliberModification", {mod_add = 1,target_prop = "PenetrationClass"}),
                {PlaceObj("CaliberModification", {mod_add = 1,target_prop = "AimAccuracy"})},
  AppliedEffects = {"Exposed", "Bleeding"}
}
}