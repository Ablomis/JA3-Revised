UndefineClass('KevlarLeggings_WeavePadding')
DefineClass.KevlarLeggings_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 4,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_leggings",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(264432677227, --[[ModItemInventoryItemCompositeDef KevlarLeggings_WeavePadding DisplayName]] "Kevlar Leggings"),
	DisplayNamePlural = T(496455217669, --[[ModItemInventoryItemCompositeDef KevlarLeggings_WeavePadding DisplayNamePlural]] "Kevlar Leggings"),
	AdditionalHint = T(817645811673, --[[ModItemInventoryItemCompositeDef KevlarLeggings_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	Slot = "Legs",
	PenetrationClass = 2,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Groin", "Legs" ),
}

