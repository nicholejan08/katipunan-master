
local carryingCamera = false
local lookingCamera = false
local captured = false
local cooldown = false
local canCapture = true
local withFilm = false
local showFilm = false
local filmCount = 0
local msgTxt = 0
local prop
local price = 0
local active = false
local noFilm = false
local playEmote = false

local standStill = false

local current_ptfx_handle_id = false
local is_particle_effect_active = false

local current_flash_handle_id = false
local is_flash_effect_active = false

RegisterNetEvent('nic_camera:registerCheckedFilm')
AddEventHandler('nic_camera:registerCheckedFilm', function(count)
    filmCount = count
    TriggerEvent("nic_camera:triggerFilm")
end)

RegisterNetEvent('nic_camera:triggerFilm')
AddEventHandler('nic_camera:triggerFilm', function()
    local player = PlayerPedId()
    local target = GetClosestPed(player, 21.0)
    local pedIsAnimal = Citizen.InvokeNative(0x9A100F1CF4546629, target)
    local pedx, pedy, pedz = table.unpack(GetEntityCoords(target, 0))
    local rewardChance = math.random(0, 12)
    local angle = 0

    withFilm = true

    if pedIsAnimal then
        angle = 120.0
    else
        angle = 90.0
    end

    if withFilm then
        TriggerServerEvent("nic_camera:removeItem")
        if not cooldown then
            
            for key, value in pairs(Config.settings) do
                if value.firstpersonMode then
                    AnimpostfxPlay("CameraTakePicture")
                end
            end

            -- exports['screenshot-basic']:requestScreenshot(function(data)
            --     TriggerEvent('chat:addMessage', { template = '<img src="{0}" style="max-width: 300px;" />', args = { data } })
            -- end)

            flashEffect()
            smokeEffect()
            playFlashAudio()
            cooldown = true
            canCapture = false
        end
        
        if IsPlayerCloseAnimal(pedx, pedy, pedz) then
            if not IsEntityDead(target) and pedIsAnimal then
                price = math.random(1, 20)*1.3
            elseif not IsEntityDead(target) and not pedIsAnimal then
                price = math.random(1, 3)*1.3
            end
            if playEmote and IsPedFacingPed(player, target, angle) and IsPedFacingPed(target, player, angle) or (IsPedRagdoll(target) and IsPedFacingPed(player, target, angle)) then
                TriggerServerEvent("nic_camera:triggerReward", price)
                playLootAudio()
                giveReward = true
            end
            if IsPedFacingPed(player, target, angle) and IsPedFacingPed(target, player, angle) then
                if not IsEntityDead(target) then
                    local random = math.random(0, 4)
                    captured = true
                    msgTxt = random
                else
                    local random = math.random(11, 13)
                    captured = true
                    msgTxt = random
                end
            end
        elseif IsPlayerNearAnimal(pedx, pedy, pedz) and not IsEntityDead(target) then
            if IsPedFacingPed(player, target, angle) and IsPedFacingPed(target, player, angle) then
                local random = math.random(5, 7)
                captured = true
                msgTxt = random
            end
        elseif IsPlayerFarAnimal(pedx, pedy, pedz) and not IsEntityDead(target) then
            if IsPedFacingPed(player, target, angle) then
                local random = math.random(8, 13)
                captured = true
                msgTxt = random
            end
        end
    end
end)

RegisterNetEvent('nic_camera:noFilm')
AddEventHandler('nic_camera:noFilm', function(count)
    noFilm = true
    filmCount = count
    smokeEffect()
    playDisabledAudio()
    cooldown = true
    canCapture = false
    withFilm = false
end)

RegisterNetEvent('nic_camera:triggerNoFilm')
AddEventHandler('nic_camera:triggerNoFilm', function()
    noFilm = true
end)

RegisterNetEvent('nic_camera:registerFilm')
AddEventHandler('nic_camera:registerFilm', function(count)
    filmCount = count
end)


