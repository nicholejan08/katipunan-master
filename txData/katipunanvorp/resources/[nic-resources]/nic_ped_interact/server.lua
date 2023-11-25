
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
	VORPInv.RegisterUsableItem("wateringcan", function(data)
		local _source = source
		TriggerClientEvent('nic_planting:useWateringcan', data.source)
	end)
end)

-- RegisterNetEvent("nic_consumables:getFirstAid")
-- AddEventHandler("nic_consumables:getFirstAid", function()
--     local _source = source
--     TriggerEvent('vorp:getCharacter', _source, function(user)
--         local count = VORPInv.getItemCount(_source, "firstaid")
--         if count >= 1 then
--             for key, value in pairs(Config.consumable.item) do
--                 TriggerClientEvent('nic_consumables:drinkMedicine', _source, 'firstaid', 'p_tonic02x', 'medicine', 20)
--                 return
--             end
--         else
--             TriggerClientEvent("vorp:TipBottom", _source, "Ubos na ang iyong Gamot", 6000)
--         end
--     end)
-- end)