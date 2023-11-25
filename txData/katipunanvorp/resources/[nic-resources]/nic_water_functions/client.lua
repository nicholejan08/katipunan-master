
local drinkPrompt = false

local drinking = false
local washing = false
local collecting = false

local drinkCooldown = false
local washCooldown = false
local collectCooldown = false

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DEL"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41, ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,
}

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 21030))
        local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
        local currentWeapon = GetPedCurrentHeldWeapon(ped)

        local action = not carrying and IsEntityInWater(ped) and not IsPedOnMount(ped) and not IsPedSwimming(ped) and not IsEntityDead(ped) and not IsPedJumping(ped) and not IsPedSprinting(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) and not IsPedGettingUp(ped) and not IsPedRagdoll(ped) and not IsPedClimbing(ped) and currentWeapon == -1569615261
        
        if action then
            if IsControlPressed(0, Keys['MOUSE2']) then
                SetPlayerLockon(PlayerId(), false)
                Draw3DPrompts(bCoords.x, bCoords.y, bCoords.z)
            end
        else
            SetPlayerLockon(PlayerId(), true)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local carrying = Citizen.InvokeNative(0xA911EE21EDF69DAF, ped)
        local action = not carrying and IsEntityInWater(ped) and not IsPedOnMount(ped) and not IsPedSwimming(ped) and not IsEntityDead(ped) and not IsPedJumping(ped) and not IsPedSprinting(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) and not  IsPedGettingUp(ped) and not IsPedRagdoll(ped) and not IsPedClimbing(ped)

        if action then
            DisableControlAction(0, 0xE8342FF2, true)

            if not washing and not drinking and not collecting then

                if not drinkCooldown then

                    if IsControlJustReleased(0, Keys['E']) then -- E
                        Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                        Wait(100)
                        StartDrink("amb_rest_drunk@world_human_bucket_drink@ground@male_a@idle_b", "idle_f")
                    end
                end
                if not washCooldown then
                    if IsControlJustReleased(0, Keys['G']) then -- G
                        Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                        Wait(100)
                        StartWash("amb_misc@world_human_wash_face_bucket@ground@male_a@idle_d", "idle_l")
                    end
                end
                if not collectCooldown then
                    if IsControlJustReleased(0, Keys['Z']) then -- Z
                        TriggerServerEvent("nic_consumables:checkCanteen")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('nic_waterfunctions:drinkCooldown')
AddEventHandler('nic_waterfunctions:drinkCooldown', function()
    drinkCooldown = true
    local cooldown
    local ped = PlayerPedId()
    local stopTimer = false

    for key, value in pairs(Config.settings) do
        cooldown = value.cooldown
    end

	Citizen.CreateThread(function()
        if not stopTimer then -- round timer start 
            while cooldown > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                cooldown = cooldown - 1
            end
    
            if cooldown == 0 then
                stopTimer = true
                drinkCooldown = false
            end
        else
            return
        end
	end)
end)

RegisterNetEvent('nic_waterfunctions:washCooldown')
AddEventHandler('nic_waterfunctions:washCooldown', function()
    washCooldown = true
    local cooldown
    local ped = PlayerPedId()
    local stopTimer = false

    for key, value in pairs(Config.settings) do
        cooldown = value.cooldown
    end

	Citizen.CreateThread(function()
        if not stopTimer then -- round timer start 
            while cooldown > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                cooldown = cooldown - 1
            end
    
            if cooldown == 0 then
                stopTimer = true
                washCooldown = false
            end
        else
            return
        end
	end)
end)

RegisterNetEvent('nic_waterfunctions:collectCooldown')
AddEventHandler('nic_waterfunctions:collectCooldown', function()
    collectCooldown = true
    local cooldown
    local ped = PlayerPedId()
    local stopTimer = false

    for key, value in pairs(Config.settings) do
        cooldown = value.cooldown
    end

	Citizen.CreateThread(function()
        if not stopTimer then -- round timer start 
            while cooldown > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                cooldown = cooldown - 1
            end
    
            if cooldown == 0 then
                stopTimer = true
                collectCooldown = false
            end
        else
            return
        end
	end)
end)

RegisterNetEvent('nic_waterfunctions:collectWater')
AddEventHandler('nic_waterfunctions:collectWater', function()
    local duration = 4000
    collecting = true
    TriggerEvent("nic_prompt:canteen_hide")
    Citizen.Wait(duration)
    TriggerEvent("nic_waterfunctions:cooldown", drinkCooldown)
    collecting = false
    TriggerEvent("nic_waterfunctions:collectCooldown")
    return
end)

StartDrink = function(dic, anim)
    local ped = PlayerPedId()
    local duration = 6000
    drinking = true
    LoadAnim(dic)
    TaskPlayAnim(ped, dic, anim, 1.0, 8.0, -1, 0, 0.0, false, false, false)
    Citizen.Wait(duration)
    TriggerEvent("nic_waterfunctions:drinkCooldown")
    ClearPedTasks(ped)
    Citizen.Wait(1)
    drinkPrompt = true
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    TriggerEvent("vorpmetabolism:changeValue", "Stamina", 100)
    TriggerEvent("vorpmetabolism:changeValue", "Thirst", 150)
    TriggerEvent("vorpmetabolism:changeValue", "OuterCoreStaminaGold", 5.0)
    drinkPrompt = false
    drinking = false
    return
end

