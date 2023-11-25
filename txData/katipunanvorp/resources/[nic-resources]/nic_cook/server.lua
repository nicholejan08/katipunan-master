VORPInv = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

-- cook

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("pot", function(data)
		local _source = source
		TriggerClientEvent('nic_cook:setCook', data.source)
	end)
end)

RegisterServerEvent('nic_cook:additem')
AddEventHandler('nic_cook:additem', function()
	local _source = source
	VORPInv.addItem(_source, 'pot', 1)
end)

RegisterServerEvent('nic_cook:removeitem')
AddEventHandler('nic_cook:removeitem', function()
	local _source = source
    VORPInv.subItem(_source,"pot", 1)
    return
end)

-- RegisterNetEvent("nic_cook:checkRecipe")
-- AddEventHandler("nic_cook:checkRecipe", function()
--     local _source = source
--     TriggerEvent('vorp:getCharacter', _source, function(data)
--         local items = {"garlic","onion","ginger","vinegar","soy_sauce","cooking_oil","black_pepper","salt"}
--         local complete = true

--         for i=1, #items do
--             local item1 = VORPInv.getItemCount(_source, items[i])
--         end
--         if complete then
--             for x=1, #items do
--                 VORPInv.subItem(_source, items[x], 1)                
--             end
--             --TriggerClientEvent('nic_cook:triggerCook', _source)
--             VorpInv.addItem(_source, 'glicense', 1)
--         end
--     end)
-- end)

RegisterNetEvent("nic_cook:checkAdoboIngredients")
AddEventHandler("nic_cook:checkAdoboIngredients", function()
    local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(data)
        local items = {"porkstew_recipe"}
        local complete = true

        for i=1, #items do
            local item1 = VORPInv.getItemCount(_source, items[i])

            if item1 == 0 then
                complete = false
                TriggerClientEvent("vorp:TipBottom", _source, "You have no "..items[i], 6000)
                TriggerClientEvent('nic_cook:emoteList', _source)
                break
            end
        end
        if complete then
            for x=1, #items do
                VORPInv.subItem(_source, items[x], 1)                
            end
            TriggerClientEvent('nic_cook:triggerCook', _source)
        end
    end)
end)

RegisterNetEvent("nic_cook:checkMenudoIngredients")
AddEventHandler("nic_cook:checkMenudoIngredients", function()
    local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(data)
        local items = {"beefstew_recipe"}
        local complete = true

        for i=1, #items do
            local item1 = VORPInv.getItemCount(_source, items[i])

            if item1 == 0 then
                complete = false
                TriggerClientEvent("vorp:TipBottom", _source, "You have no "..items[i], 6000)
                TriggerClientEvent('nic_cook:emoteList', _source)
                break
            end
        end
        if complete then
            for x=1, #items do
                VORPInv.subItem(_source, items[x], 1)
            end
            TriggerClientEvent('nic_cook:triggerCook', _source)
        end
    end)
end)