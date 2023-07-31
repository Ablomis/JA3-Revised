UndefineClass('MG42')
DefineClass.MG42 = {
	__parents = { "MachineGun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "MachineGun",
	Reliability = 95,
	ScrapParts = 12,
	Icon = "UI/Icons/Weapons/MG42",
	DisplayName = T(853579227621, --[[ModItemInventoryItemCompositeDef MG42 DisplayName]] "MG42"),
	DisplayNamePlural = T(485873631017, --[[ModItemInventoryItemCompositeDef MG42 DisplayNamePlural]] "MG42s"),
	Description = T(276874854831, --[[ModItemInventoryItemCompositeDef MG42 Description]] "With its incredible rate of fire, the MG42 provides amazing suppression capacity. She might be old but she's German."),
	AdditionalHint = T(428196745000, --[[ModItemInventoryItemCompositeDef MG42 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Less accurate when fired from the hip"),
	LargeItem = true,
	Cumbersome = true,
	UnitStat = "Marksmanship",
	Cost = 1200,
	Caliber = "762NATO",
	Damage = 28,
	MagazineSize = 100,
	PenetrationClass = 2,
	WeaponRange = 30,
	DamageFalloff = 90,
	Recoil = 28,
	OverwatchAngle = 1800,
	HandSlot = "TwoHanded",
	Entity = "Weapon_MG42",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'Modifiable', false,
			'AvailableComponents', {
				"Bipod_MG42",
			},
			'DefaultComponent', "Bipod_MG42",
		}),
	},
	HolsterSlot = "Shoulder",
	PreparedAttackType = "Machine Gun",
	AvailableAttacks = {
		"MGBurstFire",
	},
	ShootAP = 4000,
	ReloadAP = 5000,
	ReadyAP = 4000,
}

