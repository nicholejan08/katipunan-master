VORPInv = exports.vorp_inventory:vorp_inventoryApi()

local randomItem = ""

Citizen.CreateThread(function()
    Citizen.Wait(10)
        VORPInv.RegisterUsableItem(randomItem, function(data)
    end)
end)

RegisterServerEvent('nic_clone:addRandomItem')
AddEventHandler('nic_clone:addRandomItem', function(offeredItem)
    local _source = source
    local item = offeredItem
    randomItem = offeredItem
    VORPInv.addItem(_source, item, 1)
    TriggerClientEvent("vorp:TipBottom", _source, " ", 3000)
end)

RegisterCommand('startClone', function(source, args, rawCommand)
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

RegisterServerEvent('nic_clone:checkJob')
AddEventHandler('nic_clone:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'sombra' then
            TriggerClientEvent('nic_clone:Initialize', source)
        -- else
        --     TriggerClientEvent("vorp:TipBottom", _source, "You're not a Shinobi", 6000)
        end
    end)
end)

RegisterServerEvent('nic_clone:triggerServer')
AddEventHandler('nic_clone:triggerServer', function()
	local _source = source

    for key, value in pairs(Config.settings) do
        if value.associateType == "clone" then
            TriggerClientEvent('nic_clone:shadowClone', _source)
        elseif value.associateType == "custom" then
            TriggerClientEvent('nic_clone:associate', _source)
        end
    end
    
end)
