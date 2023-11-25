
local eatPrompt, eatPrompt2 = false
local selectedAmount = 0
local storeModel = ""
local chunk, chunk2, chunk3
local consume = false
local eat = false

Citizen.CreateThread(function()
    Wait(500)
    while true do
        Wait(10)
        local ped = PlayerPedId()
        local carrying = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId()) -- ISPEDCARRYING
        local model = GetEntityModel(carrying)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local animation = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich"
        local animation2 = "mech_skin@pheasant@field_dress"
        local rabbitAnim = "mech_skin@rabbit@field_dress"
		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Hand") 
		local boneIndexAlt = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Hand") 
		local boneIndex2 = GetEntityBoneIndexByName(PlayerPedId(), "FB_LowerLipRoot_000")

        RequestAnimDict(animation) 
        while ( not HasAnimDictLoaded(animation ) ) do 
            Citizen.Wait( 100 )
        end
        RequestAnimDict(animation2) 
        while ( not HasAnimDictLoaded(animation2 ) ) do 
            Citizen.Wait( 100 )
        end        

        RequestAnimDict(rabbitAnim) 
        while ( not HasAnimDictLoaded(rabbitAnim)) do 
            Citizen.Wait(100)
        end

        if carrying and Citizen.InvokeNative(0x9A100F1CF4546629, carrying) then
            selectedAmount = math.random(10, 50)
            for i, row in pairs(Edible) do
                if model == Edible[i]["model"] then

                    if IsPedWalking(PlayerPedId()) then
                        eat = true
                    end

                    if not IsPedWalking(ped) and not IsPedRunning(ped) and not IsPedSprinting(ped) then
                        if eat then
                            DrawText3DSM(x+0.4, y, z+0.4, "Press ~COLOR_ORANGE~F~COLOR_WHITE~ to Consume")
    
                            DrawText3DSM(x+0.4, y, z+0.32, "~COLOR_YELLOWSTRONG~"..Edible[i]["name"])
                            if IsControlJustPressed(0, 0xB2F377E8) then
                                storeModel = Edible[i]["name"]
                                entity = carrying
                                local ex, ey, ez = table.unpack(GetEntityCoords(entity)) 
                                local animalBone = GetPedBoneIndex(entity, GetEntityBoneIndexByName(entity, "SKEL_Head"))
                                SetEntityAsMissionEntity(entity, true, true)
        
                                AttachEntityToEntity(entity, PlayerPedId(), boneIndexAlt, 0.0, 0.0, 0.0, 170.0, 0.0, 0.0, true, true, false, true, 1, true)
                                TaskPlayAnim(PlayerPedId(), rabbitAnim, "enter", 3.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                                Citizen.Wait(700)
                                TaskPlayAnim(PlayerPedId(), rabbitAnim, "struggle", 3.0, -1.0, 120000, 18, 0, true, 0, false, 0, false)
                                Citizen.Wait(1000)
                                TaskPlayAnim(PlayerPedId(), rabbitAnim, "success", 3.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                                AddExplosion(x, y, z+0.6, 34, 15, true, false, true)
                                Citizen.InvokeNative(0xF708298675ABDC6A, x, y, z, 1.0, 0.7, 1.0, true, 1.0, true)
                                chunk = CreateObject(GetHashKey("p_whitefleshymeat01xb"), x, y, z,  true,  true, true)
                                AttachEntityToEntity(chunk, PlayerPedId(), boneIndex, 0.09, 0.03, -0.04, 25.0, 0.0, 4.0, true, true, false, true, 1, true)
                                Citizen.Wait(400)
                                DetachEntity(entity, 1, 1)
                                SetEntityAsNoLongerNeeded(entity)
                                Citizen.Wait(1000)
                                chunk2 = CreateObject(GetHashKey("p_cs_duckmeat01x"), x, y, z,  true,  true, true)
                                AttachEntityToEntity(chunk2, PlayerPedId(), boneIndex2, 0.0, 0.0, 0.0, 0.0, 0.00, -0.00, true, true, false, true, 1, true)
                                DetachEntity(chunk2, 1, 1)
                                TaskPlayAnim(PlayerPedId(), animation, "quick_right_hand", 3.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                                Citizen.Wait(1500)
                                DeleteObject(chunk)
                                chunk3 = CreateObject(GetHashKey("p_meatchunk_sm01x"), x, y, z,  true,  true, true)
                                AttachEntityToEntity(chunk3, PlayerPedId(), boneIndex2, 0.0, 0.0, 0.0, 0.0, 0.00, -0.00, true, true, false, true, 1, true)
                                PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                                TriggerEvent("vorpmetabolism:changeValue", "Hunger", selectedAmount*10)
                                StopAnimTask(ped, animation, "quick_right_hand", 3.0)
                                DetachEntity(chunk3, 1, 1)
                                Citizen.Wait(1000)
                                checkModelType = model
                                eatPrompt = true
                                Wait(1500)
                                eatPrompt2 = true
                                Wait(150)
                                poisoned()
                                Citizen.InvokeNative(0xF708298675ABDC6A, x, y, z, 1.0, 0.3, 1.0, true, 1.0, true)
                                DeleteObject(chunk2)
                                DeleteObject(chunk3)
                                Wait(3000)
                                eatPrompt = false
                                Wait(1500)
                                eatPrompt2 = false
                                storeModel = ""
                                eat = false
                            end
    
                        end
                    end
                end
            end
        else
            eat = false
        end
    end
end)

function poisoned()
    local ped = PlayerPedId()
    local pRnd = math.random(0, 5)
    local dRnd = math.random(8000, 22000)

    if pRnd == 0 then
        AnimpostfxPlay("CamTransitionBlink")
        AnimpostfxSetStrength("PlayerDrugsPoisonWell", 0.4)
        AnimpostfxPlay("PlayerDrugsPoisonWell")
        TaskStartScenarioInPlace(ped, GetHashKey("WORLD_HUMAN_VOMIT"), -1, true, false, false, false)
        Wait(dRnd)
        AnimpostfxPlay("CamTransitionBlink")
        ClearPedTasks(ped)
        AnimpostfxStop("PlayerDrugsPoisonWell")
    elseif pRnd == 1 then
        AnimpostfxPlay("CamTransitionBlink")
        AnimpostfxSetStrength("PlayerDrugsPoisonWell", 0.4)
        AnimpostfxPlay("PlayerDrugsPoisonWell")
        TaskStartScenarioInPlace(ped, GetHashKey("WORLD_HUMAN_VOMIT_KNEEL"), -1, true, false, false, false)
        Wait(dRnd)
        AnimpostfxPlay("CamTransitionBlink")
        ClearPedTasks(ped)
        AnimpostfxStop("PlayerDrugsPoisonWell")
    else
        TaskPlayEmote(ped, -1118911493)
    end
end

function TaskPlayEmote(entity, emote)
    return Citizen.InvokeNative(0xB31A277C1AC7B7FF, entity, 0, 0, emote, 1, 1, 0, 0)
end

function AnimpostfxSetStrength(char, int)
    return Citizen.InvokeNative(0xCAB4DD2D5B2B7246, char, int)
end

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))

        if eatPrompt then
            DrawText3D(x, y, z+1.0, "~COLOR_HUD_TEXT~+"..selectedAmount.." Hunger")
        end
        if eatPrompt2 then
            DrawText3DSM(x, y, z+0.90, "~COLOR_YELLOWSTRONG~Consumed "..storeModel)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawText3DSM(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.25, 0.25)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end