-- ========== GENERATED BY CombatAction Editor DO NOT EDIT MANUALLY! ==========

PlaceObj('CombatAction', {
	ActionCamera = true,
	ActionPoints = 3000,
	ActionType = "Ranged Attack",
	ConfigurableKeybind = false,
	CostBasedOnWeapon = true,
	dmg_penalty = 0,
	num_shots = 15,
	cth_loss_per_shot=1,
	Execute = function (self, units, args)
		local unit = units[1]
		local weapon = self:GetAttackWeapons(unit, args)
		args.num_shots = weapon:GetAutofireShots(self)
		args.multishot = true
		local ap = self:GetAPCost(unit, args)
		NetStartCombatAction(self.id, unit, ap, args)
	end,
	GetAPCost = function (self, unit, args)
		local weapon = self:GetAttackWeapons(unit, args)
		if not weapon then return -1 end
		local ap = unit:GetAttackAPCost(self, weapon, nil, args and args.aim or 0)
		if( args~= nil and unit:GetLastAttack()==args.target) then return ap end
		return ap+weapon.ReadyAP
	end,
	GetActionDamage = function (self, unit, target, args)
		local weapon = args and args.weapon or self:GetAttackWeapons(unit, args)
		if not weapon then return 0 end
		local base = unit and unit:GetBaseDamage(weapon) or weapon.Damage
		local penalty = self.dmg_penalty
		local num_shots = self.num_shots
		base = MulDivRound(base, Max(0, 100 + penalty), 100)
		local damage = num_shots*base
		return damage, base, damage - base
	end,
	GetActionDescription = function (self, units)
		local description = self.Description
		if (description or "") == "" then
			description = self:GetActionDisplayName()
		end
		
		local unit = units[1]
		local coneDescription = T{""}
		local interrupts_info = ""
		local overwatch = g_Overwatch[unit]
		if overwatch and overwatch.permanent then
			coneDescription = T(480046777812, " within the set cone")
			interrupts_info = T{757307734445, "<newline><newline>Interrupt attacks: <interrupts>", interrupts = unit:GetNumMGInterruptAttacks()}
		end
		
		return T{description, coneDescription = coneDescription, interrupts_info = interrupts_info}
	end,
	GetActionDisplayName = function (self, units)
		local name = self.DisplayName
		if (name or "") == "" then
			name = Untranslated(self.id)
		end
		local unit = units[1]
		return CombatActionsAppendFreeAimActionName(self, unit, name)
	end,
	GetActionIcon = function (self, units)
		-- replace icon when using Revolver
		local unit = units and units[1]
		if unit then
			local weapon = self:GetAttackWeapons(unit)
			if IsKindOf(weapon, "Revolver") then
				return CombatActions.Fanning.Icon
			end
		end
		return self.Icon
	end,
	GetActionResults = function (self, unit, args)
		local args = table.copy(args)
		args.weapon = args.weapon or self:GetAttackWeapons(unit, args)
		args.num_shots = self.num_shots
		args.multishot = true
		args.damage_bonus = self.dmg_penalty
		--args.cth_loss_per_shot = self:ResolveValue("cth_loss_per_shot")
		local attack_args = unit:PrepareAttackArgs(self.id, args)
		local results = attack_args.weapon:GetAttackResults(self, attack_args)
		return results, attack_args
	end,
	GetAnyTarget = function (self, units)
		return CombatActionGetOneAttackableEnemy(self, units and units[1], nil, CombatActionTargetFilters.MGBurstFire, units)
	end,
	GetAttackWeapons = function (self, unit, args)
		if args and args.weapon then return args.weapon end
		return unit:GetActiveWeapons("Firearm")
	end,
	GetTargets = function (self, units)
		return CombatActionGetAttackableEnemies(self, units and units[1], nil, CombatActionTargetFilters.MGBurstFire, units)
	end,
	GetUIState = function (self, units, args)
		return CombatActionGenericAttackGetUIState(self, units, args)
	end,
	Icon = "UI/Icons/Hud/burst_fire",
	IsTargetableAttack = true,
	KeybindingFromAction = "actionRedirectHeavyAttack",
	KeybindingSortId = "2372",
	MultiSelectBehavior = "first",
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "num_shots",
			'Value', 8,
			'Tag', "<num_shots>",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "cth_loss_per_shot",
			'Tag', "<cth_loss_per_shot>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "dmg_penalty",
			'Value', -50,
			'Tag', "<dmg_penalty>%",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "min_shots",
			'Value', 1,
			'Tag', "<min_shots>",
		}),
	},
	RequireState = "any",
	RequireWeapon = true,
	Run = function (self, unit, ap, ...)
		unit:SetActionCommand("FirearmAttack", self.id, ap, ...)
	end,
	UIBegin = function (self, units, args)
		CombatActionAttackStart(self, units, args, "IModeCombatAttack")
	end,
	group = "WeaponAttacks",
	id = "MGBurstFire",
	save_in = "Libs/Network",
})


