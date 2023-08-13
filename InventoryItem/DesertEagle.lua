UndefineClass('DesertEagle')
DefineClass.DesertEagle = {
	__parents = { "Pistol" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Pistol",
	RepairCost = 70,
	Reliability = 20,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/DesertEagle",
	DisplayName = T(414889211716, --[[ModItemInventoryItemCompositeDef DesertEagle DisplayName]] "Desert Eagle"),
	DisplayNamePlural = T(394539400894, --[[ModItemInventoryItemCompositeDef DesertEagle DisplayNamePlural]] "Desert Eagles"),
	Description = T(565227527190, --[[ModItemInventoryItemCompositeDef DesertEagle Description]] "Everybody knows the Desert Eagle as a .50 caliber hand cannon but the .44 barrel can make it much more practical and affordable to shoot. "),
	AdditionalHint = T(551477999708, --[[ModItemInventoryItemCompositeDef DesertEagle AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High damage\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Improved armor penetration\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Shorter range\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very noisy"),
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 3000,
	Caliber = "44CAL",
	Platform = "DesertEagle",
	Damage = 28,
	ObjDamageMod = 200,
	AimAccuracy = 4,
	BaseAccuracy = 90,
	MagazineSize = 7,
	PenetrationClass = 2,
	WeaponRange = 12,
	PointBlankRange = true,
	OverwatchAngle = 2160,
	Entity = "Weapon_DesertEagle",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ReflexSight",
				"ReflexSightAdvanced",
				"ImprovedIronsight",
			},
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
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelLong",
				"BarrelNormal",
				"Barrel50BMG_DesertEagle",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Suppressor",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"FlashlightDot",
				"Flashlight",
				"LaserDot",
				"UVDot",
			},
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
	ReloadAP = 3000,
}

