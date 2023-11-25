-- Made by Blue 
local online = {}

keys = {
    -- Letter E
    ["F1"] = 0xA8E3F467,
}

function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

local keyopen = false

Citizen.CreateThread( function()
    WarMenu.CreateMenu('players', 'KATIPUNAN RP')
	while true do

        if WarMenu.IsMenuOpened('players') then
        
            for i = 1, #online do
                if WarMenu.Button("~COLOR_WHITE~ID: ~COLOR_YELLOWSTRONG~"..online[i].no.."~COLOR_WHITE~ | ~COLOR_YELLOWSTRONG~"..online[i].name.."~COLOR_WHITE~ | PING: ~COLOR_YELLOWSTRONG~".. online[i].pong) then
                end
            end

        end
        WarMenu.Display()
		Citizen.Wait(0)
	end
end)

function GetPlayers()
    local players = {}

    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end


Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(0)
        if whenKeyJustPressed(keys["F1"]) then
            TriggerServerEvent("syn:players", GetPlayers())
            Citizen.Wait(200)
            WarMenu.OpenMenu('players')
            Citizen.Wait(2000)
            WarMenu.CloseMenu('players')
        end  
    end
end) 

RegisterNetEvent("syn:paylerlist")
AddEventHandler("syn:paylerlist", function(players)
    online = players
end)
