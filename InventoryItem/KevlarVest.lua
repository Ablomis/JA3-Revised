UndefineClass('KevlarVest')
DefineClass.KevlarVest = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_armor",
	DisplayName = T(256000075997, --[[ModItemInventoryItemCompositeDef KevlarVest DisplayName]] "Kevlar Armor"),
	DisplayNamePlural = T(692243699312, --[[ModItemInventoryItemCompositeDef KevlarVest DisplayNamePlural]] "Kevlar Armors"),
	PenetrationClass = 2,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

