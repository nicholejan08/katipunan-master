

local shield, helmet, star, shieldBlip, impaledBlip, targetCam

local particle_effect = false
local particle_id = false
local thrown = false

local shieldModel = "nic_capshield_w"
local helmetModel = "nic_cap_helmet_alt"
local starModel = "nic_cap_star"

local enablePowers = false
local equippedToBack = false
local equippedShield = false
local shieldCovered = false

local bloodDrip = false

local ptfx_handle_id = false
local is_particle_effect_active = false	
local is_particle_effect_alt_active = false	

local current_ptfx_handle_id = false

local impaled = false
local impaledTarget

local shieldAngle = 0
local shieldHeight = 0

local groundHit = false
local hitWater = false

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DEL"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41, ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,
}

RegisterNetEvent('nic_capshield:initialize')
AddEventHandler('nic_capshield:initialize', function()
    local ped = PlayerPedId()

    if not enablePowers then
        enablePowers = true
        AnimpostfxPlay("CamTransitionBlink")
        TriggerEvent('vorp:ShowTopNotification', "Super Soldier", "~t6~Activated", 4000)
        PlaySoundFrontend("Gain_Point", "HUD_MP_PITP", true, 1)
        
        if not DoesEntityExist(shield) then
            createShield()
        end

        if not DoesEntityExist(helmet) then
            createHelmet()
        end

        if not DoesEntityExist(star) then
            createStar()
        end

        SetPlayerMeleeWeaponDamageModifier(PlayerId(), 72.0)

        SetPedConfigFlag(ped, 294, false) -- DisableShockingEvents
        SetBlockingOfNonTemporaryEvents(ped, false)
        if not equippedToBack then
            equipToBack()
        end
    else
        enablePowers = false
        equippedToBack = false
        equippedShield = false
        thrown = false
        shieldCovered = false
        DeleteEntity(shield)
        DeleteEntity(star)
        DeleteEntity(helmet)
        AnimpostfxPlay("MP_HealthDrop")
        TriggerEvent('vorp:ShowTopNotification', "Super Soldier", "~e~Deactivated", 4000)
        PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    end
end)

