
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local ragdoll = false
local smoking = false
local modifier
local nearProp
local equipped = false
local writhe = false
local cover = false
local random = 0

local thrown = false
local throwHeight = 0
local upright = false
local hitEntity = false

local impaledTarget

local cloakToggled = false

local trail_particle_effect = false
local trail_particle_id = false

local spark_particle_id = false
local spark_particle_active = false

local chunk, chunk2, chunk3
local leftClaw, rightClaw, boneMask, skull, shield
local propModel = ""
local centerBone = "SKEL_Spine3"
local restorestamina = false
local superjump = false

local mutant = false
local human = true
local powerAcquired = false
local healAbility = false

local fxName = "DeadEyeEmpty"
local walkstyle = "MP_Style_Veteran"

local is_smoke_particle_effect_active = false
local smoke_ptfx_handle_id = false

local particle_effect = false
local particle_id = false

-- CONSUME VARIABLES
----------------------------------------------------------------------------------------------------

local eatPrompt, eatPrompt2 = false
local selectedAmount = 0
local consume = false
local eat = false
local deadeye = false

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DELETE"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,

    ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MDOWN"] = 0x8BDE7443
}

-- MUTANT ABILITY INITIALIZATION
----------------------------------------------------------------------------------------------------

RegisterCommand('predator', function()
    AnimpostfxStopAll()
    TriggerServerEvent("nic_predator:checkJob")
end)

RegisterNetEvent('nic_predator:Initialize')
AddEventHandler('nic_predator:Initialize', function(source)
    local ped = PlayerPedId()

    if not powerAcquired then
        AnimpostfxPlay("CamTransitionBlink")
        TriggerEvent('vorp:ShowTopNotification', "Predator", "~t6~Activated", 4000)
        PlaySoundFrontend("Gain_Point", "HUD_MP_PITP", true, 1)

        powerAcquired = true
        healAbility = true    
        restorestamina = true
        superjump = true
        human = false
        mutant = true

        applyBloodDecals(ped)
        playEffect()
        
        AnimpostfxPlay(fxName)
        AnimpostfxPlay("Mission_GNG0_Ride")
        Wait(500)
        wearAccessories()
        Wait(10)
        bloodBang("scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", ped, 1.5)
		Citizen.InvokeNative(0x46DF918788CB093F, ped, "PD_Outhouse_Muck_Body_Face", 0.0, 0.0) 
        addRightClaw()
        equipped = true
    else
        stopAll()
    end
end)

function stopAll()
    local ped = PlayerPedId()

    AnimpostfxPlay("MP_HealthDrop")
    stopEffect()
    TriggerEvent('vorp:ShowTopNotification', "Predator", "~e~Deactivated", 4000)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    SetPlayerMeleeWeaponDamageModifier(PlayerId(), 0.0)
    AnimpostfxStopAll()
	Citizen.InvokeNative(0x523C79AEEFCC4A2A, ped, 10, "ALL")
    removeClaws()
    powerAcquired = false
    human = true
    mutant = false
    healAbility = false
    superjump = false
    restorestamina = false
    deadeye = false
    thrown = false
    cloakToggled = false
    ResetEntityAlpha(ped)
    ResetEntityAlpha(boneMask)
    ResetEntityAlpha(rightClaw)
    ResetEntityAlpha(skull)
    ResetEntityAlpha(shield)
    
    Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 6)  -- enable choking peds
    Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 4)  -- enable kicking peds
    Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 33)  -- enable tackling peds
    Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 5)  -- enable shoving peds
    Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 13)  -- enable disarming peds

    Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 263, false) -- disable headshot
    Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 409, false) -- lower camera
    Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 265, false) -- disable drowning
    Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 340, false) -- disable melee takedowns

    Citizen.InvokeNative(0x923583741DC87BCE, ped, "arthur_healthy") -- reset walkstyle
    Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "normal") -- reset tired movement
    
    bloodBang("scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", ped, 1.0)
    Wait(10)
    removeAccessories()
end

