UndefineClass('FlakVest_WeavePadding')
DefineClass.FlakVest_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_vest",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(582386653630, --[[ModItemInventoryItemCompositeDef FlakVest_WeavePadding DisplayName]] "Flak Vest"),
	DisplayNamePlural = T(695504531130, --[[ModItemInventoryItemCompositeDef FlakVest_WeavePadding DisplayNamePlural]] "Flak Vests"),
	Description = "",
	AdditionalHint = T(155715286453, --[[ModItemInventoryItemCompositeDef FlakVest_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Torso" ),
}

