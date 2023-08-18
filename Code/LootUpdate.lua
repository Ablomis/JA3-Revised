function LoadLoot()
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

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'MP5') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_MP5Mag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'AK47') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_AK47Mag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'AK74') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_AK74Mag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'FAMAS') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_FAMASMag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'AUG') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_AugMag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'M16A2' or v.item == 'G36' or v.item == 'AR15') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_STANAGMag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'GALIL') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_GalilMag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'M14SAW' or v.item == 'M24' or v.item == 'PSG1') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_M14Mag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'DragunovSVD') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_SVDMag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'HK21') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_HK21Mag'}
            end
        end
    end

    for _, loot_def in pairs(LootDefs) do
        for k,v in pairs(loot_def) do
            if(v.item == 'RPK74') then 
                loot_def[#loot_def+1] = {loot_def = 'LootDef_RPK74Mag'}
            end
        end
    end
end

function OnMsg.CombatStart()
    if not (LootDefs['LegionGoon'][5]) then
        LoadLoot()
        print(LootDefs['LegionGoon'])
    end
end


function OnMsg.ZuluGameLoaded(game)
    print(LootDefs['LegionGoon'])
    if not (LootDefs['LegionGoon'][5]) then
        
        LoadLoot()
        print(LootDefs['LegionGoon'])
    end
end

