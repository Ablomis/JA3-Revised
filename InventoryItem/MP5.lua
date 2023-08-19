UndefineClass('MP5')
DefineClass.MP5 = {
	__parents = { "SubmachineGun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SubmachineGun",
	Reliability = 85,
	ScrapParts = 8,
	Icon = "UI/Icons/Weapons/MP5",
	DisplayName = T(349595990184, --[[ModItemInventoryItemCompositeDef MP5 DisplayName]] "MP5"),
	DisplayNamePlural = T(466889965101, --[[ModItemInventoryItemCompositeDef MP5 DisplayNamePlural]] "MP5s"),
	Description = T(602412192856, --[[ModItemInventoryItemCompositeDef MP5 Description]] "The submachine gun used by most police tactical teams and counter terrorist units. It has seen a lot of action since it was introduced in the sixties, but the 9mm cartridge and the widespread availability of body armor gradually decreased the interest in the MP5. "),
	AdditionalHint = T(970236595545, --[[ModItemInventoryItemCompositeDef MP5 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Less noisy"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 1600,
	Caliber = "9mm",
	Platform = "MP5",
	Damage = 18,
	AimAccuracy = 6,
	BaseAccuracy = 97,
	MagazineSize = 30,
	WeaponRange = 16,
	BarrelLengthMod = 110,
	DamageFalloff = 60,
	Recoil = 5,
	PointBlankRange = true,
	OverwatchAngle = 1440,
	Noise = 15,
	HandSlot = "TwoHanded",
	Entity = "Weapon_MP5",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'Modifiable', false,
			'AvailableComponents', {
				"MP5_Handguard",
			},
			'DefaultComponent', "MP5_Handguard",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelLong",
			},
			'DefaultComponent', "BarrelNormal",
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
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockNormal",
				"StockHeavy",
				"StockNo",
			},
			'DefaultComponent', "StockNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"LaserDot",
				"FlashlightDot",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
				"MagQuick",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"LROptics",
				"ReflexSight",
				"ReflexSightAdvanced",
				"ScopeCOG",
				"ScopeCOGQuick",
				"ThermalScope",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
				"Suppressor",
				"ImprovisedSuppressor",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"RunAndGun",
		"CancelShot",
	},
	ShootAP = 5000,
	ReloadAP = 10000,
	ReadyAP = 1000,
}

