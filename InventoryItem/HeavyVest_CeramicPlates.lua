UndefineClass('HeavyVest_CeramicPlates')
DefineClass.HeavyVest_CeramicPlates = {
	__parents = { "TransmutedArmor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "TransmutedArmor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/heavy_vest",
	SubIcon = "UI/Icons/Items/plates",
	DisplayName = T(536995929848, --[[ModItemInventoryItemCompositeDef HeavyVest_CeramicPlates DisplayName]] "Heavy Vest"),
	DisplayNamePlural = T(695893110773, --[[ModItemInventoryItemCompositeDef HeavyVest_CeramicPlates DisplayNamePlural]] "Heavy Vests"),
	AdditionalHint = T(743965765038, --[[ModItemInventoryItemCompositeDef HeavyVest_CeramicPlates AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Ceramic Plates\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> The ceramic plates will break after taking <color 124 130 96><RevertConditionCounter></color> hits\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Cumbersome (no Free Move)"),
	Cumbersome = true,
	is_valuable = true,
	PenetrationClass = 4,
	DamageReduction = 40,
	AdditionalReduction = 40,
	ProtectedBodyParts = set( "Torso" ),
}

