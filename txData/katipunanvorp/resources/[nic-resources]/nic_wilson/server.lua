VORPInv = exports.vorp_inventory:vorp_inventoryApi()

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("wilson", function(data)
		local _source = source
		TriggerClientEvent('nic_wilson:useWilson', data.source)
	end)
end)

RegisterServerEvent('nic_wilson:removeItem')
AddEventHandler('nic_wilson:removeItem', function()
	local _source = source
	VORPInv.subItem(_source, 'wilson', 1)
end)

RegisterServerEvent('nic_wilson:additem')
AddEventHandler('nic_wilson:additem', function()
	local _source = source
	VORPInv.addItem(_source, 'wilson', 1)
end)