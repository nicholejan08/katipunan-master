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
local finalTentLife = 0
local pCount = 0
local status = false
local eatPrompt = false
local eatReady = false

local campTent = 0
local rawTentModel = ""

local rawA = "p_tentrolled04x"
local rawB = "proc_bedrollclosed01x"
local rawC = "p_woodpile03x"

local classA1 = "mp005_s_posse_tent_bountyhunter07x"
local classA2 = "mp005_s_posse_tent_collector07x"
local classA3 = "mp005_s_posse_tent_bountyhunter06x"
local classA4 = "s_tent02_cloth01a_drty"
local classB1 = "p_tent_leento04x"
local classB2 = "mp005_s_posse_tent_bountyhunter04x"
local classB3 = "s_tentwedge02x"
local classC1 = "p_ambtentmulch01b"
local classC2 = "p_ambtentdebris01x"
local classC3 = "p_ambtentgrass01x"
local classC4 = "p_ambtentdebris02x"
local classC5 = "p_ambtentbark01b"

local placeHolderProp = ""
local tentType = ""
local tentModel = ""
local buildtentModel = "p_tentcollapse03x"
local debrisTentModel = ""

local debrisTentA = "p_tentdamaged02x"
local debrisTentB = "p_tentarmypupbroken01x"
local debrisTentC = "rdr_debris_stks_aa_moss_sim"

local insideArea = false
local outsideArea = false
local closestZoneIndex = 1
local nearTent
local holdingPlate = false
local ex, ey, ez

local availableToEat = false
local cooking = false
local carrying = false
local placed = false
local initial = true
local dish = ""

local resting = false
local getUp = false

local followHeading = 0
local lifespan = 0
local cookingDuration = 0
local buildDuration = 0

function setRagdoll(flag)
    ragdoll = flag
end

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)   
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
        
        nearTent = DoesObjectOfTypeExistAtCoords(x, y, z, 1.2, tentModel, true)
        if nearTent then
            insideArea = true
            closestZoneIndex = i
            if initial then
                if not resting then
                    
                   if pCount > 9 and not Citizen.InvokeNative(0x34D6AC1157C8226C, ped, GetHashKey('WORLD_HUMAN_FIRE_SIT')) then
                    DrawText3D(ex, ey, ez+1.5, "[~COLOR_PLAYER_STATUS_OVERPOWERED~R~COLOR_WHITE~] - REST")
                        if (IsControlJustPressed(0, 0xE30CD707)) and not IsEntityDead( PlayerPedId() )  then  
                            Citizen.Wait(0)	
                            SetEntityHeading(ped, followHeading)
                            resting = true				
                            TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_FIRE_SIT'), -1, true, false, false, false)
                        end   
                    end

                else
                    DisableControlAction(0, 0x7F8D09B8, true) -- Disable V

                    if pCount > 9 and Citizen.InvokeNative(0x34D6AC1157C8226C, ped, GetHashKey('WORLD_HUMAN_FIRE_SIT')) then
                        DrawText3D(ex, ey, ez+1.5, "[~COLOR_PLAYER_STATUS_OVERPOWERED~R~COLOR_WHITE~] - GET UP")
                        if (IsControlJustPressed(0, 0xE30CD707)) and not IsEntityDead( ped )  then  
                            Citizen.Wait(0)
                            ClearPedTasks(ped)
                            resting = false
                        end
                    end                  

                end
            end

            if status then
                if pCount >= 20 then
                    DrawText3D(ex, ey, ez+1.0, "~COLOR_GREEN~"..pCount)
                elseif pCount >= 10 then
                    DrawText3D(ex, ey, ez+1.0, "~COLOR_ORANGE~"..pCount)
                elseif pCount < 10 then
                    if IsPedUsingAnyScenario(PlayerPedId()) then
                        ClearPedTasks(PlayerPedId())
                    end
                    DrawText3D(ex, ey, ez+1.0, "~COLOR_RED~"..pCount)
                end
            end
            if getUp then
                FreezeEntityPosition(ped, false)
                ClearPedTasks(ped)
                resting = false
                getUp = false
            end
        elseif closestZoneIndex == i then
            insideArea = false
            TriggerEvent("nic_prompt:chop_off")
        end
	end
end)


RegisterNetEvent('nic_tents:emoteList')
AddEventHandler('nic_tents:emoteList', function()
    Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, 0xBA51B111, 1, 1, 0, 0)         
end)

RegisterNetEvent('nic_tents:triggerCook')
AddEventHandler('nic_tents:triggerCook', function()    
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
    TriggerEvent('nic_tents:timer')
end)


