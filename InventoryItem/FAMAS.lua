UndefineClass('FAMAS')
DefineClass.FAMAS = {
	__parents = { "AssaultRifle" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "AssaultRifle",
	Reliability = 70,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/FAMAS",
	DisplayName = T(526827393323, --[[ModItemInventoryItemCompositeDef FAMAS DisplayName]] "FAMAS"),
	DisplayNamePlural = T(515712859511, --[[ModItemInventoryItemCompositeDef FAMAS DisplayNamePlural]] "FAMAS's"),
	Description = T(124937011554, --[[ModItemInventoryItemCompositeDef FAMAS Description]] "Bullpup design with utility and ergonomics in mind. The magazines were designed to be single-use and disposable. But no design survives contact with reality - soldiers started reusing them and running into all sorts of problems. A durable mag was later introduced. "),
	AdditionalHint = T(438009532263, --[[ModItemInventoryItemCompositeDef FAMAS AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Low damage\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Low attack costs\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased Reload cost\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Less noisy"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 800,
	Caliber = "556",
	Platform = "FAMAS",
	Damage = 20,
	AimAccuracy = 4,
	BaseAccuracy = 95,
	MagazineSize = 25,
	PenetrationClass = 2,
	DamageFalloff = 75,
	Recoil = 15,
	OverwatchAngle = 1440,
	Noise = 10,
	HandSlot = "TwoHanded",
	Entity = "Weapon_FAMAS",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Under",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"VerticalGrip",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Bipod",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"LaserDot",
				"FlashlightDot",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"LROptics",
				"ReflexSight",
				"ScopeCOGQuick",
				"ScopeCOG",
				"ThermalScope",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'AvailableComponents', {
				"Compensator",
				"Suppressor",
				"ImprovisedSuppressor",
			},
			'DefaultComponent', "Compensator",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'Modifiable', false,
			'CanBeEmpty', true,
			'AvailableComponents', {
				"MagNormal",
			},
			'DefaultComponent', "MagNormal",
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
	ReadyAP = 2000,
}

