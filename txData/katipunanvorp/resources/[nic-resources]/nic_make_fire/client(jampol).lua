
local isInZone = false
local count = 0
local campfires = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))   
        local fire = DoesObjectOfTypeExistAtCoords(x, y, z, 1.0, GetHashKey("p_campfirefresh01x"), true)
		local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped) -- ISPEDHOLDING
        local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)
        local model = GetEntityModel(holding)
        local pedtype = GetPedType(holding)   
		entity = holding
		local model = GetEntityModel(holding)		
		if fire then 
            DrawTxt("~COLOR_WHITE~Pindutin ang ~COLOR_BLUE~SPACE~COLOR_WHITE~ Para magluto sa Apoy... ", 0.50, 0.05, 0.3, 0.3, true, 255, 0, 0, 255, true) 
            DrawTxt("~COLOR_WHITE~Pindutin ang ~COLOR_BLUE~BACKSPACE~COLOR_WHITE~ Para patayin ang Apoy... ", 0.50, 0.07, 0.3, 0.3, true, 255, 0, 0, 255, true) 
            if IsControlJustPressed(0, 0x156F7119) then  
                count = count + 1                  
                ClearPedTasks(GetPlayerPed())     
                if count%2 == 1 then 
                    TriggerEvent("ml_camping:delcampfire")
                    Citizen.Wait(2000) 
                end  
            elseif IsControlJustPressed(0, 0xD9D0E1C0) then 	
                TriggerEvent("ml_camping:cookcampfire")
            end        
        end
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustPressed(0, 0x4AF4D473) then			
		TriggerEvent("ml_camping:setcampfire")
		end
	end 
end)


RegisterNetEvent('ml_camping:cookcampfire')
AddEventHandler('ml_camping:cookcampfire', function()     
    ClearPedTasks(GetPlayerPed())   
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey("GENERIC_SIT_GROUND_SCENARIO"), 5000, true, false, false, false)
    Citizen.Wait(5000) 
    ClearPedTasksImmediately(GetPlayerPed())   
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey("WORLD_HUMAN_CANNED_FOOD_COOKING"), -1, true, false, false, false)
    Citizen.Wait(9000) 
    exports['progressbar']:startUI(8000, "Nagluluto...")
    Citizen.Wait(8000)     
    ClearPedTasks(GetPlayerPed())   
end)

RegisterNetEvent('ml_camping:setcampfire')
AddEventHandler('ml_camping:setcampfire', function()
    -- if campfire ~= 0 then
    --     SetEntityAsMissionEntity(campfire)
    --     DeleteObject(campfire)
    --     campfire = 0
    -- end
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 8000, true, false, false, false)
    exports['progressbar']:startUI(10000, "Gumagawa ng Apoy")
    Citizen.Wait(10000)
    ClearPedTasks(PlayerPedId())
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.55))
    local prop = CreateObject(GetHashKey("p_campfirefresh01x"), x, y, z, true, false, true)
    SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
    PlaceObjectOnGroundProperly(prop)
    table.insert(campfires, 1, {prop, x, y, z});
end)

RegisterNetEvent('ml_camping:delcampfire')
AddEventHandler('ml_camping:delcampfire', function()
    if campfire == 0 then
        print("There is no campfire.")
    else
        local playerPed = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(playerPed))
        local fire = DoesObjectOfTypeExistAtCoords(x, y, z, 1.0, GetHashKey("p_campfirefresh01x"), true)
        TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 5000, true, false, false, false)
        exports['progressbar']:startUI(5000, "Pinapatay ang Apoy")
        Citizen.Wait(5000)
        ClearPedTasks(PlayerPedId())
        SetEntityAsMissionEntity(campfire)
        DeleteObject(campfire)
        campfire = 0
        if fire then
            table.getn(campfires)
            for val, idx in ipairs(campfires) do
                campfire = val[0]
                cx = val[1]
                cy = val[2]
                cz = val[3]
                if IsPlayerNearCoords(cx,cy,cz) then
                    ClearPedTasks(PlayerPedId())
                    SetEntityAsMissionEntity(campfire)
                    DeleteObject(campfire)    
                    table.remove(campfires, idx+1)
                    break  
                end
            end
        end
    end

end)
    
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

    if distance < 2 then
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