RegisterCommand('capshield', function()
    TriggerServerEvent('nic_capshield:checkJob')
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enablePowers then

            ResetPedWeaponMovementClipset(ped)

            if not IsEntityDead(ped) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) and not IsPedOnMount(ped) and not IsPedSwimming(ped) and not IsPedClimbing(ped) then

                if IsControlPressed(0, Keys['D']) and IsControlPressed(0, Keys['MOUSE3']) then
                    dive("right")
                elseif IsControlPressed(0, Keys['A']) and IsControlPressed(0, Keys['MOUSE3']) then
                    dive("left")
                elseif IsControlPressed(0, Keys['W']) and IsControlPressed(0, Keys['MOUSE3']) then
                    dive("fwd")
                elseif IsControlPressed(0, Keys['S']) and IsControlPressed(0, Keys['MOUSE3']) then
                    dive("bkwr")
                end

                if IsEntityAttachedToEntity(shield, ped) and equippedShield then
                    if IsControlJustPressed(0, Keys['MOUSE2']) then
                        
                        Citizen.InvokeNative(0xD66A941F401E7302, 0)
                        Citizen.InvokeNative(0xE0447DEF81CCDFD2, PlayerId(), true)
                        -- shieldAim()
                        shieldCover()
                    elseif IsControlJustReleased(0, Keys['MOUSE2']) then
                        Citizen.InvokeNative(0xE0447DEF81CCDFD2, PlayerId(), false)                        

                        -- StopAnimTask(ped, "mech_weapons_thrown@ready_high@crouch@base@aim@sweep@intro@turn@range_r90_to_l90", "settle_0", 3.0)
                                     
                        StopAnimTask(ped, "mech_inventory@binoculars", "look", 3.0)

                        equipShield()
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
        local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Head")

        if enablePowers then
            if DoesEntityExist(shield) then
                if IsEntityAttachedToEntity(shield, ped) then
                    hitWater = false
                    SetEntityCollision(shield, false, true)
                else
                    SetEntityCollision(shield, true, true)
                end
            end
            if DoesEntityExist(helmet) then
                local pedAlt = PlayerPedId()
                local boneIndex2 = GetEntityBoneIndexByName(pedAlt, "SKEL_Head")
                
                if IsEntityAttachedToEntity(helmet, ped) then
                    SetEntityCollision(helmet, false, true)
                else
                    AttachEntityToEntity(helmet, pedAlt, boneIndex2, 0.05, 0.0, 0.0, 0.0, 88.0, 180.0, 0.0, true, true, false, true, 1, true)
                    SetEntityCollision(helmet, true, true)
                end
            end
            if DoesEntityExist(star) then
                if IsEntityAttachedToEntity(star, ped) then
                    SetEntityCollision(star, false, true)
                else
                    SetEntityCollision(star, true, true)
                end
            end

        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enablePowers then

            if not IsEntityDead(ped) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) and not IsPedClimbing(ped) and not IsPedOnMount(ped) and not IsPedInAnyVehicle(ped) then

                if not thrown and not IsEntityAttachedToEntity(shield, ped) then
                    local sCoords = GetEntityCoords(shield)

                    if IsEntityNearEntity(ped, shield, 8.0) and not IsEntityNearEntity(ped, shield, 2.0) then
                        DrawArrow3D(sCoords.x, sCoords.y, sCoords.z+0.5, "overhead", "overhead_generic_arrow")
                    else
                        if IsEntityNearEntity(ped, shield, 2.0) then
                            DrawPrompt3D(sCoords.x, sCoords.y, sCoords.z+0.2, "E", "Pickup")
    
                            if IsControlJustPressed(0, Keys['E']) then
                                pickupShield()
                            end
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

        if enablePowers then
            if equippedShield and IsPedRagdoll(ped) then
                DetachEntity(shield, true, true)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enablePowers then

            if not IsEntityDead(ped) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) then

                local currentWeapon = GetPedCurrentHeldWeapon(ped)

                if currentWeapon ~= -1569615261 then
                    if not equippedToBack then
                        if IsEntityAttachedToEntity(shield, ped) then
                            switchShield()
                            equipToBack()
                            StopAnimTask(ped, "mech_inventory@equip@fallback@base@bow", "unholster", 4.0)
                        end
                    end
                end

                if equippedShield and (IsPedClimbing(ped) or IsPedCarryingSomething(ped) or IsPedBeingHogtied(ped) or IsPedHogtied(ped) or IsPedInAnyVehicle(ped) or IsPedHangingOnToVehicle(ped) or IsPedCarryingSomething(ped) or IsPedInMeleeCombat(ped)) then
                    if IsEntityAttachedToEntity(shield, ped) then
                        switchShield()
                        equipToBack()
                    end
                end

                if not IsEntityAttachedToEntity(shield, ped) then

                    equippedToBack = false
                    equippedShield = false
    
                    if not IsCamRendering(targetCam) then

                        if IsControlJustPressed(0, Keys['MOUSE2']) then
                            if not IsEntityNearEntity(ped, shield, 2.0) then
                                if currentWeapon == -1569615261 then
                                    reachShield()
                                end
                            else
                                if not IsPedClimbing(ped) and not IsPedCarryingSomething(ped) and not IsPedBeingHogtied(ped) and not IsPedHogtied(ped) and not IsPedInAnyVehicle(ped) and not IsPedHangingOnToVehicle(ped) and not IsPedCarryingSomething(ped) and not IsPedInMeleeCombat(ped) and not IsPedOnMount(ped) then
                                    pickupShield()
                                end
                            end
                        end
                    end
                else
                    if equippedShield then
                        if IsControlJustPressed(0, Keys['MOUSE1']) then
                            throwShield()
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

        if enablePowers then

            if DoesEntityExist(shield) then
                DisableCamCollisionForObject(shield)
            end

            SetSuperJumpThisFrame(PlayerId())
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enablePowers then
            if DoesEntityExist(shield) then
                local ground = GetEntityHeightAboveGround(shield)
                if ground > 0.4 then
                    SetObjectPhysicsParams(shield, 112.0, 1.8, -1, 1, 0, 0, 0.01, 0.0, 0.0, 0, 4.0)
                end
            end
        end
    end
