UndefineClass('BrowningM2HMG')
DefineClass.BrowningM2HMG = {
	__parents = { "MachineGun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "MachineGun",
	Reliability = 80,
	ScrapParts = 20,
	Icon = "UI/Icons/Weapons/M2Browning",
	DisplayName = T(862051680945, --[[ModItemInventoryItemCompositeDef BrowningM2HMG DisplayName]] "M2 Browning"),
	DisplayNamePlural = T(152293621767, --[[ModItemInventoryItemCompositeDef BrowningM2HMG DisplayNamePlural]] "M2 Brownings"),
	Description = T(937636538876, --[[ModItemInventoryItemCompositeDef BrowningM2HMG Description]] "When you're a dime short of buying some tank ordnance but you won't make a compromise with power."),
	AdditionalHint = T(434400991920, --[[ModItemInventoryItemCompositeDef BrowningM2HMG AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Stationary weapon\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very high damage\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very noisy"),
	LargeItem = true,
	Cumbersome = true,
	UnitStat = "Marksmanship",
	Cost = 4200,
	Caliber = "50BMG",
	Damage = 40,
	BaseAccuracy = 70,
	MagazineSize = 100,
	PenetrationClass = 3,
	WeaponRange = 30,
	DamageFalloff = 90,
	Recoil = 28,
	OverwatchAngle = 3600,
	Noise = 30,
	HandSlot = "TwoHanded",
	Entity = "Weapon_M2Browning",
	ComponentSlots = {},
	HolsterSlot = "Shoulder",
	PreparedAttackType = "Machine Gun",
	AvailableAttacks = {
		"MGBurstFire",
	},
	ShootAP = 4000,
	ReloadAP = 6000,
	ReadyAP = 4000,
}

