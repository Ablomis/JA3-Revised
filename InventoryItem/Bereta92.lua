UndefineClass('Bereta92')
DefineClass.Bereta92 = {
	__parents = { "Pistol" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	__copy_group = "Firearm - Handgun",
	object_class = "Pistol",
	RepairCost = 70,
	Reliability = 20,
	ScrapParts = 6,
	Icon = "UI/Icons/Weapons/Beretta92F",
	DisplayName = T(940814769423, --[[ModItemInventoryItemCompositeDef Bereta92 DisplayName]] "Beretta 92F"),
	DisplayNamePlural = T(507015328330, --[[ModItemInventoryItemCompositeDef Bereta92 DisplayNamePlural]] "Beretta 92Fs"),
	Description = T(482532492963, --[[ModItemInventoryItemCompositeDef Bereta92 Description]] "The weapon that replaced the iconic 1911. Tough act to follow but the slick Italian manages to impress. "),
	AdditionalHint = T(803576887519, --[[ModItemInventoryItemCompositeDef Bereta92 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> High Crit chance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Less noisy"),
	UnitStat = "Marksmanship",
	Cost = 700,
	Caliber = "9mm",
	Damage = 18,
	AimAccuracy = 6,
	CritChanceScaled = 30,
	MagazineSize = 15,
	WeaponRange = 18,
	DamageFalloff = 40,
	PointBlankRange = true,
	OverwatchAngle = 2160,
	Noise = 10,
	Entity = "Weapon_Beretta92F",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ReflexSight",
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
			'AvailableComponents', {
				"MagLarge",
				"MagNormal",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelLong",
				"BarrelNormal",
			},
			'DefaultComponent', "BarrelNormal",
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
	},
	HolsterSlot = "Leg",
	AvailableAttacks = {
		"SingleShot",
		"DualShot",
		"CancelShot",
		"MobileShot",
	},
	ShootAP = 5000,
	ReloadAP = 3000,
}

