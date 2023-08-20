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

--[[PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		local target_stance = target:GetHitStance() 
		if target_stance == "Prone" then 
			local value = const.Combat.ProneCTHPenalty  
			return true, value, T(904752344471, "Target Prone") 
		elseif target_stance == "Crouch" then 
			local value = const.Combat.CrouchedCTHPenalty 
			return true, value, T(309253003316, "Target Crouched") 
		end
		return false, 0
	end,
	group = "Default",
	display_name='Stance',
	id = "StanceModifier",
})]]--

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		if attacker and weapon1 and weapon1.PointBlankRange and attacker:IsPointBlankRange(target) then
			local dexBonus = MulDivRound(attacker.Dexterity/2, RevisedConfigValues.PointBlankBonus, 100)
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
		if target:HasStatusEffect("Unconscious") and (attacker:GetDist(target)/1000 <5) then return true, 100 end
		
		return false, 0
	end,
	Parameters = {
	},
	group = "Default",
	display_name='Unconscious',
	id = "Unconscious",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		if not IsPlayerEnemy(attacker) and IsKindOf(weapon1, "SniperRifle") and not attacker:HasStatusEffect("StationedSniper") then
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
		local dist = attacker:GetDist(target)
		local cth_bonus = 0

		if(weapon1:HasComponent("x5ScopeEffect")) then
			if(dist < GetComponentEffectValue(weapon1, "x5ScopeEffect", "min_dist")) then
				cth_bonus = -GetComponentEffectValue(weapon1, "x5ScopeEffect", "cth_bonus")
			else
				cth_bonus = GetComponentEffectValue(weapon1, "x5ScopeEffect", "cth_bonus")
			end
			return true, cth_bonus
		elseif (weapon1:HasComponent("x10ScopeEffect")) then
			if(dist < GetComponentEffectValue(weapon1, "x10ScopeEffect", "min_dist")) then
				cth_bonus = -GetComponentEffectValue(weapon1, "x10ScopeEffect", "cth_bonus")
			else
				cth_bonus = GetComponentEffectValue(weapon1, "x10ScopeEffect", "cth_bonus")
			end
			return true, cth_bonus
		elseif (weapon1:HasComponent("ACOGScopeEffect")) then
			if(dist < GetComponentEffectValue(weapon1, "ACOGScopeEffect", "min_dist")) then
				cth_bonus = -GetComponentEffectValue(weapon1, "ACOGScopeEffect", "cth_bonus")
			else
				cth_bonus = GetComponentEffectValue(weapon1, "ACOGScopeEffect", "cth_bonus")
			end
			return true, cth_bonus
		else
			return false, 0
		end
	end,
	group = "Default",
	display_name='Scope',
	id = "SniperScopeBonus",
})

PlaceObj('ChanceToHitModifier', {
	CalcValue = function (self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
		
		if not IsKindOf(target, "Unit") then return false, 0 end
		
		if not target:HasStatusEffect('Moved') then return false, 0
		else
			local dist = target:GetEffectValue("tiles_moved") or 0
			if dist == 0 then
				return false, 0
			else
				local penalty = RevisedConfigValues.MoveCTHPenaltyBase + dist * RevisedConfigValues.MoveCTHPenaltyTile
				return true, penalty
			end
		end




		--[[
		local move_dir = SetLen(movement, guim)
		local dir = target:GetVisualPos() - attacker_pos
		local dp = dir:Equal2D(point20) and guim or abs(Dot2D(SetLen(dir:SetZ(0), guim), move_dir) / guim)
		
		-- scale by dot
		local mod = MulDivRound(self:ResolveValue("MaxPenalty"), guim - dp, guim)
		-- scale by distance (up to param1 tiles)
		local max_dist = self:ResolveValue("MaxDistTiles") * const.SlabSizeX
		mod = MulDivRound(mod, Min(dist, max_dist), max_dist)
		
		return mod < self:ResolveValue("MinPenalty"), mod]]--
	end,
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "MaxDistTiles",
			'Value', 10,
			'Tag', "<MaxDistTiles>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "MaxPenalty",
			'Value', -25,
			'Tag', "<MaxPenalty>",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "MinPenalty",
			'Value', -5,
			'Tag', "<MinPenalty>",
		}),
	},
	RequireTarget = true,
	display_name = T(330773997382, --[[ChanceToHitModifier Default EvasiveMovement display_name]] "Enemy Moved"),
	group = "Default",
	id = "EvasiveMovement",
})


function OnMsg.CombatStart()
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['Cover'] = round(RevisedConfigValues.CoverCTHPenalty,1)
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['ExposedCover'] = round(RevisedConfigValues.ExposedCoverCTHPenalty,1)
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['CrouchPenalty'] = round(RevisedConfigValues.CrouchedCTHPenalty,1)
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['PronePenalty'] = round(RevisedConfigValues.ProneCTHPenalty,1)
end

function OnMsg.ZuluGameLoaded(game)
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['Cover'] = round(RevisedConfigValues.CoverCTHPenalty,1)
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['ExposedCover'] = round(RevisedConfigValues.ExposedCoverCTHPenalty,1)
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['CrouchPenalty'] = round(RevisedConfigValues.CrouchedCTHPenalty,1)
	g_PresetParamCache[Presets.ChanceToHitModifier.Default.RangeAttackTargetStanceCover]['PronePenalty'] = round(RevisedConfigValues.ProneCTHPenalty,1)
end


