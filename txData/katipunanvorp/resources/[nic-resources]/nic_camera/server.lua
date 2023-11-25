
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local VorpCore = {}

-- GLOBAL IMPORTS
----------------------------------------------------------------------------------------------------

VORPInv = exports.vorp_inventory:vorp_inventoryApi()
VORP = exports.vorp_core:vorpAPI()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

TriggerEvent("getCore",function(core)
    VorpCore = core
end)


Citizen.CreateThread(function()
	Citizen.Wait(10)
	VORPInv.RegisterUsableItem("camera", function(data)
		local _source = source
		TriggerClientEvent('nic_camera:useCamera', data.source)
	end)
end)

-- SERVER EVENTS
----------------------------------------------------------------------------------------------------

RegisterServerEvent('nic_camera:triggerReward')
AddEventHandler('nic_camera:triggerReward', function(price)
    TriggerEvent("vorp:getCharacter",source,function(user)
        local _source = source
        VORP.addMoney(_source, 0, price)
	end)
end)

RegisterServerEvent('nic_camera:checkFilmCount')
AddEventHandler('nic_camera:checkFilmCount', function()
	local _source = source
    local count = VORPInv.getItemCount(_source, "film")

    if count <= 0 then
        TriggerClientEvent('nic_camera:triggerNoFilm', _source)
    else
        TriggerClientEvent('nic_camera:registerFilm', _source, count)
    end

end)

RegisterServerEvent('nic_camera:checkFilm')
AddEventHandler('nic_camera:checkFilm', function()
	local _source = source
    local count = VORPInv.getItemCount(_source, "film")

    if count > 0 then
        TriggerClientEvent('nic_camera:registerCheckedFilm', _source, count)
    else
        TriggerClientEvent('nic_camera:noFilm', _source, count)
    end
end)

RegisterServerEvent('nic_camera:removeItem')
AddEventHandler('nic_camera:removeItem', function()
	local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        VORPInv.subItem(_source, "film", 1)
        return
    end)
end)