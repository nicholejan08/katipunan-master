VORPInv = exports.vorp_inventory:vorp_inventoryApi()

local randomItem = ""

Citizen.CreateThread(function()
    Citizen.Wait(10)
        VORPInv.RegisterUsableItem(randomItem, function(data)
    end)
end)

RegisterServerEvent('nic_sombra:addRandomItem')
AddEventHandler('nic_sombra:addRandomItem', function(offeredItem)
    local _source = source
    local item = offeredItem
    randomItem = offeredItem
    VORPInv.addItem(_source, item, 1)
    TriggerClientEvent("vorp:TipBottom", _source, " ", 3000)
end)

-- SERVER IMPORTS
-------------------------------------------------------------------

RegisterServerEvent('nic_sombra:checkJob')
AddEventHandler('nic_sombra:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter", source ,function(user)
        if user.job == 'sombra' then
            TriggerClientEvent('nic_sombra:Initialize', source, true)
        end
    end)
end)

RegisterServerEvent('nic_sombra:allowServerScroll')
AddEventHandler('nic_sombra:allowServerScroll', function()
    local _source = source
    TriggerEvent("vorp:getCharacter", source ,function(user)
        if user.job == 'sombra' then
            TriggerClientEvent('nic_sombra:allowScroll', source, true)
        end
    end)
end)