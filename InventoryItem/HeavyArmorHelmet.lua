UndefineClass('HeavyArmorHelmet')
DefineClass.HeavyArmorHelmet = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 2,
	Icon = "UI/Icons/Items/heavy_helmet",
	DisplayName = T(228901791586, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet DisplayName]] "Heavy Armor Helmet"),
	DisplayNamePlural = T(929802891905, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet DisplayNamePlural]] "Heavy Armor Helmets"),
	AdditionalHint = T(108196284112, --[[ModItemInventoryItemCompositeDef HeavyArmorHelmet AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	Slot = "Head",
	PenetrationClass = 3,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Head" ),
}