PlaceObj('CombatAction', {
	ActionCamera = true,
	ActionPointDelta = -1000,
	ActionType = "Ranged Attack",
	AimType = "line",
	Comment = "-> Attack FiringMode",
	ConfigurableKeybind = false,
	CostBasedOnWeapon = true,
	FiringModeMember = "Attack",
	Description = T(775000951525, --[[CombatAction SingleShot Description]] "Cheap attack that conserves ammo."),
	DisplayName = T(776288626327, --[[CombatAction SingleShot DisplayName]] "Single Shot"),
	DisplayNameShort = T(641608509701, --[[CombatAction SingleShot DisplayNameShort]] "Single"),
	GetAPCost = function (self, unit, args)
		local weapon1, weapon2 = self:GetAttackWeapons(unit, args)
		if unit:OutOfAmmo(weapon2) or unit:IsWeaponJammed(weapon2) then
			weapon2 = nil
		end
		if weapon1 and weapon2 then
			return -1
		end
		if not weapon1 then return -1 end
		local ap = unit:GetAttackAPCost(self, weapon1, false, args and args.aim or 0, self.ActionPointDelta) or -1
		if( args~= nil and unit:GetLastAttack()==args.target) then return ap end
		return ap+weapon1.ReadyAP
	end,
	GetActionDamage = function (self, unit, target, args)
		return CombatActionsAttackGenericDamageCalculation(self, unit, args)
	end,
	GetActionDescription = function (self, units)
		local unit = units[1]
		local _, _, _, params = self:GetActionDamage(unit)
		local descr = T{self.Description, damage = GetDamageRangeText(params.min, params.max), crit = params.critChance}
		descr = CombatActionsAppendFreeAimDescription(self, unit, descr)
		return descr
	end,
	GetActionDisplayName = function (self, units)
		local name = self.DisplayName
		if (name or "") == "" then
			name = Untranslated(self.id)
		end
		local unit = units[1]
		return CombatActionsAppendFreeAimActionName(self, unit, name)
	end,
	GetActionResults = function (self, unit, args)
		local attack_args = unit:PrepareAttackArgs(self.id, args)
		local results = attack_args.weapon:GetAttackResults(self, attack_args)
		return results, attack_args
	end,
	GetAttackWeapons = function (self, unit, args)
		if args and args.weapon then return args.weapon end
		local weapon, _, list = unit:GetActiveWeapons("Firearm")
		return weapon
	end,
	GetUIState = function (self, units, args)
		local unit = units[1]
		local attackWep = self:GetAttackWeapons(unit, args)
		if not attackWep then return "hidden" end
		return CombatActionGenericAttackGetUIState(self, units, args)
	end,
	Icon = "UI/Icons/Hud/attack",
	IconFiringMode = "UI/Hud/fm_single_shot",
	IsTargetableAttack = true,
	KeybindingFromAction = "actionRedirectBasicAttack",
	MultiSelectBehavior = "first",
	RequireState = "any",
	RequireWeapon = true,
	Run = function (self, unit, ap, ...)
		unit:SetActionCommand("FirearmAttack", self.id, ap, ...)
	end,
	StealthAttack = true,
	UIBegin = function (self, units, args)
		CombatActionAttackStart(self, units, args, "IModeCombatAttack")
	end,
	basicAttack = true,
	group = "WeaponAttacks",
	id = "SingleShot",
	save_in = "Libs/Network",
})

