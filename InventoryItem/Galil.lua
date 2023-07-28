UndefineClass('Galil')
DefineClass.Galil = {
	__parents = { "AssaultRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "AssaultRifle",
	RepairCost = 50,
	Reliability = 77,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/Galil",
	DisplayName = T(544004382472, --[[ModItemInventoryItemCompositeDef Galil DisplayName]] "Galil"),
	DisplayNamePlural = T(402125270451, --[[ModItemInventoryItemCompositeDef Galil DisplayNamePlural]] "Galils"),
	Description = T(284254776964, --[[ModItemInventoryItemCompositeDef Galil Description]] "Designed with a bottle opener so the soldiers don't damage the mags while using the gun to open bottles. Tries to emulate the AK-47 for some reason. "),
	AdditionalHint = T(268602004707, --[[ModItemInventoryItemCompositeDef Galil AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High Crit chance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Longer range\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> In-built bottle opener"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 2500,
	Caliber = "762NATO",
	Damage = 28,
	AimAccuracy = 3,
	CritChanceScaled = 30,
	MagazineSize = 30,
	PenetrationClass = 2,
	WeaponRange = 30,
	DamageFalloff = 90,
	Recoil = 28,
	OverwatchAngle = 1440,
	HandSlot = "TwoHanded",
	Entity = "Weapon_Galil",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelLong",
				"BarrelNormal",
				"BarrelShort",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockHeavy",
				"StockLight",
				"StockNormal",
			},
			'DefaultComponent', "StockNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'AvailableComponents', {
				"Galil_Brake_Default",
				"Compensator",
				"Suppressor",
				"ImprovisedSuppressor",
			},
			'DefaultComponent', "Galil_Brake_Default",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'AvailableComponents', {
				"GrenadeLauncher_Galil",
				"Galil_Handguard_Default",
				"Bipod_Galil",
			},
			'DefaultComponent', "Bipod_Galil",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"LROptics",
				"ReflexSight",
				"ThermalScope",
				"ScopeCOG",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'AvailableComponents', {
				"MagLarge",
				"MagNormal",
				"MagQuick",
			},
			'DefaultComponent', "MagNormal",
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
	},
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"CancelShot",
	},
	ShootAP = 6000,
	ReloadAP = 3000,
	ReadyAP = 2000,
}

