PlaceObj('WeaponComponentEffect', {
	Comment = "Readuce Ready AP by 1",
	Description = "Better weapon maneuverability: reduces Ready AP" ,
    ModificationType = "Subtract",
	Parameters = {
        PlaceObj('PresetParamNumber', {
			'Name', "ready_ap",
			'Value', 1,
			'Tag', "<ready_ap>",
		}),
    },
	group = "Aiming",
    StatToModify = "ReadyAP",
	id = "FasterWeaponReady",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Increase crit chance",
	Description = "Better shot placement: increases crit chance. For night ops" ,
    ModificationType = "Add",
	Parameters = {
        PlaceObj('PresetParamNumber', {
			'Name', "bonus_crit",
			'Value', 15,
			'Tag', "<bonus_crit>",
		}),
    },
	group = "Aiming",
	id = "BonusCritChanceNight",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Increase crit chance",
	Description = "Better shot placement: increases crit chance. For any ops" ,
    ModificationType = "Add",
	Parameters = {
        PlaceObj('PresetParamNumber', {
			'Name', "bonus_crit",
			'Value', 15,
			'Tag', "<bonus_crit>",
		}),
    },
	group = "Aiming",
	id = "BonusCritChance",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Increase accuracy",
	Description = "Increases accuracy at medium range" ,
    ModificationType = "Subtract",
	Parameters = {
        PlaceObj('PresetParamNumber', {
			'Name', "min_dist",
			'Value', 10,
			'Tag', "<min_dist>",
		}),
        PlaceObj('PresetParamNumber', {
			'Name', "bonus_cth",
			'Value', 25,
			'Tag', "<bonus_cth>",
		}),
    },
	group = "Aiming",
	id = "x5ScopeEffect",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Increase accuracy",
	Description = "Increases accuracy at medium range" ,
    ModificationType = "Subtract",
	Parameters = {
        PlaceObj('PresetParamNumber', {
			'Name', "min_dist",
			'Value', 15,
			'Tag', "<min_dist>",
		}),
        PlaceObj('PresetParamNumber', {
			'Name', "bonus_cth",
			'Value', 35,
			'Tag', "<bonus_cth>",
		}),
    },
	group = "Aiming",
	id = "x10ScopeEffect",
})

g_PresetParamCache[WeaponComponentEffects.FasterWeaponReady] = { ready_ap = 1}
g_PresetParamCache[WeaponComponentEffects.BonusCritChance] = { bonus_crit = 15}
g_PresetParamCache[WeaponComponentEffects.x5ScopeEffect] = { min_dist = 10, bonus_cth = 25}
 

