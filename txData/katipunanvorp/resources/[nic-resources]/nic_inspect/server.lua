
-- VORP FRAMEWORK IMPORTS
----------------------------------------------------------------------------------------------------

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

-- SERVER EVENTS
----------------------------------------------------------------------------------------------------

RegisterServerEvent('nic_inspect:useItem')
AddEventHandler('nic_inspect:useItem', function()
	local _source = source
    TriggerClientEvent('nic_inspect:triggerStart', source)
end)


RegisterServerEvent('nic_companion:checkJob')
AddEventHandler('nic_companion:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'beastmaster' then
            TriggerClientEvent('nic_companion:Initialize', source)
        end
    end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
    for key, value in pairs(Config.items) do
        VORPInv.RegisterUsableItem(value.name, function(data)
            local _source = source
            TriggerClientEvent('nic_inspect:inspect', data.source, value.model, value.bone, value.animDict, value.animation, value.x, value.y, value.z, value.rotx, value.roty, value.rotz)
        end)
    end
end)