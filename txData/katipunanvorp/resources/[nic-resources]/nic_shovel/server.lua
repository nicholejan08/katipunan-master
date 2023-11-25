
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
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	Citizen.Wait(10)
	Inventory.RegisterUsableItem("shovel", function(data)
		local _source = source
		TriggerClientEvent('nic_shovel:useShovel', data.source)
	end)
end)

RegisterServerEvent('nic_shovel:addItem')
AddEventHandler('nic_shovel:addItem', function(item)
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)

        Inventory.addItem(_source, item, 1)
        return
    end)
end)

RegisterServerEvent('nic_cuttree:pay')
AddEventHandler('nic_cuttree:pay', function(treeValue)
    TriggerEvent("vorp:getCharacter",source,function(user)
        local _source = source
        VORP.addMoney(_source, 0, treeValue)
	end)
end)
