UndefineClass('HiPower')
DefineClass.HiPower = {
	__parents = { "Pistol" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Pistol",
	RepairCost = 70,
	Reliability = 50,
	ScrapParts = 6,
	Icon = "UI/Icons/Weapons/Browning HiPower",
	DisplayName = T(909669071072, --[[ModItemInventoryItemCompositeDef HiPower DisplayName]] "Hi-Power"),
	DisplayNamePlural = T(237819683973, --[[ModItemInventoryItemCompositeDef HiPower DisplayNamePlural]] "Hi-Powers"),
	Description = T(120518413996, --[[ModItemInventoryItemCompositeDef HiPower Description]] "Used by both the Nazis and Allies during WWII. The hammer has a tendency to bite. "),
	AdditionalHint = T(486978760958, --[[ModItemInventoryItemCompositeDef HiPower AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High damage\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Decreased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Limited customization options"),
	UnitStat = "Marksmanship",
	Cost = 500,
	Caliber = "9mm",
	Platform = "HiPower",
	Damage = 17,
	AimAccuracy = 4,
	BaseAccuracy = 95,
	MagazineSize = 10,
	WeaponRange = 9,
	DamageFalloff = 40,
	PointBlankRange = true,
	OverwatchAngle = 2160,
	Entity = "Weapon_Browning_HP",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ImprovisedSuppressor",
				"Suppressor",
				"Compensator",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagLarge",
				"MagNormal",
				"MagLargeFine",
				"MagNormalFine",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelNormalImproved",
				"BarrelShort",
				"BarrelShortImproved",
				"BarrelLong",
				"BarrelLongImproved",
			},
			'DefaultComponent', "BarrelNormal",
		}),
	},
	HolsterSlot = "Leg",
	AvailableAttacks = {
		"SingleShot",
		"DualShot",
		"CancelShot",
		"MobileShot",
	},
	ShootAP = 4000,
	ReloadAP = 10000,
}

