UndefineClass('LightHelmet')
DefineClass.LightHelmet = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 2,
	Icon = "UI/Icons/Items/light_helmet",
	DisplayName = T(653911002682, --[[ModItemInventoryItemCompositeDef LightHelmet DisplayName]] "Light Helmet"),
	DisplayNamePlural = T(427462920342, --[[ModItemInventoryItemCompositeDef LightHelmet DisplayNamePlural]] "Light Helmets"),
	Slot = "Head",
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Head" ),
}

