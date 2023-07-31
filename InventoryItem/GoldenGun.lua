UndefineClass('GoldenGun')
DefineClass.GoldenGun = {
	__parents = { "SniperRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SniperRifle",
	Reliability = 80,
	ScrapParts = 16,
	Icon = "UI/Icons/Weapons/GoldenGun",
	DisplayName = T(397451784612, --[[ModItemInventoryItemCompositeDef GoldenGun DisplayName]] "Gold Fever"),
	DisplayNamePlural = T(100838803930, --[[ModItemInventoryItemCompositeDef GoldenGun DisplayNamePlural]] "Gold Fever"),
	Description = T(781699606764, --[[ModItemInventoryItemCompositeDef GoldenGun Description]] "This custom-made M14 is coated with 24-karat gold and has a mean aura."),
	AdditionalHint = T(308370421640, --[[ModItemInventoryItemCompositeDef GoldenGun AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Insensitive\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very noisy"),
	LargeItem = true,
	Cumbersome = true,
	is_valuable = true,
	Cost = 3000,
	Caliber = "762NATO",
	Damage = 50,
	AimAccuracy = 7,
	PenetrationClass = 3,
	IgnoreCoverReduction = 1,
	WeaponRange = 36,
	OverwatchAngle = 360,
	Noise = 30,
	HandSlot = "TwoHanded",
	Entity = "Weapon_M14_GoldEquip",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'Modifiable', false,
			'AvailableComponents', {
				"Bipod",
			},
			'DefaultComponent', "Bipod",
		}),
	},
	HolsterSlot = "Shoulder",
	ModifyRightHandGrip = true,
	PreparedAttackType = "Both",
	AvailableAttacks = {
		"SingleShot",
	},
	ShootAP = 7000,
	ReloadAP = 3000,
	ReadyAP = 2000,
}

