VORP = exports.vorp_core:vorpAPI()

-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_antman:checkJob')
AddEventHandler('nic_antman:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'antman' then
            TriggerClientEvent('nic_antman:setAntman', source)
        else
            TriggerClientEvent('nic_antman:notAntman', source)
        end
    end)
end)

RegisterServerEvent('nic_antman:checkJobScroll')
AddEventHandler('nic_antman:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'antman' then
            TriggerClientEvent('nic_antman:setAntman', source)
        else
            TriggerClientEvent('nic_antman:notAntman', source)
        end
    end)
end)
