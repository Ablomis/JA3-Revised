PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		local num = aim
		local min_bonus = 2
		local min_mrk = 0
		local mrk_scale = 10
		local mrk = attacker.Marksmanship
		local dex = attacker.Dexterity
		
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
		local dex_back = round(35 + 0.00055 * ((dex-70)^3) + 0.5,1)
		--local bonus = num * min_bonus + MulDivRound(Max(0, mrk - min_mrk) * num, mrk_scale, 100) 
		local bonus = round((mrk - dex_back)/3.0*num + 0.5,1)
		
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
	param_bindings = {}
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		if attacker and weapon1 and weapon1.PointBlankRange and attacker:IsPointBlankRange(target) then
			local dexBonus = round(attacker.Dexterity/5,1)
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
	display_name='PointBlank',
	id = "PointBlank",
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
			local max_penalty = weapon1.Recoil + extra
			
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
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		if IsKindOf(weapon1, "SniperRifle") and not attacker:HasStatusEffect("StationedSniper") then
			return true, weapon1.NotDeployedPenalty
		end
		
		return false, 0
	end,
	group = "Default",
	display_name='Not deployed',
	id = "WeaponNotDeployed",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
	return false, 0
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
	display_name = T(520853928478, --[[ChanceToHitModifier Default Autofire display_name]] "Autofire"),
	group = "Default",
	id = "Autofire",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		return false,0
	end,
	Comment = "More accurate attacks against lower level targets",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "bonus",
			'Value', 10,
			'Tag', "<bonus>%",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "levelDiff",
			'Value', 2,
			'Tag', "<levelDiff>",
		}),
	},
	RequireTarget = true,
	display_name = T(713286242287, --[[ChanceToHitModifier Default TrainingAdvantage display_name]] "More experienced"),
	group = "Default",
	id = "TrainingAdvantage",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		return false, 0
	end,
	Comment = "Less accurate attacks against higher level targets",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "penalty",
			'Value', 10,
			'Tag', "<penalty>%",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "levelDiff",
			'Value', 2,
			'Tag', "<levelDiff>",
		}),
	},
	RequireTarget = true,
	display_name = T(133256021230, --[[ChanceToHitModifier Default TrainingDisadvantage display_name]] "Less Experienced"),
	group = "Default",
	id = "TrainingDisadvantage",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		if opportunity_attack or not IsKindOf(weapon1, "Firearm") or not IsKindOf(target, "Unit") then 
			return false, 0 
		end
		local target_stance = target:GetHitStance()
		if target_stance == "Prone" then
			local value = self:ResolveValue("PronePenalty") 
			return true, value, T(904752344471, "Target Prone")
		end
		
		local cover, any, coverage
		if weapon1 then
			local ignoreCth = weapon1:HasComponent("IgnoreCoverCtHWhenFullyAimed") and IsFullyAimedAttack(aim)
			if not ignoreCth and (opportunity_attack or target:IsAware()) and not target:HasStatusEffect("Exposed") then
				cover, any, coverage = target:GetCoverPercentage(attacker_pos, target_pos)
			end
		end
		
		-- force exposed when aiming/shooting
		local melee_attack = action and action.ActionType == "Melee Attack"
		cover = not target.aim_action_id and not melee_attack and cover
		
		if cover then
			local name = false
			local exposed_value = self:ResolveValue("ExposedCover")
			local full_value = self:ResolveValue("Cover")
			
			if CheckSightCondition(attacker, target, const.usObscured) then
				exposed_value = exposed_value + const.EnvEffects.DustStormCoverCTHPenalty
				full_value = full_value + const.EnvEffects.DustStormCoverCTHPenalty
				name = T(548829641491, "Behind Cover (Dust Storm)")
			end
			
			local value = InterpolateCoverEffect(coverage, full_value, exposed_value)
			local metaText = false
		
			if value < exposed_value then
				return true, value, name, metaText, "Cover"
			end
		end
		if target_stance == "Crouch" then
			local value = self:ResolveValue("CrouchPenalty")
			return true, value, T(309253003316, "Target Crouched")
		end
		return false, 0
	end,
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "Cover",
			'Value', -40,
			'Tag', "<Cover>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "ExposedCover",
			'Value', -5,
			'Tag', "<ExposedCover>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "CrouchPenalty",
			'Value', -20,
			'Tag', "<CrouchPenalty>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "PronePenalty",
			'Value', -40,
			'Tag', "<PronePenalty>",
		}),
	},
	RequireTarget = true,
	display_name = T(879243129261, --[[ChanceToHitModifier Default RangeAttackTargetStanceCover display_name]] "Behind Cover"),
	group = "Default",
	id = "RangeAttackTargetStanceCover",
})