StartWash = function(dic, anim)
    local ped = PlayerPedId()
    local duration = 6000
    washing = true
    LoadAnim(dic)
    TaskPlayAnim(ped, dic, anim, 1.0, 8.0, -1, 0, 0.0, false, false, false)
    Citizen.Wait(duration)
    TriggerEvent("nic_waterfunctions:washCooldown")
    washing = false
    ClearPedTasks(ped)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    Citizen.InvokeNative(0x523C79AEEFCC4A2A,ped,10, "ALL")
    Citizen.InvokeNative(0x6585D955A68452A5, ped)
    Citizen.InvokeNative(0x9C720776DAA43E7E, ped)
    Citizen.InvokeNative(0x8FE22675A5A45817, ped)
    ClearPedEnvDirt(ped)
    ClearPedBloodDamage(ped)
    ClearPedDamageDecalByZone(ped)
    TriggerEvent("nic_injury:off")
    return wash
end

LoadAnim = function(dic)
    RequestAnimDict(dic)

    while not (HasAnimDictLoaded(dic)) do
        Citizen.Wait(0)
    end
end

CreateThread(function()
	while true do
		Wait(0)
        local x, y, z = table.unpack(GetEntityCoords(ped))
        if drinkPrompt then
			DrawText3D(x, y, z+1.0, true, "~COLOR_BLUE~+150 Thirst")
        end
    end
end)

-- ////////////////////////////////////// FUNCTIONS

function GetPedCurrentHeldWeapon(entity)
    return Citizen.InvokeNative(0x8425C5F057012DAB, entity)
end

function IsAimCamActive()
    if Citizen.InvokeNative(0x698F456FB909E077) then
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

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

function Draw3DPrompts(x, y, z)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local wInvert, wInvert2 = 0, 255
    local dInvert, dInvert2 = 0, 255
    local cInvert, cInvert2 = 0, 255
    local wAlpha, dAlpha, cAlpha = 0, 0, 0

    SetTextScale(0.28, 0.28)
    SetTextFontForCurrentCommand(1)

    if not collectCooldown then
        cAlpha = 255
    else
        cAlpha = 50
    end

    if not collecting then
        SetTextColor(0, 0, 0, cAlpha)
    else
        SetTextColor(255, 255, 255, cAlpha)
    end
    
    local canteenCtrl = CreateVarString(10, "LITERAL_STRING", "Z", Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(canteenCtrl,_x+0.057,_y-0.096)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, cAlpha)
    local drinkText = CreateVarString(10, "LITERAL_STRING", "Collect", Citizen.ResultAsLong())
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(drinkText,_x+0.067,_y-0.096)

    SetTextScale(0.28, 0.28)
    SetTextFontForCurrentCommand(1)

    if not washCooldown then
        wAlpha = 255
    else
        wAlpha = 50
    end

    if not washing then
        SetTextColor(0, 0, 0, wAlpha)
    else
        SetTextColor(255, 255, 255, wAlpha)
    end

    local drinkCtrl = CreateVarString(10, "LITERAL_STRING", "G", Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(drinkCtrl,_x+0.057,_y-0.066)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, wAlpha)
    local drinkText = CreateVarString(10, "LITERAL_STRING", "Wash", Citizen.ResultAsLong())
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(drinkText,_x+0.067,_y-0.068)

    SetTextScale(0.28, 0.28)
    SetTextFontForCurrentCommand(1)

    if not drinkCooldown then
        dAlpha = 255
    else
        dAlpha = 50
    end

    if not drinking then
        SetTextColor(0, 0, 0, dAlpha)
    else
        SetTextColor(255, 255, 255, dAlpha)
    end

    local drinkCtrl = CreateVarString(10, "LITERAL_STRING", "E", Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(drinkCtrl,_x+0.057,_y-0.036)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, dAlpha)
    local drinkText = CreateVarString(10, "LITERAL_STRING", "Drink", Citizen.ResultAsLong())
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(drinkText,_x+0.067,_y-0.038)

    if not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else

        if not drinking then
            dInvert = 0
            dInvert2 = 215
        else
            dInvert = 215
            dInvert2 = 0
        end

        if not washing then
            wInvert = 0
            wInvert2 = 215
        else
            wInvert = 215
            wInvert2 = 0
        end

        if not collecting then
            cInvert = 0
            cInvert2 = 215
        else
            cInvert = 215
            cInvert2 = 0
        end

        DrawSprite("generic_textures", "counter_bg_1b", _x+0.057, _y-0.085, 0.017, 0.029, 0.1, cInvert, cInvert, cInvert, cAlpha, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.057, _y-0.085, 0.015, 0.027, 0.1, cInvert2, cInvert2, cInvert2, cAlpha, 0)

        DrawSprite("generic_textures", "counter_bg_1b", _x+0.057, _y-0.055, 0.017, 0.029, 0.1, wInvert, wInvert, wInvert, wAlpha, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.057, _y-0.055, 0.015, 0.027, 0.1, wInvert2, wInvert2, wInvert2, wAlpha, 0)

        DrawSprite("generic_textures", "counter_bg_1b", _x+0.057, _y-0.025, 0.017, 0.029, 0.1, dInvert, dInvert, dInvert, dAlpha, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.057, _y-0.025, 0.015, 0.027, 0.1, dInvert2, dInvert2, dInvert2, dAlpha, 0)

        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.057, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
    end
end