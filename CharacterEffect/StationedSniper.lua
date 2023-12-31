UndefineClass('StationedSniper')
DefineClass.StationedSniper = {
	__parents = { "CharacterEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "CharacterEffect",
	msg_reactions = {
		PlaceObj('MsgReaction', {
			Event = "EnterSector",
			Handler = function (self, game_start, load_game)
				local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "EnterSector")
				if not reaction_idx then return end
				
				local function exec(self, game_start, load_game)
				if not load_game then
					for _, unit in ipairs(g_Units) do
						if unit:HasStatusEffect("StationedSniper") then
							unit:InterruptPreparedAttack()
							unit:RemoveStatusEffect("StationedSniper")
						end
					end
				end
				end
				local id = GetCharacterEffectId(self)
				
				if id then
					local objs = {}
					for session_id, data in pairs(gv_UnitData) do
						local obj = g_Units[session_id] or data
						if obj:HasStatusEffect(id) then
							objs[session_id] = obj
						end
					end
					for _, obj in sorted_pairs(objs) do
						exec(self, game_start, load_game)
					end
				else
					exec(self, game_start, load_game)
				end
				
			end,
			HandlerCode = function (self, game_start, load_game)
				if not load_game then
					for _, unit in ipairs(g_Units) do
						if unit:HasStatusEffect("StationedSniper") then
							unit:InterruptPreparedAttack()
							unit:RemoveStatusEffect("StationedSniper")
						end
					end
				end
			end,
			param_bindings = false,
		}),
		PlaceObj('MsgReaction', {
			Event = "UnitEndTurn",
			Handler = function (self, unit)
				local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitEndTurn")
				if not reaction_idx then return end
				
				local function exec(self, unit)
				if g_Overwatch[unit] then
					g_Overwatch[unit].num_attacks = 1
					ObjModified(unit)
				end
				end
				local id = GetCharacterEffectId(self)
				
				if id then
					if IsKindOf(unit, "StatusEffectObject") and unit:HasStatusEffect(id) then
						exec(self, unit)
					end
				else
					exec(self, unit)
				end
				
			end,
			HandlerCode = function (self, unit)
				if g_Overwatch[unit] then
					g_Overwatch[unit].num_attacks = 1
					ObjModified(unit)
				end
			end,
			param_bindings = false,
		}),
	},
}

