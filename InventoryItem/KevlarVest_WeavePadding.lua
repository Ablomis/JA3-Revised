UndefineClass('KevlarVest_WeavePadding')
DefineClass.KevlarVest_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_armor",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(266430521402, --[[ModItemInventoryItemCompositeDef KevlarVest_WeavePadding DisplayName]] "Kevlar Armor"),
	DisplayNamePlural = T(421135787078, --[[ModItemInventoryItemCompositeDef KevlarVest_WeavePadding DisplayNamePlural]] "Kevlar Armors"),
	AdditionalHint = T(337899202227, --[[ModItemInventoryItemCompositeDef KevlarVest_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	PenetrationClass = 2,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

