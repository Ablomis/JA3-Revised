PlaceObj('CombatAction', {
	ActionCamera = true,
	ActionPoints = 3000,
	ActionType = "Ranged Attack",
	Comment = "-> Attack FiringMode",
	ConfigurableKeybind = false,
	CostBasedOnWeapon = true,
	Description = T(838141287304, --[[CombatAction BurstFire Description]] "Shoots <em><num> bullets</em> at the target. Lower accuracy against distant enemies."),
	DisplayName = T(885711257338, --[[CombatAction BurstFire DisplayName]] "Burst Fire"),
	DisplayNameShort = T(421007639739, --[[CombatAction BurstFire DisplayNameShort]] "Burst"),
	Execute = function (self, units, args)
		local unit = units[1]
		local weapon = self:GetAttackWeapons(unit, args)
		args.num_shots = 3
		args.multishot = true
		local ap = self:GetAPCost(unit, args)
		NetStartCombatAction(self.id, unit, ap, args)
	end,
	FiringModeMember = "Attack",
	GetAPCost = function (self, unit, args)
		if self.CostBasedOnWeapon then
			local weapon = self:GetAttackWeapons(unit, args)	
			local apCost = weapon and (unit:GetAttackAPCost(self, weapon, nil, args and args.aim or 0) + self.ActionPointDelta) or -1
			if(unit.aim_attack_args) then
				if not (unit:GetLastAttack()==unit.aim_attack_args.target) then
					apCost = apCost+1000
				end
			end
			return apCost 
		end
		return self.ActionPoints
	end,
	GetActionDamage = function (self, unit, target, args)
		local weapon = self:GetAttackWeapons(unit, args)
		if not weapon then return 0 end
		local base = unit and unit:GetBaseDamage(weapon) or weapon.Damage
		local penalty = 0
		local num_shots = 3
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
		local num_shots = 3
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
		args.num_shots = 3
		args.multishot = true
		args.damage_bonus = 0
		--args.cth_loss_per_shot = self:ResolveValue("cth_loss_per_shot")
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
		local num_shots = weapon:GetAutofireShots(self)
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
			'Value', 0,
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

