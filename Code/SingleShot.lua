PlaceObj('CombatAction', {
	ActionCamera = true,
	ActionPointDelta = -1000,
	ActionType = "Ranged Attack",
	AimType = "line",
	Comment = "-> Attack FiringMode",
	ConfigurableKeybind = false,
	CostBasedOnWeapon = true,
	Description = T(298670513550, --[[CombatAction SingleShot Description]] "Cheap attack that conserves ammo."),
	DisplayName = T(355970076448, --[[CombatAction SingleShot DisplayName]] "Single Shot"),
	DisplayNameShort = T(392229752968, --[[CombatAction SingleShot DisplayNameShort]] "Single"),
	FiringModeMember = "Attack",
	GetAPCost = function (self, unit, args)
		local weapon1, weapon2 = self:GetAttackWeapons(unit, args)
		if unit:OutOfAmmo(weapon2) or unit:IsWeaponJammed(weapon2) then
			weapon2 = nil
		end
		if weapon1 and weapon2 then
			return -1
		end
		if not weapon1 then return -1 end
		local apCost = unit:GetAttackAPCost(self, weapon1, false, args and args.aim or 0, self.ActionPointDelta) or -1
		if(weapon1.object_class=='Pistol' or weapon1.object_class=='Revolver') then return apCost end
		if(unit.aim_attack_args) then
			if not (unit:GetLastAttack()==unit.aim_attack_args.target) then
				apCost = apCost+1000
				return apCost
			end
		end
		return apCost
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