end)

local rotCount = 0

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enablePowers then
            if thrown then
                    local sRot = GetEntityRotation(shield)
                    local ground = GetEntityHeightAboveGround(shield)
    
                if ground > 0.1 then
                    if not HasEntityCollidedWithAnything(shield) then
                        SetEntityRotation(shield, 90.0, 180.0, sRot.z+0.1, 1, true)
                        Wait(5)
                    end
                else
                    thrown = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enablePowers then
            if DoesEntityExist(shield) then
                if HasEntityCollidedWithAnything(shield) then
                    local ground = GetEntityHeightAboveGround(shield)
                    local ex, ey, ez = table.unpack(GetEntityCoords(ped, 0))
                    local ex2, ey2, ez2 = table.unpack(GetEntityCoords(shield, 0))
                    local distance = GetDistanceBetweenCoords(ex, ey, ez, ex2, ey2, ez2, true) / 100
                    local maxVolume = 0.5
                    local volumeControl =  maxVolume - distance

                    if not groundHit then
                        if not IsEntityInWater(shield) then
                            if ground > 0.4 then
                                groundHit = false
                                local wRnd = math.random(0, 4)
        
                                if volumeControl < maxVolume and volumeControl > 0 then
                                    if wRnd == 0 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'wood_impact_a', volumeControl)
                                    elseif wRnd == 1 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'wood_impact_b', volumeControl)
                                    elseif wRnd == 2 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'wood_impact_c', volumeControl)
                                    elseif wRnd == 3 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'wood_impact_d', volumeControl)
                                    elseif wRnd == 4 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'wood_impact_e', volumeControl)
                                    end
                                    Wait(100)
                                end
                            else
                                if volumeControl < maxVolume and volumeControl > 0 then
                                    TriggerEvent('PlaySound:PlayOnOne', 'wood_impact_f', volumeControl)
                                    Wait(300)
                                    groundHit = true
                                end
                            end
                        else
                            if not hitWater then
                                local wRnd = math.random(0, 3)
        
                                if volumeControl < maxVolume and volumeControl > 0 then
                                    if wRnd == 0 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'water_splash_a', volumeControl)
                                    elseif wRnd == 1 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'water_splash_b', volumeControl)
                                    elseif wRnd == 2 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'water_splash_c', volumeControl)
                                    elseif wRnd == 3 then
                                        TriggerEvent('PlaySound:PlayOnOne', 'water_splash_d', volumeControl)
                                    end
                                    Wait(100)
                                end
                                hitWater = true
                            end
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

        if enablePowers then
            if not IsEntityAttachedToEntity(shield, ped) then
                if IsEntityInAir(shield) then

                    local target = GetClosestPed(shield, 7.0)
                    local pos = GetEntityForwardVector(shield)
                    local multiplier = 7.0
                    local ground = GetEntityHeightAboveGround(shield)

                    if ground > 0.4 then
                        if IsEntityNearEntity(shield, target, 1.5) then
    
                            if thrown then
                                local tHp = GetEntityHealth(target)
                                local tCoords = GetEntityCoords(target)
                                
                                if not HasEntityCollidedWithAnything(shield) then
                                    Citizen.InvokeNative(0xAE99FB955581844A, target, 3000, 0, 0, 0, 0, 0)
                                    ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)

                                    for key, value in pairs(Config.settings) do
                                        if value.enableGore then
                                            bloodBang("core", "blood_animal_maul_decal", target, 2.0)
                                            if not IsPedRagdoll(target) and not IsEntityDead(target) then
                                                bloodBang("core", "ent_sht_blood", target, 2.0)
                                            end

                                            if not IsEntityDead(target) then
                                                TriggerEvent('PlaySound:PlayOnOne', 'body_impact_a', 0.5)
                                            else
                                                TriggerEvent('PlaySound:PlayOnOne', 'body_impact_b', 0.5)
                                            end

                                            applyBloodDecals(target)
        
                                            if IsPedHuman(target) then
                                                if IsEntityNearEntity(shield, target, 0.8) then
                                                    impale(target)
                                                end
                                            end

                                            applyBloodDecals(shield)
                                        end
                                    end

                                else
                                    TriggerEvent('PlaySound:PlayOnOne', 'wood_impact_a', 0.5)
                                end

                                SetEntityHealth(target, tHp-1, 1, -1, 0)
                            end
                        end
                    else
                        rotCount = 0
                        thrown = false
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

        if enablePowers then
            if DoesEntityExist(shield) then
                if IsEntityAttachedToEntity(shield, impaledTarget) then
                    local tHp = GetEntityHealth(impaledTarget)
                    local boneIndex = GetEntityBoneIndexByName(impaledTarget, "SKEL_Spine3")

                    ApplyDamageToPed(impaledTarget, 0.1, 1, boneIndex, ped)

                    if not IsEntityNearEntity(impaledTarget, ped, 32.0) then
                        reachShield()
                    end
                else
                    RemoveBlip(impaledBlip)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if enablePowers then
            if IsControlJustPressed(0, Keys['TAB']) then

                if not (IsPedClimbing(ped) or IsPedCarryingSomething(ped) or IsPedBeingHogtied(ped) or IsPedHogtied(ped) or IsPedInAnyVehicle(ped) or IsPedHangingOnToVehicle(ped) or IsPedInMeleeCombat(ped)) then
                    if DoesEntityExist(shield) then
    
                        if equippedToBack then
                            StopAnimTask(ped, "mech_inventory@binoculars", "look", 8.0)
                            switchShield()
                            equipShield()
                        elseif equippedShield then
                            if IsEntityAttachedToEntity(shield, ped) then
                                switchShield()
                                equipToBack()
                            end
                        end
                        
                    end
                end
            end
        end
    end
