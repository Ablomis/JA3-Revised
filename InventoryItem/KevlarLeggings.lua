UndefineClass('KevlarLeggings')
DefineClass.KevlarLeggings = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_leggings",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(942888455651, --[[ModItemInventoryItemCompositeDef KevlarLeggings DisplayName]] "Kevlar Leggings"),
	DisplayNamePlural = T(754920434142, --[[ModItemInventoryItemCompositeDef KevlarLeggings DisplayNamePlural]] "Kevlar Leggings"),
	AdditionalHint = T(102971732984, --[[ModItemInventoryItemCompositeDef KevlarLeggings AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding"),
	Slot = "Legs",
	PenetrationClass = 2,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Groin", "Legs" ),
}

