
_9mm_Shock.colorStyle = 'AmmoHPColor'
InventoryItemDefs['_9mm_Shock'].colorStyle = 'AmmoHPColor'


function TFormat.bullets(context_obj, bullets, max, icon)
  icon = icon or "<image UI/Icons/Rollover/ammo_placeholder 1400>"
  bullets = bullets or GetBulletCount(context_obj)
  if not bullets then
    return T(994336406701, "<image UI/Icons/Hud/ammo_infinite>")
  end
  local max = max or context_obj and context_obj.MagazineSize or context_obj.MaxStacks

  local text = '<bullets>'
  if context_obj.ammo and context_obj.ammo.colorStyle and context_obj.ammo.colorStyle ~= 'AmmoBasicColor' then
    local colorStyle = context_obj.ammo.colorStyle
    text = '<color ' .. colorStyle .. '>' .. text .. '</color>'
  end
  if not max then
    return T({
      text,
      bullets = bullets,
      icon = icon,
    })
  else
    text = text .. "<style InventoryItemsCountMax>/<max></style>"
    return T({
      text,
      bullets = bullets,
      max = max or 0,
      icon = icon,
    })
  end
end