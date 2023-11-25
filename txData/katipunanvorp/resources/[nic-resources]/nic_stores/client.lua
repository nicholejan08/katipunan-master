
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local stores = {}
local index = 1
local menu = false
local prop
local type = ""

local exiting = false

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DELETE"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,

    ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MDOWN"] = 0x8BDE7443
}

-- RETURN EVENT
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_stores:nomoney')
AddEventHandler('nic_stores:nomoney', function()
    exports['nic_messages']:startMessage(4000, "Hindi sapat ang iyong pera")playFrontendSound("HUD_POKER", "BET_PROMPT")
end)

RegisterNetEvent('nic_stores:itemfull')
AddEventHandler('nic_stores:itemfull', function()
    exports['nic_messages']:startMessage(4000, "Di ka na maaring bumili nito")playFrontendSound("HUD_POKER", "BET_AMOUNT")
end)

RegisterNetEvent('nic_stores:inventoryfull')
AddEventHandler('nic_stores:inventoryfull', function()
    exports['nic_messages']:startMessage(4000, "Puno na ang iyong imbentaryo")playFrontendSound("HUD_POKER", "BET_MIN_MAX")
end)

RegisterNetEvent("nic_stores:openMenu")
AddEventHandler("nic_stores:openMenu", function(data)
    AnimpostfxPlay("PauseMenuIn")
    index = 1
    stores = data

    playOpenAudio()
    SetNuiFocus(true, true)
    SendNUIMessage({ message = type })
end)

RegisterNetEvent('nic_stores:playSound')
AddEventHandler('nic_stores:playSound', function()
    playLootAudio()
end)

--  CREATE NPCs
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    local ped = PlayerPedId()

    for key, value in pairs(Config.location.coords) do

        local blip = N_0x554d9d53f696d002(1664425300, value.x, value.y, value.z)
        SetBlipSprite(blip, value.blip, 1)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, value.name)

        if value.pedModel ~= nil or value.pedx ~= nil or value.pedy ~= nil or value.pedz ~= nil or value.pedh ~= nil then
            if not DoesEntityExist(npc) then
                RequestModel(GetHashKey(value.pedModel))    
                while not HasModelLoaded(GetHashKey(value.pedModel)) do
                    Wait(100)
                end
                local npc = CreatePed(value.pedModel, value.pedx, value.pedy, value.pedz-1.0, value.pedh, false, true)
                Citizen.InvokeNative(0x9587913B9E772D29 , npc, true )
                Citizen.InvokeNative(0x283978A15512B2FE , npc, true )
                SetEntityNoCollisionEntity(ped, npc, false)
                SetPedCanBeTargettedByPlayer(npc, ped, false)
                SetPedCanBeTargetted(npc, false)
                SetEntityCanBeDamaged(npc, false)
                SetEntityInvincible(npc, true)
                FreezeEntityPosition(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                SetModelAsNoLongerNeeded(model)
                SetPedAsGroupMember(npc, GetPedGroupIndex(ped))
                TaskStartScenarioInPlace(npc, GetHashKey('WORLD_HUMAN_INSPECT'), -1, true, false, false, false)
            end
        end
    end

    -- if IsEntityNearEntity(ped, npc, 32.0) then
    --     ResetEntityAlpha(npc)
    -- else
    --     SetEntityAlpha(npc, 255, false)
    -- end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if menu then
            if IsEntityDead(ped) or IsPedRagdoll(ped) then
                CloseStore()
            end
        end
    end
end)

