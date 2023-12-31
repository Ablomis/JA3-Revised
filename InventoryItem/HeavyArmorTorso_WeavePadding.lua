UndefineClass('HeavyArmorTorso_WeavePadding')
DefineClass.HeavyArmorTorso_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_armor",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(372786021739, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso_WeavePadding DisplayName]] "Heavy Armor"),
	DisplayNamePlural = T(472238143760, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso_WeavePadding DisplayNamePlural]] "Heavy Armors"),
	AdditionalHint = T(170368819056, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 3,
	DamageReduction = 40,
	AdditionalReduction = 50,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

