
-- VORP FRAMEWORK IMPORTS
----------------------------------------------------------------------------------------------------

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

-- SERVER EVENTS
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("cigarette", function(data)
		local _source = source
		TriggerClientEvent('nic_cigars:useCigarette', data.source)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("cigar", function(data)
		local _source = source
		TriggerClientEvent('nic_cigars:usecigar', data.source)
	end)
end)


RegisterServerEvent('nic_cigars:removeCigarette')
AddEventHandler('nic_cigars:removeCigarette', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        VORPInv.subItem(_source, 'cigarette', 1)
        return
    end)
end)

RegisterServerEvent('nic_cigars:removecigar')
AddEventHandler('nic_cigars:removecigar', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        VORPInv.subItem(_source, 'cigar', 1)
        return
    end)
end)