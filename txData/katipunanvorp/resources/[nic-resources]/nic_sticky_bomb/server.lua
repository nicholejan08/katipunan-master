VORPInv = exports.vorp_inventory:vorp_inventoryApi()

Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("sticky_bomb", function(data)
		local _source = source
		TriggerClientEvent('nic_sticky_bomb:use_sticky_bomb', data.source)
	end)
end)

RegisterServerEvent('nic_sticky_bomb:remove_sticky_bomb')
AddEventHandler('nic_sticky_bomb:remove_sticky_bomb', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        VORPInv.subItem(_source, "sticky_bomb", 1)
        return
    end)
end)

RegisterServerEvent('nic_sticky_bomb:add_sticky_bomb')
AddEventHandler('nic_sticky_bomb:add_sticky_bomb', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        VORPInv.addItem(_source, "sticky_bomb", 1)
        return
    end)
end)

RegisterServerEvent('nic_sticky_bomb:checkCount')
AddEventHandler('nic_sticky_bomb:checkCount', function()
	local _source = source
    local count = VORPInv.getItemCount(_source, "sticky_bomb")
    if count > 0 then
		TriggerClientEvent('nic_sticky_bomb:use_sticky_bomb', _source)
    else
        TriggerClientEvent("vorp:TipBottom", _source, "You Don't Have a Sticky Bomb", 6000)
    end
end)