-- TRANSFORM TO MUTANT
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_predator:transform')
AddEventHandler('nic_predator:transform', function(source) 
    local ped = PlayerPedId()
    local weak = ""

    for key, value in pairs(Config.settings) do
        weak = value.typeOfClaws
    end

    if weak == 'bones' then
        propModel = "bone_claws"
    else
        propModel = "metal_claws"
    end
    
    if IsPedRunning(ped) then
        playAnimation2()
        Wait(200)
        addLeftClaw()
        addRightClaw()
        StopAnimTask(ped, "mech_melee@lasso@_male@_ambient@_healthy@_noncombat", "attack_kick_stomp_leftside_dist_near_v1", 8.0)
    elseif IsPedSprinting(ped) or IsPedJumping(ped) then
        playAnimation3()
        Wait(200)
        addLeftClaw()
        addRightClaw()
        Wait(500)
        StopAnimTask(ped, "mech_melee@lasso@_male@_ambient@_healthy@_noncombat", "attack_kick_stomp_leftside_dist_near_v1", 8.0)
    elseif IsPedRagdoll(ped) then
        playAnimation3()
        addLeftClaw()
        addRightClaw()
        StopAnimTask(ped, "mech_melee@lasso@_male@_ambient@_healthy@_noncombat", "attack_kick_stomp_leftside_dist_near_v1", 8.0)
    else
        Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, 987239450, 1, 1, 0, 0)
        Citizen.Wait(2600)
        addLeftClaw()
        addRightClaw()
    end
    
    Citizen.InvokeNative(0x46DF918788CB093F, ped, "PD_Dead_John_bloody_hands", 0.0, 0.0)
    equipped = true
    Citizen.Wait(500)
end)

-- TRANSFORM TO HUMAN
----------------------------------------------------------------------------------------------------


RegisterNetEvent('nic_predator:humanize')
AddEventHandler('nic_predator:humanize', function(source)     
    equipped = false
    restorestamina = false
    superjump = false
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    Citizen.Wait(100)
    deleteObjectProps()
    vomit()
end)

-- DEFAULTS
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()  
        
        if mutant then
            defaults()
        end
	end
end)

-- FALL HEIGHT CHECKER
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)		
        local random = math.random(3000, 10000)
        local groundHeight = GetEntityHeightAboveGround(ped)

        if mutant then
            if not IsEntityDead(ped) then
                if IsPedFalling(ped) then
                    if groundHeight > 17 then
                     Citizen.InvokeNative(0xAE99FB955581844A, ped, -1, -1, 1, 0, 0, 0)
                     Citizen.Wait(random)
                     PlayPain(ped, 12, 1.0, 1, true)
                    end            
                    Citizen.InvokeNative(0xF0A4F1BBF4FA7497, ped, -1, 0, 0)
               end
            end
        end
        
       Citizen.Wait(2000)
    end
end)

-- PROMPT FUNCTION
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(ped))

        if mutant then
            if not IsEntityDead(ped) then
                if eatPrompt then
                    DrawText3D(x, y, z+1.0, "~COLOR_HUD_TEXT~+"..selectedAmount.." Hunger")
                end
                if eatPrompt2 then
                    DrawText3DSM(x, y, z+0.90, "~COLOR_YELLOWSTRONG~Consumed a Human")
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local max = GetPedMaxHealth(ped)
        local ragdoll = math.random(3000, 5000)
        local stumble = math.random(0, 1)
        local pos = GetEntityForwardVector(ped)

        local action = Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x169F59F7, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0xF5175BA1, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x772C8DD6, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x797FBF5, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x7BBD1FF6, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x63F46DE6, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0xA84762EC, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0xDDF7BC1E, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x20D13FF, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x1765A8F8, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x657065D6, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x95B24592, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x31B7B9FE, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x88A8505C, 100) or Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0x772C8DD6, 100)        
        
        if mutant then
            if not IsEntityDead(ped) then
        
                if action then
                    local hurt = math.random(0, 12)
            
                    if hurt == 2 then
                        SetPedToRagdoll(ped, 800, 2000, 0, true, true, true)
            
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
        local hp = GetEntityHealth(ped)
        local max = Citizen.InvokeNative(0x4700A416E8324EF3, ped)
        local damaged = Citizen.InvokeNative(0x9934E9C42D52D87E, ped) or Citizen.InvokeNative(0x73BB763880CD23A6, ped) or Citizen.InvokeNative(0x695D7C26DE65C423, ped)

		if mutant then
            if not IsEntityDead(ped) then
                
                if healAbility then
    
                    if IsPedFalling(ped) then
                        SetEntityInvincible(ped, true)
                    else
                        SetEntityInvincible(ped, false)
                    end
        
                    if damaged then
                        if hp < 130 then
                            SetEntityHealth(ped, hp+10, 1)
                            Wait(5)
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

        if not IsEntityDead(ped) then

            if mutant then

                Citizen.InvokeNative(0xC1E8A365BF3B29F2, ped, 29, true)
                Citizen.InvokeNative(0xC1E8A365BF3B29F2, ped, 6, true) -- infinite stamina
                Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 4, true)

                if superjump then
                    SetSuperJumpThisFrame(PlayerId())
                    SetPedMoveRateOverride(PlayerId(), 10.0)
                end
    
                if restorestamina then
                    RestorePlayerStamina(PlayerId(),1.0)
                end
            end
    
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

		if mutant then
            if not IsEntityDead(ped) then
                SetPlayerMeleeWeaponDamageModifier(PlayerId(), 72.0)
            else
                stopAll()
            end
        end
             
    end
