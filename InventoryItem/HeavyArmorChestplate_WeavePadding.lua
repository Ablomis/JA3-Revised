UndefineClass('HeavyArmorChestplate_WeavePadding')
DefineClass.HeavyArmorChestplate_WeavePadding = {
	__parents = { "Armor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Armor",
	Degradation = 5,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_vest",
	SubIcon = "UI/Icons/Items/padded",
	DisplayName = T(371164415911, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate_WeavePadding DisplayName]] "Heavy Vest"),
	DisplayNamePlural = T(556012329278, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate_WeavePadding DisplayNamePlural]] "Heavy Vests"),
	AdditionalHint = T(350558895430, --[[ModItemInventoryItemCompositeDef HeavyArmorChestplate_WeavePadding AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Weave Padding\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 3,
	DamageReduction = 40,
	AdditionalReduction = 50,
	ProtectedBodyParts = set( "Torso" ),
}

