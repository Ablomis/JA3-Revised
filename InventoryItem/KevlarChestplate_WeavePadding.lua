UndefineClass('KevlarChestplate_WeavePadding')
DefineClass.KevlarChestplate_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_vest",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(965782402014, --[[ModItemInventoryItemCompositeDef KevlarChestplate_WeavePadding DisplayName]] "Kevlar Vest"),
	DisplayNamePlural = T(254943538020, --[[ModItemInventoryItemCompositeDef KevlarChestplate_WeavePadding DisplayNamePlural]] "Kevlar Vests"),
	AdditionalHint = T(811673426506, --[[ModItemInventoryItemCompositeDef KevlarChestplate_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	PenetrationClass = 2,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Torso" ),
}

