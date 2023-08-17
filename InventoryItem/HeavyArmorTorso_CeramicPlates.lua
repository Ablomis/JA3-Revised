UndefineClass('HeavyArmorTorso_CeramicPlates')
DefineClass.HeavyArmorTorso_CeramicPlates = {
	__parents = { "TransmutedArmor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "TransmutedArmor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_armor",
	SubIcon = "UI/Icons/Items/plates",
	DisplayName = T(438625528497, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso_CeramicPlates DisplayName]] "Heavy Armor"),
	DisplayNamePlural = T(408770319300, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso_CeramicPlates DisplayNamePlural]] "Heavy Armors"),
	AdditionalHint = T(636289047809, --[[ModItemInventoryItemCompositeDef HeavyArmorTorso_CeramicPlates AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Ceramic Plates\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> The ceramic plates will break after taking <color 124 130 96><RevertConditionCounter></color> hits\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 4,
	DamageReduction = 40,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

