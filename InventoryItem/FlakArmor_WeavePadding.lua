UndefineClass('FlakArmor_WeavePadding')
DefineClass.FlakArmor_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_armor",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(889907460208, --[[ModItemInventoryItemCompositeDef FlakArmor_WeavePadding DisplayName]] "Flak Armor"),
	DisplayNamePlural = T(801284434774, --[[ModItemInventoryItemCompositeDef FlakArmor_WeavePadding DisplayNamePlural]] "Flak Armors"),
	AdditionalHint = T(932889933713, --[[ModItemInventoryItemCompositeDef FlakArmor_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