end)
    
----------------------------------------------------------------------------------------------------


-- MELEE ANIMATIONS
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local randomAttack = math.random(0, 2)
        local action = not IsPedInMeleeCombat(ped) and not cover and not IsEntityDead(ped) and not IsPedRagdoll(ped) and not IsPedGettingUp(ped) 

		if mutant and powerAcquired then

            if IsControlJustPressed(0, Keys['Z']) then
                toggleCloak()
            end

            if IsEntityAttachedToEntity(rightClaw, ped) then
                if IsControlJustPressed(0, Keys['MOUSE1']) then
                    if not IsPedInMeleeCombat(ped) then
                        random = randomAttack
                        leftAttack()
                    end
                end
            end

            if IsControlJustPressed(0, Keys['MOUSE3']) then
                if DoesEntityExist(shield) then
                    if IsEntityAttachedToEntity(shield, ped) then
                        random = randomAttack
                        rightAttack()
                    end
                end
            end
		end
	end
end)

-- IF RMB KEY IS PRESSED (DEFEND)
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local target = GetClosestPed(ped, 2.0)
        local tx, ty, tz = table.unpack(GetEntityCoords(target, 0))
        local pos = GetEntityForwardVector(target)
        local multiplier = 32.00
        local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")

        if IsPedInMeleeCombat(ped) then

            if EntityNearEntity(rightClaw, tx, ty, tz, 0.35) then
                bloodBang("core", "blood_animal_maul_decal", target, 3.0)
                applyBloodDecals(target)
                local pos = GetEntityForwardVector(ped)
                ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0, 0, 0, 1, false, true, true, true, true)
                Citizen.InvokeNative(0xD76632D99E4966C8, target, 1500, 2000, 1, -pos, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                Wait(1000)
                ApplyDamageToPed(target, 200.0, 1, -1, 0)
                SetEntityHealth(target, 0, 0)
            end
        end
    end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local player = PlayerId()
        local dict = "mech_melee@unarmed@player@winter1@_healthy@_hit_reacts@block"
        local anim = "block_idle_v1"
        
        local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Spine3")
        local boneIndex2 = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
        local boneIndex3 = GetEntityBoneIndexByName(ped, "SKEL_L_Forearm")
        local x,y,z = table.unpack(GetEntityCoords(ped))
        
        if mutant and powerAcquired and equipped then
            if cover then
                SetPlayerLockon(player, false)
                DisablePlayerFiring(ped, true)
            else
                SetPlayerLockon(player, true)
                DisablePlayerFiring(ped, false)
            end

            if IsControlJustPressed(0, Keys['MOUSE2']) and equipped and not IsPedInMeleeCombat(ped) and not IsEntityDead(ped) then
                cover = true
                playAnimation()
                AttachEntityToEntity(shield, ped, boneIndex3, 0.4, 0.06, 0.09, 334.0, 291.0, 4.0, true, true, false, true, 1, true)
            elseif IsControlJustReleased(0, Keys['MOUSE2']) and not IsEntityDead(ped) then
                cover = false
                StopAnimTask(ped, dict, anim, 8.0)
                AttachEntityToEntity(shield, ped, boneIndex3, 0.24, 0.01, -0.02, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local target = GetClosestPed(shield, 1.0)
        local tx, ty, tz = table.unpack(GetEntityCoords(target, 0))
        local multiplier = 20.00

        if thrown and IsEntityInAir(shield) then
            if EntityNearEntity(shield, tx, ty, tz, 1.0) then
                Citizen.InvokeNative(0xD76632D99E4966C8, target, 2000, 2000, 0, 1.0, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                local pos = GetEntityForwardVector(shield)
                ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0, 0, 0, 1, false, true, true, true, true)
                if not hitEntity then
                    bloodBang("core", "blood_animal_maul_decal", target, 3.0)
                    applyBloodDecals(target)
                    hitEntity = true
                    ApplyDamageToPed(target, 200.0, 1, -1, 0)
                    SetEntityHealth(target, 0, 0)
                    hitEntity = false
                    impale(target)
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)

        if thrown then
            Wait(2000)
            thrown = false
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()

        if upright then
            Wait(200)
            upright = false
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()

        if not IsEntityDead(ped) then
            if DoesEntityExist(shield) then

                if upright then
                    local shieldCoords = GetEntityCoords(shield)
                    local pedCoords = GetEntityCoords(ped)
                    
                    throwHeight = pedCoords.z+0.5

                    SetEntityRotation(shield, 360.0, 0.0, 0.0, 1, true)
                    SetEntityCoords(shield, shieldCoords.x, shieldCoords.y, throwHeight)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local boneIndex3 = GetEntityBoneIndexByName(ped, "SKEL_L_Forearm")

        if not IsEntityDead(ped) then
            if DoesEntityExist(shield) then
    
                if IsControlJustReleased(0, Keys['MOUSE2']) then
                    if not IsEntityAttachedToEntity(shield, ped) then
                        AttachEntityToEntity(shield, ped, boneIndex3, 0.24, 0.01, -0.02, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                        Wait(10)
                        bloodBang("scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", shield, 0.3)
                        thrown = false
                    else    
                        if trail_particle_id then
                            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, trail_particle_id) then   -- DoesParticleFxLoopedExist
                                Citizen.InvokeNative(0x459598F579C98929, trail_particle_id, false)   -- RemoveParticleFx
                            end
                        end
                    
                        trail_particle_id = false
                        trail_particle_id = false
                    end
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local Player = PlayerId()
        local level = 48

        if cloakToggled then
            SetEntityAlpha(ped, level, false)
            SetEntityAlpha(boneMask, level, false)
            SetEntityAlpha(rightClaw, level, false)
            SetEntityAlpha(skull, level, false)
            SetEntityAlpha(shield, level, false)

            SetEveryoneIgnorePlayer(Player, true)
            SetPlayerCanBeHassledByGangs(Player, false)
    
            for key,pedNpc in pairs(GetAllPeds()) do
                SetBlockingOfNonTemporaryEvents(pedNpc,true)
                SetPedFleeAttributes(pedNpc, 0, 0)
                SetPedCombatAttributes(pedNpc, 17, 1)
            end

            if IsPedRagdoll(ped) then
                sparkEffect()
                ResetEntityAlpha(ped)
                ResetEntityAlpha(boneMask)
                ResetEntityAlpha(rightClaw)
                ResetEntityAlpha(skull)
                ResetEntityAlpha(shield)
                cloakToggled = false
            end
        else
            SetEveryoneIgnorePlayer(Player, false)
            SetPlayerCanBeHassledByGangs(Player, true)
        end

    end
end)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetAllPeds()
    local peds = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsEntityDead(ped) and IsEntityAPed(ped) and IsPedHuman(ped) and not IsPedAPlayer(ped) then
            table.insert(peds, ped)
        end
    end
    return peds
