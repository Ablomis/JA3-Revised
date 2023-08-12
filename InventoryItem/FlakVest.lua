UndefineClass('FlakVest')
DefineClass.FlakVest = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 6,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_vest",
	DisplayName = T(601946241108, --[[ModItemInventoryItemCompositeDef FlakVest DisplayName]] "Flak Vest"),
	DisplayNamePlural = T(671528401835, --[[ModItemInventoryItemCompositeDef FlakVest DisplayNamePlural]] "Flak Vests"),
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Torso" ),
}

