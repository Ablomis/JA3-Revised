UndefineClass('M4Commando')
DefineClass.M4Commando = {
	__parents = { "SubmachineGun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SubmachineGun",
	Reliability = 80,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/Commando",
	DisplayName = T(914291490259, --[[ModItemInventoryItemCompositeDef M4Commando DisplayName]] "Commando"),
	DisplayNamePlural = T(686722912498, --[[ModItemInventoryItemCompositeDef M4Commando DisplayNamePlural]] "Commandos"),
	Description = T(428753788300, --[[ModItemInventoryItemCompositeDef M4Commando Description]] "How would you make a short barrel M16 work? Answer - lower muzzle velocity and huge muzzle flash."),
	AdditionalHint = T(522549742935, --[[ModItemInventoryItemCompositeDef M4Commando AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High Crit chance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 2700,
	Caliber = "556",
	Platform = "AR15",
	Damage = 20,
	AimAccuracy = 4,
	BaseAccuracy = 95,
	CritChanceScaled = 30,
	MagazineSize = 30,
	PenetrationClass = 2,
	WeaponRange = 18,
	Recoil = 15,
	PointBlankRange = true,
	OverwatchAngle = 1440,
	Noise = 15,
	HandSlot = "TwoHanded",
	Entity = "Weapon_CAR15",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'AvailableComponents', {
				"Handguard_Commando",
				"VerticalGrip_Commando",
				"GrenadeLauncher_Commando",
			},
			'DefaultComponent', "Handguard_Commando",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagNormalFine",
				"MagLarge",
				"MagLargeFine",
				"MagQuick",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockNormal",
				"StockLight",
			},
			'DefaultComponent', "StockNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"LaserDot",
				"FlashlightDot",
				"UVDot",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"LROptics",
				"ReflexSight",
				"ScopeCOG",
				"ThermalScope",
				"ReflexSightAdvanced",
				"ScopeCOGQuick",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
				"MuzzleBooster",
				"Suppressor",
				"ImprovisedSuppressor",
			},
			'DefaultComponent', "Compensator",
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
	ReloadAP = 10000,
	ReadyAP = 2000,
}

