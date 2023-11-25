
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local VorpCore = {}

-- GLOBAL IMPORTS
----------------------------------------------------------------------------------------------------

Inventory = exports.vorp_inventory:vorp_inventoryApi()
VORP = exports.vorp_core:vorpAPI()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

-- SERVER EVENTS
---------------------------------------------------------------------------------------------------

RegisterServerEvent('nic_lumber:checkAxe')
AddEventHandler('nic_lumber:checkAxe', function(entityHit)
    local _source = source
    local count = Inventory.getItemCount(_source, "axe")
    local bool = false
    
    if count > 0 then
        bool = true
    else
        bool = false
    end
    TriggerClientEvent('nic_lumber:chopTreeDecide', _source, bool, entityHit)
end)

RegisterServerEvent('nic_lumber:pay')
AddEventHandler('nic_lumber:pay', function(treeValue)
    TriggerEvent("vorp:getCharacter",source,function(user)
        local _source = source
        VORP.addMoney(_source, 0, treeValue)
	end)
end)
