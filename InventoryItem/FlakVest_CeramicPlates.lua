UndefineClass('FlakVest_CeramicPlates')
DefineClass.FlakVest_CeramicPlates = {
	__parents = { "TransmutedArmor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "TransmutedArmor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_vest",
	SubIcon = "UI/Icons/Items/plates",
	DisplayName = T(149398898877, --[[ModItemInventoryItemCompositeDef FlakVest_CeramicPlates DisplayName]] "Flak Vest"),
	DisplayNamePlural = T(426684043205, --[[ModItemInventoryItemCompositeDef FlakVest_CeramicPlates DisplayNamePlural]] "Flak Vests"),
	AdditionalHint = T(308669305202, --[[ModItemInventoryItemCompositeDef FlakVest_CeramicPlates AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Ceramic Plates\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> The ceramic plates will break after taking <color 124 130 96><RevertConditionCounter></color> hits"),
	PenetrationClass = 2,
	DamageReduction = 40,
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Torso" ),
}

