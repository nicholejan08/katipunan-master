VORPInv = exports.vorp_inventory:vorp_inventoryApi()


-- make fire

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("flint_steel", function(data)
		local _source = source
		TriggerClientEvent('ml_camping:setcampfire', data.source)
		VORPInv.subItem(data.source,"flint_steel", 1)
	end)
end)