-- Made by Blue 
local poutifts = 0
local playerskin = 0

keys = {
    -- Letter E
    ["SPACEBAR"] = 0xD9D0E1C0,
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
    WarMenu.CreateMenu('outfitsmenu', 'Changing Room')
	while true do

        if WarMenu.IsMenuOpened('outfitsmenu') then
            if poutifts == 0 then
                WarMenu.Button('No saved outfits')
            else
                for i = 1, #poutifts do
                    if WarMenu.Button(poutifts[i].title) then
                        local jsonCloths = poutifts[i].comps
                        TriggerEvent("vorpcharacter:loadPlayerSkin", playerskin, jsonCloths)
                        TriggerServerEvent("syn:setoutfit", jsonCloths)
                        WarMenu.CloseMenu()
                    end
                end
            end

        end
        WarMenu.Display()
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function()
	for _, info in pairs(Config.loc) do
        local blip = N_0x554d9d53f696d002(1664425300, info.x, info.y, info.z)
        SetBlipSprite(blip, 1001245999, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Changing Room")
    end  
end)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    SetTextFontForCurrentCommand(1) -- Cambiar tipo de fuente: 1,2,3,...
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    DisplayText(str, x, y)
end

Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        
        for k,v in pairs(Config.loc) do
            local betweencoords = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.x, v.y, v.z, false)
            if IsPedOnFoot(player) then
			if betweencoords < 1 then
                    DrawTxt("~COLOR_WHITE~Pindutin ang ~COLOR_WHITE~[~COLOR_RED~SPACE~COLOR_WHITE~] para magpalit ng damit", 0.50, 0.90, 0.7, 0.7, true, 255, 255, 255, 255, true)
                    if whenKeyJustPressed(keys["SPACEBAR"]) then
                        TriggerServerEvent("syn:getoutfits")
                        TriggerServerEvent("syn:getskin")
                        Citizen.Wait(700)
                        WarMenu.OpenMenu('outfitsmenu')
                    end
                end
            else end
        end
     
    end
end) 

RegisterNetEvent("syn:listoutfits")
AddEventHandler("syn:listoutfits", function(playeroutfits)
    poutifts = playeroutfits
end)
RegisterNetEvent("syn:getskins")
AddEventHandler("syn:getskins", function(skin)
    playerskin = skin
end)