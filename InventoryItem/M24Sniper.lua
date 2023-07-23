UndefineClass('M24Sniper')
DefineClass.M24Sniper = {
	__parents = { "SniperRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	__copy_group = "Firearm - Rifle",
	object_class = "SniperRifle",
	Reliability = 44,
	ScrapParts = 14,
	Icon = "UI/Icons/Weapons/M24",
	DisplayName = T(715635635668, --[[ModItemInventoryItemCompositeDef M24Sniper DisplayName]] "M24"),
	DisplayNamePlural = T(734594398655, --[[ModItemInventoryItemCompositeDef M24Sniper DisplayNamePlural]] "M24s"),
	Description = T(835133392332, --[[ModItemInventoryItemCompositeDef M24Sniper Description]] "US Army sniper weapon system that replaced the M21 (based on the M14). Apparently semi-auto was still not up to par with what snipers needed in terms of reliability and accuracy that bolt action can provide. "),
	AdditionalHint = T(342928689279, --[[ModItemInventoryItemCompositeDef M24Sniper AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Very noisy"),
	LargeItem = true,
	Cumbersome = true,
	UnitStat = "Marksmanship",
	Cost = 2500,
	Caliber = "762NATO",
	Damage = 27,
	AimAccuracy = 5,
	MagazineSize = 5,
	PenetrationClass = 2,
	WeaponRange = 36,
	OverwatchAngle = 360,
	Noise = 30,
	HandSlot = "TwoHanded",
	Entity = "Weapon_M24",
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
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'AvailableComponents', {
				"LROptics",
				"LROpticsAdvanced",
				"ReflexSight",
				"ScopeCOG",
				"ThermalScope",
			},
			'DefaultComponent', "LROptics",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
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
				"UVDot",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	PreparedAttackType = "Both",
	AvailableAttacks = {
		"SingleShot",
		"CancelShot",
	},
	ShootAP = 8000,
	ReloadAP = 3000,
	ReadyAP = 4000,
}

