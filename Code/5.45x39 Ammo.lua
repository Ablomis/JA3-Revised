UndefineClass("_54539_Basic")
DefineClass._54539_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "Mod/mXGyLTd/icons/ammo/545x39_bullets_basic.png",
  DisplayName = T("5.45x39 Standard"),
  DisplayNamePlural = T("5.45x39 Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T("5.45x39 Ammo for Soviet Assault Rifles."),
  MaxStacks = 500,
  Caliber = "545x39",
  Damage = 16,
  Modifications = {PlaceObj("CaliberModification", {mod_add = 3, target_prop = "PenetrationClass"})},
  AppliedEffects = {"Bleeding"}
},

UndefineClass("_54539_AP")
DefineClass._54539_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_armor_piercing",
  DisplayName = T(350757861829, "5.56 mm Armor Piercing"),
  DisplayNamePlural = T(684111621521, "5.56 mm Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(259826736002, "5.45x39 Ammo for Soviet Assault Rifles."),
  AdditionalHint = T(850324784601, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "545x39",
  Damage = 16,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 5, target_prop = "PenetrationClass"})
  },AppliedEffects = {"Bleeding"}
},

UndefineClass("_545x39_HP")
DefineClass._545x39_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_hollow_point",
  DisplayName = T(730378195306, "5.45x39 Hollow Point"),
  DisplayNamePlural = T(277143674333, "5.45x39 Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(220374487056, "5.45x39 Ammo for Soviet Assault Rifles."),
  AdditionalHint = T(122052983336, [[
<bullet_point> Less armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "545x39",
  Damage = 16,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = 1,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
},

UndefineClass("_545x39_Match")
DefineClass._545x39_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_match",
  DisplayName = T(983548612559, "5.45x39 Match"),
  DisplayNamePlural = T(565381152146, "5.45x39 Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(587024333620, "5.45x39 Ammo for Soviet Assault Rifles."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "545x39",
  Damage = 16,
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    },PlaceObj("CaliberModification", {mod_add = 3, target_prop = "PenetrationClass"}))
  },AppliedEffects = {"Bleeding"}
},

UndefineClass("_545x39_Tracer")
DefineClass._545x39_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_tracer",
  DisplayName = T(731781267010, "5.45x39 Tracer"),
  DisplayNamePlural = T(277651293338, "5.45x39 Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T(164095007149, "5.45x39 Ammo for Soviet Assault Rifles."),
  AdditionalHint = T(527792163999, "<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover"),
  MaxStacks = 500,
  Caliber = "545x39",
  Damage = 16,
  Modifications = {PlaceObj("CaliberModification", {mod_add = 3, target_prop = "PenetrationClass"}),
  PlaceObj("CaliberModification", {
    mod_add = 2,
    target_prop = "AimAccuracy"}),
  AppliedEffects = {"Exposed", "Bleeding"}
  }
}



