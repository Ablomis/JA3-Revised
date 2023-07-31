UndefineClass('ColtAnaconda')
DefineClass.ColtAnaconda = {
	__parents = { "Revolver" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Revolver",
	RepairCost = 30,
	Reliability = 95,
	ScrapParts = 8,
	Icon = "UI/Icons/Weapons/Anaconda",
	DisplayName = T(118793816489, --[[ModItemInventoryItemCompositeDef ColtAnaconda DisplayName]] "Anaconda"),
	DisplayNamePlural = T(776697365231, --[[ModItemInventoryItemCompositeDef ColtAnaconda DisplayNamePlural]] "Anacondas"),
	Description = T(761085981984, --[[ModItemInventoryItemCompositeDef ColtAnaconda Description]] "Double-action revolver with a swing out cylinder. High reliability and stopping power shot after shot. "),
	AdditionalHint = T(234284455558, --[[ModItemInventoryItemCompositeDef ColtAnaconda AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Improved armor penetration\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Slower Condition loss"),
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 1800,
	Caliber = "44CAL",
	Damage = 24,
	AimAccuracy = 5,
	MagazineSize = 6,
	PenetrationClass = 2,
	DamageFalloff = 40,
	PointBlankRange = true,
	OverwatchAngle = 2160,
	Entity = "Weapon_ColtAnaconda44",
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
			'SlotType', "Scope",
			'AvailableComponents', {
				"BaseIronsight_Anaconda",
				"ImprovedIronsight",
				"ReflexSight",
				"ReflexSightAdvanced",
				"ScopeCOG",
				"ScopeCOGQuick",
				"LaserDot_Anaconda",
				"FlashlightDot_Anaconda",
				"UVDot_Anaconda",
			},
			'DefaultComponent', "BaseIronsight_Anaconda",
		}),
	},
	HolsterSlot = "Leg",
	AvailableAttacks = {
		"SingleShot",
		"DualShot",
		"CancelShot",
		"MobileShot",
	},
	ShootAP = 5000,
	ReloadAP = 3000,
}

