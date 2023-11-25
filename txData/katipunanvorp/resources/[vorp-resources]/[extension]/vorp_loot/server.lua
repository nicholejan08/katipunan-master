VORP = exports.vorp_core:vorpAPI()
VorpInv = exports.vorp_inventory:vorp_inventoryApi()
local itemcount = math.random(Config.itemcount['min'], Config.itemcount['max'])

RegisterServerEvent('vorp_loot')
AddEventHandler('vorp_loot', function(price,xp)
    local _source = source
    local _price = tonumber(price)
	local _xp = tonumber(xp)
    TriggerEvent("vorp:getCharacter",source,function(user)
        VORP.addMoney(_source, 0, _price)
        VORP.addXp(_source, _xp)
    end)
end)

RegisterServerEvent('nic_loot:additem')
AddEventHandler('nic_loot:additem', function(thing, itemcount)
    local thing = ""
    local _source = source
    for i = 1, #Config.items, 1 do
        VorpInv.addItem(_source, Config.items[i].hash, itemcount)
        thing = Config.items[i].hash
    end    
end)