RegisterNetEvent('nic_tents:lifeCount')
AddEventHandler('nic_tents:lifeCount', function()
    
    for key, value in pairs(Config.settings) do
        lifespan = value.lifespan
    end

	local tentLife = lifespan*60

    finalTentLife = tentLife

	Citizen.CreateThread(function()
		while finalTentLife > 0 do
            pCount = finalTentLife
			Citizen.Wait(1000)

			if finalTentLife > 1 then
                finalTentLife = finalTentLife - 1
            else
                removeTent()
			end           
		end
	end)
end)

RegisterNetEvent('nic_tents:timer')
AddEventHandler('nic_tents:timer', function()
    
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
        TriggerEvent('nic_tents:startReady')
	end)
    
end)

RegisterNetEvent('nic_tents:startReady')
AddEventHandler('nic_tents:startReady', function(source)
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)
    DeleteObject(stew)	
    DeleteObject(spoon)
    cooking = false
    availableToEat = true
end)

RegisterNetEvent('nic_tents:setTent')
AddEventHandler('nic_tents:setTent', function(value)
    
    selectedTent = value
    tentType = selectedTent

    if tentType == "tentA1" then
        tentModel = classA1
    elseif tentType == "tentA2" then
        tentModel = classA2
    elseif tentType == "tentA3" then
        tentModel = classA3
    elseif tentType == "tentA4" then
        tentModel = classA4
    elseif tentType == "tentB1" then
        tentModel = classB1
    elseif tentType == "tentB2" then
        tentModel = classB2
    elseif tentType == "tentB3" then
        tentModel = classB3
    elseif tentType == "tentC1" then
        tentModel = classC1
    elseif tentType == "tentC2" then
        tentModel = classC2
    elseif tentType == "tentC3" then
        tentModel = classC3
    elseif tentType == "tentC4" then
        tentModel = classC4
    elseif tentType == "tentC5" then
        tentModel = classC5
    end
    
    selectedTent = tentType
    
    TriggerEvent("vorp_inventory:CloseInv")
    if campTent ~= 0 then
        TriggerEvent("nic_prompt:existing_fire_on")
        Wait(3000)
        TriggerEvent("nic_prompt:existing_fire_off")
    else
        carrying = true
        carryTent()
        TriggerServerEvent("nic_tents:removeitem", selectedTent)
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)	

        local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(prop))


        if carrying and not placed then

            Citizen.InvokeNative(0x7DE9692C6F64CFE8, PlayerPedId(), false, 0, false)
            SetEntityAsMissionEntity(campTent)
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz-0.98, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.6, 1.6, 1.0, 255, 242, 0, 190, false, true, 2, false, false, false, false)
            DrawTxt("Place the ~COLOR_BLUE~Tent~COLOR_WHITE~ to your desired location then press:", 0.5, 0.08, 0.3, 0.4, true, 181, 204, 242, 250, true)  
            DrawTxt("MOUSE1", 0.5, 0.10, 0.3, 0.7, true, 199, 215, 0, 200, true)
            DisableControlAction(0, 0xD9D0E1C0, true)
            DisableControlAction(0, 0x8FFC75D6, true) -- Disable Sprint
            DisableControlAction(0, 0xDB096B85, true) -- Disable Crouch
            DisableControlAction(0, 0x8AAA0AD4, true) -- Disable ALT
            DisableControlAction(0, 0xE8342FF2, true) -- Disable HOLDALT
            DisableControlAction(0, 0x8CC9CD42, true) -- Disable X
            
            if (IsControlJustPressed(0, 0x156F7119) or IsControlJustPressed(0, 0xF84FA74F)) or IsEntityInWater(PlayerPedId()) or IsPedSwimming(PlayerPedId()) or IsEntityInAir(PlayerPedId()) or IsPedFalling(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
                TriggerServerEvent('nic_tents:additem', selectedTent)
                print("selectedTent "..selectedTent)
                DeleteObject(placeHolderProp)
                DeleteObject(prop)
                RemoveBlip(blip)
                carrying = false
                placed = false
                campTent = 0
                playPickAnimation()
            elseif (IsControlJustPressed(0, 0x07CE1E61)) and not IsEntityDead(PlayerPedId())  then
                DeleteObject(placeHolderProp)
                DeleteObject(prop)
                carrying = false
                placed = true
                exist = true
                ClearPedTasksImmediately(PlayerPedId())
            end

            if placed then
                
                DeleteObject(placeHolderProp)

                TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_PLAYER_PICK_LOCK'), -1, true, false, false, false)
                FreezeEntityPosition(playerPed, true)
        
                local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.55))

                local buildProp = CreateObject(GetHashKey(tentModel), x, y, z, true, false, true)
                SetEntityAlpha(buildProp, 70, false)
                SetEntityHeading(buildProp, GetEntityHeading(PlayerPedId()))
                PlaceObjectOnGroundProperly(buildProp)
                
                for key, value in pairs(Config.settings) do
                    buildDuration = value.buildDuration
                end

                exports['progressbar']:startUI(buildDuration*1000, "Building Tent..")
                Citizen.Wait(buildDuration*1000)
                ClearPedTasks(PlayerPedId())
                status = true
                TriggerEvent('nic_tents:lifeCount')
                FreezeEntityPosition(playerPed, false)
                DeleteObject(buildProp)


                local prop = CreateObject(GetHashKey(tentModel), x, y, z, true, false, true)
                local px, py, pz = table.unpack(GetEntityCoords(prop))
                
                propName = 'Tent'
                blip = N_0x554d9d53f696d002(203020899, px, py, pz)
                SetBlipSprite(blip, -1606321000, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Pot Fire')
        
                ex = px
                ey = py
                ez = pz
                
                SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
                followHeading = GetEntityHeading(prop) + 180
                PlaceObjectOnGroundProperly(prop)
                campTent = prop
                
            end
        end
    end
end)

