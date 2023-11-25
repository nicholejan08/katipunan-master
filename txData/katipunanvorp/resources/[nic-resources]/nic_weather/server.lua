


function ExtractIdentifiers()
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

RegisterServerEvent('nic_defaults:extractIdentifiers')
AddEventHandler('nic_defaults:extractIdentifiers', function()
	local _source = source
    local identifiers = ExtractIdentifiers()
    local steam = identifiers.steam
    
    TriggerClientEvent('nic_defaults:getIdentifier', _source, steam)
end)