
VORP = exports.vorp_core:vorpAPI()

RegisterServerEvent('nic_scout:initiatePower')
AddEventHandler('nic_scout:initiatePower', function(id)
    TriggerEvent("vorp:getCharacter", source, function(user)
        ExecuteCommand('setjob '..id..' scout')
        if user.job == 'scout' then
            TriggerClientEvent('nic_scout:Initialize', source)
		end
    end)
end)

-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_scout:checkJob')
AddEventHandler('nic_scout:checkJob', function(user)
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        local _source = source

        if user.job == 'scout' then
            TriggerClientEvent('nic_scout:usePower', source)
        end
    end)
end)

RegisterServerEvent('nic_scout:triggerServer')
AddEventHandler('nic_scout:triggerServer', function()
	local _source = source
    TriggerClientEvent('nic_scout:clone', _source)
end)