local text = ""
local spriteVal = 0
local hp
local propName = ""
local blip
local health
local stew
local stew2
local stew3
local spoon
local clickToEat = false
local ragdoll = false 
local exist = false
local count = 4
local deduct = 1
local val
local timeCount = 0
local finalPotLife = 0
local pCount = 0
local status = false
local eatPrompt = false
local eatReady = false

local campfire = 0
local rawPotModel = "p_potteryindian09x"
local potModel = "s_mil_cookfire01x"
local buildPotModel = "p_group_cookfire01"
local debrisPotModel = "p_campfiredebris01x"
local insideArea = false
local outsideArea = false
local closestZoneIndex = 1
local nearPot
local holdingPlate = false
local ex, ey, ez

local availableToEat = false
local cooking = false
local carrying = false
local placed = false
local initial = true
local dish = ""

local walkMode = false

local lifespan = 0
local cookingDuration = 0
local buildDuration = 0

function setRagdoll(flag)
    ragdoll = flag
end

Citizen.CreateThread(function() -- Pot Checker
	while true do
        Citizen.Wait(10)   
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
        nearPot = DoesObjectOfTypeExistAtCoords(x, y, z, 0.8, potModel, true)
        if nearPot then
            insideArea = true
            closestZoneIndex = i
            if initial then
                DrawText3D(ex, ey, ez+2, "[~COLOR_PLAYER_STATUS_OVERPOWERED~SPACE~COLOR_WHITE~] - ~COLOR_YELLOW~Cook Stew")
                if (IsControlJustPressed(0, 0xD9D0E1C0)) and not IsEntityDead( PlayerPedId() )  then  
					Citizen.Wait(0)
					OpenrecipeMenu()
                end           
            end
            if status then
                if pCount >= 20 then
                    DrawText3D(ex, ey, ez+1.0, "~COLOR_GREEN~"..pCount)
                elseif pCount >= 10 then
                    DrawText3D(ex, ey, ez+1.0, "~COLOR_ORANGE~"..pCount)
                elseif pCount < 10 then
                    DrawText3D(ex, ey, ez+1.0, "~COLOR_RED~"..pCount)
                end
            end
            if cooking then
                DrawText3D(ex, ey, ez+2.0, "~COLOR_WHITE~Cooking ~COLOR_YELLOW~"..dish..": ~COLOR_WHITE~"..timeCount)
                Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, -402959, 1, 1, 0, 0)
            end
            if availableToEat and not holdingPlate then
                DrawText3D(ex, ey, ez+2.0, "[~COLOR_PLAYER_STATUS_OVERPOWERED~MOUSE2~COLOR_WHITE~] - ~COLOR_YELLOW~Get Food")
                if (IsControlJustPressed(0, 0xF84FA74F)) and not IsEntityDead( PlayerPedId() )  then
                    clickToEat = true
                    holdingPlate = true
                    addStew()
                    RequestAnimDict("mech_inventory@eating@stew")
                    while ( not HasAnimDictLoaded("mech_inventory@eating@stew" ) ) do 
                        Citizen.Wait( 100 )
                    end   
                    TaskPlayAnim(ped, "mech_inventory@eating@stew", "base", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                end
            end
        elseif closestZoneIndex == i then
            insideArea = false
            CloserecipeMenu()
            TriggerEvent("nic_prompt:chop_off")
        end
	end
end)


RegisterNetEvent('nic_cook:emoteList')
AddEventHandler('nic_cook:emoteList', function()
    Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, 0xBA51B111, 1, 1, 0, 0)         
end)

RegisterNetEvent('nic_cook:triggerCook')
AddEventHandler('nic_cook:triggerCook', function()    
    initial = false   
    RequestAnimDict( "mech_loco_m@generic@reaction@pointing@unarmed@stand" )

    while ( not HasAnimDictLoaded( "mech_loco_m@generic@reaction@pointing@unarmed@stand" ) ) do 
        Citizen.Wait( 100 )
    end

    if IsEntityPlayingAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 3) then
        ClearPedSecondaryTask(ped)
    else
        TaskPlayAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 1.0, 8.0, 1500, 31, 0, true, 0, false, 0, false)
    end
    cooking = true
    TriggerEvent('nic_cook:timer')
end)


RegisterNetEvent('nic_cook:lifeCount')
AddEventHandler('nic_cook:lifeCount', function()
    
    for key, value in pairs(Config.settings) do
        lifespan = value.lifespan
    end

	local pLife = lifespan*60

    finalPotLife = pLife

	Citizen.CreateThread(function()
		while finalPotLife > 0 do
            pCount = finalPotLife
			Citizen.Wait(1000)

			if finalPotLife > 1 then
                finalPotLife = finalPotLife - 1
            else
                removePot()
			end           
		end
	end)
end)

