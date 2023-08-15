UndefineClass('FlakArmor_CeramicPlates')
DefineClass.FlakArmor_CeramicPlates = {
	__parents = { "TransmutedArmor" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "TransmutedArmor",
	Degradation = 10,
	ScrapParts = 4,
	Icon = "UI/Icons/Items/flak_armor",
	SubIcon = "UI/Icons/Items/plates",
	DisplayName = T(466603529219, --[[ModItemInventoryItemCompositeDef FlakArmor_CeramicPlates DisplayName]] "Flak Armor"),
	DisplayNamePlural = T(924619127563, --[[ModItemInventoryItemCompositeDef FlakArmor_CeramicPlates DisplayNamePlural]] "Flak Armors"),
	AdditionalHint = T(172976560934, --[[ModItemInventoryItemCompositeDef FlakArmor_CeramicPlates AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Damage reduction improved by Ceramic Plates\n<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> The ceramic plates will break after taking <color 124 130 96><RevertConditionCounter></color> hits"),
	PenetrationClass = 2,
	DamageReduction = 40,
	AdditionalReduction = 20,
	ProtectedBodyParts = set( "Arms", "Torso" ),
}

