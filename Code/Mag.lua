function FindMagReloadTarget(item, ammo)
    if not IsKindOfClasses(ammo, "Ammo", "Ordnance") or not IsKindOf(item, "Mag") then
      return false
    end
    if item.Caliber == ammo.Caliber then
      return item
    end
  end
  function IsMagReloadTarget(drag_item, target_item)
    local target = FindMagReloadTarget(target_item, drag_item)
    return target and IsMagAvailableForReload(target, {drag_item})
  end
  function IsMagAvailableForReload(mag, ammoForWeapon)
    if not ammoForWeapon or not IsKindOf(mag, "Mag") then
      return false
    end
    local anyAmmo = 0 < #ammoForWeapon
    local fullMag = mag.Amount == mag.MagazineSize
    if fullMag then
      if not anyAmmo then
        return false, AttackDisableReasons.FullClip
      else
        return true, AttackDisableReasons.FullClipHaveOther
      end
    elseif not anyAmmo then
      return false, AttackDisableReasons.NoAmmo
    end
    return true
  end
  
  function MagReload(mag, ammo, suspend_fx, delayed_fx)
    local prev_ammo = mag.ammo
    local prev_id = mag.ammo and mag.ammo.class
    local add = 0
    local change
    if mag.ammo and prev_id == ammo.class then
      add = Max(0, Min(ammo.Amount, mag.MagazineSize - mag.ammo.Amount))
      mag.ammo.Amount = mag.ammo.Amount + add
      ammo.Amount = ammo.Amount - add
      change = 0 < add
      ObjModified(mag)
      return false, false, change
    else
      change = true
      if ammo and 0 < ammo.Amount then
        add = Min(ammo.Amount, mag.MagazineSize)
        local item = PlaceInventoryItem(ammo.class)
        ammo.Amount = ammo.Amount - add
        mag.ammo = item
        mag.ammo.Amount = add
      end
    end
    if not suspend_fx then
      CreateGameTimeThread(function(obj, delayed_fx)
        if delayed_fx then
          Sleep(InteractionRand(500, "ReloadDelay"))
        end
        if GetMercInventoryDlg() then
          PlayFX("WeaponLoad", "start", not obj.object_class and obj.weapon and obj.weapon.object_class, obj.class)
        else
          local vo = obj:GetVisualObj()
          local actor_class = vo.fx_actor_class
          vo.fx_actor_class = self.class
          PlayFX("WeaponReload", "start", vo)
          vo.fx_actor_class = actor_class
        end
      end, self, delayed_fx)
    end
    ObjModified(self)
    return prev_ammo, not suspend_fx, change
  end
  function OnUnloadMag()
  end