RegisterNetEvent('nic_cook:timer')
AddEventHandler('nic_cook:timer', function()
    
    for key, value in pairs(Config.settings) do
        cookingDuration = value.cookingDuration
    end

	local timer = cookingDuration

	Citizen.CreateThread(function()
		while timer > 0 and cooking do
            timeCount = timer
			Citizen.Wait(1000)
			if timer > 0 then
                timer = timer - 1
			end
		end
        TriggerEvent('nic_cook:startReady')
	end)
    
end)

RegisterNetEvent('nic_cook:startReady')
AddEventHandler('nic_cook:startReady', function(source)
    ClearPedTasks(PlayerPedId())
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)
    DeleteObject(stew)	
    DeleteObject(spoon)
    cooking = false
    availableToEat = true
end)

RegisterNetEvent('nic_cook:setCook')
AddEventHandler('nic_cook:setCook', function()
    TriggerEvent("vorp_inventory:CloseInv")
    if campfire ~= 0 then
        TriggerEvent("nic_prompt:existing_fire_on")
        Wait(3000)
        TriggerEvent("nic_prompt:existing_fire_off")  
    else
        carrying = true
        carryPot()
        TriggerServerEvent("nic_cook:removeitem")
    end
end)


Citizen.CreateThread(function() -- Tree Checker
	while true do
        Citizen.Wait(10)	
        local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(prop))

        if carrying and not placed then
            Citizen.InvokeNative(0x7DE9692C6F64CFE8, PlayerPedId(), false, 0, false)
            SetEntityAsMissionEntity(campfire)
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz-0.98, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.6, 1.6, 1.0, 255, 242, 0, 190, false, true, 2, false, false, false, false)
            DrawTxt("Place the ~COLOR_BLUE~Pot~COLOR_WHITE~ to your desired location then press:", 0.5, 0.08, 0.3, 0.4, true, 181, 204, 242, 250, true)  
            DrawTxt("MOUSE1", 0.5, 0.10, 0.3, 0.7, true, 199, 215, 0, 200, true)
            -- DisableControlAction(0, 0xD9D0E1C0, true) 
            DisableControlAction(0, 0x8FFC75D6, true) -- Disable Sprint
            DisableControlAction(0, 0xDB096B85, true) -- Disable Crouch
            DisableControlAction(0, 0x8AAA0AD4, true) -- Disable ALT
            DisableControlAction(0, 0xE8342FF2, true) -- Disable HOLDALT
            DisableControlAction(0, 0x8CC9CD42, true) -- Disable X

            if (IsControlJustPressed(0, 0x156F7119) or IsControlJustPressed(0, 0xF84FA74F)) or IsEntityInWater(PlayerPedId()) or IsPedSwimming(PlayerPedId()) or IsEntityInAir(PlayerPedId()) or IsPedFalling(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
                TriggerServerEvent('nic_cook:additem')
                DeleteObject(prop)
                RemoveBlip(blip)
                carrying = false
                placed = false
                campfire = 0
                playPickAnimation()
            elseif (IsControlJustPressed(0, 0x07CE1E61)) and not IsEntityDead(PlayerPedId()) then
                ClearPedTasksImmediately(PlayerPedId())
                DeleteObject(prop)
                carrying = false
                placed = true
                exist = true
            end

            if placed then
                TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CLEAN_TABLE'), -1, true, false, false, false)
                FreezeEntityPosition(playerPed, true)
        
                local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.55))
                local buildProp = CreateObject(GetHashKey(buildPotModel), x, y, z, true, false, true)
                SetEntityHeading(buildProp, GetEntityHeading(PlayerPedId()))
                PlaceObjectOnGroundProperly(buildProp)        
                
                for key, value in pairs(Config.settings) do
                    buildDuration = value.buildDuration
                end

                exports['progressbar']:startUI(buildDuration*1000, "Building Fire Pot..")
                Citizen.Wait(buildDuration*1000)
                ClearPedTasks(PlayerPedId())
                status = true
                TriggerEvent('nic_cook:lifeCount')
                FreezeEntityPosition(playerPed, false)
                DeleteObject(buildProp)
                local prop = CreateObject(GetHashKey(potModel), x, y, z, true, false, true)
                local px, py, pz = table.unpack(GetEntityCoords(prop))
                
                for key, value in pairs(Config.settings) do
                    lifespan = value.lifespan
                end
                
                local pLife = lifespan*60
                propName = 'Food'
                blip = N_0x554d9d53f696d002(203020899, px, py, pz)
                SetBlipSprite(blip, 935247438, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Pot Fire')
        
                ex = px
                ey = py
                ez = pz
                
                SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
                PlaceObjectOnGroundProperly(prop)
                campfire = prop
                
            end
        end
    end
end)

