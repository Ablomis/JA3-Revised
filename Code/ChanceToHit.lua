PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		local num = aim
		local min_bonus = 2
		local min_mrk = 0
		local mrk_scale = 10
		local mrk = attacker.Marksmanship
		
		if IsKindOfClasses(weapon1, "FirearmProperties", "MeleeWeaponProperties") then
			min_bonus = weapon1.AimAccuracy
		end
		
		local modifyVal, compDef
		local metaText = {}
		
		-- Light Stock
		modifyVal, compDef = GetComponentEffectValue(weapon1, "ReduceAimAccuracy", "cth_penalty")
		if modifyVal then
			min_bonus = Max(1, MulDivRound(min_bonus, 100 - modifyVal, 100))
			metaText[#metaText + 1] = compDef.DisplayName
		end
		
		local bonus = num * min_bonus + MulDivRound(Max(0, mrk - min_mrk) * num, mrk_scale, 100) 
		
		-- target camo
		if IsKindOf(target, "Unit") then
			local armor = target:GetItemInSlot("Torso", "Armor")
			if armor and armor.Camouflage then
				bonus = MulDivRound(bonus, Max(0, 100 - const.Combat.CamoAimPenalty), 100)
				metaText[#metaText + 1] = T(396692757033, "Camouflaged - aiming is less effective")
			end
		end
		
		-- Forward Grip
		modifyVal, compDef = GetComponentEffectValue(weapon1, "FirstAimBonusModifier", "first_aim_bonus")
		if modifyVal then
			bonus = bonus + MulDivRound(min_bonus, modifyVal, 100)
			metaText[#metaText + 1] = compDef.DisplayName
		end
		
		-- Heavy Stock
		if IsFullyAimedAttack(num) then
			modifyVal, compDef = GetComponentEffectValue(weapon1, "BonusAccuracyWhenFullyAimed", "bonus_cth")
			if modifyVal then
				bonus = bonus + modifyVal
				metaText[#metaText + 1] = compDef.DisplayName
			end
		end
		
		-- Improved Sight
		modifyVal, compDef = GetComponentEffectValue(weapon1, "AccuracyBonusWhenAimed", "bonus_cth")
		if modifyVal then
			bonus = bonus + modifyVal
			metaText[#metaText + 1] = compDef.DisplayName
		end
		
		return num > 0, bonus,  T{762331260877, "Aiming (x<aim_mod>)", aim_mod = num}, #metaText ~= 0 and metaText
	end,
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "MinBonus",
			'Value', 2,
			'Tag', "<MinBonus>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "MinDex",
			'Value', 40,
			'Tag', "<MinDex>",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "DexScale",
			'Value', 10,
			'Tag', "<DexScale>%",
		}),
	},
	group = "Default",
	id = "Aim",
	param_bindings = {},
	save_in = "Libs/Network",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		if attacker and weapon1 and weapon1.PointBlankRange and attacker:IsPointBlankRange(target) then
			local dexBonus = round(attacker.Dexterity/2,1)
			return true, dexBonus
		end
		
		return false, 0
	end,
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "bonus",
			'Value', 15,
			'Tag', "<bonus>%",
		}),
	},
	group = "Default",
	id = "PointBlank",
	save_in = "Libs/Network",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		if not attacker or not target then 
			return false, 0
		end
		
		local param
		local metaText = {}
		
		local extra = 0
		if action.id == "BurstFire" then
			param = "burst_max_penalty"
		elseif action.id == "AutoFire" then
			param = "auto_max_penalty"
		elseif action.id == "MGBurstFire" then
			if g_Overwatch[attacker] and g_Overwatch[attacker].permanent then
				param = "mg_burst_max_penalty"
			else
				param = "mg_burst_max_held_penalty"
				if weapon1 and weapon1.Cumbersome then
					extra = -20
				end
			end
		elseif action.id == "GrizzlyPerk" then
			param = "mg_burst_max_penalty"
			metaText[#metaText + 1] = GrizzlyPerk.DisplayName
		else
			return false, 0
		end
		
		local penalty = 0
		local pb_dist = const.Weapons.PointBlankRange * const.SlabSizeX
		local dist = attacker_pos:Dist(target_pos)
		
		if dist > pb_dist then
			-- scale in the distance after point-blank range to max penalty
			local max_dist = 14 * const.SlabSizeX		
			local max_penalty = weapon1.Recoil*10 + extra
			
			dist = Min(dist, max_dist) - pb_dist
			max_dist = max_dist - pb_dist
			penalty = -MulDivRound(dist, max_penalty - penalty, max_dist)
		end
		
		if penalty == 0 then
			return false, 0
		end
		
		if action.id == "BurstFire" then
			return true, penalty, T(913932180355, "Burst Fire"), #metaText ~= 0 and metaText
		end
		
		return true, penalty, false, #metaText ~= 0 and metaText
	end,
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "max_dist",
			'Value', 14,
			'Tag', "<max_dist>",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "base_penalty",
			'Tag', "<base_penalty>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "auto_max_penalty",
			'Value', -50,
			'Tag', "<auto_max_penalty>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "burst_max_penalty",
			'Value', -20,
			'Tag', "<burst_max_penalty>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "mg_burst_max_penalty",
			'Value', -50,
			'Tag', "<mg_burst_max_penalty>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "mg_burst_max_held_penalty",
			'Value', -60,
			'Tag', "<mg_burst_max_held_penalty>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "mg_burst_cumbersome_penalty",
			'Value', -20,
			'Tag', "<mg_burst_cumbersome_penalty>%",
		}),
	},
	group = "Default",
	id = "Autofire",
	save_in = "Libs/Network",
})