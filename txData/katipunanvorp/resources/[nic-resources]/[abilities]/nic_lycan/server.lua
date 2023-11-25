VORP = exports.vorp_core:vorpAPI()

-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_lycan:checkJob')
AddEventHandler('nic_lycan:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'lycan' then
            TriggerClientEvent('nic_lycan:Initialize', source)
        else
            TriggerClientEvent("vorp:TipBottom", _source, "You're not a Lycan", 6000)
        end
    end)
end)