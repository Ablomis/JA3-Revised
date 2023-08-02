UndefineClass('GoldenGun')
DefineClass.GoldenGun = {
	__parents = { "SniperRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SniperRifle",
	Reliability = 80,
	ScrapParts = 16,
	Icon = "UI/Icons/Weapons/GoldenGun",
	DisplayName = T(816582192750, --[[ModItemInventoryItemCompositeDef GoldenGun DisplayName]] "Gold Fever"),
	DisplayNamePlural = T(999086038482, --[[ModItemInventoryItemCompositeDef GoldenGun DisplayNamePlural]] "Gold Fever"),
	Description = T(100758936060, --[[ModItemInventoryItemCompositeDef GoldenGun Description]] "This custom-made M14 is coated with 24-karat gold and has a mean aura."),
	AdditionalHint = T(153539718759, --[[ModItemInventoryItemCompositeDef GoldenGun AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Insensitive\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very noisy"),
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
	Noise = 40,
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

