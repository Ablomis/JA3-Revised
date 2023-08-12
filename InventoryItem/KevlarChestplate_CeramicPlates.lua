UndefineClass('KevlarChestplate_CeramicPlates')
DefineClass.KevlarChestplate_CeramicPlates = {
	__parents = { "TransmutedArmor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "TransmutedArmor",
	Degradation = 6,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/kevlar_vest",
	SubIcon = "UI/Icons/Items/plates",
	DisplayName = T(735971260785, --[[ModItemInventoryItemCompositeDef KevlarChestplate_CeramicPlates DisplayName]] "Kevlar Vest"),
	DisplayNamePlural = T(695873351302, --[[ModItemInventoryItemCompositeDef KevlarChestplate_CeramicPlates DisplayNamePlural]] "Kevlar Vests"),
	AdditionalHint = T(640462845929, --[[ModItemInventoryItemCompositeDef KevlarChestplate_CeramicPlates AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Ceramic Plates\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> The ceramic plates will break after taking <color 124 130 96><RevertConditionCounter></color> hits"),
	PenetrationClass = 3,
	DamageReduction = 40,
	AdditionalReduction = 30,
	ProtectedBodyParts = set( "Torso" ),
}
