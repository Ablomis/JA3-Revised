UndefineClass('FlakVest_WeavePadding')
DefineClass.FlakVest_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_vest",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(375128984392, --[[ModItemInventoryItemCompositeDef FlakVest_WeavePadding DisplayName]] "Flak Vest"),
	DisplayNamePlural = T(410777366854, --[[ModItemInventoryItemCompositeDef FlakVest_WeavePadding DisplayNamePlural]] "Flak Vests"),
	Description = "",
	AdditionalHint = T(934636119847, --[[ModItemInventoryItemCompositeDef FlakVest_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Torso" ),
}

