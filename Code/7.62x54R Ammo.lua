UndefineClass("_76254R_Basic")
DefineClass._76254R_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "Mod/mXGyLTd/icons/ammo/762X54R_bullets_basic.png",
  DisplayName = T("7.62x54R Standard"),
  DisplayNamePlural = T("7.62x54R Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T("7.62x54R Ammo for Soviet Rifles and Sniper Rifles."),
  MaxStacks = 500,
  Caliber = "762x54R",
  Damage = 27,
  Modifications = {PlaceObj("CaliberModification", {mod_add = 3, target_prop = "PenetrationClass"})}
  ,AppliedEffects = {"Bleeding"}
},

UndefineClass("_76254R_AP")
DefineClass._76254R_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/556_nato_bullets_armor_piercing",
  DisplayName = T(350757861829, "5.56 mm Armor Piercing"),
  DisplayNamePlural = T(684111621521, "5.56 mm Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T("7.62x54R Ammo for Soviet Rifles and Sniper Rifles."),
  AdditionalHint = T(850324784601, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "762x54R",
  Damage = 24,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 5, target_prop = "PenetrationClass"})
  },AppliedEffects = {"Bleeding"}
},

UndefineClass("_762x54R_HP")
DefineClass._762x54R_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_hollow_point",
  DisplayName = T(730378195306, "7.62x54R Hollow Point"),
  DisplayNamePlural = T(277143674333, "7.62x54R Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T("7.62x54R Ammo for Soviet Rifles and Sniper Rifles."),
  AdditionalHint = T([[
<bullet_point> Less armor penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "762x54R",
  Damage = 27,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = 1,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
},

UndefineClass("_762x54R_Match")
DefineClass._762x54R_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_match",
  DisplayName = T(983548612559, "7.62x54R Match"),
  DisplayNamePlural = T(565381152146, "7.62x54R Match"),
  colorStyle = "AmmoMatchColor",
  Description = T("7.62x54R Ammo for Soviet Rifles and Sniper Rifles."),
  AdditionalHint = T(898089454154, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "762x54R",
  Damage = 27,
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "AimAccuracy"
    },PlaceObj("CaliberModification", {mod_add = 3, target_prop = "PenetrationClass"}))
  },AppliedEffects = {"Bleeding"}
},

UndefineClass("_762x54R_Tracer")
DefineClass._762x54R_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/762_wp_bullets_tracer",
  DisplayName = T(731781267010, "7.62x54R Tracer"),
  DisplayNamePlural = T(277651293338, "7.62x54R Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T("7.62x54R Ammo for Soviet Rifles and Sniper Rifles."),
  AdditionalHint = T(527792163999, "<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover"),
  MaxStacks = 500,
  Caliber = "762x54R",
  Damage = 27,
  Modifications = {PlaceObj("CaliberModification", {mod_add = 3, target_prop = "PenetrationClass"}),
  PlaceObj("CaliberModification", {
    mod_add = 2,
    target_prop = "AimAccuracy"}),
  AppliedEffects = {"Exposed","Bleeding"}
  }
}



