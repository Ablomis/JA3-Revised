PlaceObj('WeaponComponent', {
	Cost = 40,
	DisplayName = T(972598655631, --[[WeaponComponent VerticalGrip DisplayName]] "Vertical Grip"),
	Icon = "UI/Icons/Upgrades/mp5_grip",
	ModificationDifficulty = 20,
	ModificationEffects = {
		"FasterWeaponReady",
	},
	Slot = "Under",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_GripMP5",
			Slot = "Under",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FAMAS",
			Entity = "WeaponAttA_GripMP5",
			Slot = "Under",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FNFAL",
			Entity = "WeaponAttA_MountFNFal_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK47",
			Entity = "WeaponAttA_VerticalGripAK47",
			Slot = "Handguard",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AUG",
			Entity = "WeaponAttA_VerticalGripSteyr",
			Slot = "Under",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5",
			Entity = "WeaponAttA_HandguardMP5_02",
			Slot = "Side3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5K",
			Entity = "WeaponAttA_HandguardMP5_02",
			Slot = "Under",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "UZI",
			Entity = "WeaponAttA_MountUzi_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HK21",
			Entity = "WeaponAttA_GripHK21",
			Slot = "Under",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_VerticalGripM16",
			Slot = "Grip",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_GripMP5",
			Slot = "Grip",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_MountHKG36_02",
			Slot = "Mount2",
		}),
	},
	group = "Underslung",
	id = "VerticalGrip",
	param_bindings = {},
})

PlaceObj('WeaponComponent', {
	BlockSlots = {
		"Grenadelauncher",
	},
	Cost = 20,
	DisplayName = T(792047899659, --[[WeaponComponent AK47_VerticalGrip DisplayName]] "Vertical Grip"),
	Icon = "UI/Icons/Upgrades/ak47_vertical_grip",
	ModificationDifficulty = 0,
	ModificationEffects = {
		"FasterWeaponReady",
	},
	Slot = "Handguard",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_VerticalGripAK47",
			Slot = "Handguard",
		}),
	},
	group = "AK47 Specific",
	id = "AK47_VerticalGrip",
	param_bindings = {},
})

PlaceObj('WeaponComponent', {
	BlockSlots = {
		"Grenadelauncher",
	},
	Cost = 40,
	DisplayName = T(442108004279, --[[WeaponComponent VerticalGrip_AUG DisplayName]] "Vertical Grip"),
	Icon = "UI/Icons/Upgrades/mp5_grip",
	ModificationDifficulty = 20,
	ModificationEffects = {
		"FasterWeaponReady",
	},
	Slot = "Under",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AUG",
			Entity = "WeaponAttA_VerticalGripSteyr",
			Slot = "Under",
		}),
	},
	group = "AUG Specific",
	id = "VerticalGrip_AUG",
	param_bindings = {},
})

PlaceObj('WeaponComponent', {
	Cost = 40,
	DisplayName = T(390401707495, --[[WeaponComponent VerticalGrip_M14 DisplayName]] "Vertical Grip"),
	Icon = "UI/Icons/Upgrades/mp5_grip",
	ModificationDifficulty = 20,
	ModificationEffects = {
		"FasterWeaponReady",
	},
	Slot = "Under",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_VerticalGripM14",
			Slot = "Under",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_SideMountM14",
			Slot = "Mountside",
		}),
	},
	group = "M14 Specific",
	id = "VerticalGrip_M14",
	param_bindings = {},
})

PlaceObj('WeaponComponent', {
	Cost = 40,
	DisplayName = T(211149642866, --[[WeaponComponent VerticalGrip_M16 DisplayName]] "Vertical Grip"),
	Icon = "UI/Icons/Upgrades/mp5_grip",
	ModificationDifficulty = 20,
	ModificationEffects = {
		"FasterWeaponReady",
	},
	Slot = "Under",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_VerticalGripM16",
			Slot = "Grip",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_MountM16_02",
			Slot = "Mount2",
		}),
	},
	group = "M16A2 Specific",
	id = "VerticalGrip_M16",
	param_bindings = {},
})

