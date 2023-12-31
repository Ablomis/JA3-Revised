UndefineClass('AK47')
DefineClass.AK47 = {
	__parents = { "AssaultRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "AssaultRifle",
	RepairCost = 20,
	Reliability = 95,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/AK47",
	DisplayName = T(293703363919, --[[ModItemInventoryItemCompositeDef AK47 DisplayName]] "AK-47"),
	DisplayNamePlural = T(697105585102, --[[ModItemInventoryItemCompositeDef AK47 DisplayNamePlural]] "AK-47s"),
	Description = T(324184139596, --[[ModItemInventoryItemCompositeDef AK47 Description]] "You should not be surprised to find an AK-47 anywhere there is conflict around the world. Simple to use, reliable and dirt cheap. Over 75 million are in circulation worldwide."),
	AdditionalHint = T(917609519101, --[[ModItemInventoryItemCompositeDef AK47 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Slower Condition loss"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 800,
	Caliber = "762WP",
	Platform = "AK762",
	Damage = 25,
	BaseAccuracy = 90,
	MagazineSize = 30,
	PenetrationClass = 2,
	DamageFalloff = 80,
	Recoil = 25,
	OverwatchAngle = 1440,
	HandSlot = "TwoHanded",
	Entity = "Weapon_AK47",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Bipod",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Grenadelauncher",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"AK47_Launcher",
			},
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
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
				"MagQuick",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Handguard",
			'AvailableComponents', {
				"AK47_VerticalGrip",
				"AK47_Handguard_basic",
			},
			'DefaultComponent', "AK47_Handguard_basic",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"LROptics",
				"ReflexSight",
				"ScopeCOG",
				"ThermalScope",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
				"MuzzleBooster",
				"Suppressor",
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
	ReloadAP = 10000,
	ReadyAP = 3000,
}

