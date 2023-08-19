UndefineClass('FNFAL')
DefineClass.FNFAL = {
	__parents = { "AssaultRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "AssaultRifle",
	Reliability = 50,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/FNFAL",
	DisplayName = T(587821655735, --[[ModItemInventoryItemCompositeDef FNFAL DisplayName]] "FN-FAL"),
	DisplayNamePlural = T(225525451417, --[[ModItemInventoryItemCompositeDef FNFAL DisplayNamePlural]] "FN-FALs"),
	Description = T(947237929610, --[[ModItemInventoryItemCompositeDef FNFAL Description]] "Often described as the Right Arm of the Free World, it delivers pure Democracy in volleys!"),
	AdditionalHint = T(529126155739, --[[ModItemInventoryItemCompositeDef FNFAL AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High damage\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Faster Condition loss"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 1800,
	Caliber = "762NATO",
	Platform = "FNFAL",
	Damage = 28,
	BaseAccuracy = 93,
	MagazineSize = 30,
	PenetrationClass = 2,
	WeaponRange = 28,
	DamageFalloff = 90,
	Recoil = 28,
	OverwatchAngle = 1440,
	HandSlot = "TwoHanded",
	Entity = "Weapon_FNFAL",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Handguard",
			'Modifiable', false,
			'AvailableComponents', {
				"FNFAL_Handguard",
			},
			'DefaultComponent', "FNFAL_Handguard",
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
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ScopeCOG",
				"ScopeCOGQuick",
				"LROptics",
				"ThermalScope",
				"ReflexSight",
				"ReflexSightAdvanced",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
				"Suppressor",
				"ImprovisedSuppressor",
				"MuzzleBooster",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagNormalFine",
				"MagLarge",
				"MagLargeFine",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Bipod",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelNormalImproved",
				"BarrelHeavy",
				"BarrelLong",
				"BarrelLongImproved",
				"BarrelShort",
				"BarrelShortImproved",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'AvailableComponents', {
				"MagLarge",
				"MagLargeFine",
				"MagNormal",
				"MagNormalFine",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockNormal",
				"StockHeavy",
				"StockLight",
			},
			'DefaultComponent', "StockNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"GrenadeLauncher",
				"TacGrip",
				"VerticalGrip",
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
	ReadyAP = 3000,
}

