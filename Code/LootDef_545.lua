PlaceObj('ModItemLootDef', {
	Comment = "list",
	id = "Sunmaker-Loot-545x39_Basic",
	loot = "all",
	PlaceObj('LootEntryInventoryItem', {
		item = "_545x39_Basic",
		stack_max = 90,
		stack_min = 30,
	}),
})
PlaceObj('ModItemLootDef', {
	Comment = "list",
	id = "Sunmaker-Loot-545x39_AP",
	loot = "all",
	PlaceObj('LootEntryInventoryItem', {
		item = "_545x39_AP",
		stack_max = 90,
		stack_min = 30,
	}),
})
PlaceObj('ModItemLootDef', {
	Comment = "list",
	id = "Sunmaker-Loot-545x39_HP",
	loot = "all",
	PlaceObj('LootEntryInventoryItem', {
		item = "_545x39_HP",
		stack_max = 90,
		stack_min = 30,
	}),
})
PlaceObj('ModItemLootDef', {
	Comment = "list",
	id = "Sunmaker-Loot-545x39_Match",
	loot = "all",
	PlaceObj('LootEntryInventoryItem', {
		item = "_545x39_Match",
		stack_max = 90,
		stack_min = 30,
	}),
})
PlaceObj('ModItemLootDef', {
	Comment = "list",
	id = "Sunmaker-Loot-545x39_Tracer",
	loot = "all",
	PlaceObj('LootEntryInventoryItem', {
		item = "_545x39_Tracer",
		stack_max = 90,
		stack_min = 30,
	}),
})
PlaceObj('ModItemLootDef', {
	Comment = "list",
	id = "Sunmaker-Loot-545x39_Varied",
	loot = "all",
	PlaceObj('LootEntryLootDef', {
		loot_def = "Sunmaker-Loot-545x39_AP",
	}),
	PlaceObj('LootEntryLootDef', {
		loot_def = "Sunmaker-Loot-545x39_Basic",
		weight = 10000,
	}),
	PlaceObj('LootEntryLootDef', {
		loot_def = "Sunmaker-Loot-545x39_HP",
	}),
	PlaceObj('LootEntryLootDef', {
		loot_def = "Sunmaker-Loot-545x39_Match",
	}),
	PlaceObj('LootEntryLootDef', {
		loot_def = "Sunmaker-Loot-545x39_Tracer",
	}),
})

