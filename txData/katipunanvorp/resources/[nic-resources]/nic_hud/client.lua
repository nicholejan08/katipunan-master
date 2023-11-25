
local charID, charJob, charMoney, charHunger, charThirst
local toghud = true
local timeText = ""
local maxhealth = (GetEntityMaxHealth(GetPlayerPed()))
local temp = 0
local temperature = 0

local hudToggled = false

RegisterCommand('fadeout', function()
    DoScreenFadeOut(500)
end)

RegisterCommand('fadein', function()
    DoScreenFadeIn(500)
end)

TriggerEvent('nic_hud:loadData')

RegisterNetEvent('nic_hud:loadData')
AddEventHandler('nic_hud:loadData', function()
    TriggerServerEvent('nic_hud:registerData', id, job, money)
    charID = id
    charJob = job
    charMoney = money
end)


RegisterNetEvent('nic_hud:startResource')
AddEventHandler('nic_hud:startResource', function(id, job, money)
    SendNUIMessage({
        type = "HUD",
        hidden = false,
        display = true,
        ID = charID,
        job = charJob,
        money = charMoney
    })
end)

RegisterNetEvent('nic_hud:getData')
AddEventHandler('nic_hud:getData', function(id, job, money)
    charID = id
    charJob = job
    charMoney = money
    SendNUIMessage({
        type = "HUD",
        ID = charID,
        job = charJob,
        money = charMoney
    })
end)

RegisterNetEvent('nic_hud:hudOff')
AddEventHandler('nic_hud:hudOff', function(bool)
    SendNUIMessage({
        type = "HUD",
        hidden = true
    })
    hudToggled = bool
end)

RegisterNetEvent('nic_hud:hudOn')
AddEventHandler('nic_hud:hudOn', function(bool)
    SendNUIMessage({
        type = "HUD",
        hidden = false,
        display = true,
        ID = charID,
        job = charJob,
        money = charMoney
    })
    hudToggled = bool
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)

        TriggerEvent('vorpmetabolism:getValue', 'Hunger', function(value)
            charHunger = value/1000
        end)

        TriggerEvent('vorpmetabolism:getValue', 'Thirst', function(value)
            charThirst = value/1000
        end)
        
        SendNUIMessage({
            type = "metabolism",
            hunger = charHunger,
            thirst = charThirst
        })

    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        TriggerServerEvent('nic_hud:Initialize')
       
        SendNUIMessage({
            type = "HUD",
            ID = charID,
            job = charJob,
            money = charMoney
        })

    end
end)

SetEntityHealth(GetPlayerPed(), maxhealth, 1)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        local health = (GetEntityHealth(ped))
        local coords = GetEntityCoords(ped, true)
        temp = math.floor(GetTemperatureAtCoords(coords.x, coords.y, coords.z)*10)/10
        local location = GetCurentTownName()
        local day = dayOfWeek()
        local ExtremeColdC = -5
        local job = ''
        temperature = temp + 1
        local fxName = "PlayerHealthPoor"

        DisableHudContext(-1679307491)

        if not hudToggled then
            if IsCinematicCamRendering() or IsPauseMenuActive() then
                TriggerEvent("vorp_inventory:CloseInv")
                DisableControlAction(0, 0xE8342FF2, true)
                TriggerEvent('nic_hud:hudOff', false)
            else
                TriggerEvent('nic_hud:hudOn', false)
            end
        end

        if not IsEntityDead(ped) then
            if health >= 200 then
                SetEntityHealth(ped, 100)
            end
        end

        if not IsEntityDead(ped) and not IsPauseMenuActive() then

            SendNUIMessage({
                action = 'updateStatusHud',
                show = toghud,
                health = health,
                temp = temperature,
                location = location,
                day = day
            })
        end
    end
end)

-- crosshair

RegisterNetEvent('nic_hud:crosshairToggle')
AddEventHandler('nic_hud:crosshairToggle', function(bool)
    if bool then
        SendNUIMessage({
          type = "crosshair",
          display = true
        })
    else
        SendNUIMessage({
          type = "crosshair",
          display = false
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local weapon = Citizen.InvokeNative(0x8425C5F057012DAB, ped)
        local isBinoculars = Citizen.InvokeNative(0xC853230E76A152DF, weapon)

        if not IsEntityDead(ped) then
          if IsPlayerFreeAiming(PlayerId()) then
            if not IsPedInCover(ped, true, true) and not IsPedGoingIntoCover(ped) and not IsPedInMeleeCombat(PlayerPedId()) and weapon ~= -1569615261 and not isBinoculars then

                TriggerEvent("nic_hud:crosshairToggle", true)
                ShakeGameplayCam("HAND_SHAKE", 2.0)

            end
          else
            TriggerEvent("nic_hud:crosshairToggle", false)
            -- ShakeGameplayCam("HAND_SHAKE", 0.0)

          end
        end
    end
end)

-- player menu

local toggled = false
local fade = false

local sleeping = false
local sitting = false
local peeing = false
local pooping = false
local standby = false

local triggered = false
local playerMenuFX = "WheelHUDIn"

RegisterNetEvent('nic_hud:toggleUI')
AddEventHandler('nic_hud:toggleUI', function(val)
    if val == "main" then
        AnimpostfxPlay(playerMenuFX)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "player-menu",
            message = val
        })
    elseif val == "wake" then
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "player-menu",
            message = val
        })
    else
        AnimpostfxStop(playerMenuFX)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "player-menu",
            message = nil
        })
    end
end)

