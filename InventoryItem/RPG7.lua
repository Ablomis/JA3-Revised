UndefineClass('RPG7')
DefineClass.RPG7 = {
	__parents = { "RocketLauncher" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "RocketLauncher",
	Reliability = 50,
	ScrapParts = 16,
	Caliber = "Warhead",
	Entity = "Weapon_RPG7_Copy",
	Icon = "UI/Icons/Weapons/RPG-7",
	DisplayName = T(728193841650, --[[ModItemInventoryItemCompositeDef RPG7 DisplayName]] "RPG-7"),
	DisplayNamePlural = T(793007034595, --[[ModItemInventoryItemCompositeDef RPG7 DisplayNamePlural]] "RPGs-7"),
	Description = T(580871032649, --[[ModItemInventoryItemCompositeDef RPG7 Description]] "Initially created as an anti-tank weapon, it's currently being used against vehicles, buildings, and generally anything else the wielders dislike."),
	AdditionalHint = T(987224437704, --[[ModItemInventoryItemCompositeDef RPG7 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Shoots Rockets in a straight line to the target\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Minor damage to characters behind the attacker\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Mishap chance increased with distance\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	LargeItem = true,
	Cumbersome = true,
	UnitStat = "Explosives",
	is_valuable = true,
	Cost = 10000,
	ObjDamageMod = 600,
	CritChanceScaled = 0,
	PenetrationClass = 5,
	WeaponRange = 45,
	HandSlot = "TwoHanded",
	HolsterSlot = "Shoulder",
	PreparedAttackType = "None",
	ShootAP = 6000,
	ReloadAP = 10000,
	ReadyAP = 2000,
	BackfireRange = 2,
	BackfireDamage = 8,
}
