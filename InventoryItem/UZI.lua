UndefineClass('UZI')
DefineClass.UZI = {
	__parents = { "SubmachineGun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SubmachineGun",
	Reliability = 75,
	ScrapParts = 6,
	Icon = "UI/Icons/Weapons/UZI",
	DisplayName = T(466347174849, --[[ModItemInventoryItemCompositeDef UZI DisplayName]] "UZI"),
	DisplayNamePlural = T(552875844935, --[[ModItemInventoryItemCompositeDef UZI DisplayNamePlural]] "UZIs"),
	Description = T(200256486550, --[[ModItemInventoryItemCompositeDef UZI Description]] "Designed as a personal defense weapon for rear echelon troops in the Israel Defense Forces. Intended to be used with a buttstock, but regularly wielded one-handed. Can deliver a lot of lead though accuracy may vary. "),
	AdditionalHint = T(265307145163, --[[ModItemInventoryItemCompositeDef UZI AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Decreased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Less noisy\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Firing Modes: Burst, Auto"),
	UnitStat = "Marksmanship",
	Cost = 1200,
	Caliber = "9mm",
	Platform = "UZI",
	Damage = 17,
	AimAccuracy = 3,
	BaseAccuracy = 90,
	MagazineSize = 25,
	WeaponRange = 16,
	Recoil = 20,
	PointBlankRange = true,
	OverwatchAngle = 1440,
	Noise = 10,
	Entity = "Weapon_Uzi",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelNormalImproved",
				"BarrelLong",
				"BarrelLongImproved",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"LaserDot",
				"FlashlightDot",
				"UVDot",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
				"MagLargeFine",
				"MagNormalFine",
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
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
				"Suppressor",
			},
		}),
	},
	HolsterSlot = "Leg",
	AvailableAttacks = {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"DualShot",
		"RunAndGun",
		"CancelShot",
	},
	ShootAP = 5000,
	ReloadAP = 10000,
}

