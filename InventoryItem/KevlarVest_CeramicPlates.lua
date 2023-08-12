UndefineClass('KevlarVest_CeramicPlates')
DefineClass.KevlarVest_CeramicPlates = {
	__parents = { "TransmutedArmor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "TransmutedArmor",
	Degradation = 6,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_armor",
	SubIcon = "UI/Icons/Items/plates",
	DisplayName = T(980753649635, --[[ModItemInventoryItemCompositeDef KevlarVest_CeramicPlates DisplayName]] "Kevlar Armor"),
	DisplayNamePlural = T(103558083359, --[[ModItemInventoryItemCompositeDef KevlarVest_CeramicPlates DisplayNamePlural]] "Kevlar Armors"),
	AdditionalHint = T(586259445813, --[[ModItemInventoryItemCompositeDef KevlarVest_CeramicPlates AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Ceramic Plates\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> The ceramic plates will break after taking <color 124 130 96><RevertConditionCounter></color> hits"),
	PenetrationClass = 3,
	DamageReduction = 40,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}
