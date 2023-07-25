UndefineClass("_9mm_Basic")
DefineClass._9mm_Basic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_basic",
  DisplayName = T(235145143577, "9 mm Standard"),
  DisplayNamePlural = T(363994540714, "9 mm Standard"),
  colorStyle = "AmmoBasicColor",
  Description = T(667953407193, "9 mm ammo for Handguns and SMGs."),
  MaxStacks = 500,
  Caliber = "9mm",
  Damage = 15,
  AppliedEffects = {"Bleeding"}
},

UndefineClass("_9mm_AP")
DefineClass._9mm_AP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_armor_piercing",
  DisplayName = T(511863800683, "9 mm Armor Piercing"),
  DisplayNamePlural = T(543760141960, "9 mm Armor Piercing"),
  colorStyle = "AmmoAPColor",
  Description = T(909426327700, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(689365321555, "<bullet_point> Improved armor penetration"),
  MaxStacks = 500,
  Caliber = "9mm",
  Damage = 13,
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 2,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
},

UndefineClass("_9mm_HP")
DefineClass._9mm_HP = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_hollow_point",
  DisplayName = T(266966643839, "9 mm Hollow Point"),
  DisplayNamePlural = T(560775721611, "9 mm Hollow Point"),
  colorStyle = "AmmoHPColor",
  Description = T(839153279981, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(264921787121, [[
<bullet_point> Reduced penetration
<bullet_point> High Crit chance
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "9mm",
  Damage = 15,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -2,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Bleeding"}
},

UndefineClass("_9mm_Match")
DefineClass._9mm_Match = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_match",
  DisplayName = T(423815928188, "9 mm Match"),
  DisplayNamePlural = T(106653528434, "9 mm Match"),
  colorStyle = "AmmoMatchColor",
  Description = T(539464011742, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(169874693254, "<bullet_point> Increased bonus from Aiming"),
  MaxStacks = 500,
  Caliber = "9mm",
  Damage = 15,
  Modifications = {
    PlaceObj("CaliberModification", {
      mod_add = 3,
      target_prop = "AimAccuracy"
    })
  },AppliedEffects = {"Bleeding"}
},

UndefineClass("_9mm_Shock")
DefineClass._9mm_Shock = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_shock",
  DisplayName = T(527113359889, "9 mm Shock"),
  DisplayNamePlural = T(592944604182, "9 mm Shock"),
  colorStyle = "AmmoMatchColor",
  Description = T(923881615835, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(205583625720, [[
<bullet_point> No armor penetration
<bullet_point> High Crit chance
<bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
<bullet_point> Inflicts <em>Bleeding</em>]]),
  MaxStacks = 500,
  Caliber = "9mm",
  Damage = 15,
  Modifications = {
    PlaceObj("CaliberModification", {mod_add = 50, target_prop = "CritChance"}),
    PlaceObj("CaliberModification", {
      mod_add = -2,
      target_prop = "PenetrationClass"
    })
  },
  AppliedEffects = {"Exposed", "Bleeding"}
},

UndefineClass("_9mm_Subsonic")
DefineClass._9mm_Subsonic = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_subsonic",
  DisplayName = T(416825324724, "9 mm Subsonic"),
  DisplayNamePlural = T(676522769844, "9 mm Subsonic"),
  colorStyle = "AmmoMatchColor",
  Description = T(571319448676, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T(368177980365, "<bullet_point> Less noisy"),
  MaxStacks = 500,
  Caliber = "9mm",
  Damage = 13,
  Modifications = {
    PlaceObj("CaliberModification", {mod_mul = 500, target_prop = "Noise"})
  },AppliedEffects = {"Bleeding"}
},

UndefineClass("_9mm_Tracer")
DefineClass._9mm_Tracer = {
  __parents = {"Ammo"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "Ammo",
  Icon = "UI/Icons/Items/9mm_bullets_tracer",
  DisplayName = T(388936410240, "9 mm Tracer"),
  DisplayNamePlural = T(576279361457, "9 mm Tracer"),
  colorStyle = "AmmoTracerColor",
  Description = T(605716564475, "9 mm ammo for Handguns and SMGs."),
  AdditionalHint = T([[
  <bullet_point> Hit enemies are <em>Exposed</em> and lose the benefits of Cover
  <bullet_point> Increased bonus from Aiming]]),
  MaxStacks = 500,
  Caliber = "9mm",
  Damage = 13,
  Modifications = {
    PlaceObj("CaliberModification", {
        mod_add = 3,
        target_prop = "AimAccuracy"
      }),
},AppliedEffects = {"Bleeding"}
}









