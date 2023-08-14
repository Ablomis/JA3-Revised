PlaceObj('WeaponComponentEffect', {
	Comment = "Used by FX to switch to silenced fx",
	ModificationType = "Multiply",
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "NoiseMultiplier",
			'Value', 1,
			'Tag', "<NoiseMultiplier>",
		}),
	},
	StatToModify = "Noise",
	group = "FX Placeholders",
	id = "SilentShots",
})
PlaceObj('WeaponComponentEffect', {
	Comment = "Multiplies Noise by 25%",
	Description = T(487137358216, --[[WeaponComponentEffect SilentShots Description]] "<em>75%</em> noise reduction"),
	ModificationType = "Multiply",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "NoiseMultiplier",
			'Value', 25,
			'Tag', "<NoiseMultiplier>%",
		}),
	},
	Scale = "%",
	StatToModify = "Noise",
	group = "FX Placeholders",
	id = "SoundReductionOneQuarter",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Mltiplies Noise by 33%",
	Description = T(487137358216, --[[WeaponComponentEffect SilentShots Description]] "<em>66%</em> noise reduction"),
	ModificationType = "Multiply",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "NoiseMultiplier",
			'Value', 33,
			'Tag', "<NoiseMultiplier>%",
		}),
	},
	Scale = "%",
	StatToModify = "Noise",
	group = "FX Placeholders",
	id = "SoundReductionOneThird",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Multiplies Noise by 50%",
	Description = T(487137358216, --[[WeaponComponentEffect SilentShots Description]] "<em>50%</em> noise reduction"),
	ModificationType = "Multiply",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "NoiseMultiplier",
			'Value', 50,
			'Tag', "<NoiseMultiplier>%",
		}),
	},
	Scale = "%",
	StatToModify = "Noise",
	group = "FX Placeholders",
	id = "SoundReductionHalf",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Multiplies Noise by 66%",
	Description = T(487137358216, --[[WeaponComponentEffect SilentShots Description]] "<em>33%</em> noise reduction"),
	ModificationType = "Multiply",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "NoiseMultiplier",
			'Value', 66,
			'Tag', "<NoiseMultiplier>%",
		}),
	},
	Scale = "%",
	StatToModify = "Noise",
	group = "FX Placeholders",
	id = "SoundReductionTwoThird",
})

PlaceObj('WeaponComponentEffect', {
	Comment = "Multiplies Noise by 75%",
	Description = T(487137358216, --[[WeaponComponentEffect SilentShots Description]] "<em>25%</em> noise reduction"),
	ModificationType = "Multiply",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "NoiseMultiplier",
			'Value', 75,
			'Tag', "<NoiseMultiplier>%",
		}),
	},
	Scale = "%",
	StatToModify = "Noise",
	group = "FX Placeholders",
	id = "SoundReductionThreeQuarter",
})

PlaceObj('WeaponComponentEffect', {
	Description = T(926413244556, --[[WeaponComponentEffect ReduceMaxAimActions Description]] "Max aim level reduced by<em>1</em>"),
	ModificationType = "Subtract",
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "MaxAimActionsIncrease",
			'Value', 1,
			'Tag', "<MaxAimActionsIncrease>",
		}),
	},
	StatToModify = "MaxAimActions",
	group = "Stats",
	id = "ReduceMaxAimActions",
})
PlaceObj('WeaponComponentEffect', {
	Description = T(611710257378, --[[WeaponComponentEffect ReduceDamageOne Description]] "Reduced damage by <em><DamageDecrease></em>"),
	ModificationType = "Subtract",
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "DamageDecrease",
			'Value', 1,
			'Tag', "<DamageDecrease>",
		}),
	},
	RequiredParams = {
		"DamageDecrease",
	},
	StatToModify = "Damage",
	group = "Stats",
	id = "ReduceDamageOne",
})
PlaceObj('WeaponComponentEffect', {
	Description = T(998143212137, --[[WeaponComponentEffect ReduceReadyAP Description]] "Quicker Weapon Readying by <em><ReadyAPDecrease> AP</em>"),
	ModificationType = "Subtract",
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "ReadyAPDecrease",
			'Value', 1,
			'Tag', "<ReadyAPDecrease>",
		}),
	},
	RequiredParams = {
		"ReadyAPDecrease",
	},
	Scale = "AP",
	StatToModify = "ReadyAP",
	group = "Stats",
	id = "ReduceReadyAP",
})
PlaceObj('WeaponComponentEffect', {
	Comment = "Increases the bonus of the Aiming cth modifier. Scales per aim level. ReduceAimAccuracy reduces the same stat, but is implemented through the cth modifier.",
	Description = T(812606236945, --[[WeaponComponentEffect ReduceAimAccuracyPoints Description]] "Reduced Aiming Bonus by <em><AimAccuracyDecrease> AP</em>"),
	ModificationType = "Subtract",
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "AimAccuracyDecrease",
			'Tag', "<AimAccuracyDecrease>",
		}),
	},
	RequiredParams = {
		"AimAccuracyDecrease",
	},
	StatToModify = "AimAccuracy",
	group = "Stats",
	id = "ReduceAimAccuracyPoints",
})
