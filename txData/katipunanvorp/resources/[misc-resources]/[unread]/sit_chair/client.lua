local isInZone = false
local count = 0

RegisterNetEvent('anim_menuopen') AddEventHandler('anim_menuopen', function() 
	WarMenu.OpenMenu('Anim') 
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if IsPlayerNearCoords(2688.84, -1117.15, 49.7) then
            -- DrawTxt("~COLOR_WHITE~Pindutin ang ~COLOR_BLUE~G~COLOR_WHITE~ Para umupo ".. count, 0.72, 0.05, 0.3, 0.3, true, 255, 0, 0, 255, true)  
            DrawTxt("~COLOR_WHITE~Pindutin ang ~COLOR_BLUE~G~COLOR_WHITE~ Para umupo ", 0.72, 0.05, 0.3, 0.3, true, 255, 0, 0, 255, true)   
            if IsControlJustPressed(0, 0x760A9C6F) then  
                count = count + 1                  
                ClearPedTasks(GetPlayerPed())     
                if count%2 == 1 then 
                    TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('GENERIC_SEAT_CHAIR_SCENARIO'), 2688.844, -1116.55, 50.28, 177.63, 0, true, true, 0, true)
                    Citizen.Wait(2000) 
                end          
            end
        end
    end    
end)

function DisplayPayment()
    Citizen.CreateThread(function()
        count = count + 1  
		while count < 5000 do
			Wait(0)
			N_0xe296208c273bd7f0(-1, -1, 0, 17, 0, 0)
		end
	end)
end
    
Citizen.CreateThread(function()    
    while true do 
        Citizen.Wait(1)
        if IsControlJustPressed(0, 0x156F7119) and count%2 == 0 then
            count = count + 1
            ClearPedTasks(GetPlayerPed())
            Citizen.Wait(2000)     
        end 
    end
end)

function IsPlayerNearCoords(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 3 then
        return true
    end
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    SetTextFontForCurrentCommand(15) -- Cambiar tipo de fuente: 1,2,3,...
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    DisplayText(str, x, y)
end