PlaceObj('CombatAction', {
	ActionCamera = true,
	ActionPoints = 3000,
	ActionType = "Ranged Attack",
	Comment = "-> Attack FiringMode",
	ConfigurableKeybind = false,
	dmg_penalty = 0,
	num_shots = 3,
	cth_loss_per_shot=0,
	CostBasedOnWeapon = true,
	Description = T(407142474259, --[[CombatAction BurstFire Description]] "Shoots <em><num> bullets</em> at the target. Lower accuracy against distant enemies."),
	DisplayName = T(956399226505, --[[CombatAction BurstFire DisplayName]] "Burst Fire"),
	DisplayNameShort = T(434110622708, --[[CombatAction BurstFire DisplayNameShort]] "Burst"),
	Execute = function (self, units, args)
		local unit = units[1]
		local weapon = self:GetAttackWeapons(unit, args)
		args.num_shots = self.num_shots
		args.multishot = true
		local ap = self:GetAPCost(unit, args)
		NetStartCombatAction(self.id, unit, ap, args)
	end,
	FiringModeMember = "Attack",
	GetAPCost = function (self, unit, args)
		if self.CostBasedOnWeapon then
			local weapon = self:GetAttackWeapons(unit, args)	
			local ap = weapon and (unit:GetAttackAPCost(self, weapon, nil, args and args.aim or 0) + self.ActionPointDelta) or -1
			if( args~= nil and unit:GetLastAttack()==args.target) then return ap end
			return ap+weapon.ReadyAP
		end
		return self.ActionPoints
	end,
	GetActionDamage = function (self, unit, target, args)
		local weapon = self:GetAttackWeapons(unit, args)
		if not weapon then return 0 end
		local base = unit and unit:GetBaseDamage(weapon) or weapon.Damage
		local penalty = self.dmg_penalty
		local num_shots = self.num_shots
		base = MulDivRound(base, Max(0, 100 + penalty), 100)
		local damage = num_shots*base
		return damage, base, damage - base
	end,
	GetActionDescription = function (self, units)
		local description = self.Description
		local unit = units and units[1]
		if not unit then
			return self:GetActionDisplayName()
		end
		local weapon = self:GetAttackWeapons(unit)
		
		-- replace description when using Revolver
		if IsKindOf(weapon, "Revolver") then
			description = CombatActions.Fanning.Description
		end
		
		local damage, base, bonus = self:GetActionDamage(unit)
		local num_shots = self.num_shots
		local descr = T{description, num = num_shots, damage = base}
		return CombatActionsAppendFreeAimDescription(self, unit, descr)
	end,
	GetActionDisplayName = function (self, units)
		local name = self.DisplayName
		
		-- replace name when using Revolver
		local unit = units and units[1]
		if unit then
			local weapon = self:GetAttackWeapons(unit)
			if IsKindOf(weapon, "Revolver") then
				name = CombatActions.Fanning.DisplayName
			end
		end
		
		if (name or "") == "" then
			name = Untranslated(self.id)
		end
		return CombatActionsAppendFreeAimActionName(self, unit, name)
	end,
	GetActionIcon = function (self, units)
		-- replace icon when using Revolver
		local unit = units and units[1]
		if unit then
			local weapon = self:GetAttackWeapons(unit)
			if IsKindOf(weapon, "Revolver") then
				return CombatActions.Fanning.Icon
			end
		end
		return self.Icon
	end,
	GetActionResults = function (self, unit, args)
		local args = table.copy(args)
		args.weapon = self:GetAttackWeapons(unit, args)
		args.num_shots = self.num_shots
		args.multishot = true
		args.damage_bonus = self.dmg_penalty
		--args.cth_loss_per_shot = self.cth_loss_per_shot
		local attack_args = unit:PrepareAttackArgs(self.id, args)
		local results = attack_args.weapon:GetAttackResults(self, attack_args)
		return results, attack_args
	end,
	GetAttackWeapons = function (self, unit, args)
		if args and args.weapon then return args.weapon end
		local weapon, _, list = unit:GetActiveWeapons("Firearm")
		return weapon
	end,
	GetUIState = function (self, units, args)
		local unit = units[1]
		local weapon = self:GetAttackWeapons(unit, args)
		local num_shots = self.num_shots
		if not weapon.ammo or weapon.ammo.Amount < num_shots then
			return "disabled", AttackDisableReasons.InsufficientAmmo
		end
		
		return CombatActionGenericAttackGetUIState(self, units, args)
	end,
	Icon = "UI/Icons/Hud/burst_fire",
	IconFiringMode = "UI/Hud/fm_burst_fire",
	IsTargetableAttack = true,
	MultiSelectBehavior = "first",
	Parameters = {
		PlaceObj('PresetParamNumber', {
			'Name', "num_shots",
			'Value', 3,
			'Tag', "<num_shots>",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "cth_loss_per_shot",
			'Tag', "<cth_loss_per_shot>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "dmg_penalty",
			'Value', 0,
			'Tag', "<dmg_penalty>%",
		}),
	},
	RequireState = "any",
	RequireWeapon = true,
	Run = function (self, unit, ap, ...)
		unit:SetActionCommand("FirearmAttack", self.id, ap, ...)
	end,
	SortKey = 2,
	StealthAttack = true,
	UIBegin = function (self, units, args)
		CombatActionAttackStart(self, units, args, "IModeCombatAttack")
	end,
	basicAttack = true,
	group = "WeaponAttacks",
	id = "BurstFire",
	save_in = "Libs/Network",
})

