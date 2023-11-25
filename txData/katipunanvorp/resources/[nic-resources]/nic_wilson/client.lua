

local wilson
local is_particle_effect_active = false
local current_ptfx_handle_id = false
local teleported = false

local dict = "mech_inventory@chores@feed_chickens"
local anim = "base"

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DELETE"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,

    ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MDOWN"] = 0x8BDE7443
}


-- IF WILSON IS USED
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_wilson:useWilson')
AddEventHandler('nic_wilson:useWilson', function()
    if not DoesEntityExist(wilson) then
        TriggerEvent("vorp_inventory:CloseInv")
        spawnWilson()
        TriggerServerEvent('nic_wilson:removeItem')
    else
        TriggerEvent("vorp:TipBottom", "There's still an existing Wilson", 3000)
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        
        if IsControlJustPressed(0, Keys['Z']) then
            if DoesEntityExist(wilson) then
                removeWilson()
            end
        end

    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if IsEntityDead(ped) then
            removeWilson()
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        
        if DoesEntityExist(wilson) then
            toggleCombat()

            if IsEntityAttachedToEntity(wilson, ped) then

                if IsPedRagdoll(ped) then
                    StopAnimTask(ped, dict, anim, 8.0)
                    DetachEntity(wilson, true, true)
                    PlaceObjectOnGroundProperly(wilson)
                end

                if not IsEntityPlayingAnim(ped, dict, anim, 3) then
                    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 31, 0, true, 0, false, 0, false)
                end
            else
                StopAnimTask(ped, dict, anim, 8.0)
            end
        else
            StopAnimTask(ped, dict, anim, 8.0)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
        local rnd = math.random(-1, 2)
        local rnd2 = math.random(-1, 2)
        
        if DoesEntityExist(wilson) then
            local wx, wy, wz = table.unpack(GetEntityCoords(wilson, 0))
            local ground = GetEntityHeightAboveGround(ped)

            makeEntityFaceEntity(wilson, ped)

            if not IsEntityDead(ped) then
                
                if IsPlayerNearsEntity(wx, wy, wz, 1.5) then

                    if not IsEntityAttachedToEntity(wilson, ped) then
                        DrawKey3D(wx, wy, wz, "E", "Pickup")
                    else
                        DrawKey3D(wx, wy, wz, "E", "Drop")
                    end

                    if IsControlJustPressed(0, Keys['E']) then
                        if not IsEntityAttachedToEntity(wilson, ped) then
                            pickupWilson()
                        else
                            DetachEntity(wilson, true, true)
                            PlaceObjectOnGroundProperly(wilson)
                        end
                    end
                end

                if not IsPlayerNearsEntity(wx, wy, wz, 8.0) then
                    if not IsPedRunning(ped) and not IsPedSprinting(ped) and not IsPedFalling(ped) and not IsEntityInAir(ped) and not IsEntityInWater(ped) and not IsPedOnMount(ped) and not IsPedInAnyVehicle(ped, true) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) then                        
                        teleported = false

                        if not teleported then
                            smoke(0.5)
                            SetEntityAlpha(wilson, 0, true)
                            Wait(500)
                            ResetEntityAlpha(wilson)
                            SetEntityCoords(wilson, px+rnd, py+rnd2, pz-0.85)
                            smoke(0.5)
                            teleported = true
                        end
                        PlaceObjectOnGroundProperly(wilson)
                    end
                end
            end
        end
    end
end)

function toggleCombat()
    local ped = PlayerPedId()

    if IsEntityAttachedToEntity(wilson, ped) then
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 0)
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 1)
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 2)
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 3)
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 4)
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 5)
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 6)
    else
        Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 0)
        Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 1)
        Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 2)
        Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 3)
        Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 4)
        Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 5)
        Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 6)
    end
end

function removeWilson()
    smoke(0.5)
    Wait(100)
    DeleteEntity(wilson)
end

function IsPedFacingEntity(entity)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))

    if IsEntityInAngledArea(entity, playerx, playery, playerz, 0.0, 0.0, 0.0, -90.0, true, true, 1) then
        return true
    end
end

function pickupWilson()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_Forearm")

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end

    AttachEntityToEntity(wilson, ped, boneIndex, 0.255, 0.1, 0.05, 255.0, 128.0, 312.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 31, 0, true, 0, false, 0, false)
end

function spawnWilson()
    local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Spine2")
    local propModel = "prop_wilson"
    local ground = GetEntityHeightAboveGround(ped)
    local rnd = math.random(-1, 2)
    local rnd2 = math.random(-1, 2)
    local wSprite = 692310

    wilson = CreateObject(GetHashKey(propModel), px+rnd, py+rnd2, pz-0.85, true, true, true)
    smoke(0.5)
    local wBlip = BlipAddForEntity(wilson)
    SetBlipSprite(wBlip, wSprite, 1)
    Citizen.InvokeNative(0x9CB1A1623062F402, wBlip, 'Wilson')
    PlaceObjectOnGroundProperly(wilson)
end

function BlipAddForEntity(entity)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, wilson)
end

function PlaceEntityOnGroundProperly(entity, p1)
	return Citizen.InvokeNative(0x9587913B9E772D29, entity, p1)
end

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = (GetHeadingFromVector_2d(dx, dy))-180
    SetEntityHeading(player, heading)
end

function smoke(size)
    local new_ptfx_dictionary = "scr_fme_spawn_effects"
    local new_ptfx_name = "scr_net_fetch_smoke_puff"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_particle_effect_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))  -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
                Citizen.Wait(5)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then  -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary) -- UseParticleFxAsset

            
            current_ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, wilson, 0, 0, -0.2, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
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

function IsPlayerNearsEntity(x, y, z, dValue)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < dValue then
        return true
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