UndefineClass('Winchester1894')
DefineClass.Winchester1894 = {
	__parents = { "SniperRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SniperRifle",
	Reliability = 95,
	ScrapParts = 8,
	Icon = "UI/Icons/Weapons/Winchester",
	DisplayName = T(741069182513, --[[ModItemInventoryItemCompositeDef Winchester1894 DisplayName]] "Winchester 1894"),
	DisplayNamePlural = T(233963180429, --[[ModItemInventoryItemCompositeDef Winchester1894 DisplayNamePlural]] "Winchester 1894s"),
	Description = T(707441453749, --[[ModItemInventoryItemCompositeDef Winchester1894 Description]] 'One of the guns that "won the West". The magazine tube holds more ammo than your standard bolt action rifle. How this one got in this part of the world is anyone\'s guess.'),
	AdditionalHint = T(864256930516, --[[ModItemInventoryItemCompositeDef Winchester1894 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High Crit chance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Low attack costs\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Shorter range"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 1250,
	Caliber = "44CAL",
	Damage = 25,
	AimAccuracy = 5,
	CritChanceScaled = 20,
	MagazineSize = 9,
	WeaponRange = 24,
	DamageFalloff = 90,
	Recoil = 28,
	OverwatchAngle = 360,
	NotDeployedPenalty = 10,
	HandSlot = "TwoHanded",
	Entity = "Weapon_Winchester",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelLong",
				"BarrelNormal",
				"BarrelShort_Winchester",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ImprovisedSuppressor",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ImprovedIronsight",
				"LROptics",
				"LROpticsAdvanced",
				"ReflexSight",
				"ReflexSightAdvanced",
				"ScopeCOG",
				"ScopeCOGQuick",
				"ThermalScope",
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
	ShootAP = 7000,
	ReloadAP = 3000,
	ReadyAP = 2000,
}

