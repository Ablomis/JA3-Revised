UndefineClass('DragunovSVD')
DefineClass.DragunovSVD = {
	__parents = { "SniperRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "SniperRifle",
	Reliability = 50,
	ScrapParts = 14,
	Icon = "UI/Icons/Weapons/Dragunov",
	DisplayName = T(856644725501, --[[ModItemInventoryItemCompositeDef DragunovSVD DisplayName]] "Dragunov"),
	DisplayNamePlural = T(219061391007, --[[ModItemInventoryItemCompositeDef DragunovSVD DisplayNamePlural]] "Dragunovs"),
	Description = T(545235852014, --[[ModItemInventoryItemCompositeDef DragunovSVD Description]] "Not what it seems at first glance. On the outside it looks like an AK but actually uses a short stroke gas piston system that reduces the recoil and allows for better follow up shots. It is more of a close support designated marksman's rifle than a sniper one. "),
	AdditionalHint = T(949800283910, --[[ModItemInventoryItemCompositeDef DragunovSVD AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Decreased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very noisy\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Rifle with Burst firing mode"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 1750,
	Caliber = "762x54R",
	Damage = 30,
	AimAccuracy = 3,
	BaseAccuracy = 95,
	CritChance = 10,
	CritChanceScaled = 0,
	MagazineSize = 10,
	PenetrationClass = 2,
	WeaponRange = 40,
	DamageFalloff = 90,
	Recoil = 28,
	OverwatchAngle = 360,
	Noise = 30,
	HandSlot = "TwoHanded",
	Entity = "Weapon_Dragunov",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockHeavy",
				"StockLight",
				"StockNormal",
			},
			'DefaultComponent', "StockNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Bipod",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'AvailableComponents', {
				"LROptics_DragunovDefault",
				"ReflexSight",
				"ScopeCOG",
				"ThermalScope",
				"LROpticsAdvanced",
				"ReflexSightAdvanced",
				"ScopeCOGQuick",
			},
			'DefaultComponent', "LROptics_DragunovDefault",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'AvailableComponents', {
				"Compensator",
				"Suppressor",
			},
			'DefaultComponent', "Compensator",
		}),
	},
	HolsterSlot = "Shoulder",
	PreparedAttackType = "Both",
	AvailableAttacks = {
		"SingleShot",
		"BurstFire",
		"CancelShot",
	},
	ShootAP = 7000,
	ReloadAP = 3000,
	ReadyAP = 3000,
}

