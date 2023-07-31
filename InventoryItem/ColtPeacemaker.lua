UndefineClass('ColtPeacemaker')
DefineClass.ColtPeacemaker = {
	__parents = { "Revolver" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Revolver",
	RepairCost = 30,
	Reliability = 95,
	ScrapParts = 6,
	Icon = "UI/Icons/Weapons/Colt Peacemaker",
	DisplayName = T(170223524192, --[[ModItemInventoryItemCompositeDef ColtPeacemaker DisplayName]] "Peacemaker"),
	DisplayNamePlural = T(838225344906, --[[ModItemInventoryItemCompositeDef ColtPeacemaker DisplayNamePlural]] "Peacemakers"),
	Description = T(338888002120, --[[ModItemInventoryItemCompositeDef ColtPeacemaker Description]] "Single action revolver designed for the US army. Don't forget to carry it with one empty under the hammer unless you want a hole in your foot."),
	AdditionalHint = T(708828816228, --[[ModItemInventoryItemCompositeDef ColtPeacemaker AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Slower Condition loss"),
	UnitStat = "Marksmanship",
	Cost = 600,
	Caliber = "44CAL",
	Damage = 20,
	AimAccuracy = 4,
	MagazineSize = 6,
	PointBlankRange = true,
	OverwatchAngle = 2160,
	Entity = "Weapon_Colt",
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