end
    

-- FUNCTIONS
----------------------------------------------------------------------------------------------------

function defaults()
    local ped = PlayerPedId()
    local player = PlayerId()

    -- configs------------------------------------------------
    
    Citizen.InvokeNative(0xFAEE099C6F890BB8, ped, 1, 1)
    Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 13)  -- disable disarming peds

    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 6)  -- disable choking peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 4)  -- disable kicking peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 33)  -- disable tackling peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 5)  -- disable shoving peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 8)  -- disable countering peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 10)  -- disable dodging peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 15)  -- disable takedown peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 16)  -- disable executing peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 17)  -- disable stealth kill peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 26)  -- disable arm grab peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 27)  -- disable leg grab peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 28)  -- disable knockdown peds
    -- Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 32)  -- disable auto shove peds

    -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 263, true) -- disable headshot
    -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 265, true) -- disable drowning
    -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 340, true) -- disable melee takedowns

    -- DisableControlAction(0, 0xE30CD707, true) -- Disables R Key
    DisableControlAction(0, 0x7F8D09B8, true) -- Disables Inventory Key

    if equipped then
        -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 409, true) -- lower camera
        Citizen.InvokeNative(0x923583741DC87BCE, ped, "primate") -- set walkstyle
        Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "normal") -- set tired movement
    else
        -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 409, false) -- lower camera
        Citizen.InvokeNative(0x923583741DC87BCE, ped, "arthur_healthy") -- reset walkstyle
        Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "normal") -- reset tired movement
    end    

    -- configs------------------------------------------------

    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 2, true)
    Citizen.InvokeNative(0xD77AE48611B7B10A, ped, 900.0)
    SetPlayerHealthRechargeMultiplier(ped, 1.0)
    TriggerEvent("vorpmetabolism:changeValue", "Hunger", 500)
    TriggerEvent("vorpmetabolism:changeValue", "Thirst", 500)
    TriggerEvent("vorpmetabolism:changeValue", "Metabolism", 500)
    TriggerEvent("vorpmetabolism:changeValue", "Stamina", 500)
    TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealth", 500)
    TriggerEvent("vorpmetabolism:changeValue", "OuterCoreHealth", 500)
    TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealthGold", 500)
    TriggerEvent("vorpmetabolism:changeValue", "OuterCoreHealthGold", 500)
    TriggerEvent("vorpmetabolism:changeValue", "InnerCoreStaminaGold", 500)
    TriggerEvent("vorpmetabolism:changeValue", "OuterCoreStaminaGold", 500)
