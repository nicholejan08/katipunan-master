
VORPInv = exports.vorp_inventory:vorp_inventoryApi()

RegisterCommand('dirty', function(source)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
		TriggerClientEvent('nic_hobo:dirty', _source)
    end)
end)


-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_hobo:checkJob')
AddEventHandler('nic_hobo:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'hobo' then
            TriggerClientEvent('nic_hobo:trigger', source)
        end
    end)
end)