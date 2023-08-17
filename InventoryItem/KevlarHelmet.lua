UndefineClass('KevlarHelmet')
DefineClass.KevlarHelmet = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 2,
	Icon = "UI/Icons/Items/kevlar_helmet",
	DisplayName = T(290235971069, --[[ModItemInventoryItemCompositeDef KevlarHelmet DisplayName]] "Kevlar Helmet"),
	DisplayNamePlural = T(215125162345, --[[ModItemInventoryItemCompositeDef KevlarHelmet DisplayNamePlural]] "Kevlar Helmets"),
	Slot = "Head",
	PenetrationClass = 2,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Head" ),
}

