UndefineClass('MP40Magazine')
DefineClass.MP40Magazine = {
	__parents = { "Mag" },
	__generated_by_class = "ModItemInventoryItemCompositeDef",


	object_class = "Mag",
	Repairable = false,
	Icon = "UI/Icons/Upgrades/expanded_MP40_magazine",
	DisplayName = T(113889702445, --[[ModItemInventoryItemCompositeDef MP40Magazine DisplayName]] "MP40 Magazine"),
	DisplayNamePlural = T(911544004753, --[[ModItemInventoryItemCompositeDef MP40Magazine DisplayNamePlural]] "MP40 Magazines"),
	Description = T(961445744053, --[[ModItemInventoryItemCompositeDef MP40Magazine Description]] "Standard MP40 magazine for 9mm round"),
	AdditionalHint = T(536502090678, --[[ModItemInventoryItemCompositeDef MP40Magazine AdditionalHint]] "9mm"),
	Platform = "MP40",
	MagazineSize = 40,
	Caliber = "9mm",
}
