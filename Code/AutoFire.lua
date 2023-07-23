PlaceObj('CombatAction', {
	ActionPoints = 10000,
	ActionType = "Ranged Attack",
	AimType = "line",
	Comment = "-> Attack FiringMode",
	ConfigurableKeybind = false,
	Description = T(393518976346, --[[CombatAction AutoFire Description]] "<em>Spends all AP</em>.\nShoots a hail of <em><bullets> bullets</em> and inflict <GameTerm('Suppressed')> even on miss when the enemy is in weapon range. Lower accuracy against distant enemies."),
	DisplayName = T(847115637646, --[[CombatAction AutoFire DisplayName]] "Auto Fire"),
	DisplayNameShort = T(810267106493, --[[CombatAction AutoFire DisplayNameShort]] "Auto"),
	Execute = function (self, units, args)
		local unit = units[1]
		args.multishot = true
		local weapon = self:GetAttackWeapons(unit, args)
		args.num_shots = 15
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
		local penalty = 0
		local num_shots = 15
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
		args.num_shots = 15
		--args.single_fx = true
		--args.fx_action = "WeaponAutoFire"
		args.damage_bonus = 0
		--args.cth_loss_per_shot = 0
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