end

function impale(entity)
    local boneIndex = GetEntityBoneIndexByName(entity, "SKEL_Spine3") 
    local boneIndex3 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Forearm")
    local impaleChance = math.random(0, 3)
    
    if impaleChance == 0 then        
        AttachEntityToEntity(shield, entity, GetPedBoneIndex(entity, boneIndex), 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1, 1, 0, 1, 0, 1)
        Wait(2000)
        AttachEntityToEntity(shield, PlayerPedId(), boneIndex3, 0.24, 0.01, -0.02, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        if trail_particle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, trail_particle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, trail_particle_id, false)   -- RemoveParticleFx
            end
        end
    
        trail_particle_id = false
        trail_particle_id = false
    end

end


function sparkEffect()
    local ped = PlayerPedId()
    local new_ptfx_dictionary = "core"
    local new_ptfx_name = "ent_col_electrical"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not spark_particle_active then
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
            
            spark_particle_id =  Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name, ped, 0, 0, 0, 0, 0, 0, 3.0, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if spark_particle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, spark_particle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, spark_particle_id, false)   -- RemoveParticleFx
            end
        end
        spark_particle_id = false
        spark_particle_active = false	
    end
end

function toggleCloak()
    local ped = PlayerPedId()
    local animation = "mech_inspection@generic@lh@base"

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end

    TaskPlayAnim(ped, animation, "hold", 8.0, -8.0, 500, 31, 0, true, 0, false, 0, false)

    Wait(500)
    
    if not cloakToggled then
        cloakToggled = true
    else
        ResetEntityAlpha(ped)
        ResetEntityAlpha(boneMask)
        ResetEntityAlpha(rightClaw)
        ResetEntityAlpha(skull)
        ResetEntityAlpha(shield)
        cloakToggled = false
    end
end

function gotPunched(entity)
    if Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, entity, 0xA2719263, 100) then
        return true
    end
end

function EntityNearEntity(entity, x, y, z, dNum)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, x, y, z, true)

    if distance < dNum then
        return true
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

function bloodBang(pDict, pName, entity, size)
    local new_ptfx_dictionary = pDict
    local new_ptfx_name = pName
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_smoke_particle_effect_active then
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

            
            smoke_ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name, entity, 0, 0, 0, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if smoke_ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, smoke_ptfx_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, smoke_ptfx_handle_id, false)   -- RemoveParticleFx
            end
        end
        smoke_ptfx_handle_id = false
        is_smoke_particle_effect_active = false	
    end
end

function shieldTrail()
	local ped = PlayerPedId()

	local particle_dict = "scr_smuggler2"
	local particle_name = "proj_cannon_trail"	
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

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

		local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_ROOT")
		trail_particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, shield, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, 5.0, 0, 0, 0)

		trail_particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playEffect()
	local ped = PlayerPedId()

	local particle_dict = "eagle_eye"
	local particle_name = "eagle_eye_lootable_plant"	
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

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

		local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_ROOT")
		particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, ped, 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, boneIndex, 0.7, 0, 0, 0)

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function stopEffect()
	if particle_id or trail_particle_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, particle_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, trail_particle_id) then   -- DoesParticleFxLoopedExist
			Citizen.InvokeNative(0x459598F579C98929, particle_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, trail_particle_id, false)   -- RemoveParticleFx
		end
	end

	trail_particle_id = false
    trail_particle_id = false

	particle_id = false
	particle_effect = false
    
    spark_particle_id = false
    spark_particle_active = false
