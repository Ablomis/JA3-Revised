UndefineClass('KevlarChestplate_CeramicPlates')
DefineClass.KevlarChestplate_CeramicPlates = {
	__parents = { "TransmutedArmor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "TransmutedArmor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_vest",
	SubIcon = "UI/Icons/Items/plates",
	DisplayName = T(701230961364, --[[ModItemInventoryItemCompositeDef KevlarChestplate_CeramicPlates DisplayName]] "Kevlar Vest"),
	DisplayNamePlural = T(351259650027, --[[ModItemInventoryItemCompositeDef KevlarChestplate_CeramicPlates DisplayNamePlural]] "Kevlar Vests"),
	AdditionalHint = T(174367016299, --[[ModItemInventoryItemCompositeDef KevlarChestplate_CeramicPlates AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Ceramic Plates\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> The ceramic plates will break after taking <color 124 130 96><RevertConditionCounter></color> hits"),
	PenetrationClass = 3,
	DamageReduction = 40,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Torso" ),
}

