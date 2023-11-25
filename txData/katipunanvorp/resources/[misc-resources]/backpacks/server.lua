


VORP = exports.vorp_inventory:vorp_inventoryApi()

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("sack", function(data)
		local _source = source
		TriggerClientEvent('Perry_Reput:sack', data.source)
		VORP.subItem(data.source,"sack", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("reppu1", function(data)
		local _source = source
		TriggerClientEvent('Perry_Reput:reppu1', data.source)
		VORP.subItem(data.source,"reppu1", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("reppu2", function(data)
		local _source = source
		TriggerClientEvent('Perry_Reput:reppu2', data.source)
		VORP.subItem(data.source,"reppu2", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("reppu3", function(data)
		local _source = source
		TriggerClientEvent('Perry_Reput:reppu3', data.source)
		VORP.subItem(data.source,"reppu3", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("plywood", function(data)
		local _source = source
		TriggerClientEvent('nic_attach:plywood', data.source)
		VORP.subItem(data.source,"plywood", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("juggernaut", function(data)
		local _source = source
		TriggerClientEvent('nic_attach:juggernaut', data.source)
		VORP.subItem(data.source,"juggernaut", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("flag", function(data)
		local _source = source
		TriggerClientEvent('nic_attach:flag', data.source)
		VORP.subItem(data.source,"flag", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("medbox", function(data)
		local _source = source
		TriggerClientEvent('nic_attach:medbox', data.source)
		VORP.subItem(data.source,"medbox", 1)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
    VORP.RegisterUsableItem("helmet", function(data)
		local _source = source
		TriggerClientEvent('nic_attach:helmet', data.source)
		VORP.subItem(data.source,"helmet", 1)
	end)
end)