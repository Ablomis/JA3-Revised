UndefineClass('FlakArmor')
DefineClass.FlakArmor = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_armor",
	DisplayName = T(318057181173, --[[ModItemInventoryItemCompositeDef FlakArmor DisplayName]] "Flak Armor"),
	DisplayNamePlural = T(767452718732, --[[ModItemInventoryItemCompositeDef FlakArmor DisplayNamePlural]] "Flak Armors"),
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

