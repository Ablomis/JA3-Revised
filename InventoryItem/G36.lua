UndefineClass('G36')
DefineClass.G36 = {
	__parents = { "AssaultRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "AssaultRifle",
	Reliability = 90,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/G36",
	DisplayName = T(832666094442, --[[ModItemInventoryItemCompositeDef G36 DisplayName]] "G36"),
	DisplayNamePlural = T(324750753284, --[[ModItemInventoryItemCompositeDef G36 DisplayNamePlural]] "G36s"),
	Description = T(623752649075, --[[ModItemInventoryItemCompositeDef G36 Description]] "Futuristic assault rifle with an integrated dual combat sighting system. The 5.56 NATO cartridge combined with the short-stroke gas piston system make this a joy to shoot."),
	AdditionalHint = T(277854338238, --[[ModItemInventoryItemCompositeDef G36 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Longer range\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Low attack costs"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 4000,
	Caliber = "556",
	Platform = "AR15",
	Damage = 22,
	AimAccuracy = 6,
	BaseAccuracy = 97,
	MagazineSize = 30,
	PenetrationClass = 2,
	WeaponRange = 28,
	DamageFalloff = 60,
	Recoil = 22,
	PointBlankRange = true,
	OverwatchAngle = 1440,
	HandSlot = "TwoHanded",
	Entity = "Weapon_HKG36",
	fxClass = "G36",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelLong",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'AvailableComponents', {
				"ScopeCOG",
				"LROptics",
				"ThermalScope",
				"ReflexSightAdvanced",
			},
			'DefaultComponent', "ScopeCOG",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'AvailableComponents', {
				"Compensator",
				"Suppressor",
				"ImprovisedSuppressor",
			},
			'DefaultComponent', "Compensator",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
				"MagQuick",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"TacGrip",
				"VerticalGrip",
				"GrenadeLauncher",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"FlashlightDot",
				"LaserDot",
				"UVDot",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockNormal",
				"StockFolded",
				"StockHeavy",
			},
			'DefaultComponent', "StockNormal",
		}),
	},
	Color = "Black",
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"CancelShot",
	},
	ShootAP = 6000,
	ReloadAP = 3000,
	ReadyAP = 3000,
}

