VORPInv = exports.vorp_inventory:vorp_inventoryApi()

RegisterServerEvent('nic_pee:additem')
AddEventHandler('nic_pee:additem', function()
	local _source = source
	VORPInv.addItem(_source, 'mushroom', 1)
	Citizen.Wait(1000)
end)
