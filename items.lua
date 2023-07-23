return {
PlaceObj('ModItemCode', {
	'name', "CTHCalc",
	'CodeFileName', "Code/CTHCalc.lua",
}),
PlaceObj('ModItemCode', {
	'name', "ChanceToHit",
	'CodeFileName', "Code/ChanceToHit.lua",
}),
PlaceObj('ModItemCode', {
	'name', "DamageCalculation",
	'CodeFileName', "Code/DamageCalculation.lua",
}),
PlaceObj('ModItemCode', {
	'name', "FirearmProperty",
	'CodeFileName', "Code/FirearmProperty.lua",
}),
PlaceObj('ModItemCode', {
	'name', "GetAttackAPCost",
	'CodeFileName', "Code/GetAttackAPCost.lua",
}),
PlaceObj('ModItemGameRuleDef', {
	display_name = T(259417638381, --[[ModItemGameRuleDef APReductionOnHit display_name]] "APReductionOnHit"),
	id = "APReductionOnHit",
	msg_reactions = {
		PlaceObj('MsgReaction', {
			Event = "DamageTaken",
			Handler = function (self, attacker, target, dmg, hit_descr)
				ap_penalty = 1
				if target:GetStatusEffect("SpentAP") then
					ap_penalty = target:GetEffectValue("spent_ap") +1
				else target:AddStatusEffect("SpentAP") 
				end
				target:SetEffectValue("spent_ap", ap_penalty)
				print('Damage: '..tostring(dmg )..'dmg')
				print('AP Penalty: '..tostring(ap_penalty )..'AP')
			end,
			HandlerCode = function (self, attacker, target, dmg, hit_descr)
				ap_penalty = 1
				if target:GetStatusEffect("SpentAP") then
					ap_penalty = target:GetEffectValue("spent_ap") +1
				else target:AddStatusEffect("SpentAP") 
				end
				target:SetEffectValue("spent_ap", ap_penalty)
				print('Damage: '..tostring(dmg )..'dmg')
				print('AP Penalty: '..tostring(ap_penalty )..'AP')
			end,
			param_bindings = false,
		}),
	},
}),
PlaceObj('ModItemInventoryItemCompositeDef', {
	'Group', "Firearm - Assault",
	'Id', "AK47",
	'object_class', "AssaultRifle",
	'RepairCost', 20,
	'Reliability', 95,
	'ScrapParts', 10,
	'Icon', "UI/Icons/Weapons/AK47",
	'DisplayName', T(823196795567, --[[ModItemInventoryItemCompositeDef AK47 DisplayName]] "AK-47"),
	'DisplayNamePlural', T(882527122666, --[[ModItemInventoryItemCompositeDef AK47 DisplayNamePlural]] "AK-47s"),
	'Description', T(205869440892, --[[ModItemInventoryItemCompositeDef AK47 Description]] "You should not be surprised to find an AK-47 anywhere there is conflict around the world. Simple to use, reliable and dirt cheap. Over 75 million are in circulation worldwide."),
	'AdditionalHint', T(783364115492, --[[ModItemInventoryItemCompositeDef AK47 AdditionalHint]] "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120> Slower Condition loss"),
	'LargeItem', true,
	'UnitStat', "Marksmanship",
	'Cost', 800,
	'Caliber', "762WP",
	'Damage', 20,
	'MagazineSize', 30,
	'PenetrationClass', 2,
	'WeaponRange', 24,
	'OverwatchAngle', 1440,
	'HandSlot', "TwoHanded",
	'Entity', "Weapon_AK47",
	'ComponentSlots', {
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Bipod",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Bipod",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Grenadelauncher",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"AK47_Launcher",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Stock",
			'AvailableComponents', {
				"StockNormal",
				"StockLight",
			},
			'DefaultComponent', "StockNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Magazine",
			'AvailableComponents', {
				"MagNormal",
				"MagLarge",
				"MagQuick",
			},
			'DefaultComponent', "MagNormal",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Handguard",
			'AvailableComponents', {
				"AK47_VerticalGrip",
				"AK47_Handguard_basic",
			},
			'DefaultComponent', "AK47_Handguard_basic",
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Scope",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"LROptics",
				"ReflexSight",
				"ScopeCOG",
				"ThermalScope",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Muzzle",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Compensator",
				"MuzzleBooster",
				"Suppressor",
			},
		}),
		PlaceObj('WeaponComponentSlot', {
			'SlotType', "Side",
			'CanBeEmpty', true,
			'AvailableComponents', {
				"Flashlight",
				"FlashlightDot",
				"LaserDot",
			},
		}),
	},
	'HolsterSlot', "Shoulder",
	'AvailableAttacks', {
		"BurstFire",
		"AutoFire",
		"SingleShot",
		"CancelShot",
	},
	'ShootAP', 6000,
	'ReloadAP', 3000,
	'ReadyAP', 2000,
}),
}
