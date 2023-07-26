UndefineClass("AmmoProperties")
DefineClass.AmmoProperties = {
	__parents = { "PropertyObject", },
	__generated_by_class = "ClassDef",

	properties = {
		{ category = "Caliber", id = "Caliber", 
			editor = "combo", default = false, template = true, items = function (self) return PresetGroupCombo("Caliber", "Default") end, },
		{ id = "Damage", name = "Damage", help = "Bullet base damage.", 
			editor = "number", default = 1, min = 1, max = 200, modifiable = true, },
		{ category = "Caliber", id = "MaxStacks", name = "Max Stacks", help = "Ammo can stack up to that number.", 
			editor = "number", default = 10, template = true, slider = true, min = 1, max = 10000, },
		{ id = "Modifications", 
			editor = "nested_list", default = false, template = true, base_class = "CaliberModification", inclusive = true, },
		{ category = "Combat", id = "AppliedEffects", name = "Applied Effects", 
			editor = "preset_id_list", default = {}, template = true, preset_class = "CharacterEffectCompositeDef", preset_group = "Default", item_default = "", },
	},
}
UndefineClass("FirearmProperties")
DefineClass.FirearmProperties = {
	__parents = { "ItemWithCondition", },
	__generated_by_class = "ClassDef",

	properties = {
		{ category = "Caliber", id = "Caliber", 
			editor = "combo", default = false, template = true, items = function (self) return PresetGroupCombo("Caliber", "Default") end, },
		{ category = "General", id = "btnAddAmmo", 
			editor = "buttons", default = false, buttons = { {name = "Add Ammo To Current Unit", func = "UIPlaceInInventoryAmmo"}, }, template = true, },
		{ category = "Caliber", id = "Damage", help = "Damage of the firearm", 
			editor = "number", default = 0, template = true, min = 0, max = 1000, modifiable = true, },
		{ category = "Caliber", id = "ObjDamageMod", name = "Objects damage modifier", help = "Multiplicative damage modifier against objects (non-units)", 
			editor = "number", default = 100, template = true, scale = "%", min = 0, max = 1000, modifiable = true, },
		{ category = "Caliber", id = "AimAccuracy", name = "Aim Accuracy", help = "Base chance to hit increase per aim action", 
			editor = "number", default = 2, template = true, scale = "%", min = 1, modifiable = true, },
		{ category = "Caliber", id = "CritChance", name = "Crit Chance", help = "Base chance to cause a critical hit which deals more damage.", 
			editor = "number", default = 0, template = true, scale = "%", slider = true, min = 0, max = 100, modifiable = true, },
		{ category = "Caliber", id = "CritChanceScaled", name = "Crit Chance (Scaled)", help = "Additional chance to cause a critical hit (scaled by level, specified number is at merc level 10)", 
			editor = "number", default = 10, template = true, scale = "%", slider = true, min = 0, max = 100, modifiable = true, },
		{ category = "Caliber", id = "MagazineSize", name = "Magazine Size", help = "Number of bullets in a single clip", 
			editor = "number", default = 1, template = true, min = 1, max = 1000, modifiable = true, },
		{ category = "Caliber", id = "PenetrationClass", 
			editor = "number", default = 1, template = true, 
			name = function(self) return "Penetration Class: " .. (PenetrationClassIds[self.PenetrationClass] or "") end, slider = true, min = 1, max = 5, modifiable = true, },
		{ category = "Caliber", id = "IgnoreCoverReduction", name = "Ignore Cover Reduction", help = "If > 0 attacks with this weapon will ignore the damage reduction that would normally apply for targets in cover.", 
			editor = "number", default = 0, template = true, min = 0, max = 100, modifiable = true, },
		{ category = "Caliber", id = "WeaponRange", name = "Range", help = "Range at which the penalty of the gun is 100.", 
			editor = "number", default = 20, template = true, slider = true, min = 1, max = 200, modifiable = true, },
		{ category = "Caliber", id = "BarrelLength", name = "Barrel Length", help = "The length of the barrel in cm.", 
			editor = "number", default = 50, template = true, scale = "cm", slider = true, min = 0, max = 1000, modifiable = true, },
		{ category = "Caliber", id = "Weight", name = "Weapon Weight", help = "How much the weapon weights in Kg.", 
			editor = "number", default = 3000, template = true, scale = "kg", step = 100, min = 100, max = 30000, modifiable = true, },
		{ category = "Caliber", id = "DamageFalloff", name = "Damage Falloff", help = "How much damage falls off at max range.", 
			editor = "number", default = 50, template = true, scale = "%", min = 0, max = 100, modifiable = true, },
		{ category = "Caliber", id = "Recoil", name = "Recoil", help = "How strong the recoil is. Influences burst accuracy penalty.", 
			editor = "number", default = 3, template = true, min = 0, max = 30, modifiable = true, },
		{ category = "Caliber", id = "PointBlankRange", name = "Point Blank Range", help = "attacks get bonus CTH in point-blank range", 
			editor = "bool", default = false, template = true, },
		{ category = "Caliber", id = "OverwatchAngle", name = "Overwatch Angle", help = "overwatch area cone angle", 
			editor = "number", default = 2400, template = true, 
			no_edit = function(self) return 
	(self.PreparedAttackType ~= "Overwatch" and self.PreparedAttackType ~= "Both" and self.PreparedAttackType ~= "Machine Gun")
end, scale = "deg", slider = true, min = 1, max = 5400, modifiable = true, },
		{ category = "Caliber", id = "BuckshotConeAngle", name = "Buckshot Cone Angle", 
			editor = "number", default = 1600, template = true, 
			no_edit = function(self) return not table.find(self.AvailableAttacks, "Buckshot") end, scale = "deg", min = 60, max = 7200, modifiable = true, },
		{ category = "Caliber", id = "BuckshotFalloffDamage", name = "Buckshot Falloff Damage", help = "what percent of nominal damage is the attack dealing at max range (cone length)", 
			editor = "number", default = 25, template = true, 
			no_edit = function(self) return not table.find(self.AvailableAttacks, "Buckshot") end, scale = "%", min = 0, max = 100, modifiable = true, },
		{ category = "Caliber", id = "BuckshotFalloffStart", name = "Buckshot Falloff Start", help = "at what percent of the max distance (cone length) does the damage falloff start", 
			editor = "number", default = 50, template = true, 
			no_edit = function(self) return not table.find(self.AvailableAttacks, "Buckshot") end, scale = "%", min = 0, max = 100, modifiable = true, },
		{ category = "Caliber", id = "Noise", name = "Noise Range", help = "Range (in tiles) in which the weapon alerts unaware enemies when firing.", 
			editor = "number", default = 20, template = true, min = 0, max = 100, modifiable = true, },
		{ category = "Caliber", id = "RangePenalty", name = "Range Penalty", 
			editor = "accuracy_chart", default = "", dont_save = true, template = true, },
		{ category = "General", id = "HandSlot", help = "One-haneded or two-handed weapon.", 
			editor = "combo", default = "OneHanded", template = true, items = function (self) return { "OneHanded", "TwoHanded" } end, },
		{ category = "Body & Components", id = "Entity", 
			editor = "combo", default = false, template = true, items = function (self) return GetWeaponEntities end, },
		{ category = "Body & Components", id = "fxClass", name = "FX Class", help = "use to override the default fx class of this weapon", 
			editor = "combo", default = "", template = true, items = function (self) return ItemTemplatesCombo("FirearmProperties") end, },
		{ category = "Body & Components", id = "ComponentSlots", 
			editor = "nested_list", default = false, template = true, base_class = "WeaponComponentSlot", inclusive = true, },
		{ category = "Body & Components", id = "Color", 
			editor = "combo", default = "Olive", template = true, items = function (self) return Presets.WeaponColor.Default end, },
		{ category = "Body & Components", id = "BaseDifficulty", help = 'Base difficulty value compared against the "Mechanical" skill.', 
			editor = "number", default = false, template = true, min = 0, max = 10000000, modifiable = true, },
		{ category = "Body & Components", id = "HolsterSlot", help = "By default Two Handed weapons go on shoulders, One Handed go to legs", 
			editor = "combo", default = "", template = true, items = function (self) return { "", "Shoulder", "Leg" } end, },
		{ category = "Body & Components", id = "ModifyRightHandGrip", 
			editor = "bool", default = false, template = true, },
		{ category = "General", id = "PreparedAttackType", name = "Prepared Attack Type", 
			editor = "choice", default = "Overwatch", template = true, items = function (self) return { "Overwatch", "Pin Down", "None", "Both", "Machine Gun" } end, },
		{ category = "General", id = "AvailableAttacks", name = "Available Attacks", 
			editor = "preset_id_list", default = {}, template = true, preset_class = "CombatAction", preset_group = "WeaponAttacks", item_default = "", },
		{ category = "ActionPoints", id = "ShootAP", name = "Shoot", help = "Action points needed to shoot a single shot", 
			editor = "number", default = 1000, template = true, scale = "AP", min = 1000, max = 50000, modifiable = true, },
		{ category = "ActionPoints", id = "ReloadAP", name = "Reload", help = "Action points needed to reload the gun", 
			editor = "number", default = 1000, template = true, scale = "AP", min = 1000, max = 50000, modifiable = true, },
		{ category = "ActionPoints", id = "ReadyAP", name = "Ready", help = "Action points needed to ready the gun", 
			editor = "number", default = 0, template = true, scale = "AP", min = 0, max = 50000, modifiable = true, },
		{ category = "ActionPoints", id = "MaxAimActions", name = "Max Aim Actions", help = "Max number of aim actions allowed", 
			editor = "number", default = 3, min = 0, max = 5, modifiable = true, },
		{ category = "Debug", id = "SetRange", name = "Range", 
			editor = "number", default = 10, dont_save = true, template = true, slider = true, min = 0, max = 50, },
		{ category = "Debug", id = "DPS", 
			editor = "number", default = false, dont_save = true, read_only = true, template = true, min = 0, max = 1000, },
	},
}

function FirearmProperties:GetDPS()
	return self:GetProperty("Damage") * Max(0, GetRangeAccuracy(self, self:GetProperty("SetRange")*const.SlabSizeX)) / 100
end