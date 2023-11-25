VORPInv = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

-- tents

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentA1"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentA2"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentA3"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentA4"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentB1"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentB2"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentB3"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentC1"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentC2"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentC3"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentC4"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)	
	local selectedTent = "tentC5"
	VORPInv.RegisterUsableItem(selectedTent, function(data)
		local _source = source
		TriggerClientEvent('nic_tents:setTent', data.source, selectedTent)
	end)	
end)

RegisterServerEvent('nic_tents:additem')
AddEventHandler('nic_tents:additem', function(value)	
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
		VORPInv.addItem(_source, value, 1)
        return
    end)
end)

RegisterServerEvent('nic_tents:removeitem')
AddEventHandler('nic_tents:removeitem', function(selectedItem)
	local _source = source
    VORPInv.subItem(_source, selectedItem, 1)
    return
end)
