VORPInv = exports.vorp_inventory:vorp_inventoryApi()

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("townportal", function(data)
		local _source = source
		TriggerClientEvent('nic_townportal:useItem', data.source)
		VORPInv.subItem(data.source,"townportal", 1)
	end)
end)
