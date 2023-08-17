UndefineClass('KevlarChestplate')
DefineClass.KevlarChestplate = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_vest",
	DisplayName = T(893147703722, --[[ModItemInventoryItemCompositeDef KevlarChestplate DisplayName]] "Kevlar Vest"),
	DisplayNamePlural = T(719571334204, --[[ModItemInventoryItemCompositeDef KevlarChestplate DisplayNamePlural]] "Kevlar Vests"),
	PenetrationClass = 2,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Torso" ),
}

