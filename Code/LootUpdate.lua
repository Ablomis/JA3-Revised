function OnMsg.EnterSector()
    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'HiPower') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_BHPMag'}
            end
        end
    end
    
    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'Bereta92') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_BerettaMag'}
            end
        end
    end
    
    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'Glock18') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_Glock18Mag'}
            end
        end
    end
    
    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'DesertEagle') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_DesertEagleMag'}
            end
        end
    end
    
    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'MP40') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_MP40Mag'}
            end
        end
    end
    
    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'UZI') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_UZIMag'}
            end
        end
    end
  end
