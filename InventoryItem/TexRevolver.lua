UndefineClass('TexRevolver')
DefineClass.TexRevolver = {
	__parents = { "Revolver" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Revolver",
	RepairCost = 50,
	Reliability = 95,
	ScrapParts = 8,
	Icon = "UI/Icons/Weapons/TexRevolver",
	DisplayName = T(455395513471, --[[ModItemInventoryItemCompositeDef TexRevolver DisplayName]] "Custom Six-Shooter"),
	DisplayNamePlural = T(595949091928, --[[ModItemInventoryItemCompositeDef TexRevolver DisplayNamePlural]] "Custom Six-Shooters"),
	Description = T(500719653611, --[[ModItemInventoryItemCompositeDef TexRevolver Description]] "A custom-built revolver with a 10-inch barrel and ivory handle featuring TEX engraved in a 14K gold."),
	AdditionalHint = T(816428269653, --[[ModItemInventoryItemCompositeDef TexRevolver AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High Crit chance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Slower Condition loss"),
	UnitStat = "Marksmanship",
	Cost = 2000,
	locked = true,
	Caliber = "44CAL",
	Damage = 20,
	AimAccuracy = 5,
	BaseAccuracy = 95,
	CritChanceScaled = 30,
	MagazineSize = 6,
	WeaponRange = 12,
	DamageFalloff = 45,
	PointBlankRange = true,
	OverwatchAngle = 2160,
	Entity = "Weapon_Colt",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'Modifiable', false,
			'AvailableComponents', {
				"BarrelNormal",
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
	ReloadAP = 5000,
}

