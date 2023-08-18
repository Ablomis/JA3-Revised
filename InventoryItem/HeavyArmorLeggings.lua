UndefineClass('HeavyArmorLeggings')
DefineClass.HeavyArmorLeggings = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_leggings",
	DisplayName = T(453269471038, --[[ModItemInventoryItemCompositeDef HeavyArmorLeggings DisplayName]] "Heavy Armor Leggings"),
	DisplayNamePlural = T(797453000557, --[[ModItemInventoryItemCompositeDef HeavyArmorLeggings DisplayNamePlural]] "Heavy Armor Leggings"),
	AdditionalHint = T(943746423837, --[[ModItemInventoryItemCompositeDef HeavyArmorLeggings AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	Slot = "Legs",
	PenetrationClass = 3,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Groin", "Legs" ),
}

