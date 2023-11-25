local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()


RegisterServerEvent("syn_death:delete")
AddEventHandler("syn_death:delete", function()
    local _source = source
    local Character = VorpCore.getUser(source).getUsedCharacter
    local money = Character.money
    local gold = Character.gold
    local role = Character.rol

    if Config.removeweapons then 
        TriggerEvent("vorpCore:getUserWeapons", tonumber(_source), function(getUserWeapons)
           for k, v in pairs (getUserWeapons) do
            local id = v.id
            VorpInv.subWeapon(_source, v.id)
            exports.ghmattimysql:execute("DELETE FROM loadout WHERE id=@id", { ['id'] = id})
           end
        end)
    end
    if Config.removeitems then 
        TriggerEvent("vorpCore:getUserInventory", tonumber(_source), function(getInventory)
            for k, v in pairs (getInventory) do
                VorpInv.subItem(_source, v.name, v.count)  
            end
        end) 
    end

    if Config.removecash then 
        Character.removeCurrency(0, money)
    end
    if Config.removegold then 
        Character.removeCurrency(1, gold)
    end
    if Config.removerole then 
        Character.removeCurrency(2, role)
    end
end) 