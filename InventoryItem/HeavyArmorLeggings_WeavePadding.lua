UndefineClass('HeavyArmorLeggings_WeavePadding')
DefineClass.HeavyArmorLeggings_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_leggings",
	DisplayName = T(906769034974, --[[ModItemInventoryItemCompositeDef HeavyArmorLeggings_WeavePadding DisplayName]] "Heavy Armor Leggings"),
	DisplayNamePlural = T(926848263190, --[[ModItemInventoryItemCompositeDef HeavyArmorLeggings_WeavePadding DisplayNamePlural]] "Heavy Armor Leggings"),
	AdditionalHint = T(853518669280, --[[ModItemInventoryItemCompositeDef HeavyArmorLeggings_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	Slot = "Legs",
	PenetrationClass = 3,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Groin", "Legs" ),
}

