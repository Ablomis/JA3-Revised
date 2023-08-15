UndefineClass('HeavyArmorHelmet_WeavePadding')
DefineClass.HeavyArmorHelmet_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 2,
	Icon = "UI/Icons/Items/heavy_helmet",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(312959511631, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet_WeavePadding DisplayName]] "Heavy Armor Helmet"),
	DisplayNamePlural = T(922328066335, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet_WeavePadding DisplayNamePlural]] "Heavy Armor Helmets"),
	AdditionalHint = T(189820872926, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	Slot = "Head",
	PenetrationClass = 3,
	AdditionalReduction = 50,
	ProtectedBodyParts = set( "Head" ),
}

