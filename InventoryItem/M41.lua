UndefineClass('M41')
DefineClass.M41 = {
	__parents = { "Shotgun" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Shotgun",
	RepairCost = 50,
	Reliability = 71,
	ScrapParts = 10,
	Icon = "UI/Icons/Weapons/M1014",
	DisplayName = T(660138182899, --[[ModItemInventoryItemCompositeDef M41 DisplayName]] "M1014"),
	DisplayNamePlural = T(439709606589, --[[ModItemInventoryItemCompositeDef M41 DisplayNamePlural]] "M1014s"),
	Description = T(643676233348, --[[ModItemInventoryItemCompositeDef M41 Description]] "12-gauge semi-auto slick Italian. Boasting little need for maintenance and high level of reliability, it is loved by law enforcement and military alike."),
	AdditionalHint = T(803836363845, --[[ModItemInventoryItemCompositeDef M41 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Longer range\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Increased bonus from Aiming"),
	LargeItem = true,
	UnitStat = "Marksmanship",
	Cost = 1700,
	Caliber = "12gauge",
	Damage = 32,
	ObjDamageMod = 150,
	AimAccuracy = 5,
	MagazineSize = 6,
	WeaponRange = 16,
	Recoil = 12,
	PointBlankRange = true,
	OverwatchAngle = 1200,
	BuckshotConeAngle = 900,
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
	ReloadAP = 3000,
	ReadyAP = 2000,
}

