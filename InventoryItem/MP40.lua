UndefineClass('MP40')
DefineClass.MP40 = {
	__parents = { "SubmachineGun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SubmachineGun",
	Reliability = 70,
	ScrapParts = 6,
	Icon = "UI/Icons/Weapons/MP40",
	DisplayName = T(566189362261, --[[ModItemInventoryItemCompositeDef MP40 DisplayName]] "MP40"),
	DisplayNamePlural = T(872193152468, --[[ModItemInventoryItemCompositeDef MP40 DisplayNamePlural]] "MP40s"),
	Description = T(678858435545, --[[ModItemInventoryItemCompositeDef MP40 Description]] "Initially designed for vehicle crews and paratroopers, It really became widely used when the brutal urban combat of the Eastern front showed the value of a reliable submachine gun. "),
	AdditionalHint = T(770524763314, --[[ModItemInventoryItemCompositeDef MP40 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Decreased bonus from Aiming"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 800,
	Caliber = "9mm",
	Platform = "MP40",
	Damage = 17,
	MagazineSize = 40,
	WeaponRange = 10,
	Recoil = 30,
	PointBlankRange = true,
	OverwatchAngle = 1440,
	Noise = 15,
	HandSlot = "TwoHanded",
	Entity = "Weapon_MP40",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
			},
			'DefaultComponent', "MagNormal",
		}),
	},
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"RunAndGun",
		"CancelShot",
	},
	ShootAP = 5000,
	ReloadAP = 3000,
	ReadyAP = 1000,
}