end

function IsValidTarget(ped)
	return not IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and not IsPedRagdoll(ped)
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

function removeClaws()
    local ped = PlayerPedId()
    local dict = "mech_melee@lasso@_male@_ambient@_healthy@_noncombat"
    local anim = "attack_kick_push_leftside_dist_far_v1"
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local px, py, pz = table.unpack(GetEntityCoords(prop))
                   
    if equipped then
        playAnimation5()
        Citizen.Wait(400)
    end
    equipped = false
    Citizen.Wait(100)
    deleteObjectProps()
    Citizen.Wait(500)
    StopAnimTask(ped, dict, anim, 8.0)
end

function deleteObjectProps()

    if DoesEntityExist(leftClaw) then
        bloodBang("core", "blood_animal_maul_decal", leftClaw, 0.8)
        DeleteEntity(leftClaw)
    end

    if DoesEntityExist(rightClaw) then
        bloodBang("core", "blood_animal_maul_decal", rightClaw, 0.8)
        DeleteEntity(rightClaw)
    end
end

function MakeEntityFaceEntity(entity1, entity2)
	local p1 = GetEntityCoords(entity1)
	local p2 = GetEntityCoords(entity2)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)

	SetEntityHeading(entity1, heading)
end

function BloodEffects(target)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local tx, ty, tz = table.unpack(GetEntityCoords(target))
    local boneIndex = GetEntityBoneIndexByName(target, "SKEL_R_Thigh") 
    local boneIndex2 = GetEntityBoneIndexByName(target, "SKEL_Spine1") 
    local boneIndex3 = GetEntityBoneIndexByName(target, "SKEL_Head")

    AddExplosion(tx, ty, tz+0.6, 34, 15, true, false, true)
    Citizen.InvokeNative(0xF708298675ABDC6A, tx, ty, tz, 1.0, 0.7, 1.0, true, 1.0, true)

    chunk = CreateObject(GetHashKey("p_whitefleshymeat01xb"), tx, ty, tz, true, true, true)
    chunk2 = CreateObject(GetHashKey("p_cs_duckmeat01x"), tx, ty, tz, true, true, true)
    chunk3 = CreateObject(GetHashKey("p_meatchunk_sm01x"), tx, ty, tz, true, true, true)
    
    AttachEntityToEntity(chunk, target, boneIndex, 0.09, 0.03, -0.04, 25.0, 0.0, 4.0, true, true, false, true, 1, true)
    AttachEntityToEntity(chunk2, target, boneIndex2, 0.0, 0.0, 0.0, 0.0, 0.00, -0.00, true, true, false, true, 1, true)
    AttachEntityToEntity(chunk3, target, boneIndex3, 0.0, 0.0, 0.0, 0.0, 0.00, -0.00, true, true, false, true, 1, true)
    
    DetachEntity(chunk, 1, 1)
    DetachEntity(chunk2, 1, 1)
    DetachEntity(chunk3, 1, 1)

    Wait(3000)

    DeleteObject(chunk)
    DeleteObject(chunk2)
    DeleteObject(chunk3)
end

