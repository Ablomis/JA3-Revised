UndefineClass('AA12')
DefineClass.AA12 = {
	__parents = { "Shotgun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Shotgun",
	RepairCost = 50,
	Reliability = 80,
	ScrapParts = 12,
	Icon = "UI/Icons/Weapons/AA12",
	DisplayName = T(899836667502, --[[ModItemInventoryItemCompositeDef AA12 DisplayName]] "AA12"),
	DisplayNamePlural = T(906996263278, --[[ModItemInventoryItemCompositeDef AA12 DisplayNamePlural]] "AA12s"),
	Description = T(284800951653, --[[ModItemInventoryItemCompositeDef AA12 Description]] "Firing from an open bolt, the AA12 has more similarity with some machine guns than with other shotguns. Boasting reduced recoil for a 12-gauge round, it is made for sustained fire."),
	AdditionalHint = T(989612403590, --[[ModItemInventoryItemCompositeDef AA12 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Decreased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Special firing mode: Buckshot Burst"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 3200,
	Caliber = "12gauge",
	Damage = 26,
	ObjDamageMod = 150,
	BaseAccuracy = 75,
	MagazineSize = 15,
	WeaponRange = 14,
	Recoil = 28,
	PointBlankRange = true,
	OverwatchAngle = 1200,
	BuckshotConeAngle = 900,
	HandSlot = "TwoHanded",
	Entity = "Weapon_AA12",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelLongShotgun",
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
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ReflexSight",
				"ReflexSightAdvanced",
				"ScopeCOGQuick",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight_aa12",
				"LaserDot_aa12",
				"FlashlightDot_aa12",
				"UVDot_aa12",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Suppressor",
				"Compensator",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"BuckshotBurst",
		"Buckshot",
		"CancelShotCone",
	},
	ShootAP = 5000,
	ReloadAP = 3000,
	ReadyAP = 2000,
}

