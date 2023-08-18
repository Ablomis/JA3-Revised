UndefineClass('KevlarLeggings_WeavePadding')
DefineClass.KevlarLeggings_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 4,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_leggings",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(823955368056, --[[ModItemInventoryItemCompositeDef KevlarLeggings_WeavePadding DisplayName]] "Kevlar Leggings"),
	DisplayNamePlural = T(957796596130, --[[ModItemInventoryItemCompositeDef KevlarLeggings_WeavePadding DisplayNamePlural]] "Kevlar Leggings"),
	AdditionalHint = T(922637390244, --[[ModItemInventoryItemCompositeDef KevlarLeggings_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	Slot = "Legs",
	PenetrationClass = 2,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Groin", "Legs" ),
}

