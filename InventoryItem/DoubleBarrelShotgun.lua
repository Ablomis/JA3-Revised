UndefineClass('DoubleBarrelShotgun')
DefineClass.DoubleBarrelShotgun = {
	__parents = { "Shotgun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Shotgun",
	RepairCost = 50,
	Reliability = 50,
	ScrapParts = 8,
	Icon = "UI/Icons/Weapons/Double-barrelled Shotgun",
	DisplayName = T(606270505268, --[[ModItemInventoryItemCompositeDef DoubleBarrelShotgun DisplayName]] "Double-Barrel"),
	DisplayNamePlural = T(228351734678, --[[ModItemInventoryItemCompositeDef DoubleBarrelShotgun DisplayNamePlural]] "Double-Barrels"),
	Description = T(651294078680, --[[ModItemInventoryItemCompositeDef DoubleBarrelShotgun Description]] "A simple hunting weapon. Fancier combat shotguns can shoot semi and fully automatic but only the double-barrel can shoot two shells at once. "),
	AdditionalHint = T(158662174720, --[[ModItemInventoryItemCompositeDef DoubleBarrelShotgun AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High Crit chance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Limited ammo capacity\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Greatly decreased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Special firing mode: Double Barrel"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 700,
	Caliber = "12gauge",
	Damage = 28,
	ObjDamageMod = 150,
	AimAccuracy = 1,
	CritChanceScaled = 30,
	MagazineSize = 2,
	WeaponRange = 16,
	Recoil = 7,
	PointBlankRange = true,
	OverwatchAngle = 1200,
	BuckshotConeAngle = 900,
	HandSlot = "TwoHanded",
	Entity = "Weapon_DBShotgun",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelLongShotgun",
				"BarrelNormal",
				"BarrelShortShotgun",
			},
			'DefaultComponent', "BarrelNormal",
		}),
	},
	HolsterSlot = "Shoulder",
	ModifyRightHandGrip = true,
	AvailableAttacks = {
		"Buckshot",
		"DoubleBarrel",
		"CancelShotCone",
	},
	ShootAP = 5000,
	ReloadAP = 3000,
	ReadyAP = 2000,
}

