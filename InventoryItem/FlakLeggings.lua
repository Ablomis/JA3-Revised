UndefineClass('FlakLeggings')
DefineClass.FlakLeggings = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_leggings",
	DisplayName = T(629648741238, --[[ModItemInventoryItemCompositeDef FlakLeggings DisplayName]] "Flak Leggings"),
	DisplayNamePlural = T(395108337569, --[[ModItemInventoryItemCompositeDef FlakLeggings DisplayNamePlural]] "Flak Leggings"),
	Slot = "Legs",
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Groin", "Legs" ),
}

