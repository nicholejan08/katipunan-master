
local toggled = false
local fade = false

local sleeping = false
local sitting = false
local peeing = false
local pooping = false
local standby = false

local triggered = false
local playerMenuFX = "WheelHUDIn"

RegisterNetEvent('nic_player_menu:toggleUI')
AddEventHandler('nic_player_menu:toggleUI', function(val)
    if val == "main" then
        AnimpostfxPlay(playerMenuFX)
        SetNuiFocus(true, true)
        SendNUIMessage({message = val})
    elseif val == "wake" then
        SetNuiFocus(true, true)
        SendNUIMessage({message = val})
    else
        AnimpostfxStop(playerMenuFX)
        SetNuiFocus(false, false)
        SendNUIMessage({message = nil})
    end
end)

RegisterNetEvent('nic_player_menu:toggleWakeUp')
AddEventHandler('nic_player_menu:toggleWakeUp', function(bool)
    SetNuiFocus(bool, bool)
    if not bool then
        bool = nil
    end
    SendNUIMessage({wake = bool})
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()

        if Citizen.InvokeNative(0x57AB4A3080F85143, ped) then
            SetPedCanRagdoll(ped, false)
        else
            SetPedCanRagdoll(ped, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()
      
      if IsPedRagdoll(ped) or (standby or sitting) and Citizen.InvokeNative(0x57AB4A3080F85143, ped) and not peeing and not pooping then

        if IsControlJustPressed(0, 0x156F7119) or IsControlJustPressed(0, 0x4AF4D473) or IsControlJustPressed(0, 0x8FD015D8) or IsControlJustPressed(0, 0x7065027D) or IsControlJustPressed(0, 0xD27782E3) or IsControlJustPressed(0, 0xB4E465B4) or IsControlJustPressed(0, 0xD9D0E1C0) or IsControlJustPressed(0, 0xDB096B85) then
            if sleeping then
                DoScreenFadeIn(3000)
            end
            standby = false
            sitting = false
            stopAll()
            ClearPedTasks(ped)
        end

      end

    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()
      
      if IsEntityDead(ped) then
        SetNuiFocus(false, false)
        sleeping = false
        sitting = false
        peeing = false
        pooping = false
        TriggerEvent("player_menu_close")
        DoScreenFadeIn(3000)
      end
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()

        if IsControlJustPressed(0, 0xE8342FF2) and DoesEntityExist(ped) and not IsEntityDead(ped) then
            if not IsPedUsingAnyScenario(ped) then
                if not toggled then
                    toggled = true
                    TriggerEvent('nic_player_menu:toggleUI', "main")
                    playOpenAudio()
                else
                    toggled = false
                    TriggerEvent('nic_player_menu:toggleUI', nil)
                    playCloseAudio()
                end
            else
                notAllowedPrompt()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)

        if IsControlJustPressed(0, 0xD8F73058) then
            if not triggered then
                triggered = true
                TriggerEvent("vorpmetabolism:getValue","Thirst", function(value)
                    tValue = value
                  end)
                  thirst = true
                  Wait(3000)
                  thirst = false
            else
                triggered = false
            end
        end
    end
end)

function DrawTxt(str)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
    SetTextScale(1.2, 1.2)
    SetTextColor(214, 232, 79, 200)
    SetTextCentre(true)
    SetTextDropshadow(1, 0, 0, 0, 255)
    Citizen.InvokeNative(0xADA9255D, 10);
    DisplayText(str, 0.5, 0.5)
 end

function testAnim()
    local dict = "mech_loco_m@character@arthur@fidgets@weather@rainy_wet@unarmed"
    local anim = "shake_off_c"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Wait(100)
    end
    TaskPlayAnim(ped, dict, anim, 1.0, 4000.0, -1, 31, 0, true, 0, false, 0, false)
    lookingCamera = true
end

RegisterNUICallback('player_menu_open', function()
    stopAll()
    TriggerEvent("vorp_inventory:CloseInv")
    playOpenAudio()
end)

RegisterNUICallback('player_menu_hover', function()
    playHoverAudio()
end)

RegisterNUICallback('player_menu_close', function()
    if toggled then
        TriggerEvent("vorp_inventory:CloseInv")
        toggled = false
        TriggerEvent('nic_player_menu:toggleUI', nil)
        stopAll()
        playCloseAudio()
    end
end)

RegisterNUICallback('player_menu_sleep', function()
    stopAll()
    playerSleep()
    TriggerEvent("vorp_inventory:CloseInv")
end)

RegisterNUICallback('player_menu_pee', function()
    stopAll()
    TriggerEvent("vorp_inventory:CloseInv")
    TriggerEvent("nic_pee:startPee")
    peeing = true
    Citizen.Wait(15000)
    peeing = false
end)

RegisterNUICallback('player_menu_poop', function()
    stopAll()
    TriggerEvent("vorp_inventory:CloseInv")
    TriggerEvent("nic_poop:startPoop")
    pooping = true
    Citizen.Wait(4000)
    pooping = false
end)

RegisterNUICallback('player_menu_wakeup', function()
    SetNuiFocus(false, false)
    toggleUI(true)
    toggled = false
    stopAll()
    playerWakeup()
end)

RegisterNUICallback('player_menu_sit', function()
    stopAll()
    playerSit()
    TriggerEvent("vorp_inventory:CloseInv")
end)

RegisterNUICallback('player_menu_standby', function()
    stopAll()
    playerStandBy()
    TriggerEvent("vorp_inventory:CloseInv")
end)


function stopAll()
    standby = false
    sleeping = false
    sitting = false
    peeing = false
    pooping = false
    fade = false
