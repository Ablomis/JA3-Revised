UndefineClass('HeavyArmorChestplate')
DefineClass.HeavyArmorChestplate = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_vest",
	DisplayName = T(450273100419, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate DisplayName]] "Heavy Vest"),
	DisplayNamePlural = T(278315057602, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate DisplayNamePlural]] "Heavy Vests"),
	AdditionalHint = T(435967619428, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 3,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Torso" ),
}

