UndefineClass('AUG')
DefineClass.AUG = {
	__parents = { "AssaultRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "AssaultRifle",
	Reliability = 85,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/AUG",
	DisplayName = T(290038561726, --[[ModItemInventoryItemCompositeDef AUG DisplayName]] "AUG"),
	DisplayNamePlural = T(955050440842, --[[ModItemInventoryItemCompositeDef AUG DisplayNamePlural]] "AUGs"),
	Description = T(635347879990, --[[ModItemInventoryItemCompositeDef AUG Description]] "A bullpup with heavy use of polymer and one of the first to feature integrated optics. Embodying the concept of switching from heavy main battle rifles to assault rifles with the lighter 5.56 NATO cartridge."),
	AdditionalHint = T(475813373026, --[[ModItemInventoryItemCompositeDef AUG AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Longer range\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Low attack costs"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 2500,
	Caliber = "556",
	Platform = "AUG",
	Damage = 22,
	AimAccuracy = 6,
	BaseAccuracy = 95,
	MagazineSize = 30,
	PenetrationClass = 2,
	DamageFalloff = 75,
	Recoil = 18,
	OverwatchAngle = 1440,
	HandSlot = "TwoHanded",
	Entity = "Weapon_Steyr",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelShort_AUG",
				"BarrelShortImproved_AUG",
				"BarrelLong_AUG",
				"BarrelLongImproved_AUG",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'AvailableComponents', {
				"AUGCompensator_01",
				"AUGCompensator_03",
				"Suppressor",
			},
			'DefaultComponent', "AUGCompensator_01",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'AvailableComponents', {
				"VerticalGrip",
			},
			'DefaultComponent', "VerticalGrip",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Grenadelauncher",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"GrenadeLauncher_AUG",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagLarge",
				"MagNormal",
				"MagQuick",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Mount",
			'Modifiable', false,
			'CanBeEmpty', true,
			'AvailableComponents', {
				"AUGMount",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'AvailableComponents', {
				"LROptics",
				"LROpticsAdvanced",
				"ThermalScope",
				"ReflexSight",
				"ScopeCOG",
				"AUGScope_Default",
			},
			'DefaultComponent', "AUGScope_Default",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"FlashlightDot",
				"LaserDot",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"CancelShot",
	},
	ShootAP = 6000,
	ReloadAP = 10000,
	ReadyAP = 2000,
}