end)

-- ////////////////////////////////////// FUNCTIONS

function GetPedCurrentHeldWeapon(entity)
    return Citizen.InvokeNative(0x8425C5F057012DAB, entity)
end

function IsPedHogtied(entity)
    return Citizen.InvokeNative(0x3AA24CCC0D451379, entity)
end

function IsPedBeingHogtied(entity)
    return Citizen.InvokeNative(0xD453BB601D4A606E, entity)
end

function IsPedCarryingSomething(entity)
    return Citizen.InvokeNative(0xA911EE21EDF69DAF, entity)
end

function dive(direction)
    local ped = PlayerPedId()
    local animDict = "mech_weapons_core@base@dive@rifle@launch"
    local animName = ""
    
    if direction == "right" then
        animName = "dive_launch_right"
    elseif direction == "left" then
        animName = "dive_launch_left"
    elseif direction == "fwd" then
        animName = "dive_launch_fwd"
    elseif direction == "bkwr" then
        animName = "dive_launch_bkwr"
    end

    LoadAnim(animDict)
    TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 1, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
    SetPlayerInvincible(PlayerId(), true)
    StopAnimTask(ped, animDict, animName, 4.0)
    Citizen.Wait(1000)
    SetPlayerInvincible(PlayerId(), false)
end

function pickupShield()
    local ped = PlayerPedId()
    local animDict = "mech_pickup@system@rh"
    local animName = ""

    makeEntityFaceEntity(ped, shield)

    if IsEntityNearEntity(ped, shield, 2.0) and not IsEntityNearEntity(ped, shield, 1.5) then
        animName = "ground_far_swipe"
    else
        animName = "ground_near"
    end

    LoadAnim(animDict)
    TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 1, 0, true, 0, false, 0, false)
    Citizen.Wait(500)
    equipShield()
    Citizen.Wait(500)
    StopAnimTask(ped, animDict, animName, 4.0)
    
    if IsEntityAttachedToEntity(shield, impaledTarget) then
        local pos = GetEntityForwardVector(impaledTarget)
        local multiplier = 7.0
        Citizen.InvokeNative(0xAE99FB955581844A, impaledTarget, 3000, 0, 0, 0, 0, 0)
        ApplyForceToEntity(impaledTarget, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
        bloodBang("core", "blood_animal_maul_decal", impaledTarget, 2.0)
    end
end

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function DrawPrompt3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.038,_y-0.038)

    if not HasStreamedTextureDictLoaded("multiwheel_emotes") or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("multiwheel_emotes", false)
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("multiwheel_emotes", "emote_greet_gentlewave", _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function DrawArrow3D(x, y, z, dic, sprite)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.045,_y-0.038)

    if not HasStreamedTextureDictLoaded(dic) or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict(dic, false)
        RequestStreamedTextureDict("generic_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite(dic, sprite, _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
    end
end

function bloodBang(pDict, pName, entity, size)
    local new_ptfx_dictionary = pDict
    local new_ptfx_name = pName
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

            
            ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name, entity, 0, 0, 0, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, ptfx_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, ptfx_handle_id, false)   -- RemoveParticleFx
            end
        end
        ptfx_handle_id = false
        is_particle_effect_active = false	
    end
