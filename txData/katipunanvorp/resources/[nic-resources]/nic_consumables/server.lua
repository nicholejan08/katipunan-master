
-- VORP FRAMEWORK IMPORTS
----------------------------------------------------------------------------------------------------

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

-- SERVER EVENTS
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	Citizen.Wait(10)
    for key, value in pairs(Config.consumable.item) do
        VORPInv.RegisterUsableItem(value.name, function(data)
            local _source = source
            if value.type == 'food' or value.type == 'food_crunch' or value.type == 'food_long' then
                if value.objectPlacement == 'custom' then
                    TriggerClientEvent('nic_consumables:getCustomValues', data.source, value.objectPlacement, value.x, value.y, value.z, value.rotx, value.roty, value.rotz)
                end
                TriggerClientEvent('nic_consumables:eatItem', data.source, value.name, value.propModel, value.type, value.amount)
            elseif value.type == 'canned' then
                if value.objectPlacement == 'custom' then
                    TriggerClientEvent('nic_consumables:getCustomValues', data.source, value.objectPlacement, value.x, value.y, value.z, value.rotx, value.roty, value.rotz)
                end
                TriggerClientEvent('nic_consumables:eatCannedItem', data.source, value.name, value.propModel, value.type, value.amount)
            elseif value.type == 'drinks' or value.type == 'drinks_slow' then
                if value.objectPlacement == 'custom' then
                    TriggerClientEvent('nic_consumables:getCustomValues', data.source, value.objectPlacement, value.x, value.y, value.z, value.rotx, value.roty, value.rotz)
                end
                TriggerClientEvent('nic_consumables:drinkItem', data.source, value.name, value.propModel, value.type, value.amount)
            elseif value.type == 'medicine' or value.type == 'medicine_strong' then
                if value.objectPlacement == 'custom' then
                    TriggerClientEvent('nic_consumables:getCustomValues', data.source, value.objectPlacement, value.x, value.y, value.z, value.rotx, value.roty, value.rotz)
                end
                TriggerClientEvent('nic_consumables:drinkMedicine', data.source, value.name, value.propModel, value.type, value.amount)
            elseif value.type == 'liquor' then
                if value.objectPlacement == 'custom' then
                    TriggerClientEvent('nic_consumables:getCustomValues', data.source, value.objectPlacement, value.x, value.y, value.z, value.rotx, value.roty, value.rotz)
                end
                TriggerClientEvent('nic_consumables:drinkLiquor', data.source, value.name, value.propModel, value.type, value.amount)
            end
        end)
    end
end)


RegisterServerEvent('nic_consumables:lastCanteen')
AddEventHandler('nic_consumables:lastCanteen', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        local count = VORPInv.getItemCount(_source, "canteen")
        local lastItem = false

        if count > 1 then
            lastItem = false
            TriggerClientEvent('nic_consumables:drinkCanteen', _source, lastItem, count) 
        else
            lastItem = true
            TriggerClientEvent('nic_consumables:drinkCanteen', _source, lastItem, count)
        end
    end)    
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("canteen", function(data)
		local _source = source        
        TriggerClientEvent('nic_consumables:triggerLastCanteen', data.source)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("invi_potion", function(data)
		local _source = source
		TriggerClientEvent('nic_consumables:drinkInvi', data.source)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("jump_potion", function(data)
		local _source = source
		TriggerClientEvent('nic_consumables:drinkJump', data.source)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("tango", function(data)
		local _source = source
		TriggerClientEvent('nic_consumables:useTango', data.source)
	end)
end)

-- ADD ITEMS FUNCTION
----------------------------------------------------------------------------------------------------

RegisterServerEvent('nic_consumables:addWater')
AddEventHandler('nic_consumables:addWater', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        local full = 20
        local count = VORPInv.getItemCount(_source, "canteen")
        local storage = full - count
    
        VORPInv.addItem(_source, "canteen", storage)
        TriggerClientEvent('nic_consumables:check', _source, storage, full, count)
        return
    end)
end)

RegisterServerEvent('nic_consumables:checkCanteen')
AddEventHandler('nic_consumables:checkCanteen', function()
	local _source = source
    local hasCanteen = false
    local count = VORPInv.getItemCount(_source, "canteen")

    if count > 0 then
        hasCanteen = true
        TriggerClientEvent('nic_consumables:getWater', _source, hasCanteen)
        TriggerClientEvent('nic_waterfunctions:collectWater', _source)
    else
        TriggerClientEvent("vorp:TipBottom", _source, "Wala kang lalagyan ng canteen", 6000)
    end
end)


-- REMOVE ITEMS FUNCTION
----------------------------------------------------------------------------------------------------

RegisterServerEvent('nic_consumables:removeItem')
AddEventHandler('nic_consumables:removeItem', function(selectedItem)
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        VORPInv.subItem(_source, selectedItem, 1)
        return
    end)
end)

RegisterServerEvent('nic_consumables:removeWater')
AddEventHandler('nic_consumables:removeWater', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        VORPInv.subItem(_source, 'canteen', 1)
        return
    end)
end)

-- FIRSTAID COUNTER
----------------------------------------------------------------------------------------------------

RegisterNetEvent("nic_consumables:getFirstAid")
AddEventHandler("nic_consumables:getFirstAid", function()
    local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        local count = VORPInv.getItemCount(_source, "firstaid")
        if count >= 1 then
            for key, value in pairs(Config.consumable.item) do
                TriggerClientEvent('nic_consumables:drinkMedicine', _source, 'firstaid', 'p_tonic02x', 'medicine', 20)
                return
            end
        else
            TriggerClientEvent("nic_consumables:prompt", _source)
        end
    end)
end)