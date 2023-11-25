VORPInv = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData", function(call)
    data = call
end)

RegisterServerEvent('nic_travel:removeitem')
AddEventHandler('nic_travel:removeitem', function(ticket)
	local _source = source
	local item = ticket

    VORPInv.subItem(_source, item, 1)
    return
end)

RegisterServerEvent('nic_travel:checkBicolTicket')
AddEventHandler('nic_travel:checkBicolTicket', function()
    local _source = source
    local count = VORPInv.getItemCount(_source, "bticket")
    local bool = false
    
    if count > 0 then
		TriggerClientEvent('nic_travel:proceedToBicol', _source)
    else
        TriggerClientEvent("vorp:TipBottom", _source, "Wala kang Ticket ng Bicol para Bumyahe", 5000)
    end
end)

RegisterServerEvent('nic_travel:checkManilaTicket')
AddEventHandler('nic_travel:checkManilaTicket', function()
    local _source = source
    local count = VORPInv.getItemCount(_source, "mticket")
    local bool = false
    
    if count > 0 then
		TriggerClientEvent('nic_travel:proceedToManila', _source)
    else
        TriggerClientEvent("vorp:TipBottom", _source, "Wala kang Ticket ng Maynila para Bumyahe", 5000)
    end
end)

RegisterServerEvent('nic_travel:removeitem')
AddEventHandler('nic_travel:removeitem', function(ticket)
	local _source = source
	local item = ticket
    VORPInv.subItem(_source, item, 1)
    return
end)

