UndefineClass('FlakLeggings_WeavePadding')
DefineClass.FlakLeggings_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_leggings",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(829864672018, --[[ModItemInventoryItemCompositeDef FlakLeggings_WeavePadding DisplayName]] "Flak Leggings"),
	DisplayNamePlural = T(271743784546, --[[ModItemInventoryItemCompositeDef FlakLeggings_WeavePadding DisplayNamePlural]] "Flak Leggings"),
	Description = "",
	AdditionalHint = T(968629960765, --[[ModItemInventoryItemCompositeDef FlakLeggings_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	Slot = "Legs",
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Groin", "Legs" ),
}

