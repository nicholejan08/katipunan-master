

local plant, grownPlant, shield
local nearPlant = false

local particle_effect = false
local particle_id = false
local growing = false
local growFruit = false

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DELETE"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,
}

RegisterCommand('plant', function()
	local _source = source

    if not DoesEntityExist(plant) then
        createPlant()
        TriggerEvent("nic_planting:plantTimer")
    else
        DeleteEntity(plant)
        DeleteEntity(grownPlant)
    end
end)

RegisterNetEvent('nic_planting:plantTimer')
AddEventHandler('nic_planting:plantTimer', function()
    local plantTimer = 2

	Citizen.CreateThread(function()
        if plantTimer > 1 then -- round timer start 
            while plantTimer > 0 and not IsEntityDead(PlayerPedId()) do
                Citizen.Wait(1000)
                plantTimer = plantTimer - 1
            end
    
            if plantTimer == 0 then
                growPlant()
                if not particle_effect then
                    growing = true
                    playParticleEffect(grownPlant, "anm_gang2", "ent_anim_gng2_balloon_leaves", "skel_spine0", 0.5, 0, 0, 0, 0, 0, 0)
                else
                    stopEffect()
                end
            end
        else
            return
        end
	end)
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)

        if growing then
            Wait(2000)
            growing = false
        end
    end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)

        if growFruit then
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(ped, 0))

        if DoesEntityExist(grownPlant) then
            local gPlantx, gPlanty, gPlantz = table.unpack(GetEntityCoords(grownPlant, 0))

            if IsPlayerNearEntity(gPlantx, gPlanty, gPlantz, 5.0) then
                DrawGraphic3D(gPlantx, gPlanty, gPlantz+0.5) 
            end

            if IsPlayerNearEntity(gPlantx, gPlanty, gPlantz, 1.5) then
                DrawKey3D(gPlantx, gPlanty, gPlantz+0.5, "E", "Harvest Plant")

                if IsControlJustReleased(0, Keys['E']) then
                    TaskTurnPedToFaceEntity(ped, grownPlant, 1000, 1, 0, 0)
                    Wait(1000)
                    DeleteEntity(plant)
                    DeleteEntity(grownPlant)
                    playPickAnimation()
                end
            end
        end

        if DoesEntityExist(plant) then
            local plantx, planty, plantz = table.unpack(GetEntityCoords(plant, 0))
            
            if IsPlayerNearEntity(plantx, planty, plantz, 5.0) then
                DrawGraphic3D(plantx, planty, plantz+0.5)
            end
        end

    end
end)

function createPlant()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local propModel = "prop_weed_04"

    plant = CreateObject(GetHashKey(propModel), x, y, z-1.0,  true,  true, true)
    PlaceObjectOnGroundProperly(plant)
end

function growPlant()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(plant))
    local propModel = "p_pumpkin"

    if DoesEntityExist(plant) then
        DeleteEntity(plant)
    end

    grownPlant = CreateObject(GetHashKey(propModel), x, y, z+0.5,  true,  true, true)
    growFruit = true
    -- PlaceObjectOnGroundProperly(grownPlant)
end

function playPickAnimation()
    local ped = PlayerPedId()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "stn_long_low_skill_exit", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(2000)
    ClearPedTasks(ped)
end

function IsPlayerNearEntity(x, y, z, radius)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < radius then
        return true
    end
end

function DrawGraphic3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    cVariance = "provision_wldflwr_chocolate_daisy"

    if not HasStreamedTextureDictLoaded("pm_collectors_bag_mp") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("pm_collectors_bag_mp", false)
        RequestStreamedTextureDict("generic_textures", false)
    else
        -- DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x, _y, 0.024, 0.04, 0.1, 215, 215, 215, 100, 0)
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.021, 0.035, 0.1, 215, 215, 215, 255, 0)

        if DoesEntityExist(plant) then
            DrawSprite("pm_collectors_bag_mp", cVariance, _x, _y, 0.015, 0.03, 0.1, 217, 232, 86, 80, 0)
        elseif DoesEntityExist(grownPlant) then
            DrawSprite("pm_collectors_bag_mp", cVariance, _x, _y, 0.015, 0.03, 0.1, 217, 232, 86, 215, 0)
        end
    end
end

function DrawKey3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.28, 0.28)
    SetTextFontForCurrentCommand(1)
    SetTextColor(0, 0, 0, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x+0.017,_y-0.036)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.027,_y-0.038)

    if not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.017, _y-0.025, 0.017, 0.029, 0.1, 0, 0, 0, 255, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.017, _y-0.025, 0.015, 0.027, 0.1, 215, 215, 215, 255, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        -- DrawSprite("overhead", "overhead_normal", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 255, 255, 255, 185, 0)
    end
end

function playParticleEffect(entity, dict, lib, bone, scale, x, y, z, rotx, roty, rotz)

    if not particle_effect then
       local particle_dict = dict
       local particle_name = lib
       local current_particle_dict = particle_dict
       local current_particle_name = particle_name
       local particle_bone = bone
 
       current_particle_dict = particle_dict
       current_particle_name = particle_name
 
       if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
          Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
          local counter = 0
          while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
             Citizen.Wait(0)
          end
       end
       if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
          Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)
 
          local boneIndex = GetEntityBoneIndexByName(entity, particle_bone)
          particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, ped, x, y, z, rotx, roty, rotz, boneIndex, scale, 0, 0, 0)
 
          particle_effect = true
       else
          print("cant load ptfx dictionary!")
       end
    end
 end
 
function stopEffect()
	if particle_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, particle_id) then   -- DoesParticleFxLoopedExist
			Citizen.InvokeNative(0x459598F579C98929, particle_id, false)   -- RemoveParticleFx
		end
	end
	particle_id = false
	particle_effect = false
    growing = false
end
