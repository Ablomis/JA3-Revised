return PlaceObj('ModDef', {
	'title', "Revised",
	'description', "This mod is designed to create more complete experiencel, reflecting real life combat as much as possible.\nThe design philosophy of the mod: deadlier weapons, lower accuracy.\n\nNOT Vanilla save compatible.\n\nMajor changes:\n1. Auto damage increased\n2. Accuracy decreased to compensate.\n3. Dexterity used for close-range combat, marksmanship for aiming\n4. Lighting reflexes should not work on stealth kill\n5. Each weapon now has AP ready\n6. Increased number of AP for mercs to compensate\n7. All wounds cause bleeding if no armor or armor is penetrated\n8 Damage falloff beyond effective range\n9. Grenades are always inaccurate\n\nThis is ALPHA version of the mod - might be not well balanced. Feedback and suggestions are welcome.",
	'image', "Mod/Db7c5fd/Images/JA3Revised 2.png",
	'last_changes', "Sniper deployment alfa version",
	'id', "Db7c5fd",
	'content_path', "Mod/Db7c5fd/",
	'author', "Ablomis",
	'version_minor', 1,
	'version', 3012,
	'lua_revision', 233360,
	'saved_with_revision', 339125,
	'code', {
		"CharacterEffect/StationedSniper.lua",
		"Code/.44 Ammo.lua",
		"Code/12ga Ammo.lua",
		"Code/5.45x39 Ammo.lua",
		"Code/50 BMGAmmo.lua",
		"Code/556 AMMO.lua",
		"Code/7.62x54R Ammo.lua",
		"Code/762 WP Ammo.lua",
		"Code/762NATO Ammo.lua",
		"Code/9mm AMMO.lua",
		"Code/AIApplyAttacks.lua",
		"Code/AllAmmoCausesBleeding.lua",
		"Code/ArmorProperties.lua",
		"Code/ChanceToHit.lua",
		"Code/ClassDef-Inventory.lua",
		"Code/ColoredAmmo.lua",
		"Code/CombatActionGrenade.lua",
		"Code/CombatActions.lua",
		"Code/CombatObject.lua",
		"Code/Constants.lua",
		"Code/CustomSuppActionFXInherit_Actor.lua",
		"Code/CustomWeaponComponentEffect.lua",
		"Code/DamageCalculation.lua",
		"Code/Flanked.lua",
		"Code/GetRangeAccuracy.lua",
		"Code/IModeCombatAreaAim.lua",
		"Code/Inventory.lua",
		"Code/InventoryContextMenu.lua",
		"Code/InventoryMoveItem.lua",
		"Code/InventoryRolloverInfo.lua",
		"Code/InventoryUI.lua",
		"Code/LootDef_545.lua",
		"Code/LootUpdate.lua",
		"Code/Mag.lua",
		"Code/MaxActionPoints.lua",
		"Code/ModifyWeaponDlg.lua",
		"Code/RolloverInventoryWeaponBase.lua",
		"Code/AI.lua",
		"Code/SniperSetup.lua",
		"Code/Unit.lua",
		"Code/UnitActions.lua",
		"Code/UnitAwareness.lua",
		"Code/UnitCaching.lua",
		"Code/UnitOverwatch.lua",
		"Code/Weapon.lua",
		"Code/WeaponComponentEffect.lua",
		"Code/WeaponComponents.lua",
		"Code/WeaponModChoicePopup.lua",
		"Code/WeaponModsInventoryItems.lua",
		"InventoryItem/HiPower.lua",
		"InventoryItem/Bereta92.lua",
		"InventoryItem/Glock18.lua",
		"InventoryItem/ColtPeacemaker.lua",
		"InventoryItem/TexRevolver.lua",
		"InventoryItem/ColtAnaconda.lua",
		"InventoryItem/DesertEagle.lua",
		"InventoryItem/MP40.lua",
		"InventoryItem/UZI.lua",
		"InventoryItem/MP5.lua",
		"InventoryItem/MP5K.lua",
		"InventoryItem/AKSU.lua",
		"InventoryItem/M4Commando.lua",
		"InventoryItem/AK47.lua",
		"InventoryItem/AK74.lua",
		"InventoryItem/FAMAS.lua",
		"InventoryItem/AUG.lua",
		"InventoryItem/AR15.lua",
		"InventoryItem/M16A2.lua",
		"InventoryItem/G36.lua",
		"InventoryItem/FNFAL.lua",
		"InventoryItem/Galil.lua",
		"InventoryItem/M14SAW.lua",
		"InventoryItem/MG42.lua",
		"InventoryItem/FNMinimi.lua",
		"InventoryItem/HK21.lua",
		"InventoryItem/RPK74.lua",
		"InventoryItem/DoubleBarrelShotgun.lua",
		"InventoryItem/Auto5.lua",
		"InventoryItem/M41Shotgun.lua",
		"InventoryItem/AA12.lua",
		"InventoryItem/BrowningM2HMG.lua",
		"InventoryItem/Winchester1894.lua",
		"InventoryItem/Gewehr98.lua",
		"InventoryItem/DragunovSVD.lua",
		"InventoryItem/M24Sniper.lua",
		"InventoryItem/PSG1.lua",
		"InventoryItem/BarretM82.lua",
		"InventoryItem/ReflexSight.lua",
		"InventoryItem/ReflexSightAdvanced.lua",
		"InventoryItem/ImprovedIronsight.lua",
		"InventoryItem/LROptics.lua",
		"InventoryItem/LROpticsAdvanced.lua",
		"InventoryItem/ScopeCOG.lua",
		"InventoryItem/ScopeCOGQuick.lua",
		"InventoryItem/ThermalScope.lua",
		"InventoryItem/AdvancedCompensator.lua",
		"InventoryItem/Compensator.lua",
		"InventoryItem/RecoilBooster.lua",
		"InventoryItem/VerticalGrip.lua",
		"InventoryItem/TacticalGrip.lua",
		"InventoryItem/MP5MagazineNormal.lua",
		"InventoryItem/AK47Magazine.lua",
		"InventoryItem/AK74Magazine.lua",
		"InventoryItem/AK74MagazineExpanded.lua",
		"InventoryItem/STANAGMagazine.lua",
		"InventoryItem/AUGMagazine.lua",
		"InventoryItem/M14Magazine.lua",
		"InventoryItem/GalilMagazine.lua",
		"InventoryItem/FAMASMagazine.lua",
		"InventoryItem/FNFALMagazine.lua",
		"InventoryItem/AR15Magazine.lua",
		"InventoryItem/GlockMagazine.lua",
		"InventoryItem/UZIMagazine.lua",
		"InventoryItem/SVDMagazine.lua",
		"InventoryItem/HK21Magazine.lua",
		"InventoryItem/FNMinimiMagazine.lua",
		"InventoryItem/BerettaMagazine.lua",
		"InventoryItem/BHPMagazine.lua",
		"InventoryItem/DesertEagleMagazine.lua",
		"InventoryItem/MP40Magazine.lua",
		"InventoryItem/FlakVest.lua",
		"InventoryItem/FlakVest_CeramicPlates.lua",
		"InventoryItem/FlakVest_WeavePadding.lua",
		"InventoryItem/FlakArmor.lua",
		"InventoryItem/FlakArmor_CeramicPlates.lua",
		"InventoryItem/FlakArmor_WeavePadding.lua",
		"InventoryItem/FlakLeggings.lua",
		"InventoryItem/FlakLeggings_WeavePadding.lua",
		"InventoryItem/KevlarVest.lua",
		"InventoryItem/KevlarVest_CeramicPlates.lua",
		"InventoryItem/KevlarVest_WeavePadding.lua",
		"InventoryItem/KevlarChestplate.lua",
		"InventoryItem/KevlarChestplate_CeramicPlates.lua",
		"InventoryItem/KevlarChestplate_WeavePadding.lua",
		"InventoryItem/KevlarLeggings.lua",
		"InventoryItem/KevlarLeggings_WeavePadding.lua",
		"InventoryItem/KevlarHelmet.lua",
		"InventoryItem/KevlarHelmet_WeavePadding.lua",
		"InventoryItem/HeavyVest.lua",
		"InventoryItem/HeavyVest_CeramicPlates.lua",
		"InventoryItem/LightHelmet.lua",
		"InventoryItem/LightHelmet_WeavePadding.lua",
		"InventoryItem/HeavyArmorChestplate.lua",
		"InventoryItem/HeavyArmorChestplate_CeramicPlates.lua",
		"InventoryItem/HeavyArmorChestplate_WeavePadding.lua",
		"InventoryItem/HeavyArmorTorso.lua",
		"InventoryItem/HeavyArmorTorso_CeramicPlates.lua",
		"InventoryItem/HeavyArmorTorso_WeavePadding.lua",
		"InventoryItem/HeavyArmorHelmet.lua",
		"InventoryItem/HeavyArmorHelmet_WeavePadding.lua",
		"InventoryItem/HeavyArmorLeggings.lua",
		"InventoryItem/HeavyArmorLeggings_WeavePadding.lua",
	},
	'saved', 1692138027,
	'code_hash', 3762069029806066662,
	'steam_id', "3008768068",
})