function ApplyDamage()
    local ped = PlayerPedId()
    local target = GetClosestPed(ped, 1.0)
    local cx, cy, cz = table.unpack(GetEntityCoords(target))
    local pos = GetEntityForwardVector(target)
    local multiplier = 12.0  

    if mutant and IsPedHuman(target) and not IsPedOnMount(target) or not IsPedInAnyVehicle(target) then
        if not IsEntityDead(target) then
            MakeEntityFaceEntity(ped, target)
        end

        if mutant and IsEntityDead(target) then
            BloodEffects(target)
        end

        Citizen.Wait(900)
        ApplyPedBloodSpecific(target, 1, 1.0, 1.0, 1.0, 1.0, 1, 1.0, 1)
        -- SetPedToRagdoll(target, 1000, 1000, 0, 0, 0, 0)
        AddExplosion(cx, cy, cz+0.6, 34, 24, true, false, true)

        ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0, 0, 0, 1, false, true, true, true, true)
        Wait(200)
        ApplyForceToEntity(target, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0, 0, 0, 1, false, true, true, true, true)
        AddExplosion(cx, cy, cz, 12, 0.0, true, false, true)
        SetEntityHealth(target, 0, 0)
        ApplyDamageToPed(target, 90000, false)
        Citizen.InvokeNative(0xD76632D99E4966C8, target, 1500, 2000, 1, -pos, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
end

function bloodExplode(ped, scale)
    local new_ptfx_dictionary = "core"
    local new_ptfx_name = "blood_explosive_bullet"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_blood_effect_active then
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
            
            current_blood_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, ped, 0, 0, 0, 0, 0, 0, scale, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_blood_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_blood_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_blood_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_blood_handle_id = false
        is_blood_effect_active = false	
    end
end

-- PLAY ANIMATION FUNCTION
----------------------------------------------------------------------------------------------------
    
function playAnimation()
    local ped = PlayerPedId()
    local animation = "mech_melee@unarmed@player@winter1@_healthy@_hit_reacts@block"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "block_idle_v1", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

-- PLAY ANIMATION2 FUNCTION
----------------------------------------------------------------------------------------------------

function playAnimation2()
    local ped = PlayerPedId()
    local animation = "mech_melee@lasso@_male@_ambient@_healthy@_noncombat"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "att_low_kick_dist_near_v1", 8.0, -8.0, 600, 31, 0, true, 0, false, 0, false)
end

-- PLAY ANIMATION3 FUNCTION
----------------------------------------------------------------------------------------------------

function playAnimation3()
    local ped = PlayerPedId()
    local animation = "mech_melee@lasso@_male@_ambient@_healthy@_noncombat"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "attack_kick_stomp_leftside_dist_near_v1", 8.0, -8.0, 600, 31, 0, true, 0, false, 0, false)
end

-- PLAY ANIMATION4 FUNCTION
----------------------------------------------------------------------------------------------------

function throwShield()
    local ped = PlayerPedId()
    local boneIndex3 = GetEntityBoneIndexByName(ped, "SKEL_L_Forearm")
    local multiplier = 172.00
    
    if DoesEntityExist(shield) then
        if IsEntityAttachedToEntity(shield, ped) then
            DetachEntity(shield, 1, 1)
            local pos = GetEntityForwardVector(ped)
            ApplyForceToEntity(shield, 1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier, 0, 0, 0, 1, false, true, true, true, true)
            thrown = true
            upright = true

            shieldTrail()
        end
    end
end