function removePot()

    local decayDuration = 0
    
    for key, value in pairs(Config.settings) do
        decayDuration = value.decayDuration
    end
    
    if exist then
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(campfire, 0.0, 0.0, -1.0))

        DeleteObject(campfire)
        RemoveBlip(blip)

        AddExplosion(x, y, z, 12, 5.0, true, false, true)
        
        availableToEat = false
        initial = true
        timeCount = 0
        holdingPlate = false
        cooking = false
        status = false
        
        prop3 = CreateObject(GetHashKey(debrisPotModel), x, y, z, true, false, true)
        local fx, fy, fz = table.unpack(GetEntityCoords(prop3))
        local rawPot = CreateObject(GetHashKey(rawPotModel), fx, fy, fz+1.0, true, false, true)
        Citizen.Wait(0)
        PlaceObjectOnGroundProperly(prop3)
        PlaceObjectOnGroundProperly(rawPot)
        Wait(decayDuration*1000)
        carrying = false
        placed = false
        DeleteObject(rawPot)
        DeleteObject(prop3)
        campfire = 0
        finalPotLife = 0
        pCount = 0
        exist = false
    end    
end

function SET_BLIP_TYPE ( campfire )
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, 773587962, campfire)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)	
        local dead = Citizen.InvokeNative(0x3317DEDB88C95038, PlayerPedId(), true)
        if IsPedRagdoll(PlayerPedId()) or dead then                
            availableToEat = false
            initial = true
            timeCount = 0
            holdingPlate = false
            cooking = false
            status = false
            carrying = false
            placed = false
            DeleteObject(rawPot)
            campfire = 0
            count = 4
			DetachEntity(prop, 1, 1)
			DetachEntity(stew, 1, 1)
			DetachEntity(stew2, 1, 1)
			DetachEntity(stew3, 1, 1)
            DetachEntity(spoon, 1, 1)
            holdingPlate = false
            Wait(2000)
            DeleteObject(prop)
            DeleteObject(stew)	
            DeleteObject(stew2)	
            DeleteObject(stew3)	
            DeleteObject(spoon)	
            clickToEat = false
       end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        RequestAnimDict("mech_inventory@eating@stew") 
        if clickToEat then
            eatReady = true
            walkMode = true
            if IsControlJustPressed(0, 0x07CE1E61) then
                eatReady = false
                count = count - deduct
                val = count
                while ( not HasAnimDictLoaded("mech_inventory@eating@stew" ) ) do 
                    Citizen.Wait( 100 )
                end
                eating = true
                TaskPlayAnim(PlayerPedId(), "mech_inventory@eating@stew", "eat_finish_discard", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Wait(800)
                eatPrompt = true
                PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                Wait(800)
                TriggerEvent("vorpmetabolism:changeValue", "Hunger", 100)
                TriggerEvent("vorpmetabolism:changeValue", "Thirst", 100)
                TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealth", 80.0)
                TriggerEvent("vorpmetabolism:changeValue", "OuterCoreHealth", 10.0)
                TriggerEvent("vorpmetabolism:changeValue", "OuterCoreHealthGold", 50.0)
                TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealthGold", 50.0)
                TriggerEvent("vorpmetabolism:changeValue", "InnerCoreStaminaGold", 50.0)
                TriggerEvent("vorpmetabolism:changeValue", "OuterCoreStaminaGold", 50.0)
                eatPrompt = false
                eating = false
                eatReady = true
                
                if val == 1 then
                    DeleteObject(stew)	
                    state2()
                end

                if val > 1 then
                    TaskPlayAnim(PlayerPedId(), "mech_inventory@eating@stew", "base", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                else
                    eatReady = false
                    clickToEat = false
                    TaskPlayAnim(PlayerPedId(), "mech_inventory@eating@stew", "eat_finish_discard", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    Wait(3995)
                    eatPrompt = true
                    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                    TriggerEvent("vorpmetabolism:changeValue", "Hunger", 100)
                    TriggerEvent("vorpmetabolism:changeValue", "Thirst", 100)
                    TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealth", 80.0)
                    TriggerEvent("vorpmetabolism:changeValue", "OuterCoreHealth", 10.0)
                    TriggerEvent("vorpmetabolism:changeValue", "OuterCoreHealthGold", 50.0)
                    TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealthGold", 50.0)
                    TriggerEvent("vorpmetabolism:changeValue", "InnerCoreStaminaGold", 50.0)
                    TriggerEvent("vorpmetabolism:changeValue", "OuterCoreStaminaGold", 50.0)
                    DeleteObject(stew2)	
                    state3()
                    Wait(1200)
                    eatPrompt = false
                    DetachEntity(stew3, 1, 1)
                    Wait(506)
                    DetachEntity(spoon, 1, 1)
                    ClearPedTasks(PlayerPedId()) 
                    walkMode = false
                    Wait(2500)
                    DeleteObject(stew3)	
                    DeleteObject(spoon)
                    holdingPlate = false
                    count = 4
                end
            end
        end
    end
end)

-- CARRY PROP FUNCTION
----------------------------------------------------------------------------------------------------

function carryPot()
    local animation = "mech_carry_box"
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Hand")
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end    
    prop = CreateObject(GetHashKey(rawPotModel), x, y, z,  true,  true, true)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.02, -0.30, 0.30, -90.0, -90.0, 0.00, true, true, false, true, 1, true)
    carrying = true
    TaskPlayAnim(PlayerPedId(), animation, "idle", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

function playPickAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "stn_long_low_skill_exit", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
end

function OpenrecipeMenu()
    WarMenu.OpenMenu('recipe')
end

function CloserecipeMenu()
    WarMenu.CloseMenu('recipe')
end

Citizen.CreateThread(function()
    WarMenu.CreateMenu('recipe', 'Recipes')
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('recipe') then
			if WarMenu.Button('Adobo') then
                TriggerServerEvent('nic_cook:checkAdoboIngredients')
                dish = "Adobo"
                CloserecipeMenu()
            elseif WarMenu.Button('Menudo') then
                TriggerServerEvent('nic_cook:checkMenudoIngredients')
                dish = "Menudo"
				CloserecipeMenu()
			end
			WarMenu.Display()
		end
    end
end)

function addStew()
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Finger12")
    local boneIndex2 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Finger12")
    local prop_name = 'p_cs_platestew01x'
    local prop_name2 = 'p_beefstew_spoon01x'
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    stew = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
    spoon = CreateObject(GetHashKey(prop_name2), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(stew, playerPed, boneIndex, 0.11, -0.05, 0.00, 20.00, 0.00, 0.00, true, true, false, true, 1, true)
    AttachEntityToEntity(spoon, playerPed, boneIndex2, -0.05, -0.03, -0.04, 20.00, 150.00, 0.00, true, true, false, true, 1, true)
end

function state2()
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Finger12")
    local prop_name = 'p_cs_platestew02x_noanim'
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    stew2 = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(stew2, playerPed, boneIndex, 0.11, -0.05, 0.00, 20.00, 0.00, 0.00, true, true, false, true, 1, true)
end

function state3()
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Finger12")
    local prop_name = 'p_cs_platestew03x_emty'
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    stew3 = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(stew3, playerPed, boneIndex, 0.11, -0.05, 0.00, 20.00, 0.00, 0.00, true, true, false, true, 1, true)
end

-- PROMPTS
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(0)
        local px, py, pz = table.unpack(GetEntityCoords(spoon))
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        if eatPrompt then
			DrawText3DSM(x, y, z+1.0, true, "~COLOR_FREEMODE~+25 HUNGER")
        end
        if eatReady then      
			DrawText3DSM(px+0.1, py, pz+0.3, true, "~COLOR_WHITE~Press [~COLOR_RADAR_DEAD_EYE~LMB~COLOR_WHITE~] to Eat")
        end
        if walkMode then
            Citizen.InvokeNative(0xB128377056A54E2A, PlayerPedId(), false)
            DisableControlAction(0, 0x8CC9CD42, true) -- Disable X
            DisableControlAction(0, 0x8FFC75D6, true) -- Disable Sprint
            DisableControlAction(0, 0xDB096B85, true) -- Disable Crouch
            DisableControlAction(0, 0x8AAA0AD4, true) -- Disable ALT
            DisableControlAction(0, 0xE8342FF2, true) -- Disable HOLDALT
            DisableControlAction(0, 0xD9D0E1C0, true) -- Disable SPACE
            DisableControlAction(0, 0xF84FA74F, true) -- MOUSE2
            DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3      
        end
    end
end)


function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.45, 0.45)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawText3DSM(x, y, z, enableShadow, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    --Citizen.InvokeNative(0x66E0276CC5F6B9DA, 2)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end