RegisterNetEvent('nic_camera:useCamera')
AddEventHandler('nic_camera:useCamera', function()
    TriggerEvent("vorp_inventory:CloseInv")
    
    local player = PlayerPedId()
    
    if not carryingCamera and not IsEntityDead(player) then
        getCamera()
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        
        if carryingCamera then
            if IsControlJustPressed(0, 0xB238FE0B) and not IsEntityDead(player) then
                hideCamera()
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        if IsPedRagdoll(player) or IsEntityDead(player) then
            ResetEntityAlpha(PlayerPedId())
            ResetEntityAlpha(prop)
            destroyCam()
            TriggerEvent("nic_prompt:focus_overlay_off")
            DeleteObject(prop, 1, 1)
            showFilm = false
            carryingCamera = false
            lookingCamera = false
            current_ptfx_handle_id = false
            is_particle_effect_active = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
		local px, py, pz = table.unpack(GetEntityCoords(player, 0))
        if showFilm then            
            for key, value in pairs(Config.settings) do
                if not value.disableFilmUI then
                    DrawNum3D(px, py, pz+0.8, filmCount)
                end
            end
        end
    end
end)

function createCam()
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local heading = GetEntityHeading(PlayerPedId())
	local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Head")
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_FLY_CAMERA", px, py, pz, GetGameplayCamRelativePitch(), 0.0, heading, 55.0, false, 0)
    SetEntityAlpha(PlayerPedId(), 0, false)
    SetEntityAlpha(prop, 0, false)
    if Citizen.InvokeNative(0xD5FE956C70FF370B, PlayerPedId()) then
        Citizen.InvokeNative(0xDFC1E4A44C0324CA, cam, PlayerPedId(), 31086, 0.0, 0.0, 0.0, heading)
    else
        Citizen.InvokeNative(0xDFC1E4A44C0324CA, cam, PlayerPedId(), 31086, 0.0, 0.0, 0.5, heading) 
    end  
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 500, true, true, 0)
end

function destroyCam()
    SetCamActive(cam, false)
    DestroyCam(cam, true)
end

Citizen.CreateThread(function()
    while true do
        Wait(10)
        local camFov = Citizen.InvokeNative(0x8101D32A0A6B0F60, cam)

        if standStill then

            for key, value in pairs(Config.settings) do
                if value.firstpersonMode then
                    
                    if showFilm then
                        TaskStandStill(PlayerPedId(), -1)
                    else
                        showFilm = false
                        standStill = false
                        ClearPedTasks(PlayerPedId())
                    end

                    if IsControlJustPressed(0, 0x8BDE7443) then
                        if GetCamFov(cam) < 65 then
                            playScrollAudio()
                            SetCamFov(cam, GetCamFov(cam)+5)
                        end
                    end
                    if IsControlJustPressed(0, 0x3076E97C) then
                        if GetCamFov(cam) > 15 then
                            playScrollAudio()
                            SetCamFov(cam, GetCamFov(cam)-5)
                        end
                    end
                end
            end
        end
    end
end)

