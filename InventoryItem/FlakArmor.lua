UndefineClass('FlakArmor')
DefineClass.FlakArmor = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 6,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_armor",
	DisplayName = T(812167508849, --[[ModItemInventoryItemCompositeDef FlakArmor DisplayName]] "Flak Armor"),
	DisplayNamePlural = T(958063434218, --[[ModItemInventoryItemCompositeDef FlakArmor DisplayNamePlural]] "Flak Armors"),
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