end

function startNonLoopedParticle(entity, dict, lib, x, y, z, size)
    local new_ptfx_dictionary = dict
    local new_ptfx_name = lib
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_particle_effect_alt_active then
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

            
            current_ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, entity, x, y, z, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
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
        is_particle_effect_alt_active = false	
    end  
end

function applyBloodDecals(entity)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Blood_Spray_Front_att", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Blood_Spray_FRONT_V1", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Dead_John_bloody_back_vic", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Dead_John_bloody_chest_vic", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Mob4_Bitten_Leg_Blood_Soak_R", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_AnimalBlood_Lrg_Bloody", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Blood_Spray_Right_V2", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Blood_face_left", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Blood_face_right", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Blood_Soak_Right_Arm_Murder_for_Hire_Bump", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Blood_Soak_Left_Arm_Murder_for_Hire_Bump", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Victim_Dead_Arrow_Wounds1", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_Victim_Dead_Knife_Wounds1", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, entity, "PD_LimbLoss_L_Foot", 0.0, 0.0) 
end

function shieldCover()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
    local inBedDicts = "mech_inventory@binoculars"
    local inBedAnims = "look"

    LoadAnim(inBedDicts)

    TaskPlayAnim(ped, inBedDicts, inBedAnims, 8.0, 8.0, -1, 31, 0, false, false, false)
    AttachEntityToEntity(shield, ped, boneIndex, 0.07, 0.02, -0.17, 40.0, 50.0, 60.0, 1, 1, 0, 1, 0, 1)
end

function IsEntityNearEntity(entity1, entity2, dist)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity1, 0))
    local ex2, ey2, ez2 = table.unpack(GetEntityCoords(entity2, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, ex2, ey2, ez2, true)

    if distance < dist then
        return true
    end
end

function IsValidTarget(ped)
    local playerPed = PlayerPedId()
	return playerPed ~= ped
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

function DisableCamCollisionForObject(entity)
    return Citizen.InvokeNative(0x7E3F546ACFE6C8D9, entity)
end

function AddBlipForEntity(entity)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, entity)
end

function createShield()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    shield = CreateObject(GetHashKey(shieldModel), coords.x, coords.y, coords.z-1.0,  true,  true, true)
    addShieldBlip()
    DisableCamCollisionForObject(shield)