RegisterNetEvent('nic_hud:toggleWakeUp')
AddEventHandler('nic_hud:toggleWakeUp', function(bool)
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
            stopAllMenuActions()
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
        toggled = false
        stopAllMenuActions()
        ClearPedTasks(ped)
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
                    TriggerEvent('nic_hud:toggleUI', "main")
                    playOpenAudio()
                else
                    toggled = false
                    TriggerEvent('nic_hud:toggleUI', nil)
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

-- NUI callbacks

RegisterNUICallback('player_menu_open', function()
    stopAllMenuActions()
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
        TriggerEvent('nic_hud:toggleUI', nil)
        stopAllMenuActions()
        playCloseAudio()
    end
end)

RegisterNUICallback('player_menu_sleep', function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
    Wait(100)
    stopAllMenuActions()
    playerSleep()
    TriggerEvent("vorp_inventory:CloseInv")
end)

RegisterNUICallback('player_menu_pee', function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
    Wait(100)
    stopAllMenuActions()
    TriggerEvent("vorp_inventory:CloseInv")
    TriggerEvent("nic_pee:startPee")
    peeing = true
    Citizen.Wait(15000)
    peeing = false
end)

RegisterNUICallback('player_menu_poop', function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
    Wait(100)
    stopAllMenuActions()
    TriggerEvent("vorp_inventory:CloseInv")
    TriggerEvent("nic_poop:startPoop")
    pooping = true
    Citizen.Wait(4000)
    pooping = false
end)

RegisterNUICallback('player_menu_wakeup', function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
    Wait(100)
    SetNuiFocus(false, false)
    toggled = false
    stopAllMenuActions()
    playerWakeup()
end)

RegisterNUICallback('player_menu_sit', function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
    Wait(100)
    stopAllMenuActions()
    playerSit()
    TriggerEvent("vorp_inventory:CloseInv")
end)

RegisterNUICallback('player_menu_standby', function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
    Wait(100)
    stopAllMenuActions()
    playerStandBy()
    TriggerEvent("vorp_inventory:CloseInv")
end)

-- functions

function DisableHudContext(hash)
    return Citizen.InvokeNative(0x8BC7C1F929D07BF3, hash)
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

function stopAllMenuActions()
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
            DoScreenFadeOut(3000)
            Citizen.Wait(3000)
            playOpenAudio()
            Citizen.Wait(3000)
            TriggerEvent('nic_hud:toggleUI', "wake")
        else
            notAllowedPrompt()
        end
    else
        notAllowedPrompt()
    end
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

function displayHUD(bool)
    local ped = PlayerPedId()

    SetNuiFocus(false, false)

    if bool then
        SendNUIMessage({
            type = "HUD",
            display = true
        })
    else
        SendNUIMessage({
            type = "HUD",
            display = false
        })
    end
end

displayHUD(true)

function GetCurentTownName()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords, 1)
    if town_hash == GetHashKey("Annesburg") then        
        return "Annesburg"
    elseif town_hash == GetHashKey("Armadillo") then
        return "Armadillo"
    elseif town_hash == GetHashKey("Blackwater") then
        return "Cavite"
    elseif town_hash == GetHashKey("BeechersHope") then
        return "BeechersHope"
    elseif town_hash == GetHashKey("Braithwaite") then
        return "Braithwaite"
    elseif town_hash == GetHashKey("Butcher") then
        return "Butcher"
    elseif town_hash == GetHashKey("Caliga") then
        return "Caliga"
    elseif town_hash == GetHashKey("cornwall") then
        return "Cornwall"
    elseif town_hash == GetHashKey("Emerald") then
        return "Emerald"
    elseif town_hash == GetHashKey("lagras") then
        return "lagras"
    elseif town_hash == GetHashKey("Manzanita") then
        return "Manzanita"
    elseif town_hash == GetHashKey("Rhodes") then 
        return "Caloocan"
    elseif town_hash == GetHashKey("Siska") then
        return "Siska"
    elseif town_hash == GetHashKey("StDenis") then 
        return "Maynila"
    elseif town_hash == GetHashKey("Strawberry") then
        return "Baguio"
    elseif town_hash == GetHashKey("Tumbleweed") then
        return "Tumbleweed"
    elseif town_hash == GetHashKey("valentine") then
        return "Laguna"
    elseif town_hash == GetHashKey("VANHORN") then
        return "Vanhorn"
    elseif town_hash == GetHashKey("Wallace") then
        return "Wallace"
    elseif town_hash == GetHashKey("wapiti") then
        return "Wapiti"
    elseif town_hash == GetHashKey("AguasdulcesFarm") then
        return "Bicol"
    elseif town_hash == GetHashKey("AguasdulcesRuins") then
        return "Bicol"
    elseif town_hash == GetHashKey("AguasdulcesVilla") then
        return "Bicol"
    elseif town_hash == GetHashKey("Manicato") then
        return "Manicato"
    elseif town_hash == GetHashKey("Guarma") then
        return "Bicol"
    else
        return "Pilipinas"
    end
end

function dayOfWeek()
	local dayOfWeek = GetClockDayOfWeek()
	
	if dayOfWeek == 0 then
		return "Linggo"
	elseif dayOfWeek == 1 then
		return "Lunes"
	elseif dayOfWeek == 2 then
		return "Martes"
	elseif dayOfWeek == 3 then
		return "Miyerkules"
	elseif dayOfWeek == 4 then
		return "Huwebes"
	elseif dayOfWeek == 5 then
		return "Biyernes"
	elseif dayOfWeek == 6 then
		return "Sabado"
	end
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end