function removeTent()
    
    if tentModel == classA1 or tentModel == classA2 or tentModel == classA3 or tentModel == classA4 then
        debrisTentModel = debrisTentA
    elseif tentModel == classB1 or tentModel == classB2 or tentModel == classB3 then
        debrisTentModel = debrisTentB
    elseif tentModel == classC1 or tentModel == classC2 or tentModel == classC3 or tentModel == classC4 or tentModel == classC5 then
        debrisTentModel = debrisTentC
    end
    
    print(debrisTentModel)

    local decayDuration = 0
    
    for key, value in pairs(Config.settings) do
        decayDuration = value.decayDuration
    end
    
    if exist then
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(campTent, 0.0, 0.0, -1.0))

        DeleteObject(campTent)
        RemoveBlip(blip)

        AddExplosion(x, y, z, 12, 5.0, true, false, true)
        
        availableToEat = false
        initial = true
        timeCount = 0
        holdingPlate = false
        cooking = false
        status = false
        
        prop3 = CreateObject(GetHashKey(debrisTentModel), x, y, z, true, false, true)
        local fx, fy, fz = table.unpack(GetEntityCoords(prop3))
        Citizen.Wait(0)
        PlaceObjectOnGroundProperly(prop3)
        Wait(decayDuration*1000)
        campTent = 0
        carrying = false
        placed = false
        DeleteObject(prop3)
        finalTentLife = 0
        pCount = 0
        decayDuration = 0
        exist = false
        resting = false
        getUp = true
    end    
end

function SET_BLIP_TYPE ( campTent )
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, 773587962, campTent)
end

-- CARRY PROP FUNCTION
----------------------------------------------------------------------------------------------------

function carryTent()
    local animation = "mech_carry_box"
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Hand")
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end

    if tentModel == classA1 or tentModel == classA2 or tentModel == classA3 or tentModel == classA4 then
        rawTentModel = rawA

        prop = CreateObject(GetHashKey(rawTentModel), x, y, z,  true,  true, true)
        AttachEntityToEntity(prop, PlayerPedId(), boneIndex, -0.11, 0.01, 0.29, 12.0, 79.0, 35.0, true, true, false, true, 1, true)

    elseif tentModel == tentModel == classB1 or tentModel == classB2 or tentModel == classB3 then
        rawTentModel = rawB

        prop = CreateObject(GetHashKey(rawTentModel), x, y, z,  true,  true, true)
        AttachEntityToEntity(prop, PlayerPedId(), boneIndex, -0.11, 0.01, 0.29, 12.0, 79.0, 35.0, true, true, false, true, 1, true)
        
    else
        rawTentModel = rawC

        prop = CreateObject(GetHashKey(rawTentModel), x, y, z,  true,  true, true)
        AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.0, 0.0, 0.33, 122.0, 0.0, 0.0, true, true, false, true, 1, true)
        
    end
    
    placeHolderProp = CreateObject(GetHashKey(tentModel), x, y, z, true, false, true)
    SetEntityAlpha(placeHolderProp, 70, false)
    SetEntityHeading(placeHolderProp, GetEntityHeading(PlayerPedId()))
    AttachEntityToEntity(placeHolderProp, PlayerPedId(), 4215, 0.0, 1.33, -0.78, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    carrying = true

    TaskPlayAnim(PlayerPedId(), animation, "idle", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)

    print("CARRY TENT")
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