function rightAttack()
    local ped = PlayerPedId()
    local animation2 = "mech_melee@unarmed@bruiser@_ambient@_healthy@_variations"
    local animation3 = "mech_melee@unarmed@_male@_ambient@_healthy@_streamed"
    RequestAnimDict(animation2)
    RequestAnimDict(animation3)

    while not HasAnimDictLoaded(animation2) or not HasAnimDictLoaded(animation3) do
        Wait(100)
    end
    
    if random == 0 then
        TaskPlayAnim(ped, animation3, "att_hook_head_leftside_dist_close_v1", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Citizen.Wait(200)
        throwShield()
        Citizen.Wait(380)
        StopAnimTask(ped, animation3, "att_hook_head_leftside_dist_close_v1", 8.0)
    elseif random == 1 then
        TaskPlayAnim(ped, animation2, "att_combo_v2_pt3_rightside_dist_near_att", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Citizen.Wait(200)
        throwShield()
        Citizen.Wait(380)
        StopAnimTask(ped, animation2, "att_combo_v2_pt3_rightside_dist_near_att", 8.0)
    else
        TaskPlayAnim(ped, animation3, "att_desperate_getup_head_leftside_dist_near_v1", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Citizen.Wait(200)
        throwShield()
        Citizen.Wait(380)
        StopAnimTask(ped, animation3, "att_desperate_getup_head_leftside_dist_near_v1", 8.0)
    end
    
    return random
end

function leftAttack()
    local ped = PlayerPedId()
    local animation = "mech_melee@unarmed@_male@_ambient@_healthy@_hit_reacts@block"
    local animation2 = "mech_melee@unarmed@bruiser@_ambient@_healthy@_variations"
    local animation3 = "mech_melee@unarmed@_male@_ambient@_healthy@_streamed"
    
    RequestAnimDict(animation)
    RequestAnimDict(animation2)
    RequestAnimDict(animation3)

    while not HasAnimDictLoaded(animation) or not HasAnimDictLoaded(animation2) or not HasAnimDictLoaded(animation3) do
        Wait(100)
    end

    if random == 0 then
        TaskPlayAnim(ped, animation, "block_combo_neutral_v1_pt3_att", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Citizen.Wait(580)
        StopAnimTask(ped, animation, "block_combo_neutral_v1_pt3_att", 8.0)
    elseif random == 1 then
        TaskPlayAnim(ped, animation2, "att_combo_v2_pt2_leftside_dist_near_att", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Citizen.Wait(580)
        StopAnimTask(ped, animation2, "att_combo_v2_pt2_leftside_dist_near_att", 8.0)
    else
        TaskPlayAnim(ped, animation3, "att_desperate_getup_head_rightside_dist_near_v1", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Citizen.Wait(580)
        StopAnimTask(ped, animation3, "att_desperate_getup_head_rightside_dist_near_v1", 8.0)
    end
    
    return random
end

-- PLAY ANIMATION5 FUNCTION
----------------------------------------------------------------------------------------------------

function playAnimation5()
    local ped = PlayerPedId()
    local animation = "mech_melee@lasso@_male@_ambient@_healthy@_noncombat"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "attack_kick_push_leftside_dist_far_v1", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

-- PLAY ANIMATION6 FUNCTION
----------------------------------------------------------------------------------------------------

function playAnimation6()
    local ped = PlayerPedId()
    local animation = "script_rc@dst6@ig@rsc3_ig2_knife_kill"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "rsc3_ig2_walk_knifethrow_rt01_ig_mrsadler", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

-- ADD PROP FUNCTION
----------------------------------------------------------------------------------------------------

function wearAccessories()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Head")
    local boneIndex2 = GetEntityBoneIndexByName(ped, "SKEL_Spine2")
    local boneIndex3 = GetEntityBoneIndexByName(ped, "SKEL_L_Forearm")
    local maskModel = "bone_mask"
    local skullModel = "mp005_p_mp_predhunt_skull01x"
    local shieldModel = "p_barrelsaltlid01x_sea"
    local x, y, z = table.unpack(GetEntityCoords(ped))

    if not DoesEntityExist(boneMask) then
        boneMask = CreateObject(GetHashKey(maskModel), x, y, z, true, true, true)
        AttachEntityToEntity(boneMask, ped, boneIndex, 0.07, 0.07, 0.01, 179.0, 267.0, 5.0, true, true, false, true, 1, true)
    end

    if not DoesEntityExist(skull) then
        skull = CreateObject(GetHashKey(skullModel), x, y, z, true, true, true)
        AttachEntityToEntity(skull, ped, boneIndex2, 0.25, -0.09, -0.01, 27.0, 91.0, 0.0, true, true, false, true, 1, true)
    end
    
    if not DoesEntityExist(shield) then
        shield = CreateObject(GetHashKey(shieldModel), x, y, z, true, true, true)
        AttachEntityToEntity(shield, ped, boneIndex3, 0.24, 0.01, -0.02, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    end
end

function removeAccessories()    
    
    if DoesEntityExist(boneMask) then
        DeleteEntity(boneMask)
    end

    if DoesEntityExist(skull) then
        DeleteEntity(skull)
    end  
    
    if DoesEntityExist(shield) then
        DeleteEntity(shield)
    end
end

function addRightClaw()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local propModel = "predator_claws"
    
    if not DoesEntityExist(rightClaw) then
        rightClaw = CreateObject(GetHashKey(propModel), x, y, z, true, true, true)
        AttachEntityToEntity(rightClaw, ped, boneIndex, 0.09, 0.01, -0.005, 2.0, 13.0, 0.0, true, true, false, true, 1, true)
    end
    bloodBang("core", "blood_dismember_hand", rightClaw, 0.8)
end

-- DRAW 2D TEXT IN-GAME FUNCTION
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

-- DRAW 3D TEXT IN-GAME FUNCTION
----------------------------------------------------------------------------------------------------

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawText3DSM(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.25, 0.25)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function playParticleEffect(dict, lib, entity, scale, x, y, z, rotx, roty, rotz)
    local ped = PlayerPedId()
    local new_ptfx_dictionary = dict
    local new_ptfx_name = lib
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name
    local current_ptfx_handle_id = false
    local is_particle_effect_active = false

    if Citizen.InvokeNative(0x91AEF906BCA88877,0, 0x17BEC168) then   -- just pressed E
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
                
                current_ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name, entity, x, y, z, rotx, roty, rotz, scale, 0.0, 0.0, 0.0) -- StartNetworkedParticleFxNonLoopedOnEntity

                is_particle_effect_active = true
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
 end