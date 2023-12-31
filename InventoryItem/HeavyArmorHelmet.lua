UndefineClass('HeavyArmorHelmet')
DefineClass.HeavyArmorHelmet = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 2,
	Icon = "UI/Icons/Items/heavy_helmet",
	DisplayName = T(487343226522, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet DisplayName]] "Heavy Armor Helmet"),
	DisplayNamePlural = T(117526344678, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet DisplayNamePlural]] "Heavy Armor Helmets"),
	AdditionalHint = T(900817449420, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	Slot = "Head",
	PenetrationClass = 3,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Head" ),
}

