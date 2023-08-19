UndefineClass('PSG1')
DefineClass.PSG1 = {
	__parents = { "SniperRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SniperRifle",
	Reliability = 53,
	ScrapParts = 14,
	Icon = "UI/Icons/Weapons/PSG1",
	DisplayName = T(309730176554, --[[ModItemInventoryItemCompositeDef PSG1 DisplayName]] "PSG1"),
	DisplayNamePlural = T(576513658185, --[[ModItemInventoryItemCompositeDef PSG1 DisplayNamePlural]] "PSG1s"),
	Description = T(608529480545, --[[ModItemInventoryItemCompositeDef PSG1 Description]] 'Semi-auto precision rifle initially designed for law enforcement after the 1972 Munich Olympics. They skipped adding any iron sights and went straight to a scope. Adjustable buttstock, cheekpiece, trigger unit, and much more. This gun screams "I can watch this hostage situation all day as I wait for the greenlight". '),
	AdditionalHint = T(743930355246, --[[ModItemInventoryItemCompositeDef PSG1 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High Crit chance"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	is_valuable = true,
	Cost = 3200,
	Caliber = "762NATO",
	Platform = "M14",
	Damage = 30,
	AimAccuracy = 5,
	CritChanceScaled = 30,
	MagazineSize = 5,
	PenetrationClass = 2,
	WeaponRange = 36,
	DamageFalloff = 90,
	Recoil = 28,
	OverwatchAngle = 360,
	HandSlot = "TwoHanded",
	Entity = "Weapon_PSG1",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockNormal",
				"StockHeavy",
			},
			'DefaultComponent', "StockNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'AvailableComponents', {
				"Bipod",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ImprovisedSuppressor",
				"Suppressor",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagNormalFine",
				"MagLarge",
				"MagLargeFine",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'AvailableComponents', {
				"PSG_DefaultScope",
				"LROpticsAdvanced",
				"ReflexSight",
				"ReflexSightAdvanced",
				"ScopeCOG",
				"ScopeCOGQuick",
				"ThermalScope",
			},
			'DefaultComponent', "PSG_DefaultScope",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"FlashlightDot_PSG_M1",
				"Flashlight_PSG_M1",
				"LaserDot_PSG_M1",
				"UVDot_PSG_M1",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	PreparedAttackType = "Both",
	AvailableAttacks = {
		"SingleShot",
		"CancelShot",
	},
	ShootAP = 7000,
	ReloadAP = 10000,
	ReadyAP = 4000,
}