PlaceObj('WeaponComponent', {
	Cost = 40,
	DisplayName = T(291801976985, --[[WeaponComponent VerticalGrip_Commando DisplayName]] "Vertical Grip"),
	Icon = "UI/Icons/Upgrades/mp5_grip",
	ModificationDifficulty = 20,
	ModificationEffects = {
		"FasterWeaponReady",
	},
	Slot = "Under",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_VerticalGripCAR15",
			Slot = "Verticalgrip",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_MountBottomCAR15",
			Slot = "Mountbottom",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_HandguardCAR15",
			Slot = "Handguard",
		}),
	},
	group = "M4 Commando Specific",
	id = "VerticalGrip_Commando",
	param_bindings = {},
})

PlaceObj('WeaponComponent', {
	Cost = 40,
	DisplayName = T(236370866133, --[[WeaponComponent RPK74_VerticalGrip DisplayName]] "Vertical Grip"),
	Icon = "UI/Icons/Upgrades/ak47_vertical_grip",
	ModificationDifficulty = 20,
	ModificationEffects = {
		"FasterWeaponReady",
	},
	Slot = "Handguard",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "RPK74",
			Entity = "WeaponAttA_HandguardRPK74_02",
			Slot = "Handguard",
		}),
	},
	group = "RPK 74 Specific",
	id = "RPK74_VerticalGrip",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 10,
	DisplayName = T(405161321170, --[[WeaponComponent LaserDot_Anaconda DisplayName]] "Red Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChanceNight",
	},
	Slot = "Scope",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Scope",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount",
		}),
	},
	group = "Anaconda Specific",
	id = "LaserDot_Anaconda",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 10,
	DisplayName = T(841174949604, --[[WeaponComponent LaserDot_PSG_M1 DisplayName]] "Red Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChanceNight",
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
	},
	group = "PSG1-Specific",
	id = "LaserDot_PSG_M1",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 10,
	DisplayName = T(394807232613, --[[WeaponComponent LaserDot DisplayName]] "Red Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChanceNight",
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Galil",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK47",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AKSU",
			Entity = "WeaponAttA_MountAKS74U_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK74",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AUG",
			Entity = "WeaponAttA_SideMountSteyr",
			Slot = "Mountside",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Bereta92",
			Entity = "WeaponAttA_MountBeretta",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HiPower",
			Entity = "WeaponAttA_MountBHP",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FAMAS",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M41Shotgun",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AA12",
			Entity = "WeaponAttA_MountAA12_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Gewehr98",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "PSG1",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Winchester1894",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5K",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "UZI",
			Entity = "WeaponAttA_MountUzi_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FNFAL",
			Entity = "WeaponAttA_MountFNFal_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HK21",
			Entity = "WeaponAttA_MountHK21_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_SideMountM14",
			Slot = "Mountside",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AR15",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_MountFrontCAR15",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_MountM16_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_MountHKG36_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
	},
	group = "Side",
	id = "LaserDot",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 10,
	DisplayName = T(427210220552, --[[WeaponComponent LaserDot_aa12 DisplayName]] "Red Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChanceNight",
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AA12",
			Entity = "WeaponAttA_MountAA12_02",
			Slot = "Mount2",
		}),
	},
	group = "AA12 Specific",
	id = "LaserDot_aa12",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 20,
	DisplayName = T(506806756026, --[[WeaponComponent UVDot_Anaconda DisplayName]] "UV Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChance",
	},
	Slot = "Scope",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Scope",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount",
		}),
	},
	group = "Anaconda Specific",
	id = "UVDot_Anaconda",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 20,
	DisplayName = T(524417680473, --[[WeaponComponent UVDot_PSG_M1 DisplayName]] "UV Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChance",
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
	},
	group = "PSG1-Specific",
	id = "UVDot_PSG_M1",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 20,
	DisplayName = T(199081852714, --[[WeaponComponent UVDot DisplayName]] "UV Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChance",
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Galil",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK47",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AKSU",
			Entity = "WeaponAttA_MountAKS74U_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK74",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AUG",
			Entity = "WeaponAttA_SideMountSteyr",
			Slot = "Mountside",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Bereta92",
			Entity = "WeaponAttA_MountBeretta",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HiPower",
			Entity = "WeaponAttA_MountBHP",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FAMAS",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M41Shotgun",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AA12",
			Entity = "WeaponAttA_MountAA12_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Gewehr98",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "PSG1",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Winchester1894",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5K",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "UZI",
			Entity = "WeaponAttA_MountUzi_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FNFAL",
			Entity = "WeaponAttA_MountFNFal_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HK21",
			Entity = "WeaponAttA_MountHK21_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_SideMountM14",
			Slot = "Mountside",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AR15",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_MountFrontCAR15",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_MountM16_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_MountHKG36_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
	},
	group = "Side",
	id = "UVDot",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 20,
	DisplayName = T(739522307124, --[[WeaponComponent UVDot_aa12 DisplayName]] "UV Dot"),
	Icon = "UI/Icons/Upgrades/side_laser",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"BonusCritChance",
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaser",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AA12",
			Entity = "WeaponAttA_MountAA12_02",
			Slot = "Mount2",
		}),
	},
	group = "AA12 Specific",
	id = "UVDot_aa12",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 30,
	DisplayName = T(638946230736, --[[WeaponComponent FlashlightDot_aa12 DisplayName]] "Tactical Device"),
	Icon = "UI/Icons/Upgrades/side_laserlight",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"IgnoreInTheDark",
		"BonusCritChance",
	},
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "maxaims",
			'Value', 1,
			'Tag', "<maxaims>",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "aim_bonus",
			'Value', 1,
			'Tag', "<aim_bonus>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "stealth_kill_bonus",
			'Value', 2,
			'Tag', "<stealth_kill_bonus>%",
		}),
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AA12",
			Entity = "WeaponAttA_MountAA12_02",
			Slot = "Mount2",
		}),
	},
	group = "AA12 Specific",
	id = "FlashlightDot_aa12",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 20,
	DisplayName = T(646651177477, --[[WeaponComponent FlashlightDot_Anaconda DisplayName]] "Tactical Device"),
	Icon = "UI/Icons/Upgrades/side_laserlight",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"IgnoreInTheDark",
		"BonusCritChance",
	},
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "stealth_kill_bonus",
			'Value', 2,
			'Tag', "<stealth_kill_bonus>%",
		}),
	},
	Slot = "Scope",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Scope",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount",
		}),
	},
	group = "Anaconda Specific",
	id = "FlashlightDot_Anaconda",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 30,
	DisplayName = T(875731475724, --[[WeaponComponent FlashlightDot_PSG_M1 DisplayName]] "Tactical Device"),
	Icon = "UI/Icons/Upgrades/side_laserlight",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"IgnoreInTheDark",
		"BonusCritChance",
	},
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "stealth_kill_bonus",
			'Value', 2,
			'Tag', "<stealth_kill_bonus>%",
		}),
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side1",
		}),
	},
	group = "PSG1-Specific",
	id = "FlashlightDot_PSG_M1",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "Microchip",
		}),
	},
	Cost = 30,
	DisplayName = T(599763053072, --[[WeaponComponent FlashlightDot DisplayName]] "Tactical Device"),
	Icon = "UI/Icons/Upgrades/side_laserlight",
	ModificationDifficulty = 10,
	ModificationEffects = {
		"IgnoreInTheDark",
		"BonusCritChance",
	},
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "maxaims",
			'Value', 1,
			'Tag', "<maxaims>",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "aim_bonus",
			'Value', 1,
			'Tag', "<aim_bonus>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "stealth_kill_bonus",
			'Value', 2,
			'Tag', "<stealth_kill_bonus>%",
		}),
	},
	Slot = "Side",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Galil",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5K",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "UZI",
			Entity = "WeaponAttA_MountUzi_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK47",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AKSU",
			Entity = "WeaponAttA_MountAKS74U_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK74",
			Entity = "WeaponAttA_FrontMountAK47",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AUG",
			Entity = "WeaponAttA_SideMountSteyr",
			Slot = "Mountside",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Bereta92",
			Entity = "WeaponAttA_MountBeretta",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HiPower",
			Entity = "WeaponAttA_MountBHP",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FAMAS",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M41Shotgun",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AA12",
			Entity = "WeaponAttA_MountAA12_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Gewehr98",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "PSG1",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Winchester1894",
			Entity = "WeaponAttA_FrontMountM24",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FNFAL",
			Entity = "WeaponAttA_MountFNFal_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HK21",
			Entity = "WeaponAttA_MountHK21_02",
			Slot = "Mount2",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_SideMountM14",
			Slot = "Mountside",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AR15",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_MountFrontCAR15",
			Slot = "Mountfront",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_MountM16_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_MountHKG36_03",
			Slot = "Mount3",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_SideLaserLight",
			Slot = "Side1",
		}),
	},
	group = "Side",
	id = "FlashlightDot",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "OpticalLens",
		}),
	},
	Cost = 20,
	DisplayName = T(844523910352, --[[WeaponComponent LROptics DisplayName]] "Sniper Scope x5"),
	Icon = "UI/Icons/Upgrades/scope_longrange",
	ModificationDifficulty = 0,
	ModificationEffects = {
		"IncreaseMaxAimActions",
        'x5ScopeEffect'
	},
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "MaxAimActionsIncrease",
			'Value', 0,
			'Tag', "<MaxAimActionsIncrease>",
		}),
	},
	Slot = "Scope",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_ScopeLongRange",
			Slot = "Scope",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK47",
			Entity = "WeaponAttA_MountAK47",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AKSU",
			Entity = "WeaponAttA_MountAKS74U_01",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "RPK74",
			Entity = "WeaponAttA_MountRPK74",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK74",
			Entity = "WeaponAttA_MountAK47",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AUG",
			Entity = "WeaponAttA_MountSteyr",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Galil",
			Entity = "WeaponAttA_MountGalil",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_MountM24",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5",
			Entity = "WeaponAttA_MountMP5",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "MP5K",
			Entity = "WeaponAttA_MountMP5",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "UZI",
			Entity = "WeaponAttA_MountUzi_01",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_MountM14",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Gewehr98",
			Entity = "WeaponAttA_MountGewehr",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FNFAL",
			Entity = "WeaponAttA_MountFNFal_01",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HK21",
			Entity = "WeaponAttA_MountHK21_01",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Winchester1894",
			Entity = "WeaponAttA_MountWinchester",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_MountCAR15",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_MountM16_01",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "G36",
			Entity = "WeaponAttA_ScopeHKG36_02",
			Icon = "UI/Icons/Upgrades/g36_scope_02",
			Slot = "Scope",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "BarretM82",
			Entity = "WeaponAttA_IronSightBarrettM82_Folded",
			Slot = "Ironsight",
		}),
	},
	group = "Scope",
	id = "LROptics",
})

