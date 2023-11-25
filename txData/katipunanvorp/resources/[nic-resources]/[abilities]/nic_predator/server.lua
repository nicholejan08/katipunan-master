VORP = exports.vorp_core:vorpAPI()

-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_predator:checkJob')
AddEventHandler('nic_predator:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'predator' then
            TriggerClientEvent('nic_predator:Initialize', source)
        else
            TriggerClientEvent("vorp:TipBottom", _source, "You're not a Predator", 6000)
        end
    end)
end)