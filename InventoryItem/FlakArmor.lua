UndefineClass('FlakArmor')
DefineClass.FlakArmor = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_armor",
	DisplayName = T(286816691775, --[[ModItemInventoryItemCompositeDef FlakArmor DisplayName]] "Flak Armor"),
	DisplayNamePlural = T(257608673422, --[[ModItemInventoryItemCompositeDef FlakArmor DisplayNamePlural]] "Flak Armors"),
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

