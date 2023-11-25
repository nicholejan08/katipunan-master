local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Inventory = exports.vorp_inventory:vorp_inventoryApi()

Citizen.CreateThread(function()
	Citizen.Wait(10)
	Inventory.RegisterUsableItem("carrot", function(data)
		local _source = source
		TriggerClientEvent('nic_horseitems:carrot', data.source)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	Inventory.RegisterUsableItem("haycube", function(data)
		local _source = source
		TriggerClientEvent('nic_horseitems:haycube', data.source)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	Inventory.RegisterUsableItem("horse_stim", function(data)
		local _source = source
		TriggerClientEvent('nic_horseitems:horse_stim', data.source)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	Inventory.RegisterUsableItem("horsebrush", function(data)
		local _source = source
		TriggerClientEvent('nic_horseitems:brush', data.source)
	end)
end)

RegisterServerEvent('nic_horseitems:removeItem')
AddEventHandler('nic_horseitems:removeItem', function(value)
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        Inventory.subItem(_source, value, 1)
        return
    end)
end)