end

function addShieldBlip()
    local blipSprite = 1321928545
    shieldBlip = AddBlipForEntity(shield)
    SetBlipSprite(shieldBlip, blipSprite)
    SetBlipName(shieldBlip, "Shield")
end

function addImpaledBlip(entity)
    local blipSprite = 1109348405
    impaledBlip = AddBlipForEntity(entity)
    SetBlipSprite(impaledBlip, blipSprite)
    SetBlipName(impaledBlip, "Stranger")
end

function SetBlipName(blip, blipName)
    return Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipName)
end

function createStar()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Spine3")
    local coords = GetEntityCoords(ped)

    star = CreateObject(GetHashKey(starModel), coords.x, coords.y, coords.z-1.0,  true,  true, true)
    AttachEntityToEntity(star, ped, boneIndex, 0.08, 0.22, 0.0, 186.0, 53.0, 7.0, 0.0, true, true, false, true, 1, true)
    DisableCamCollisionForObject(star)
end

function createHelmet()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    helmet = CreateObject(GetHashKey(helmetModel), coords.x, coords.y, coords.z-1.0,  true,  true, true)
    DisableCamCollisionForObject(helmet)
end

function throwShield()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
    local random = math.random(0, 2)
    local animDict = ""
    local animName = ""
    local multiplier = 72.0
    local randomizer = math.random(0, 0)
    local flag = 0
    
    if IsPedRunning(ped) or IsPedSprinting(ped) or IsPedWalking(ped) or IsPedOnMount(ped) then
        flag = 31
    else
        flag = 16
    end

    if randomizer == 0 then
        animDict = "mech_melee@unarmed@bruiser@_ambient@_healthy@_variations"
        animName = "att_combo_v2_pt2_leftside_dist_near_att"
    end

    LoadAnim(animDict)

    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, -1, flag, 0, true, 0, false, 0, false)

    Citizen.Wait(100)
    TriggerEvent('PlaySound:PlayOnOne', 'shield_throw', 0.2)

    if IsPedOnMount(ped) then
        AttachEntityToEntity(shield, ped, 0, 0.5, 1.5, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    end

    local pedCoords = GetEntityCoords(ped)
    local sCoords = GetEntityCoords(shield)
    local pos = GetEntityForwardVector(ped)
    
    ShakeGameplayCam("REINFORCED_LASSO_STRUGGLE_SHAKE", 1.0)
    DetachEntity(shield, true, true)

    shieldAngle = GetEntityRotation(shield)
    throwHeight = pedCoords.z+0.5
    shieldHeight = sCoords.z

    ApplyForceToEntity(shield, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier+8.0, 0,0,0, 1, false, true, true, true, true)
    thrown = true
    Citizen.Wait(480)
    StopAnimTask(ped, animDict, "att_combo_v2_pt2_leftside_dist_near_att", 3.0)
    ShakeGameplayCam("REINFORCED_LASSO_STRUGGLE_SHAKE", 0.0)
end

function TaskTurnPedToFaceEntity(entity, target, duration)
    return Citizen.InvokeNative(0x5AD23D40115353AC, entity, target, duration, 1, 1, 1)
end

function reachShield()
    local ped = PlayerPedId()
    local animDict = "mech_weapons_special@lantern"
    local catchDict = "mech_weapons_thrown@ready_high@crouch@base@aim@sweep@intro@turn@range_r90_to_l90"
    local animName = "fire_med"
    local flag = 0
    
    if IsPedRunning(ped) or IsPedSprinting(ped) or IsPedWalking(ped) or IsPedOnMount(ped) then
        flag = 31
    else
        -- TaskTurnPedToFaceEntity(ped, shield, 1000)
        flag = 16
    end

    LoadAnim(animDict)
    LoadAnim(catchDict)

    TaskPlayAnim(ped, animDict, animName, 4.0, 8.0, -1, 31, 0, true, 0, false, 0, false)

    if IsEntityNearEntity(ped, shield, 17.0) then
        TriggerEvent('PlaySound:PlayOnOne', 'shield_return_near', 0.2)
        Citizen.Wait(300)
    else
        TriggerEvent('PlaySound:PlayOnOne', 'shield_return_far', 0.2)
        Citizen.Wait(700)
    end

    StopAnimTask(ped, animDict, animName, 8.0)
    
    if IsEntityAttachedToEntity(shield, impaledTarget) then
        TriggerEvent('PlaySound:PlayOnOne', 'squelch_equip', 0.4)
        local pos = GetEntityForwardVector(impaledTarget)
        local multiplier = 7.0
        Citizen.InvokeNative(0xAE99FB955581844A, impaledTarget, 3000, 0, 0, 0, 0, 0)
        ApplyForceToEntity(impaledTarget, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0,0,0, 1, false, true, true, true, true)
        bloodDrip = true
    end
    
    ShakeGameplayCam("REINFORCED_LASSO_STRUGGLE_SHAKE", 1.0)    

    if not IsEntityNearEntity(ped, shield, 17.0) then
        local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
        AttachEntityToEntity(shield, ped, boneIndex, 0.46, -0.155, 0.19, 311.0, 0.0, 0.0, true, true, false, true, 1, true)
    end

    if bloodDrip then
        bloodBang("core", "blood_animal_maul_decal", impaledTarget, 2.0)
        equipShield()
        TaskPlayAnim(ped, catchDict, "settle_r90", 8.0, 3.0, -1, flag, 0, true, 0, false, 0, false)
        Wait(300)
        ShakeGameplayCam("REINFORCED_LASSO_STRUGGLE_SHAKE", 0.0)
        Wait(300)

        local dripRnd = math.random(0, 1)

        if dripRnd == 0 then
            TriggerEvent('PlaySound:PlayOnOne', 'blood_drip_a', 0.2)
        else
            TriggerEvent('PlaySound:PlayOnOne', 'blood_drip_b', 0.2)
        end

        bloodDrip = false
        StopAnimTask(ped, catchDict, "settle_r90", 3.0)
    else
        TriggerEvent('PlaySound:PlayOnOne', 'shield_equip', 0.2)
        equipShield()
        TaskPlayAnim(ped, catchDict, "settle_r90", 8.0, 3.0, -1, flag, 0, true, 0, false, 0, false)
        Wait(300)
        ShakeGameplayCam("REINFORCED_LASSO_STRUGGLE_SHAKE", 0.0)
        StopAnimTask(ped, catchDict, "settle_r90", 3.0)
    end
    groundHit = false
    
end

function shieldAim()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
    local inBedDicts = "mech_weapons_thrown@ready_high@crouch@base@aim@sweep@intro@turn@range_r90_to_l90"
    local inBedAnims = "settle_0"

    LoadAnim(inBedDicts)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 8.0, 3.0, -1, 31, 0, false, false, false)
