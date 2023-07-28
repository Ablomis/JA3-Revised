function Firearm:GetAreaAttackParams(action_id, attacker, target_pos, step_pos, stance)
    local params = {
      attacker = attacker,
      weapon = self,
      target_pos = target_pos,
      step_pos = step_pos,
      used_ammo = 1,
      damage_mod = 100,
      attribute_bonus = 0,
      dont_destroy_covers = true
    }
    if attacker then
      params.step_pos = step_pos or not attacker:IsValidPos() or GetPassSlab(attacker) or attacker:GetPos()
      params.stance = stance or attacker.stance
    end
    if action_id == "Buckshot" or action_id == "DoubleBarrel" or action_id == "BuckshotBurst" or action_id == "CancelShotCone" then
      if attacker then
        params.attribute_bonus = MulDivRound(const.Combat.BuckshotAttribBonus, attacker.Marksmanship, 100)
      end
      params.falloff_start = self.BuckshotFalloffStart
      params.falloff_damage = self.BuckshotFalloffDamage
      params.cone_angle = self.BuckshotConeAngle
      params.min_range = self.WeaponRange
      params.max_range = self.WeaponRange
    elseif action_id == "EyesOnTheBack" then
      local effect = attacker:GetStatusEffect("EyesOnTheBack")
      params.cone_angle = effect and effect:ResolveValue("cone_angle") * 60
      params.min_range = self:GetOverwatchConeParam("MinRange")
      params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "Overwatch" or action_id == "MGRotate" or action_id == "MGSetup" or action_id == "SniperRotate" or action_id == "SniperSetup" then
      params.cone_angle = self.OverwatchAngle
      params.min_range = self:GetOverwatchConeParam("MinRange")
      params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "BulletHell" or action_id == "DanceForMe" then
      params.cone_angle = self.OverwatchAngle
      params.min_range = self:GetOverwatchConeParam("MinRange")
      params.max_range = self:GetOverwatchConeParam("MaxRange")
    elseif action_id == "FireFlare" then
      params.min_range = self.ammo and self.ammo.AreaOfEffect or 0
      params.max_range = self.ammo and self.ammo.AreaOfEffect or 0
    end
    return params
  end
  function GetBulletCount(weapon)
    if IsKindOf(weapon, "Firearm") then
      if weapon.emplacement_weapon then
        return false
      end
      return weapon.ammo and weapon.ammo.Amount or 0
    elseif IsKindOfClasses(weapon, "Grenade", "StackableMeleeWeapon") then
      return weapon.Amount or 0
    else
      return false
    end
  end
  function TFormat.bullets(context_obj, bullets, max, icon)
    icon = icon or "<image UI/Icons/Rollover/ammo_placeholder 1400>"
    bullets = bullets or GetBulletCount(context_obj)
    if not bullets then
      return T(994336406701, "<image UI/Icons/Hud/ammo_infinite>")
    end
    local max = max or context_obj and context_obj.MagazineSize or context_obj.MaxStacks
    local text = bullets == 0 and "<error><bullets></error>" or "<bullets>"
    if not max then
      return T({
        370913997359,
        text,
        bullets = bullets,
        icon = icon
      })
    else
      text = text .. "/<style InventoryItemsCountMax><max></style>"
      return T({
        text,
        bullets = bullets,
        max = max or 0,
        icon = icon
      })
    end
  end
  function Firearm:GetItemSlotUI()
    local text = T({
      414344497801,
      "<bullets()>",
      self
    })
    local subweapon = self:GetSubweapon("Firearm")
    if subweapon then
      text = Untranslated(_InternalTranslate(T({
        975717474075,
        "<bullets()><newline>",
        subweapon
      }))) .. text
    end
    return text
  end
  function Firearm:GetItemStatusUI()
    if self:IsCondition("Broken") then
      return T(623193685060, "BROKEN")
    end
    if self.jammed then
      return T(935110589090, "JAMMED")
    end
    return InventoryItem.GetItemStatusUI(self)
  end
  function Firearm:GetRolloverHint()
    local keywords = {}
    if self.AdditionalHint then
      keywords[#keywords + 1] = self.AdditionalHint
    end
    local text = next(keywords) and table.concat(keywords, ", ") or ""
    local texts = {text}
    return table.concat(texts, "\n")
  end
  function Firearm:__toluacode(indent, pstr, GetPropFunc)
    return self:SaveToLuaCode(indent, pstr, GetPropFunc)
  end
  function Firearm:SaveToLuaCode(indent, pStr, GetPropFunc, pos)
    if not pStr then
      local additional
      if self.ammo then
        local ammo_props = self.ammo:SavePropsToLuaCode(indent, GetPropFunc)
        ammo_props = ammo_props or "nil"
        additional = string.format([[
  
       'ammo',PlaceInventoryItem('%s', %s)]], self.ammo.class, ammo_props)
      end
      if next(self.subweapons) ~= nil then
        additional = additional and string.format("%s,", additional)
        additional = string.format([[
  %s
       'subweapons',{]], additional or "")
        local additionalWeps = {}
        for slot, item in sorted_pairs(self.subweapons) do
          additionalWeps[#additionalWeps + 1] = string.format([[
  
          ['%s'] = %s]], slot, item:__toluacode("\t\t\t", nil, GetPropFunc))
        end
        additional = string.format("%s%s%s", additional, table.concat(additionalWeps, ", "), [[
  
      },]])
      end
      local props = self:SavePropsToLuaCode(indent, GetPropFunc, pStr, additional)
      props = props or "nil"
      if pos then
        return string.format("%d, PlaceInventoryItem('%s', %s)", pos, self.class, props)
      else
        return string.format("PlaceInventoryItem('%s', %s)", self.class, props)
      end
    else
      local additional = pstr("", 1024)
      if self.ammo then
        additional:appendf([[
  
       'ammo',PlaceInventoryItem('%s', ]], self.ammo.class)
        if not self.ammo:SavePropsToLuaCode(indent, GetPropFunc, additional) then
          additional:append("nil")
        end
        additional:append("),")
      end
      if next(self.subweapons) ~= nil then
        additional:append([[
  
       'subweapons',{]])
        for slot, item in sorted_pairs(self.subweapons) do
          additional:appendf([[
  
          ['%s'] = %s]], slot, item:__toluacode("\t\t\t", nil, GetPropFunc))
        end
        additional:append([[
  
      },]])
      end
      if pos then
        pStr:append(tostring(pos) .. ", ")
        pStr:appendf("PlaceInventoryItem('%s', ", self.class)
        if not self:SavePropsToLuaCode(indent, GetPropFunc, pStr, additional) then
          pStr:append("nil")
        end
        return pStr:append(") ")
      else
        pStr:appendf("PlaceInventoryItem('%s', ", self.class)
        if not self:SavePropsToLuaCode(indent, GetPropFunc, pStr, additional) then
          pStr:append("nil")
        end
        return pStr:append(") ")
      end
    end
  end