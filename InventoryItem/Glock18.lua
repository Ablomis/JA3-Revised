UndefineClass('Glock18')
DefineClass.Glock18 = {
	__parents = { "Pistol" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Pistol",
	RepairCost = 70,
	Reliability = 80,
	ScrapParts = 6,
	Icon = "UI/Icons/Weapons/Glock18",
	DisplayName = T(251999879778, --[[ModItemInventoryItemCompositeDef Glock18 DisplayName]] "Glock 18"),
	DisplayNamePlural = T(217889869759, --[[ModItemInventoryItemCompositeDef Glock18 DisplayNamePlural]] "Glock 18s"),
	Description = T(533217672144, --[[ModItemInventoryItemCompositeDef Glock18 Description]] "Glock 17 with a fun switch and built in compensator. 9x19mm spray in the palm of your hand. "),
	AdditionalHint = T(362890649105, --[[ModItemInventoryItemCompositeDef Glock18 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Special Burst firing mode - 4 bullets"),
	UnitStat = "Marksmanship",
	Cost = 1500,
	Caliber = "9mm",
	Damage = 17,
	AimAccuracy = 4,
	MagazineSize = 15,
	WeaponRange = 17,
	DamageFalloff = 40,
	Recoil = 25,
	PointBlankRange = true,
	OverwatchAngle = 2160,
	Entity = "Weapon_Glock18",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ReflexSight",
				"ReflexSightAdvanced_Glock",
				"ImprovedIronsight",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ImprovisedSuppressor",
				"Suppressor",
				"Compensator_Glock",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Handguard",
			'Modifiable', false,
			'AvailableComponents', {
				"MuzzleBooster_Glock18",
			},
			'DefaultComponent', "MuzzleBooster_Glock18",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'AvailableComponents', {
				"MagLarge",
				"MagNormal",
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
	},
	HolsterSlot = "Leg",
	AvailableAttacks = {
		"BurstFire",
		"SingleShot",
		"DualShot",
		"CancelShot",
		"MobileShot",
	},
	ShootAP = 5000,
	ReloadAP = 3000,
}