function playScrollAudio()
    local is_scroll_sound_playing = false
    local scroll_soundset_ref = "HUD_POKER"
    local scroll_soundset_name =  "BET_AMOUNT"

    if not is_scroll_sound_playing then           
        if scroll_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, scroll_soundset_name, scroll_soundset_ref);   -- load sound frontend
        end
        Citizen.InvokeNative(0x67C540AA08E4A6F5, scroll_soundset_name, scroll_soundset_ref, true, 0);  -- play sound frontend
        is_scroll_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, scroll_soundset_name, scroll_soundset_ref)  -- stop audio
        is_scroll_sound_playing = false
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        local target = GetClosestPed(player, 21.0)
        local pedIsAnimal = Citizen.InvokeNative(0x9A100F1CF4546629, target)
        local pedx, pedy, pedz = table.unpack(GetEntityCoords(target, 0))
        local rewardChance = math.random(0, 12)
        local angle = 0
        local fxName = "cameraviewfinderadv"

        if pedIsAnimal then
            angle = 120.0
        else
            angle = 90.0
        end

        -- AnimpostfxStopAll()
        
        if carryingCamera then

            if IsControlJustReleased(0, 0xF84FA74F) then
                AnimpostfxStop(fxName)
                noFilm = false
                ResetEntityAlpha(PlayerPedId())
                ResetEntityAlpha(prop)
                destroyCam()
                showFilm = false
                TriggerEvent("nic_prompt:focus_overlay_off")
                holdCamera()
            end

            if IsControlJustPressed(0, 0xF84FA74F) then
                
                for key, value in pairs(Config.settings) do
                    if value.firstpersonMode then
                        AnimpostfxPlay(fxName)
                        createCam()
                    end
                end

                TriggerServerEvent("nic_camera:checkFilmCount")
                standStill = true
                showFilm = true
                playFocusLensAudio()
                TriggerEvent("nic_prompt:focus_overlay_on")
                if IsPlayerCloseAnimal(pedx, pedy, pedz) and not Citizen.InvokeNative(0x9A100F1CF4546629, target) then
                    if IsPedFacingPed(player, target, angle) and IsPedFacingPed(target, player, angle) and not Citizen.InvokeNative(0x84D0BF2B21862059, target) then
                        local emoteChance = math.random(0, 3)
                        local random = math.random(0, 6)

                        if emoteChance == 0 then
                            ClearPedTasks(target)
                            playEmote = true
                            if random == 1 then
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, 0x43F71CA8, 1, 1, 0, 0)
                            elseif random == 2 then
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, 1939251934, 1, 1, 0, 0)
                            elseif random == 3 then
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -1639456476, 1, 1, 0, 0)
                            elseif random == 4 then
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -221241824, 1, 1, 0, 0)
                            elseif random == 5 then
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, 1256841324, 1, 1, 0, 0)
                            elseif random == 6 then
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -339257980, 1, 1, 0, 0)
                            else
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, 1927505461, 1, 1, 0, 0)
                            end
                        end
                    end
                end
                lookCamera()
            end
        end

        if carryingCamera and IsPedInMeleeCombat(player) or IsPedInCombat(player, target) then
            TriggerEvent("nic_prompt:focus_overlay_off")
            Citizen.InvokeNative(0x97FF36A1D40EA00A, player,"mech_inventory@binoculars", "hold", 0)
            Citizen.InvokeNative(0x97FF36A1D40EA00A, player,"mech_inventory@binoculars", "look", 0)
            carryingCamera = false
            DeleteObject(prop, 1, 1)
            lookingCamera = false
        end

        if lookingCamera then
            if IsControlJustPressed(0, 0x07CE1E61) then
                if canCapture then
                    TriggerServerEvent("nic_camera:checkFilm")
                end
            end
        end
    end
end)

CreateThread(function()
	while true do
		Wait(0)
        if playEmote then
            Citizen.Wait(3000)
            playEmote = false
        end
    end
end)

CreateThread(function()
	while true do
		Wait(0)
        if cooldown then
            Citizen.Wait(1500)
            cooldown = false
            canCapture = true
        end
    end
end)

CreateThread(function()
	while true do
		Wait(0)
        if giveReward then
            Citizen.Wait(1500)
            giveReward = false
        end
    end
end)

CreateThread(function()
	while true do
		Wait(0)
        if captured then
            Citizen.Wait(1500)
            captured = false
        end
    end
end)

