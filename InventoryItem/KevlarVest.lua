UndefineClass('KevlarVest')
DefineClass.KevlarVest = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 6,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_armor",
	DisplayName = T(448831102560, --[[ModItemInventoryItemCompositeDef KevlarVest DisplayName]] "Kevlar Armor"),
	DisplayNamePlural = T(926279369253, --[[ModItemInventoryItemCompositeDef KevlarVest DisplayNamePlural]] "Kevlar Armors"),
	PenetrationClass = 2,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

