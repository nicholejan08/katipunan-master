local companionName = "Companion"
local spawning = false
local despawning = false
local timerStarted = false
local spawned = false
local timer = 0
local sprite = 1321928545

RegisterNetEvent('nic_companion:Initialize')
AddEventHandler('nic_companion:Initialize', function(source)
    spawned = true
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local player = PlayerPedId()
		
        if spawning or despawning then
            SetEntityInvincible(player)
            SetEntityInvincible(companion)
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local player = PlayerPedId()
        local maxMana = Citizen.InvokeNative(0xCB42AFE2B613EE55, player)

		if spawned and not DoesEntityExist(companion) and not IsPlayerNearPed(nx, ny, nz) then
            spawnCompanion()
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local player = PlayerPedId()
        local cx, cy, cz = table.unpack(GetEntityCoords(companion, 0))

        if IsPedInMeleeCombat(player) and not DoesEntityExist(companion) then
            TriggerServerEvent("nic_companion:checkJob")
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local player = PlayerPedId()
        local cx, cy, cz = table.unpack(GetEntityCoords(companion, 0))
		
        if IsEntityDead(player) and not IsPedInMeleeCombat(companion) then
            Citizen.Wait(3000)
            despawnCompanion()
        end
        if IsEntityDead(companion) and DoesEntityExist(companion) then
            Citizen.Wait(3000)
            despawnCompanion()
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local player = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(player, 0))
        local cx, cy, cz = table.unpack(GetEntityCoords(companion, 0))
		
        if IsPlayerCloseCompanion(cx, cy, cz) and DoesEntityExist(companion) then
            DrawCore3D(cx, cy, cz+1.0)
        elseif not IsPlayerCloseCompanion(cx, cy, cz) and DoesEntityExist(companion) then
            DrawDot3D(cx, cy, cz+1.0)
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local cx, cy, cz = table.unpack(GetEntityCoords(companion, 0))

        if DoesEntityExist(companion) and not IsEntityDead(companion) then
            if not IsPlayerNearCompanion(cx, cy, cz) and not IsPedInMeleeCombat(companion) then
                despawnCompanion()
            end
        end
    end
end)

RegisterNetEvent('nic_companion:timer')
AddEventHandler('nic_companion:timer', function()
    timerStarted = true

    for key, value in pairs(Config.settings) do
        timer = value.companionTimer
    end
    
	Citizen.CreateThread(function()
		while timer > 0 and DoesEntityExist(companion) do
			Citizen.Wait(1000)
			timer = timer - 1
		end
        if timer == 0 then
            timerStarted = false
            despawnCompanion()
        end
	end)
    Citizen.CreateThread(function()
        while timer > 0 do
            Citizen.Wait(0)
            local cx, cy, cz = table.unpack(GetEntityCoords(companion, 0))
            if timerStarted and timer > 0 and DoesEntityExist(companion) then
                DrawTimer3D(cx, cy, cz+1.0, " "..timer)
            end
        end
    end)
end)
    
function IsPlayerNearPed(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 7.0 then
        return true
    end
end

function IsPlayerNearCompanion(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 14.0 then
        return true
    end
end

function IsPlayerCloseCompanion(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 8.0 then
        return true
    end
end

function despawnCompanion()
    local player = PlayerPedId()

    despawning = true

    SetEntityInvincible(player, true)
    local cx, cy, cz = table.unpack(GetEntityCoords(companion, 0))
    spawning = false
    spawned = false
    DeleteEntity(companion)
    RemoveBlip(blip)
    SetEntityInvincible(player, false)
    despawning = false
    timer = 0
end

function spawnCompanion()
    spawning = true
    Citizen.Wait(1000)

    spawned = false

    local model = ""
    local player = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(player, 0))

    for key, value in pairs(Config.settings) do
        model = value.companionModel
    end

    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(100)
    end

    companion = CreatePed(model, px+2.5, py+2.5, pz-1.0, GetEntityHeading(player), false, true)
    SetEntityInvincible(companion, true)
    Citizen.Wait(100)

    local cx, cy, cz = table.unpack(GetEntityCoords(companion, 0))
    local blip = SET_BLIP_TYPE(companion) 
    for key, value in pairs(Config.settings) do 
        SetPedScale(companion, value.companionScale)
    end
    SetPlayerMeleeWeaponDamageModifier(companion, 72.65)
    SetEntityAlpha(companion, 120, false)
    SetBlipSprite(blip, sprite, 1)
    SetPedNameDebug(companion, companionName)
    SetPedAsGroupMember(companion, GetPedGroupIndex(player))
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, companionName)
    SetPedPromptName(companion, companionName)
    SetPedRandomComponentVariation(companion, 1)
    SetBlockingOfNonTemporaryEvents(companion, false)
    SetEntityInvincible(companion, false)
    SetPedCanBeTargettedByPlayer(companion, player, false)
    SetEntityInvincible(companion, false)
    spawning = false
    TriggerEvent('nic_companion:timer')
end

function SET_BLIP_TYPE (companion)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, companion)
end


function DrawDot3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not cloneDrinking then
        if not HasStreamedTextureDictLoaded("BLIPS") then
        else
            if GetEntityHealth(companion) <= 0 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 0, 0, 0, 0, 0)
            elseif GetEntityHealth(companion) <= 5 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 161, 0, 0, 255, 0)
            elseif GetEntityHealth(companion) <= 25 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 255, 0, 0, 255, 0)
            elseif GetEntityHealth(companion) <= 50 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 204, 147, 41, 255, 0)
            elseif GetEntityHealth(companion) <= 75 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 204, 204, 41, 255, 0)
            else
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 41, 204, 63, 255, 0)
            end
        end
    end
end

function DrawTimer3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.32, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x-0.002,_y-0.038)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("menu_textures", "menu_icon_rank", _x, _y-0.025, 0.017, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function DrawCore3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.10, 0.10)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("rpg_menu_item_effects") or not HasStreamedTextureDictLoaded("ammo_types") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("rpg_menu_item_effects", false)
        RequestStreamedTextureDict("ammo_types", false)
        RequestStreamedTextureDict("generic_textures", false)
    else
        for key, value in pairs(Config.settings) do
            if value.showHealth then
                if GetEntityHealth(companion) <= 5 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_01", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 20 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_02", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 25 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_03", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 30 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_04", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 35 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_05", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 40 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_06", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 45 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_07", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 50 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_08", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 55 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_1", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 60 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_2", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 65 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_3", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 60 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_4", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 75 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_5", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 70 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_6", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 85 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_7", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 80 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_8", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(companion) <= 95 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_9", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                else
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_10", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                end
            else
                DrawSprite("generic_textures", "default_pedshot", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
                DrawSprite("ammo_types", "bullet_varmint", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
            end
        end
    end
end