--  IF NEAR COORDS
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local action = not exiting and not IsPedJumping(ped) and not IsPedRagdoll(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) and not IsEntityDead(ped) and not IsPedFalling(ped) and not IsEntityInWater(ped) and not IsEntityInAir(ped) and not IsPedSprinting(ped)

        for key, value in pairs(Config.location.coords) do

            if IsPlayerNearCoords(value.x, value.y, value.z) then

                for key, value in pairs(Config.settings) do
                    if value.safezone then
                        DisablePlayerFiring(ped, true)
                    end
                end
                
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, value.x, value.y, value.z-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 192, 201, 85, 50, false, true, 2, false, false, false, false)
                if value.pedModel ~= nil or value.pedx ~= nil or value.pedy ~= nil or value.pedz ~= nil or value.pedh ~= nil then
                    DrawLogo3D(value.pedx, value.pedy, value.pedz+1.1)
                end
            end

           if IsPlayerNearStore(value.x, value.y, value.z) then

                for key, value in pairs(Config.settings) do
                    if value.safezone then
                        DisablePlayerFiring(ped, true)
                    end
                end
                
                if not menu then
                    DrawBuy3D(value.x, value.y, value.z, "F")

                    if IsControlJustPressed(0, Keys['F']) then
                        if action then
                            DeleteObject(prop, 1, 1)                             
                            type = value.t
                            exiting = true
                            SetEntityHeading(ped, value.h)
                            playStoreAnimation()
                            carryProp()
                            menu = true
                            TriggerEvent("nic_stores:openMenu") 
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local animation = "mech_inspection@generic@lh@base"

        if IsEntityPlayingAnim(playerPed, animation, "hold", 3) then
            TaskPlayAnim(playerPed, animation, "hold", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
            carryProp()
        end	
        if IsEntityPlayingAnim(playerPed, "mech_pickup@plant@gold_currant", "stn_long_low_skill_exit", 3) then
            exiting = true
            TaskPlayAnim(playerPed, "mech_pickup@plant@gold_currant", "stn_long_low_skill_exit", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        end
    end
end)

-- PLAY PICK ANIMATION FUNCTION
----------------------------------------------------------------------------------------------------

function playKeepkAnimation()
    local ped = PlayerPedId()
    local animation = "mech_pickup@plant@gold_currant"

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "stn_long_low_skill_exit", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

-- PLAY STORE ANIMATION FUNCTION
----------------------------------------------------------------------------------------------------

function playStoreAnimation()
    local ped = PlayerPedId()
    local animation = "mech_inspection@generic@lh@base"

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "hold", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

-- CUSTOM FUNCTIONS
----------------------------------------------------------------------------------------------------

function IsEntityNearEntity(entity1, entity2, dist)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity1, 0))
    local ex2, ey2, ez2 = table.unpack(GetEntityCoords(entity2, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, ex2, ey2, ez2, true)

    if distance < dist then
        return true
    end
end

function CloseStore()
    local ped = PlayerPedId()
    AnimpostfxStop("PauseMenuIn")
    playCloseAudio()
    playKeepkAnimation()
    index = 1
    menu = false
    SetNuiFocus(false, false)
    SendNUIMessage({})
    Citizen.Wait(1000)
    DeleteObject(prop, 1, 1)
    Citizen.Wait(1000)
    ClearPedTasks(ped)
    exiting = false
end

function IsPlayerNearCoords(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 12 then
        return true
    end
end

function IsPlayerNearStore(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 1 then
        return true
    end
end

-- CREATE ITEM PROP FUNCTION
----------------------------------------------------------------------------------------------------

function carryProp()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_Hand")
    local playerPed = ped
    local propName = "p_moneybag01x"
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    prop = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(prop, ped, boneIndex, 0.07, -0.01, 0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
end

-- UTILS FUNCTION
----------------------------------------------------------------------------------------------------

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
   local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(w, h)
   SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
   SetTextCentre(centre)
   if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, x, y)
end

-- 3D TEXT FUNCTION
----------------------------------------------------------------------------------------------------

function DrawText3D(x, y, z, enableShadow, text)
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

--  NUI FUNCTIONS
----------------------------------------------------------------------------------------------------

RegisterNUICallback('close', function()
    CloseStore()
end)

-- ITEM TRIGGERS
----------------------------------------------------------------------------------------------------

for key, value in pairs(Config.stores.items) do
    RegisterNUICallback(value.name, function()
        TriggerServerEvent('nic_stores:useItem', type, value.name, value.price)
        playStoreAnimation()
    end)
end

function DrawLogo3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z+0.2)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.10, 0.10)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("honor_display") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 175, 0)
        DrawSprite("menu_textures", "menu_icon_alert", _x, _y+0.0122, 0.017, 0.032, 0.1, 245, 239, 86, 215, 0)
    end
end

function DrawBuy3D(x, y, z, text)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(0, 0, 0, 255)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x+0.016,_y-0.038)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.016, _y-0.025, 0.017, 0.029, 0.1, 0, 0, 0, 215, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.016, _y-0.025, 0.015, 0.027, 0.1, 215, 215, 215, 255, 0)

        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("overhead", "overhead_cash_bag", _x, _y, 0.018, 0.03, 0.1, 255, 255, 255, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        -- DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.017, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

-- AUDIO FUNCTIONS
----------------------------------------------------------------------------------------------------

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

function playFrontendSound(dict, val)
    local is_shrink_sound_playing = false
    local shrink_soundset_ref = dict
    local shrink_soundset_name =  val
  
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

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

