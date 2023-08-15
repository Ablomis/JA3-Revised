UndefineClass('HeavyArmorChestplate')
DefineClass.HeavyArmorChestplate = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_vest",
	DisplayName = T(308668980173, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate DisplayName]] "Heavy Vest"),
	DisplayNamePlural = T(734396635902, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate DisplayNamePlural]] "Heavy Vests"),
	AdditionalHint = T(437082510304, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 3,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Torso" ),
}
