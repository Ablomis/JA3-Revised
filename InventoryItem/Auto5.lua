UndefineClass('Auto5')
DefineClass.Auto5 = {
	__parents = { "Shotgun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Shotgun",
	RepairCost = 50,
	Reliability = 20,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/Browning Auto-5",
	DisplayName = T(168346986279, --[[ModItemInventoryItemCompositeDef Auto5 DisplayName]] "Auto-5"),
	DisplayNamePlural = T(616333971173, --[[ModItemInventoryItemCompositeDef Auto5 DisplayNamePlural]] "Auto-5s"),
	Description = T(953932195235, --[[ModItemInventoryItemCompositeDef Auto5 Description]] "First mass produced semi-automatic shotgun in the world. Turned out it was one hell of a good gun for jungle close-quarter firefights. "),
	AdditionalHint = T(404519137847, --[[ModItemInventoryItemCompositeDef Auto5 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Low attack costs"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 1200,
	Caliber = "12gauge",
	Damage = 26,
	ObjDamageMod = 150,
	AimAccuracy = 4,
	MagazineSize = 5,
	WeaponRange = 8,
	PointBlankRange = true,
	OverwatchAngle = 1200,
	BuckshotConeAngle = 1200,
	HandSlot = "TwoHanded",
	Entity = "Weapon_Auto5",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"DuckbillChoke",
				"FullChoke",
				"Compensator",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"Auto5_Basic_LMag",
				"Auto5_Basic_NMag",
				"Auto5_Long_LMag",
				"Auto5_Long_NMag",
				"Auto5_Short_NMag",
			},
			'DefaultComponent', "Auto5_Basic_NMag",
		}),
	},
	HolsterSlot = "Shoulder",
	ModifyRightHandGrip = true,
	AvailableAttacks = {
		"Buckshot",
		"CancelShotCone",
	},
	ShootAP = 4000,
	ReloadAP = 3000,
	ReadyAP = 2000,
}

