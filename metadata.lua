return PlaceObj('ModDef', {
	'title', "Revised",
	'description', "This mod is designed to create more complete experience, reflecting real life combat as much as possible.\n\n[b]Design philosophy[/b]\n[list]\n[*]Weapons are deadlier - a single shot from AK can severly injur or kill an unprotected target\n[*]Accuracy is lower - to compensate for this accuracy is lower across the board\n[*]Cover is much more important - you dont really want to face an AK burst outside of cover\n[/list]\n\n[b]Major Changes[/b]\n[list]\n[*]Each weapon has AP to Ready it which can be reduced by the accessories\n[*]Aiming reworked: unaimed shot requires Dexterity and aiming requires marksmansghip (was the other way in vanilla)\n[*]Recoil reworked: every subsequent bullet has CTH penalty\n[*]Sniper rifles reworked: they need to be deployed like an MG and sniper scope provides penalty in close range\n[*]Reload reworked: mags exist now and they are much faster to reload compared to ammo reload\n[*]Ballistics reworked: weapon damage depends on ammo (muzle velocity and bullet mass)\n[*]All weapons have rather high crit chance up close: lethality depends on whether you hit vitals\n[*]Enemies can be temporarily incapacitated after a hit (depend on hitpoints left)\n[*]Weapon lethality is based of real data (i.e. AR bullet has 60% of incapacitating with one-hit)\n[/list]\n\n[b]Recommended mods[/b]\n[list]\n[*]Pinned down\n[*]Increased drop chance\n[/list]\n\n[b]Known issues[/b]\n[list]\n[*]Mags need to be reloaded manually from inventory\n[*]Mags dont drop\n[/list]\n\n[b]Check mod options for fine-tuning[/b]\n\n[b]Compatibility[/b]\n[list]\n[*]Will NOT be compatible with any mods touching ammo\n[*]Will NOT be compatible with any mods touching guns\n[*]SHOULD be compatible with mods that don't touch combat (training, visibility)\n[/list]\n\n[b]NOT vanilla save game compatible[/b]",
	'image', "Mod/Db7c5fd/Images/JA3Revised 2.png",
	'last_changes', "Unconscious multiplier added to options",
	'dependencies', {},
	'id', "Db7c5fd",
	'content_path', "Mod/Db7c5fd/",
	'author', "Ablomis",
	'version_major', 1,
	'version_minor', 1,
	'version', 3770,
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
		"Code/AI.lua",
		"Code/AIApplyAttacks.lua",
		"Code/AllAmmoCausesBleeding.lua",
		"Code/ArmorProperties.lua",
		"Code/ChanceToHit.lua",
		"Code/ClassDef-Inventory.lua",
		"Code/ColoredAmmo.lua",
		"Code/CombatActions.lua",
		"Code/CombatMovementContour.lua.lua",
		"Code/CombatObject.lua",
		"Code/Config.lua",
		"Code/Constants.lua",
		"Code/CustomSuppActionFXInherit_Actor.lua",
		"Code/CustomWeaponComponentEffect.lua",
		"Code/DamageCalculation.lua",
		"Code/Flanked.lua",
		"Code/GetRangeAccuracy.lua",
		"Code/Grenade.lua",
		"Code/Inventory.lua",
		"Code/InventoryContextMenu.lua",
		"Code/InventoryMoveItem.lua",
		"Code/InventoryRolloverInfo.lua",
		"Code/InventoryUI.lua",
		"Code/LootDef_545.lua",
		"Code/Mag.lua",
		"Code/MaxActionPoints.lua",
		"Code/ModOptions.lua",
		"Code/ModifyWeaponDlg.lua",
		"Code/SniperSetup.lua",
		"Code/Unit.lua",
		"Code/UnitActions.lua",
		"Code/UnitAwareness.lua",
		"Code/UnitCaching.lua",
		"Code/UnitOverwatch.lua",
		"Code/Visibility.lua",
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
	'has_options', true,
	'saved', 1692392601,
	'code_hash', 6684450100749587645,
	'steam_id', "3021628746",
})