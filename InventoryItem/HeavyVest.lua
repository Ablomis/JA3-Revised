UndefineClass('HeavyVest')
DefineClass.HeavyVest = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_vest",
	DisplayName = T(207745004833, --[[ModItemInventoryItemCompositeDef HeavyVest DisplayName]] "Heavy Vest"),
	DisplayNamePlural = T(926739004584, --[[ModItemInventoryItemCompositeDef HeavyVest DisplayNamePlural]] "Heavy Vests"),
	AdditionalHint = T(121560514640, --[[ModItemInventoryItemCompositeDef HeavyVest AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 3,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Torso" ),
}