CreateThread(function()
	while true do
		Wait(0)
        local player = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(player))
        if Citizen.InvokeNative(0xD5FE956C70FF370B, player) then
            z = z-0.5
        end
        if giveReward then
			DrawCoin3D(x, y, z+1.15)

            for key, value in pairs(Config.settings) do                
                if value.firstpersonMode then
                    DrawTxtPrice("~COLOR_MENU_BAR~You Earned ~COLOR_SOCIAL_CLUB~$"..price)
                else
                    DrawText3D(x, y, z+1.1, "~COLOR_MENU_BAR~You Earned ~COLOR_SOCIAL_CLUB~$"..price)
                end
            end
            
        end
        if captured then
            
            for key, value in pairs(Config.settings) do

                if not value.firstpersonMode then

                    if msgTxt == 0 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Nice Shot!")
                    elseif msgTxt == 1 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Good Job!")
                    elseif msgTxt == 2 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Awesome!")
                    elseif msgTxt == 3 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Not Bad!")
                    elseif msgTxt == 4 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Perfect!")
                    elseif msgTxt == 5 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Move Closer!")
                    elseif msgTxt == 6 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Get a better distance!")
                    elseif msgTxt == 7 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Get Closer!")
                    elseif msgTxt == 8 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Can't get a Clear Shot!")
                    elseif msgTxt == 9 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~Too Far Away!")
                    elseif msgTxt == 10 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~You're too Far!")
                    elseif msgTxt == 11 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~What a Crime Scene")
                    elseif msgTxt == 12 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~It's Dead already!")
                    elseif msgTxt == 13 then
                        DrawText3D(x, y, z+1.0, "~COLOR_YELLOW~It's Dead")
                    end

                else

                    if msgTxt == 0 then
                        DrawTxt("~COLOR_YELLOW~Nice Shot!")
                    elseif msgTxt == 1 then
                        DrawTxt("~COLOR_YELLOW~Good Job!")
                    elseif msgTxt == 2 then
                        DrawTxt("~COLOR_YELLOW~Awesome!")
                    elseif msgTxt == 3 then
                        DrawTxt("~COLOR_YELLOW~Not Bad!")
                    elseif msgTxt == 4 then
                        DrawTxt("~COLOR_YELLOW~Perfect!")
                    elseif msgTxt == 5 then
                        DrawTxt("~COLOR_YELLOW~Move Closer!")
                    elseif msgTxt == 6 then
                        DrawTxt("~COLOR_YELLOW~Get a better distance!")
                    elseif msgTxt == 7 then
                        DrawTxt("~COLOR_YELLOW~Get Closer!")
                    elseif msgTxt == 8 then
                        DrawTxt("~COLOR_YELLOW~Can't get a Clear Shot!")
                    elseif msgTxt == 9 then
                        DrawTxt("~COLOR_YELLOW~Too Far Away!")
                    elseif msgTxt == 10 then
                        DrawTxt("~COLOR_YELLOW~You're too Far!")
                    elseif msgTxt == 11 then
                        DrawTxt("~COLOR_YELLOW~What a Crime Scene")
                    elseif msgTxt == 12 then
                        DrawTxt("~COLOR_YELLOW~It's Dead already!")
                    elseif msgTxt == 13 then
                        DrawTxt("~COLOR_YELLOW~It's Dead")
                    end

                end

            end

            
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        
        if noFilm then
            DrawTxt("~COLOR_REDLIGHT~No Film")
        end
    end
end)

