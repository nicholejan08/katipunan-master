
VORP = exports.vorp_core:vorpAPI()

RegisterCommand('command', function(source, args, rawCommand)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
        local group = user.group
        if group == 'admin' then
		TriggerClientEvent('lto_pedmenu:open', _source)
        end
    end)
end)

-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_companion:checkJob')
AddEventHandler('nic_companion:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'beastmaster' then
            TriggerClientEvent('nic_companion:Initialize', source)
        end
    end)
end)