end

function switchShield()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_Clavicle")
    local inBedDicts = "mech_inventory@equip@fallback@base@unarmed@back@longarms"
    local inBedAnims = "unholster"

    LoadAnim(inBedDicts)

    TriggerEvent('PlaySound:PlayOnOne', 'shield_holster', 0.2)
    TaskPlayAnim(ped, inBedDicts, inBedAnims, 4.0, 4.0, -1, 31, 0, false, false, false)
    Wait(400)
    AttachEntityToEntity(shield, ped, boneIndex, -0.1156, -0.18, -0.135, 304.0, 210.0, 11.0, true, true, false, true, 1, true)
    Wait(50)
    AttachEntityToEntity(shield, ped, boneIndex, -0.32, -0.18, -0.135, 304.0, 210.0, 11.0, true, true, false, true, 1, true)
    StopAnimTask(ped, inBedDicts, inBedAnims, 4.0)
end

function impale(entity)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(entity, "SKEL_Spine1")
    local sRot = GetEntityRotation(shield)

    impaledTarget = entity
    
    AttachEntityToEntity(shield, entity, boneIndex, 0.13, -0.02, -0.04, 273.0, 149.0, 169.0, true, true, false, true, 1, true)
    bloodBang("core", "ent_sht_blood", shield, 2.0)
    addImpaledBlip(entity)

    -- CreateKillCam(entity)

    if not IsEntityDead(entity) then
        for key, value in pairs(Config.settings) do
            if value.enableKillcam then
                killCam(entity)
            end
        end
    end