function IsPlayerCloseAnimal(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 13.0 then
        return true
    end
end

function IsPlayerNearAnimal(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 15.0 then
        return true
    end
end

function IsPlayerFarAnimal(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 18.0 then
        return true
    end
end

function IsValidTarget(ped)
	return IsPedHuman(ped) or Citizen.InvokeNative(0x9A100F1CF4546629, ped) and not (IsPedAPlayer(ped) and not IsPvpEnabled()) and not IsPedRagdoll(ped)
end

function GetClosestPed(playerPed, radius)
	local playerCoords = GetEntityCoords(playerPed)

	local itemset = CreateItemset(true)
	local size = Citizen.InvokeNative(0x59B57C4B06531E1E, playerCoords, radius, itemset, 1, Citizen.ResultAsInteger())

	local closestPed
	local minDist = radius

	if size > 0 then
		for i = 0, size - 1 do
			local ped = GetIndexedItemInItemset(i, itemset)

			if playerPed ~= ped and IsValidTarget(ped) then
				local pedCoords = GetEntityCoords(ped)
				local distance = #(playerCoords - pedCoords)

				if distance < minDist then
					closestPed = ped
					minDist = distance
				end
			end
		end
	end

	if IsItemsetValid(itemset) then
		DestroyItemset(itemset)
	end

	return closestPed
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local dict = "mech_inventory@binoculars"
        local anim = "hold"
        local player = PlayerPedId()

        if carryingCamera then
            if IsPedOnMount(player) or IsPedInAnyVehicle(player, false) or IsPedSwimming(player) then
                hideCamera()
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        local dict = "mech_inventory@binoculars"
        local anim = "hold"
        local player = PlayerPedId()
        
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
          Wait(100)
        end

        if carryingCamera then
            if lookingCamera or active or IsPedRunning(player) or IsPedSprinting(player) or IsPedJumping(player) then
                Citizen.InvokeNative(0x97FF36A1D40EA00A, player,"mech_inventory@binoculars", "hold", 0)
            elseif not IsControlJustPressed(0, 0xF84FA74F) and not lookingCamera and not active and (IsPedWalking(player) or IsPedStill(player)) and not Citizen.InvokeNative(0xDEE49D5CA6C49148, player, "mech_inventory@binoculars", "hold", 31) then
                TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
            end
        end
    end
end)

function playFlashAudio()
    local is_flash_sound_playing = false
    local flash_soundset_ref = "Photo_Mode_Sounds"
    local flash_soundset_name =  "take_photo"
  
    if not is_flash_sound_playing then
      if flash_soundset_ref ~= 0 then
        Citizen.InvokeNative(0x0F2A2175734926D8, flash_soundset_name, flash_soundset_ref);   -- load sound frontend
      end
      Citizen.InvokeNative(0x67C540AA08E4A6F5, flash_soundset_name, flash_soundset_ref, true, 0);  -- play sound frontend
      is_flash_sound_playing = true
    else
      Citizen.InvokeNative(0x9D746964E0CF2C5F, flash_soundset_name, flash_soundset_ref)  -- stop audio
      is_flash_sound_playing = false
    end
end

function playDisabledAudio()
    local is_flash_sound_playing = false
    local flash_soundset_ref = "RDRO_Poker_Sounds"
    local flash_soundset_name =  "round_start_countdown_tick"
  
    if not is_flash_sound_playing then
      if flash_soundset_ref ~= 0 then
        Citizen.InvokeNative(0x0F2A2175734926D8, flash_soundset_name, flash_soundset_ref);   -- load sound frontend
      end
      Citizen.InvokeNative(0x67C540AA08E4A6F5, flash_soundset_name, flash_soundset_ref, true, 0);  -- play sound frontend
      is_flash_sound_playing = true
    else
      Citizen.InvokeNative(0x9D746964E0CF2C5F, flash_soundset_name, flash_soundset_ref)  -- stop audio
      is_flash_sound_playing = false
    end
end

function lookCamera()
    local dict = "mech_inventory@binoculars"
    local anim = "look"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    lookingCamera = true
end

function holdCamera()
    local dict = "mech_inventory@binoculars"
    local anim = "hold"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    lookingCamera = false
    active = false
    Wait(10)
end

function getCamera()
    local dict = "mech_inventory@item@_templates@binoculars@binoculars@unarmed@base"
    local anim = "holster"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Wait(100)
    end
    active = true
    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Wait(800)
    carryProp()
    Wait(100)
    
end

function playFocusLensAudio()
    local is_shrink_sound_playing = false
    local shrink_soundset_ref = "RDRO_Poker_Sounds"
    local shrink_soundset_name =  "player_turn_countdown_start"

    if not is_shrink_sound_playing then           
        if shrink_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, shrink_soundset_name, shrink_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5, shrink_soundset_name, shrink_soundset_ref, true, 0);  -- play sound frontend
        is_shrink_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, shrink_soundset_name, shrink_soundset_ref)  -- stop audio
        is_shrink_sound_playing = false
    end
end

function carryProp()
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Hand")
    local playerPed = PlayerPedId()
    local propName = "p_camerabox_film01x"
    local x,y,z = table.unpack(GetEntityCoords(playerPed))

    prop = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.13, 0.03, -0.12, 117.0, 158.0, 193.0, true, true, false, true, 1, true)
    ClearPedTasks(PlayerPedId())
    holdCamera()
    carryingCamera = true
end


