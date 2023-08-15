UndefineClass('HeavyArmorTorso')
DefineClass.HeavyArmorTorso = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_armor",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(617500205392, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso DisplayName]] "Heavy Armor"),
	DisplayNamePlural = T(860603834149, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso DisplayNamePlural]] "Heavy Armors"),
	AdditionalHint = T(462792895606, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 3,
	DamageReduction = 40,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

