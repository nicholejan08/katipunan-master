local deathCam

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DEL"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41, ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,
}

RegisterCommand('goto', function(source, args, raw)
    local ped = PlayerPedId()

	if #args > 0 then
		local x = (args[1] and tonumber(args[1]) or 0)
		local y = (args[2] and tonumber(args[2]) or 0)
		local z = (args[3] and tonumber(args[3]) or 0)
        SetEntityCoords(ped, x, y, z)
        print(x.." "..y.." "..z)
	end
end, true)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local player = PlayerId()
        local hp = GetEntityHealth(ped)
        
        DisableControlAction(0, 0x52E60A8B, true)
        DisableControlAction(0, 0x1ECA87D4, true)
        DisableControlAction(0, 0xAC4BD4F1, true)

        for key, value in pairs(Config.settings) do
            if value.revealWholeMap then
                SetMinimapHideFow(true)
            else
                SetMinimapHideFow(false)
            end
        end

        for key, value in pairs(Config.settings) do
            if not value.firstperson then
                DisableFirstPersonCamThisFrame()
            end
        end

        for key, value in pairs(Config.settings) do
            if not value.cameraModes then
                Citizen.InvokeNative(0x1CFB749AD4317BDE)
            end
        end

        for key, value in pairs(Config.settings) do
            if not value.gameplayCameraShake then
                StopGameplayCamShaking(1)
            else
                StopGameplayCamShaking(0)
            end
        end

        for key, value in pairs(Config.settings) do
            if not value.playerImpact then
                SetPedCanRagdollFromPlayerImpact(player, true)	
            end
        end

        if not IsEntityDead(ped) then

            if hp >= 50 then
                SetPlayerHealthRechargeMultiplier(player, 0.05)
            else
                SetPlayerHealthRechargeMultiplier(player, 0.01)
            end

            if hp > 130 then
                SetEntityHealth(ped, 130, 1)
            end

        end
        
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)  
        local ped = PlayerPedId()
        local fxName = "PlayerSickDoctorsOpinion"

        if IsEntityDead(ped) then
            AnimpostfxPlay(fxName)
            if not IsCamRendering(deathCam) then
                startDeathCam()
            end
        else
            AnimpostfxStop(fxName)
            if IsCamRendering(deathCam) then
                destroyCam()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        for key, value in pairs(Config.settings) do
            if value.cameraModes then
                if IsControlJustPressed(0, Keys['V']) then
                    playFlashAudio()
                end
            end
        end

        if IsControlJustPressed(0, Keys['Z']) then
            SetCurrentPedWeapon(ped, 0x8580C63E, true, 2, true, true)
        end
        
        if IsControlJustPressed(0, Keys['TAB']) then
            HidePedWeapons(ped, 2, false)
        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local player = PlayerId()

        Citizen.InvokeNative(0x4CC5F2FC1332577F, 0xBB47198C)
        Citizen.InvokeNative(0x4CC5F2FC1332577F, -2106452847)		
        Citizen.InvokeNative(0x8BC7C1F929D07BF3 , 100665617)	
        Citizen.InvokeNative(0x8BC7C1F929D07BF3 , -859384195)
        Citizen.InvokeNative(0x4CC5F2FC1332577F, 1058184710)
        Citizen.InvokeNative(0x4CC5F2FC1332577F, -66088566)

        if IsPlayerFreeAiming(player) and IsPedWeaponReadyToShoot(ped) then
                    
            if not IsFirstPersonAimCamActive() then
                weapon, weponhash = GetCurrentPedWeapon(ped, true)
                isBow = GetHashKey("WEAPON_BOW")
                if weponhash ~= isBow then                
                    Citizen.InvokeNative(0x4CC5F2FC1332577F, 0xBB47198C)
                end
            end
        end

    end
end)

function startDeathCam()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        ClearFocus()
        local camHeight = 20
        local x, y, z = table.unpack(GetEntityCoords(ped))
        local coords = vector3(x+3.0, y+3.0, z+31.0)
        deathCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0.00, 0.00, 0.00, camHeight*1.0, false, 0)
        AttachCamToPedBone(deathCam, ped, 0, 2.0, 2.0, camHeight*1.0, 0)
        PointCamAtEntity(deathCam, ped, 1, 1, 0, true)
        SetCamActive(deathCam, true)
        RenderScriptCams(true, true, 200, true, false)
        PointCamAtEntity(deathCam, ped, 1, 1, 0, false)
    end)
end

function destroyCam()
    NetworkSetInSpectatorMode(false, ped)
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(deathCam, false)
    deathCam = nil
end

function showHUD()
    DisplayRadar(true)
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("alpohud:toggleHud", true)
    TriggerEvent("vorp_hud:toggleHud", true)
end

function hideHUD()
    DisplayRadar(false)
    TriggerEvent("vorp_inventory:CloseInv")
    TriggerEvent("vorp:showUi", false)
    TriggerEvent("alpohud:toggleHud", false)
    TriggerEvent("vorp_hud:toggleHud", false)
end

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