function hideCamera()
    local dict = "mech_inventory@item@_templates@paper@w10-16_h15-24@unarmed@base"
    local anim = "unholster"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    active = true
    Wait(1400)
    DeleteObject(prop, 1, 1)
    carryingCamera = false
    Wait(200)
    ClearPedTasks(PlayerPedId())
    active = false
end

function smokeEffect()
    local new_ptfx_dictionary = "core"
    local new_ptfx_name = "mech_ped_sparks"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_particle_effect_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))  -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
                Citizen.Wait(0)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then  -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary) -- UseParticleFxAsset

            current_ptfx_handle_id =  Citizen.InvokeNative(0xFF4C64C513388C12, current_ptfx_name, prop, 0.0, 0.0, -0.07, 0, 0, 0, 0.5, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_ptfx_handle_id = false
        is_particle_effect_active = false	
    end
end

function flashEffect()
    local new_ptfx_dictionary = "anm_weapons"
    local new_ptfx_name = "ent_anim_muzzle_flash_light"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_particle_effect_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))  -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
                Citizen.Wait(0)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then  -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary) -- UseParticleFxAsset

            current_flash_handle_id =  Citizen.InvokeNative(0xFF4C64C513388C12, current_ptfx_name, prop, 0.0, 0.0, 0.1, 0, 180, 0, 0.1, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_flash_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_flash_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_flash_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_flash_handle_id = false
        is_flash_effect_active = false	
    end
end

function playLootAudio()
    local is_frontend_sound_playing = false
    local frontend_soundset_ref = "HUD_DOMINOS_SOUNDSET"
    local frontend_soundset_name =  "MONEY"

    if not is_frontend_sound_playing then           
        if frontend_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8,frontend_soundset_name, frontend_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5,frontend_soundset_name, frontend_soundset_ref, true, 0);  -- play sound frontend
        is_frontend_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F,frontend_soundset_name, frontend_soundset_ref)  -- stop audio
        is_frontend_sound_playing = false
    end
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextDropshadow(4, 4, 21, 22, 255)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawTxt(str)
   local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(1.2, 1.2)
   SetTextColor(214, 232, 79, 200)
   SetTextCentre(true)
   SetTextDropshadow(1, 0, 0, 0, 255)
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, 0.5, 0.5)
end

function DrawTxtPrice(str)
   local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(0.8, 0.8)
   SetTextColor(214, 232, 79, 200)
   SetTextCentre(true)
   SetTextDropshadow(1, 0, 0, 0, 255)
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, 0.5, 0.45)
end

function DrawCoin3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    if not HasStreamedTextureDictLoaded("mp_lobby_textures") then
        RequestStreamedTextureDict("mp_lobby_textures", false)
    else
        DrawSprite("mp_lobby_textures", "leaderboard_cash", _x, _y, 0.015, 0.028, 0.1, 206, 214, 62, 215, 0)
    end
end

function DrawNum3D(x, y, z, filmCount)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    if num == 1 then
        SetTextColor(255, 255, 255, 215)
    elseif num == 10 then
        SetTextColor(64, 134, 247, 215)
    else
        SetTextColor(255, 255, 255, 45)
    end
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    -- DisplayText(str,_x,_y-0.038)
     
    if not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        if filmCount > 0 then
            if filmCount > 10 then
                DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.036, 0.007, 0.043, 0.1, 0, 0, 0, 200, 0)
                DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.036, 0.007, 0.043, 0.1, 0, 0, 0, 200, 0)
            else
                DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.036, 0.007, 0.043, 0.1, 0, 0, 0, 200, 0)
            end
        end
        
        if filmCount == 1 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
        elseif filmCount == 2 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
        elseif filmCount == 3 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
        elseif filmCount == 4 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
        elseif filmCount == 5 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
        elseif filmCount == 6 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
        elseif filmCount == 7 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
        elseif filmCount == 8 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
        elseif filmCount == 9 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
        elseif filmCount == 10 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)


        elseif filmCount == 11 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)

            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 12 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 13 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 14 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 15 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 16 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 17 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 18 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 19 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        elseif filmCount == 20 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.07 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
            
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.06 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        end
    end
end