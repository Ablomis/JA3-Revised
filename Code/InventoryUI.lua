function XInventorySlot:Gossip(item, src_container, target, src_x, src_y, dest_x, dest_y)
    local context = target:GetContext()
    local item_id = item.id
    if (context == "drop" or IsKindOfClasses(context, "SectorStash", "ItemDropContainer", "ItemContainer", "ContainerMarker") or IsKindOf(context, "Unit") and context:IsDead()) and IsKindOfClasses(src_container, "Unit", "UnitData", "SquadBag") and not g_GossipItemsMoveFromPlayerToContainer[item_id] then
      g_GossipItemsMoveFromPlayerToContainer[item_id] = true
    end
    if IsKindOfClasses(context, "Unit", "UnitData", "SquadBag") and (IsKindOfClasses(src_container, "SectorStash", "ItemDropContainer", "ItemContainer", "ContainerMarker") or IsKindOf(src_container, "Unit") and src_container:IsDead()) and not g_GossipItemsTakenByPlayer[item_id] and g_GossipItemsSeenByPlayer[item_id] and not g_GossipItemsMoveFromPlayerToContainer[item_id] then
      NetGossip("Loot", "TakeByPlayer", item.class, rawget(item, "Amount") or 1, GetCurrentPlaytime(), Game and Game.CampaignTime)
      g_GossipItemsTakenByPlayer[item_id] = true
    end
    local ammo = IsKindOfClasses(item, "Ammo", "Ordnance")
    if ammo then
      return
    end
    if IsKindOfClasses(item, "WeaponMod") then
        return
    end
    local src = IsKindOfClasses(src_container, "Unit", "UnitData") and src_container.session_id or src_container.class
    local dest = IsKindOfClasses(context, "Unit", "UnitData") and context.session_id or context.class
    local src_part = IsKindOf(self, "EquipInventorySlot") and "Body" or "Items"
    local dest_part = IsKindOf(target, "EquipInventorySlot") and "Body" or "Items"
    if not g_GossipItemsEquippedByPlayer[item_id] and dest_part == "Body" and src_part == "Items" then
      NetGossip("EquipItem", item.class, src, src_part, src_x, src_y, dest, dest_part, dest_x, dest_y, GetCurrentPlaytime(), Game and Game.CampaignTime)
      g_GossipItemsEquippedByPlayer[item_id] = true
    end
  end

  function XInventoryTile:OnDropEnter(drag_win, pt, drag_source_win)
    local drag_item = InventoryDragItem
    local slot = self:GetInventorySlotCtrl()
    local mouse_text = InventoryGetMoveIsInvalidReason(slot.context, InventoryStartDragContext)
    local wnd, under_item = slot:FindItemWnd(pt)
    if under_item == drag_item then
      under_item = false
    end
    local is_reload = IsReload(drag_item, under_item)
    local is_upgrade = IsUpgrade(drag_item, under_item)
    local ap_cost, unit_ap, action_name = GetAPCostAndUnit(drag_item, InventoryStartDragContext, InventoryStartDragSlotName, slot:GetContext(), slot.slot_name, under_item, is_reload, is_upgrade)
    if not mouse_text then
      mouse_text = action_name or ""
      if InventoryIsCombatMode() and ap_cost and 0 < ap_cost then
        mouse_text = InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
      end
    end
    InventoryShowMouseText(true, mouse_text)
    HighlightDropSlot(self, true, pt, drag_win)
    HighlightAPCost(InventoryDragItem, true, self)
  end

  function XInventoryItem:OnDropEnter(drag_win, pt, drag_source_win)
    local slot = self:GetInventorySlotCtrl()
    local context = slot:GetContext()
    local mouse_text = InventoryGetMoveIsInvalidReason(context, InventoryStartDragContext)
    local drag_item = InventoryDragItem
    HighlightDropSlot(self, true, pt, drag_win)
    local cur_item = self:GetContext()
    local slot_name = slot.slot_name
    if IsKindOf(context, "UnitData") and g_Combat then
      context = g_Units[context.session_id]
    end
    local is_reload = IsReload(drag_item, cur_item)
    local is_upgrade = IsUpgrade(drag_item, cur_item)
    local ap_cost, unit_ap, action_name = GetAPCostAndUnit(drag_item, InventoryStartDragContext, InventoryStartDragSlotName, context, slot_name, cur_item, is_reload,is_upgrade)
    if not mouse_text then
      mouse_text = action_name or ""
      local is_combat = InventoryIsCombatMode()
      if not is_combat then
        drag_win:OnContextUpdate(drag_win:GetContext())
      end
      if is_combat and ap_cost and 0 < ap_cost then
        mouse_text = InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
      end
    end
    InventoryShowMouseText(true, mouse_text)
    HighlightAPCost(InventoryDragItem, true, self)
  end

  function XInventorySlot:GetCostAP(dest, dest_slot_name, dest_pos, is_reload, drag_item, src_context, is_upgrade)
    if not InventoryIsCombatMode() or not dest and not dest_pos then
      return 0
    end
    if dest == "drop" then
      return 0
    end
    local src = src_context or self.context
    local item, l, t
    dest_pos = dest_pos or InventoryDragItemPos
    if IsKindOf(dest_pos, "InventoryItem") then
      l, t = dest:GetItemPos(dest_pos)
      item = dest_pos
    else
      l, t = point_unpack(dest_pos)
      item = dest:GetItemAtPos(dest_slot_name, l, t)
      if not item then
        item = dest:GetItemAtPos(dest_slot_name, l - 1, t)
        if item and 1 < item:GetUIWidth() then
          l = l - 1
        end
      end
    end
    if not drag_item and item then
      drag_item = item
      item = false
    end
    return GetAPCostAndUnit(drag_item, src, self.slot_name, dest, dest_slot_name, item, is_reload, is_upgrade)
  end

  function XInventorySlot:CanDropAt(pt)
    if not pt then
      return true
    end
    local unit = self:GetContext()
    if not unit then
      return
    end
    local stackable = IsKindOf(InventoryDragItem, "InventoryStack")
    local dest_slot = self.slot_name
    local _, dx, dy = self:FindTile(pt)
    if not dx then
      return true
    end
    local item_at_dest = dx and unit:GetItemInSlot(dest_slot, nil, dx, dy)
    stackable = stackable and item_at_dest and item_at_dest.class == InventoryDragItem.class
    if IsReload(InventoryDragItem, item_at_dest) or IsUpgrade(InventoryDragItem, item_at_dest) or IsMedicineRefill(InventoryDragItem, item_at_dest) or InventoryIsCombineTarget(InventoryDragItem, item_at_dest) then
      return true
    end
    if not unit:CheckClass(InventoryDragItem, dest_slot) then
      return false, "different class"
    end
    local is_equip_slot = IsEquipSlot(dest_slot)
    if not is_equip_slot and item_at_dest and item_at_dest ~= InventoryDragItem and not stackable and InventoryDragItem.LargeItem ~= item_at_dest.LargeItem then
      return false, "cannot swap"
    end
    if not is_equip_slot and InventoryDragItem.LargeItem then
      local ssx, ssy, sdx = point_unpack(InventoryDragItemPos)
      if 0 <= sdx then
        dx = dx - sdx
      end
      local otherItem = unit:GetItemInSlot(dest_slot, nil, dx, dy)
      if otherItem and (otherItem.LargeItem ~= InventoryDragItem.LargeItem or item_at_dest and item_at_dest ~= otherItem) then
        return false, "cannot swap"
      end
    end
    return true
  end