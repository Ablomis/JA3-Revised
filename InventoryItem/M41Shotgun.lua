UndefineClass('M41Shotgun')
DefineClass.M41Shotgun = {
	__parents = { "Shotgun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Shotgun",
	RepairCost = 50,
	Reliability = 71,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/M1014",
	DisplayName = T(183263371273, --[[ModItemInventoryItemCompositeDef M41Shotgun DisplayName]] "M1014"),
	DisplayNamePlural = T(376626654469, --[[ModItemInventoryItemCompositeDef M41Shotgun DisplayNamePlural]] "M1014s"),
	Description = T(863714207754, --[[ModItemInventoryItemCompositeDef M41Shotgun Description]] "12-gauge semi-auto slick Italian. Boasting little need for maintenance and high level of reliability, it is loved by law enforcement and military alike."),
	AdditionalHint = T(313639405986, --[[ModItemInventoryItemCompositeDef M41Shotgun AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Longer range\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 1700,
	Caliber = "12gauge",
	Damage = 32,
	ObjDamageMod = 150,
	AimAccuracy = 5,
	MagazineSize = 6,
	WeaponRange = 16,
	DamageFalloff = 20,
	Recoil = 28,
	PointBlankRange = true,
	OverwatchAngle = 1200,
	BuckshotConeAngle = 900,
	BuckshotFalloffDamage = 100,
	HandSlot = "TwoHanded",
	Entity = "Weapon_Benelli_M4",
	ComponentSlots = {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Barrel",
			'AvailableComponents', {
				"BarrelNormal",
				"BarrelShortShotgun_Benelli",
			},
			'DefaultComponent', "BarrelNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"ScopeCOG",
				"LROptics",
				"ReflexSight",
				"ThermalScope",
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
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
			},
		}),
	},
	HolsterSlot = "Shoulder",
	AvailableAttacks = {
		"Buckshot",
		"CancelShotCone",
	},
	ShootAP = 5000,
	ReloadAP = 6000,
	ReadyAP = 2000,
}