end

function playOpenAudio()
    local is_frontend_sound_playing = false
    local frontend_soundset_ref = "Study_Sounds"
    local frontend_soundset_name =  "show_info"

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

function playerStandBy()
    local ped = PlayerPedId()
    local inWater = IsEntityInWater(ped)
    local swimming = IsPedSwimming(ped)
	local male =  IsPedMale(ped)
    local scenario = ""
    local num = math.random(0, 4)

    if not IsPedOnMount(ped) and not IsEntityDead(ped) and not IsPedRagdoll(ped) then
        if male then
            scenario = "WORLD_HUMAN_BADASS"
        else
            scenario = "WORLD_CAMP_FIRE_SIT_GROUND_FEMALE_A"
        end
    
        if num == 0 then
            scenario = "WORLD_HUMAN_STAND_WAITING"
        elseif num == 1 then
            scenario = "WORLD_HUMAN_WAITING_IMPATIENT"
        elseif num == 2 then
            scenario = "WORLD_HUMAN_BADASS"
        elseif num == 3 then
            scenario = "WORLD_HUMAN_STARE_STOIC"
        else
            scenario = "WORLD_HUMAN_STERNGUY_IDLES"
        end
    
        if not inWater and not swimming and not Citizen.InvokeNative(0xA911EE21EDF69DAF, ped) and not Citizen.InvokeNative(0x306C1F6178F01AB3, ped) and not IsPedOnMount(ped) and not Citizen.InvokeNative(0x997ABD671D25CA0B, ped, true) then
            ClearPedTasks(ped)
            TaskStartScenarioInPlace(ped, GetHashKey(scenario), -1, true, false, false, false)
            Citizen.Wait(5000)
            standby = true
        else
            notAllowedPrompt()
        end
    else
        notAllowedPrompt()
    end
end

function playerSit()
    local ped = PlayerPedId()
    local inWater = IsEntityInWater(ped)
    local swimming = IsPedSwimming(ped)
	local male =  IsPedMale(ped)
    local scenario = ""

    if not IsPedOnMount(ped) and not IsEntityDead(ped) and not IsPedRagdoll(ped) then
        if male then
            scenario = "WORLD_HUMAN_FIRE_SIT"
        else
            scenario = "WORLD_CAMP_FIRE_SIT_GROUND_FEMALE_A"
        end
    
        if not inWater and not swimming and not Citizen.InvokeNative(0xA911EE21EDF69DAF, ped) and not Citizen.InvokeNative(0x306C1F6178F01AB3, ped) and not IsPedOnMount(ped) and not Citizen.InvokeNative(0x997ABD671D25CA0B, ped, true) then
            ClearPedTasks(ped)
            TaskStartScenarioInPlace(ped, GetHashKey(scenario), -1, true, false, false, false)
            Citizen.Wait(5000)
            sitting = true
        else
            notAllowedPrompt()
        end
    else
        notAllowedPrompt()
    end
end

function playerSleep()
    local ped = PlayerPedId()
    local inWater = IsEntityInWater(ped)
    local swimming = IsPedSwimming(ped)
	local male =  IsPedMale(ped)
    local scenario = ""
    local num = math.random(0, 1)
    local duration = 0

    if not IsPedOnMount(ped) and not IsEntityDead(ped) and not IsPedRagdoll(ped) then

        if male then
            if num == 0 then
                scenario = "WORLD_HUMAN_SLEEP_GROUND_PILLOW"
                duration = 18000
            else
                scenario = "WORLD_HUMAN_SLEEP_GROUND_ARM"
                duration = 18000
            end
        else
            scenario = "PROP_CAMP_SLEEP_PEW_COLD_FEMALE_B"
            duration = 15000
        end
    
        if not inWater and not swimming and not Citizen.InvokeNative(0xA911EE21EDF69DAF, ped) and not Citizen.InvokeNative(0x306C1F6178F01AB3, ped) and not IsPedOnMount(ped) and not Citizen.InvokeNative(0x997ABD671D25CA0B, ped, true) then
            ClearPedTasks(ped)
            AnimpostfxPlay("CamTransition01")
            TaskStartScenarioInPlace(ped, GetHashKey(scenario), -1, true, false, false, false)
            Citizen.Wait(duration)
            sleeping = true
            toggleUI(false)
            DoScreenFadeOut(3000)
            Citizen.Wait(3000)
            playOpenAudio()
            Citizen.Wait(3000)
            TriggerEvent('nic_player_menu:toggleUI', "wake")
        else
            notAllowedPrompt()
        end
    else
        notAllowedPrompt()
    end
end

function toggleUI(bool)
    AnimpostfxStopAll()
    TriggerEvent("vorp:showUi", bool)
    TriggerEvent("alpohud:toggleHud", bool)
    TriggerEvent("vorp_hud:toggleHud", bool)
end

function playerWakeup()
    local ped = PlayerPedId()
    AnimpostfxStop("PoisonDartPassOut")
    AnimpostfxPlay("PlayerWakeUpKnockout")
    playCloseAudio()
    DoScreenFadeIn(3000)
    Citizen.Wait(3000)
    ClearPedTasks(ped)
end

function playHoverAudio()
    local is_frontend_sound_playing = false
    local frontend_soundset_ref = "Ledger_Sounds"
    local frontend_soundset_name =  "INFO_SHOW"

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

function playCloseAudio()
    local is_frontend_sound_playing = false
    local frontend_soundset_ref = "Study_Sounds"
    local frontend_soundset_name =  "hide_info"

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

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end