end

function CreateKillCam(entity)
    return Citizen.InvokeNative(0x2F994CC29CAA9D22, entity)
end

function killCam(entity)
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Head")
    local eCoords = GetEntityCoords(entity)
    local postFx = "spectatorcam01"
    targetCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", eCoords.x+1.0, eCoords.y+1.0, eCoords.z+0.5, 0.0, 0.0, 0.0, 50.0, false, 0)
    PointCamAtEntity(targetCam, entity, 1, 1, 0, true)
    SetCamActive(targetCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AnimpostfxPlay(postFx)
    SetTimeScale(0.1)
    Citizen.InvokeNative(0x69D65E89FFD72313, true, true)
    TriggerEvent('nic_hud:hudOff', true)
    Wait(2000)
    
    local distance = GetDistanceBetweenCoords(pCoords, eCoords, true) * 10
    local maxFov = 20.0
    local fovControl =  maxFov - distance

    SetCamFov(targetCam, fovControl)
    -- SetCamCoord(targetCam, pCoords)
    PointCamAtEntity(targetCam, helmet, 1, 1, -0.5, true)
    -- SetCamCoord(targetCam, pCoords.x-4.0, pCoords.y-4.0, pCoords.z)
    Wait(1000)
    TriggerEvent('nic_hud:hudOn', false)
    Citizen.InvokeNative(0x69D65E89FFD72313, false, false)
    AnimpostfxStop(postFx)
    SetTimeScale(1.0)
    RenderScriptCams(false, false, 0, true, false)
    ClearFocus()
    SetCamActive(targetCam, false)
    DestroyCam(targetCam, false)
    targetCam = nil
end

function equipToBack()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Spine2")

    if shieldModel == "nic_capshield_w" then
        AttachEntityToEntity(shield, ped, boneIndex, 0.15, -0.08, -0.035, 339.0, 89.0, 5.0, true, true, false, true, 1, true)
    else
        AttachEntityToEntity(shield, ped, boneIndex, 0.14, -0.10, 0.0, 112.0, -90.0, 0.0, true, true, false, true, 1, true)
    end
    equippedToBack = true
    equippedShield = false
    groundHit = false
end

function equipShield()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
    
    if shieldModel == "nic_capshield_w" then
        AttachEntityToEntity(shield, ped, boneIndex, -0.08, -0.005, 0.02, 8.0, 275.0, 51.0, true, true, false, true, 1, true)
    else
        AttachEntityToEntity(shield, ped, boneIndex, -0.065, -0.035, 0.015, 93.0, 95.0, -39.0, true, true, false, true, 1, true)
    end
    equippedToBack = false
    equippedShield = true
    groundHit = false
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function SetMonModel(name)
    local model = GetHashKey(name)
    local player = PlayerId()
        
    if not IsModelValid(model) then return end
    PerformRequest(model)
        
    if HasModelLoaded(model) then
        Citizen.InvokeNative(0xED40380076A31506, player, model, false)
        Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), true)
        SetModelAsNoLongerNeeded(model)
    end
 end

function PerformRequest(hash)
    RequestModel(hash, 0)
    local bacon = 1
    while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, hash) do
        Citizen.InvokeNative(0xFA28FE3A6246FC30, hash, 0)
        bacon = bacon + 1
        Citizen.Wait(0)
        if bacon >= 100 then break end
    end
end