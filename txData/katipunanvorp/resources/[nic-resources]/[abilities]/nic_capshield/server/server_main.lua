
-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_capshield:checkJob')
AddEventHandler('nic_capshield:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter", source ,function(user)
        if user.job == 'captain' then
            TriggerClientEvent('nic_capshield:initialize', source)
        end
    end)
end)