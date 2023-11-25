local campfire = 0
local fireModel = "p_campfirefresh01x"
local buildFireModel = "p_campfire_win2_01x"
local debrisfireModel = "p_campfiredebris01x"
local isInZone = false
local count = 0
local sprite = 1754365229
local fireName = ""

Citizen.CreateThread(function()
    Citizen.Wait(0)
	while true do
        Citizen.Wait(10)
        fireName = "Apoy"
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))   
        local fire = DoesObjectOfTypeExistAtCoords(x, y, z, 0.7, GetHashKey(fireModel), true) 
        local fire2 = DoesObjectOfTypeExistAtCoords(x, y, z, 0.7, GetHashKey(ignitefireModel), true)
		local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped) -- ISPEDHOLDING
        local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)
        local model = GetEntityModel(holding)
        local pedtype = GetPedType(holding)   
		entity = holding
		local model = GetEntityModel(holding)	
        local blip = SET_BLIP_TYPE( campfire )
        Citizen.InvokeNative(0xFA925AC00EB830B9, 0, fireName)
        SetPedNameDebug(campfire, fireName)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, fireName)
        SetPedPromptName(campfire, fireName)
        SetBlipSprite(blip, sprite, 1)
        SetBlipScale(blip, 0.05)	
		if fire then 
            TriggerEvent("nic_prompt:kill_fire_fadein")
            TriggerEvent("nic_prompt:killing_fire_off")
            if IsControlJustPressed(0, 0x4AF4D473) then  
                count = count + 1                  
                ClearPedTasks(GetPlayerPed())     
                if count%2 == 1 then
                    TriggerEvent("ml_camping:delcampfire")
                    Citizen.Wait(2000) 
                end  
            end  
        else
            TriggerEvent("nic_prompt:kill_fire_fadeout")
        end 
	end
end)

function SET_BLIP_TYPE ( campfire )
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, campfire)
end


RegisterNetEvent('ml_camping:setcampfire')
AddEventHandler('ml_camping:setcampfire', function()
    TriggerEvent("vorp_inventory:CloseInv")

    local lifespan = 0
    local buildFireDuration = 0

    if campfire ~= 0 then 
        TriggerEvent("nic_prompt:existing_fire_on")
        Wait(3000)
        TriggerEvent("nic_prompt:existing_fire_off")        
        -- TriggerEvent("redemrp_notification:start", "Patayin mo muna ang Apoy", 2, "error") 
        SetEntityAsMissionEntity(campfire)
    else
        local playerPed = PlayerPedId()
        StopAudioScene('WORLD_HUMAN_WASH_FACE_BUCKET_GROUND_NO_BUCKET')
        TaskStartScenarioInPlace(playerPed, GetHashKey
        ('WORLD_HUMAN_WASH_FACE_BUCKET_GROUND_NO_BUCKET'), -1, true, false, false, false)
        FreezeEntityPosition(playerPed, true)

        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.55))
        local prop2 = CreateObject(GetHashKey(buildFireModel), x, y, z, true, false, true)
        SetEntityHeading(prop2, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(prop2)

        for key, value in pairs(Config.settings) do
            lifespan = value.lifespan
        end

        for key, value in pairs(Config.settings) do
            buildFireDuration = value.buildFireDuration
        end

        exports['progressbar']:startUI(buildFireDuration*1000, "Gumagawa ng Apoy")
        Citizen.Wait(buildFireDuration*1000)
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(playerPed, false)
        DeleteObject(prop2)
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.55))
        local prop = CreateObject(GetHashKey(fireModel), x, y, z, true, false, true)
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        PlaceObjectOnGroundProperly(prop)
        campfire = prop
        print(lifespan)
        Wait(lifespan*1000)
        DeleteObject(campfire)
        
        prop3 = CreateObject(GetHashKey(debrisfireModel), x, y, z, true, false, true)
        Citizen.Wait(0)
        PlaceObjectOnGroundProperly(prop3)
        campfire = prop3
        
        campfire = 0
        Wait(50000)
        DeleteObject(prop3)

    end
end)

RegisterNetEvent('ml_camping:delcampfire')
AddEventHandler('ml_camping:delcampfire', function()
    if campfire == 0 then
        print("There is no campfire.")
    else
        local playerPed = PlayerPedId()
        SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
        TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_BROOM_WORKING'), -1, true, false, false, false)
        exports['progressbar']:startUI(7000, "Pinapatay ang Apoy")
        TriggerEvent("nic_prompt:kill_fire_off")
        TriggerEvent("nic_prompt:killing_fire_on")
        Citizen.Wait(7000)
        ClearPedTasksImmediately(PlayerPedId())
        SetEntityAsMissionEntity(campfire)
        DeleteObject(campfire)
        campfire = 0
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