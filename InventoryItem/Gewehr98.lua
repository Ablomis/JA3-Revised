UndefineClass('Gewehr98')
DefineClass.Gewehr98 = {
	__parents = { "SniperRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SniperRifle",
	Reliability = 25,
	ScrapParts = 8,
	Icon = "UI/Icons/Weapons/Gewehr98",
	DisplayName = T(136989751826, --[[ModItemInventoryItemCompositeDef Gewehr98 DisplayName]] "Gewehr 98"),
	DisplayNamePlural = T(171595257376, --[[ModItemInventoryItemCompositeDef Gewehr98 DisplayNamePlural]] "Gewehr 98s"),
	Description = T(886179819584, --[[ModItemInventoryItemCompositeDef Gewehr98 Description]] "It is said that this Mauser design is the grandpa of all bolt action rifles. Even the modern hunting or military sniper rifles started here. "),
	AdditionalHint = T(165416275520, --[[ModItemInventoryItemCompositeDef Gewehr98 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Shorter range\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very noisy"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 1250,
	Caliber = "762NATO",
	Damage = 27,
	AimAccuracy = 5,
	MagazineSize = 5,
	PenetrationClass = 2,
	WeaponRange = 32,
	DamageFalloff = 90,
	OverwatchAngle = 360,
	Noise = 30,
	HandSlot = "TwoHanded",
	Entity = "Weapon_Gewehr98",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'AvailableComponents', {
				"LROptics",
				"ReflexSight",
				"ScopeCOG",
				"GewehrDefaultSight",
				"ImprovedIronsight",
				"ReflexSightAdvanced",
				"ScopeCOGQuick",
				"ThermalScope",
			},
			'DefaultComponent', "GewehrDefaultSight",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ImprovisedSuppressor",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	ModifyRightHandGrip = true,
	PreparedAttackType = "Both",
	AvailableAttacks = {
		"SingleShot",
		"CancelShot",
	},
	ShootAP = 8000,
	ReloadAP = 3000,
	ReadyAP = 3000,
}

