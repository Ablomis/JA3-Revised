UndefineClass("Flanked")
DefineClass.Flanked = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if not obj:IsMerc() and IsNetPlayerTurn() then
            PlayVoiceResponse(obj, "AIFlanked")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if not obj:IsMerc() and IsNetPlayerTurn() then
          PlayVoiceResponse(obj, "AIFlanked")
        end
      end,
      param_bindings = false
    }),
  },
  DisplayName = T(529722665638, "Flanked"),
  Description = T(938831848548, "Threatened from both sides. Target gets morale penalty."),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/flanked",
  RemoveOnEndCombat = true,
  Shown = true
}

function UnitProperties:GetPersonalMorale()
    local teamMorale = self.team and self.team.morale or 0
    local personalMorale = 0
    local isDisliking = false
    for _, dislikedMerc in ipairs(self.Dislikes) do
      local dislikedIndex = table.find(self.team.units, "session_id", dislikedMerc)
      if dislikedIndex and not self.team.units[dislikedIndex]:IsDead() then
        personalMorale = personalMorale - 1
        isDisliking = true
        break
      end
    end
    if not isDisliking then
      for _, likedMerc in ipairs(self.Likes) do
        local likedIndex = table.find(self.team.units, "session_id", likedMerc)
        if likedIndex and not self.team.units[likedIndex]:IsDead() then
          personalMorale = personalMorale + 1
          break
        end
      end
    end
    local isWounded = false
    local idx = self:HasStatusEffect("Wounded")
    if idx and self.StatusEffects[idx].stacks >= 3 then
      isWounded = true
    end
    if self.HitPoints < MulDivRound(self.MaxHitPoints, 50, 100) or isWounded then
      if HasPerk(self, "Psycho") then
        personalMorale = personalMorale + 1
      else
        personalMorale = personalMorale - 1
      end
    end
    for _, likedMerc in ipairs(self.Likes) do
      local ud = gv_UnitData[likedMerc]
      if ud and ud.HireStatus == "Dead" then
        local deathDay = ud.HiredUntil
        if deathDay + 7 * const.Scale.day > Game.CampaignTime then
          personalMorale = personalMorale - 1
          break
        end
      end
    end
    if self:HasStatusEffect("ZoophobiaChecked") then
      personalMorale = personalMorale - 1
    end
    if self:HasStatusEffect("ClaustrophobiaChecked") then
      personalMorale = personalMorale - 1
    end
    if self:HasStatusEffect("FriendlyFire") then
      personalMorale = personalMorale - 1
    end
    if self:HasStatusEffect("Flanked") then
        personalMorale = personalMorale - 2
      end
    if self:HasStatusEffect("Conscience_Guilty") then
      personalMorale = personalMorale - 1
    end
    if self:HasStatusEffect("Conscience_Sinful") then
      personalMorale = personalMorale - 2
    end
    if self:HasStatusEffect("Conscience_Proud") then
      personalMorale = personalMorale + 1
    end
    if self:HasStatusEffect("Conscience_Righteous") then
      personalMorale = personalMorale + 2
    end
    return Clamp(personalMorale + teamMorale, -3, 3)
  end