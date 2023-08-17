UndefineClass('FlakVest')
DefineClass.FlakVest = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_vest",
	DisplayName = T(692958963541, --[[ModItemInventoryItemCompositeDef FlakVest DisplayName]] "Flak Vest"),
	DisplayNamePlural = T(666274457404, --[[ModItemInventoryItemCompositeDef FlakVest DisplayNamePlural]] "Flak Vests"),
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Torso" ),
}

