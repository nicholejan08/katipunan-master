
RegisterCommand('edit', function(source, args, rawCommand)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
        local group = user.group
        if group == 'admin' then
		TriggerClientEvent('nic_attach:startEditing', _source)
        end
    end)
end)