PlaceObj('WeaponComponent', {
	AdditionalCosts = {
		PlaceObj('WeaponComponentCost', {
			'Amount', 1,
			'Type', "OpticalLens",
		}),
	},
	Cost = 35,
	DisplayName = T(756379377948, --[[WeaponComponent LROpticsAdvanced DisplayName]] "Sniper Scope x10"),
	Icon = "UI/Icons/Upgrades/sniper_scope_x10",
	ModificationDifficulty = 0,
	ModificationEffects = {
		"IncreaseMaxAimActions",
        'x10ScopeEffect'
	},
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "AimAccuracyIncrease",
			'Value', 0,
			'Tag', "<AimAccuracyIncrease>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "MaxAimActionsIncrease",
			'Value', 0,
			'Tag', "<MaxAimActionsIncrease>",
		}),
	},
	Slot = "Scope",
	StoreAsTable = true,
	Visuals = {
		PlaceObj('WeaponComponentVisual', {
			Entity = "WeaponAttA_ScopeSniperX10",
			Slot = "Scope",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK47",
			Entity = "WeaponAttA_MountAK47",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AKSU",
			Entity = "WeaponAttA_MountAKS74U_01",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "RPK74",
			Entity = "WeaponAttA_MountRPK74",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AK74",
			Entity = "WeaponAttA_MountAK47",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "AUG",
			Entity = "WeaponAttA_MountSteyr",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Galil",
			Entity = "WeaponAttA_MountGalil",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M24Sniper",
			Entity = "WeaponAttA_MountM24",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "DragunovSVD",
			Entity = "WeaponAttA_MountDragunov_01",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M14SAW",
			Entity = "WeaponAttA_MountM14",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Gewehr98",
			Entity = "WeaponAttA_MountGewehr",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "ColtAnaconda",
			Entity = "WeaponAttA_MountAnaconda",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "FNFAL",
			Entity = "WeaponAttA_MountFNFal_01",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "HK21",
			Entity = "WeaponAttA_MountHK21_01",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "Winchester1894",
			Entity = "WeaponAttA_MountWinchester",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M4Commando",
			Entity = "WeaponAttA_MountCAR15",
			Slot = "Mount",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "M16A2",
			Entity = "WeaponAttA_MountM16_01",
			Slot = "Mount1",
		}),
		PlaceObj('WeaponComponentVisual', {
			ApplyTo = "BarretM82",
			Entity = "WeaponAttA_IronSightBarrettM82_Folded",
			Slot = "Ironsight",
		}),
	},
	group = "Scope",
	id = "LROpticsAdvanced",
})