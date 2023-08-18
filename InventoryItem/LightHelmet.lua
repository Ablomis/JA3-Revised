UndefineClass('LightHelmet')
DefineClass.LightHelmet = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 2,
	Icon = "UI/Icons/Items/light_helmet",
	DisplayName = T(482815934105, --[[ModItemInventoryItemCompositeDef LightHelmet DisplayName]] "Light Helmet"),
	DisplayNamePlural = T(854948718972, --[[ModItemInventoryItemCompositeDef LightHelmet DisplayNamePlural]] "Light Helmets"),
	Slot = "Head",
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Head" ),
}

