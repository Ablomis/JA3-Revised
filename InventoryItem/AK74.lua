UndefineClass('AK74')
DefineClass.AK74 = {
	__parents = { "AssaultRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "AssaultRifle",
	RepairCost = 20,
	Reliability = 95,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/AK74",
	DisplayName = T(676935703959, --[[ModItemInventoryItemCompositeDef AK74 DisplayName]] "AK-74"),
	DisplayNamePlural = T(719437719823, --[[ModItemInventoryItemCompositeDef AK74 DisplayNamePlural]] "AK-74s"),
	Description = T(275756593159, --[[ModItemInventoryItemCompositeDef AK74 Description]] "The Soviets revisited their emblematic design around 1974 and this beauty was born. It has sprouted many variations but keeps the long stroke gas piston system of the original design."),
	AdditionalHint = T(874572998189, --[[ModItemInventoryItemCompositeDef AK74 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High damage\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Improved armor penetration\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Slower Condition loss"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 4000,
	Caliber = "762WP",
	Damage = 22,
	AimAccuracy = 3,
	BaseAccuracy = 90,
	MagazineSize = 30,
	PenetrationClass = 3,
	WeaponRange = 28,
	DamageFalloff = 75,
	Recoil = 20,
	OverwatchAngle = 1440,
	HandSlot = "TwoHanded",
	Entity = "Weapon_AK74",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockHeavy",
				"StockLight",
			},
			'DefaultComponent', "StockHeavy",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormalFine",
				"MagLarge",
				"MagLargeFine",
				"MagQuick",
			},
			'DefaultComponent', "MagNormalFine",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"LROptics",
				"LROpticsAdvanced",
				"ReflexSight",
				"ReflexSightAdvanced",
				"ScopeCOG",
				"ScopeCOGQuick",
				"ThermalScope",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
				"MuzzleBooster",
				"ImprovisedSuppressor",
				"Suppressor",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"GrenadeLauncher",
				"Bipod_Under",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"FlashlightDot",
				"LaserDot",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"CancelShot",
	},
	ShootAP = 6000,
	ReloadAP = 3000,
	ReadyAP = 2000,
}