PlaceObj('CombatAction', {
	ActionPoints = 10000,
	ActionType = "Ranged Attack",
	AimType = "line",
	Comment = "-> Attack FiringMode",
	ConfigurableKeybind = false,
	dmg_penalty = 0,
	num_shots = 15,
	cth_loss_per_shot=0,
	Description = T(631854101896, --[[CombatAction AutoFire Description]] "<em>Spends all AP</em>.\nShoots a hail of <em><bullets> bullets</em> and inflict <GameTerm('Suppressed')> even on miss when the enemy is in weapon range. Lower accuracy against distant enemies."),
	DisplayName = T(729612747243, --[[CombatAction AutoFire DisplayName]] "Auto Fire"),
	DisplayNameShort = T(845536748856, --[[CombatAction AutoFire DisplayNameShort]] "Auto"),
	Execute = function (self, units, args)
		local unit = units[1]
		args.multishot = true
		local weapon = self:GetAttackWeapons(unit, args)
		args.num_shots = self.num_shots
		local ap = self:GetAPCost(unit, args)
		NetStartCombatAction(self.id, unit, ap, args)
	end,
	FiringModeMember = "Attack",
	GetAPCost = function (self, unit, args)
		local weapon = self:GetAttackWeapons(unit, args)
		if not weapon or not weapon:CanAutofire() then
			return -1
		end
		return unit:GetMaxActionPoints()
	end,
	GetActionDamage = function (self, unit, target, args)
		local weapon = self:GetAttackWeapons(unit, args)
		if not weapon then return 0 end
		local base = unit:GetBaseDamage(weapon)
		local penalty = self.dmg_penalty
		local num_shots = self.num_shots
		base = MulDivRound(base, Max(0, 100 + penalty), 100)
		local damage = num_shots*base
		return damage, base, damage - base
	end,
	GetActionDescription = function (self, units)
		local unit = units[1]
		local weapon = self:GetAttackWeapons(unit)
		local damage, base, bonus = self:GetActionDamage(unit)
		local params = weapon:GetAreaAttackParams("AutoFire")
		local descr = T{self.Description, damage = base, bullets = weapon:GetAutofireShots(self)}
		return CombatActionsAppendFreeAimDescription(self, unit, descr)
	end,
	GetActionDisplayName = function (self, units)
		local name = self.DisplayName
		if (name or "") == "" then
			name = Untranslated(self.id)
		end
		local unit = units[1]
		return CombatActionsAppendFreeAimActionName(self, unit, name)
	end,
	GetActionResults = function (self, unit, args)
		local args = table.copy(args)
		args.applied_status = "Suppressed"
		args.multishot = true
		args.weapon = self:GetAttackWeapons(unit, args)
		args.num_shots = self.num_shots
		--args.single_fx = true
		--args.fx_action = "WeaponAutoFire"
		args.damage_bonus = self.dmg_penalty
		--args.cth_loss_per_shot = self.cth_loss_per_shot
		local attack_args = unit:PrepareAttackArgs(self.id, args)
		local results = attack_args.weapon:GetAttackResults(self, attack_args)
		local target = attack_args.target			
		if results.miss and not attack_args.stuck and IsKindOf(target, "Unit") and IsValidTarget(target) then
			local target_dist = unit:GetDist(target)
			local weapon = attack_args.weapon
			if target_dist <= weapon.WeaponRange * const.SlabSizeX then
				local flight_dist = 0
				for _, shot in ipairs(results.shots) do
					for _, hit in ipairs(shot.hits) do
						flight_dist = Max(flight_dist, shot.attack_pos:Dist(hit.pos))
					end	
				end
				flight_dist = flight_dist / const.SlabSizeX
				target_dist = target_dist / const.SlabSizeX
				if flight_dist >= target_dist - 1 then
					results.extra_packets = results.extra_packets or {}
					table.insert(results.extra_packets, {target = target, effects = "Suppressed"})
				end
			end
		end
		return results, attack_args
	end,
	GetAttackWeapons = function (self, unit, args)
		if args and args.weapon then return args.weapon end
		local weapon, _, list = unit:GetActiveWeapons("Firearm")
		return weapon
	end,
	GetUIState = function (self, units, args)
		local state, err = CombatActionGenericAttackGetUIState(self, units, args)
		if state ~= "enabled" then return state, err end
		
		local unit = units[1]
		local weapon = self:GetAttackWeapons(unit, args)
		local autoFire_ammo = weapon:GetAutofireShots(self)
		if not weapon.ammo or weapon.ammo.Amount < autoFire_ammo then
			return "disabled", AttackDisableReasons.InsufficientAmmo
		end
		return "enabled"
	end,
	Icon = "UI/Icons/Hud/full_auto",
	IconFiringMode = "UI/Hud/fm_autoshot",
	IsAimableAttack = false,
	IsTargetableAttack = true,
	MultiSelectBehavior = "first",
	Parameters = {
		PlaceObj('PresetParamPercent', {
			'Name', "cth_loss_per_shot",
			'Tag', "<cth_loss_per_shot>%",
		}),
		PlaceObj('PresetParamPercent', {
			'Name', "dmg_penalty",
			'Value', 0,
			'Tag', "<dmg_penalty>%",
		}),
		PlaceObj('PresetParamNumber', {
			'Name', "num_shots",
			'Value', 15,
			'Tag', "<num_shots>",
		}),
	},
	RequireState = "any",
	RequireWeapon = true,
	Run = function (self, unit, ap, ...)
		unit:SetActionCommand("FirearmAttack", self.id, ap, ...)
	end,
	SortKey = 3,
	UIBegin = function (self, units, args)
		CombatActionAttackStart(self, units, args, "IModeCombatAttack")
	end,
	basicAttack = true,
	group = "WeaponAttacks",
	id = "AutoFire",
	save_in = "Libs/Network",
})

