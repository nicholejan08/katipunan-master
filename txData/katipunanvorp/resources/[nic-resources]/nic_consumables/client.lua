
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local prop
local propName = ""
local stopTimer = false
local invisible = false
local superjump = false
local tangoEffect = false
local clumsy = false
local lastCanteen = false
local eating = false
local drinking = false

local inprogress = false
local health = Citizen.InvokeNative(0x0317C947D062854E, ped)

local particle_effect = false
local particle_id = false

local current_ptfx_handle_id = false
local is_particle_effect_active = false	

----------------------------------------------------------------------------------------------------

local selectedItem, selectedPropModel, selectedType, propPlacement, category = ""
local selectedAmount, objectx, objecty, objectz, objectrotx, objectroty, objectrotz = 0
local drink, eat, canned, medicine, drinkPrompt, eatPrompt, medicinePrompt, canteen, drinkingCanteen, jumpPrompt, jumpTimer, jumpStarted, playingAnim, liquorPrompt, dizzy = false

-- SPECIAL ABITLITY FUNCTION
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_consumable:tango')
AddEventHandler('nic_consumable:tango', function()
	if not particle_effect then
        playParticleEffect("anm_gang2", "ent_anim_gng2_balloon_leaves", "skel_spine0", 0.5, 0, 0, 0, 0, 0, 0)
	else
		stopEffect()
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)      
        local ped = ped

        if eating then
			if not particle_effect then
                playParticleEffect("anm_foodprep", "ent_anim_gut_dried_meat_saw", "skel_head", 1.5, 0, 0.1, 0, -90.0, 0, 0)
                Wait(1000)
				stopEffect()
                eating = false
			end
        end

        if drinking then
			if not particle_effect then
                playParticleEffect("cut_utopia2", "cs_utopia2_water_drips", "skel_head", 1.5, 0, 0.1, 0, -90.0, 0, 0)
                Wait(4000)
				stopEffect()
                drinking = false
			end
        end

    end
end)

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()

        if tangoEffect then
            local hp = GetEntityHealth(ped)
            if hp < 200 then
                SetEntityHealth(ped, hp+1, 1)
                Wait(100)
            else
                stopEffect()
                tangoEffect = false
            end
        end
    end
end)

CreateThread(function()
	while true do
		Wait(5)
        if tangoEffect then
            Wait(5000)
            stopEffect()
            tangoEffect = false
        end
    end
end)

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()

        if invisible then
            SetEveryoneIgnorePlayer(ped, false)
        end
        if GetEntityAlpha(ped) == 50 then
            SetEveryoneIgnorePlayer(ped, true)
        end

        if not IsEntityDead(ped) then
            if superjump then
                SetSuperJumpThisFrame(PlayerId())
            end
    
            if clumsy then
                Citizen.InvokeNative(0xAE99FB955581844A, ped, -1, 0, 0, 0, 0, 0)
            end
    
            if IsPedRagdoll(ped) then            
                DetachEntity(prop, 1, 1)
            end
    
            if dizzy then
                SetEntityInvincible(ped, true)
                Citizen.InvokeNative(0xF0A4F1BBF4FA7497, ped, 5000, 0, 0)
                if IsPedRagdoll(ped) then
                    clumsy = true
                    Citizen.Wait(3000)
                    clumsy = false
                    Citizen.Wait(4000)
                end
            end
    
            if IsEntityPlayingAnim(ped, "mech_inventory@item@fallbacks@tonic_potent@offhand", "use_quick", 23) or IsEntityPlayingAnim(ped, "mech_pickup@system@rh", "ground_far_swipe", 23) then
                SetPedCanRagdoll(ped, false)
            else
                SetPedCanRagdoll(ped, true)
            end
        end
	end
end)


-- REMOVE ITEMS IF CONSUMED
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_consumables:prompt')
AddEventHandler('nic_consumables:prompt', function()
    exports['nic_messages']:startMessage(4000, "You don't have any firstaid")
end)

RegisterNetEvent('nic_consumables:drinkLiquor')
AddEventHandler('nic_consumables:drinkLiquor', function(value, model, type, amount)
    local ped = PlayerPedId()

    getValues(value, model, type, amount)
    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        liquor = true
        return selectedItem, selectedPropModel
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:useTango')
AddEventHandler('nic_consumables:useTango', function()
    local ped = PlayerPedId()

    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        selectedItem = "tango"
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        tango = true
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:drinkJump')
AddEventHandler('nic_consumables:drinkJump', function()
    local ped = PlayerPedId()

    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        selectedItem = "jump_potion"
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        jump = true
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:drinkInvi')
AddEventHandler('nic_consumables:drinkInvi', function()
    local ped = PlayerPedId()

    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        selectedItem = "invi_potion"
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        invi = true
    elseif not IsEntityDead(ped) and not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:triggerLastCanteen')
AddEventHandler('nic_consumables:triggerLastCanteen', function()    
    TriggerServerEvent('nic_consumables:lastCanteen')
end)

RegisterNetEvent('nic_consumables:drinkCanteen')
AddEventHandler('nic_consumables:drinkCanteen', function(lastItem, count)
    local ped = PlayerPedId()

    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        TriggerEvent("vorp_inventory:CloseInv")
        canteen = true
        lastCanteen = lastItem
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:getCustomValues')
AddEventHandler('nic_consumables:getCustomValues', function(objectPlacement, x, y, z, rotx, roty, rotz)
    getCustomValues(objectPlacement, x, y, z, rotx, roty, rotz)
    category = propPlacement
end)

RegisterNetEvent('nic_consumables:eatItem')
AddEventHandler('nic_consumables:eatItem', function(value, model, type, amount)
    local ped = PlayerPedId()

    getValues(value, model, type, amount)

    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        eat = true
        return selectedItem, selectedPropModel
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:eatCannedItem')
AddEventHandler('nic_consumables:eatCannedItem', function(value, model, type, amount)
    local ped = PlayerPedId()
    getValues(value, model, type, amount)

    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        canned = true
        return selectedItem, selectedPropModel
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:drinkItem')
AddEventHandler('nic_consumables:drinkItem', function(value, model, type, amount)
    local ped = PlayerPedId()
    getValues(value, model, type, amount)
    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        drink = true
        return selectedItem, selectedPropModel
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:drinkMedicine')
AddEventHandler('nic_consumables:drinkMedicine', function(value, model, type, amount)
    local ped = PlayerPedId()
    getValues(value, model, type, amount)
    if not IsEntityDead(ped) and not inprogress and not (IsPedHangingOnToVehicle(ped)) then
        TriggerServerEvent('nic_consumables:removeItem', selectedItem)
        TriggerEvent("vorp_inventory:CloseInv")
        medicine = true
        return selectedItem, selectedPropModel
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:getWater')
AddEventHandler('nic_consumables:getWater', function(hasCanteen)
    local ped = PlayerPedId()
    local canteen = hasCanteen
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
    local animation = "mech_pickup@system@rh"
    local animation2 = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    RequestAnimDict(animation)
    while ( not HasAnimDictLoaded(animation)) do 
        Citizen.Wait( 100 )
    end
    if hasCanteen and not (IsPedHangingOnToVehicle(ped)) and not IsEntityDead(ped) then
        drinkingCanteen = true
        inprogress = true
        ClearPedTasks(ped)
        TaskPlayAnim(ped, animation2, "use_quick", 8.0, -1.0, 120000, 23, 0, true, 0, false, 0, false)
        Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
        Citizen.Wait(1000)
        carryCanteen()
        AttachEntityToEntity(prop, ped, boneIndex, 0.12, 0.03, -0.07, -65.0, 0.00, -17.00, true, true, false, true, 1, true)
        Citizen.Wait(300)
        TaskPlayAnim(ped, animation, "ground_far_swipe", 3.0, -1.0, 120000, 23, 0, true, 0, false, 0, false)
        startNonLoopedParticle(prop, "core", "ent_sht_water", 0.3)
        startNonLoopedParticle(prop, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.3)
        Citizen.Wait(200)
        TriggerServerEvent('nic_consumables:addWater')
        Citizen.Wait(1000)
        startNonLoopedParticle(prop, "core", "ent_sht_water", 0.3)
        startNonLoopedParticle(prop, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.3)
        Citizen.Wait(200)
        playKeepkAnimation()
        Citizen.Wait(1000)
        DeleteObject(prop, 1, 1)
        Citizen.Wait(1000)
        ClearPedTasks(ped)
        inprogress = false
        drinkingCanteen = false
    elseif not inprogress and IsPedHangingOnToVehicle(ped) then
        notAllowedPrompt()
    else
        cooldownPrompt()
    end
end)

RegisterNetEvent('nic_consumables:check')
AddEventHandler('nic_consumables:check', function(storage, full, count)
    print("storage: "..storage.." full: "..full.." count: "..count)
end)

-- IF PLAYER IS IN WATER
----------------------------------------------------------------------------------------------------

-- (function is in nic_waterfunctions)

-- IF G KEY IS PRESSED
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local pLife = GetEntityHealth(ped)
		local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
		local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
        RequestAnimDict(animation) 
        while ( not HasAnimDictLoaded(animation)) do 
            Citizen.Wait( 100 )
        end
        
        if not IsEntityDead(ped) then
            if IsControlJustPressed(0, 0x760A9C6F) and not IsEntityInWater(ped) then
                if pLife < 100 then
                    if not IsPedInMeleeCombat(ped) and not IsPedRagdoll(ped) and not IsEntityDead(ped) and not IsEntityInWater(ped) then
                        TriggerServerEvent('nic_consumables:getFirstAid')
                    end
                end
            end

            if canteen then
                local fxName = "KingCastleBlue"
                inprogress = true
                selectedAmount = 50
                selectedItem = 'canteen'
                DeleteObject(prop, 1, 1)
                TaskPlayAnim(ped, animation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                Citizen.Wait(500)
                TriggerEvent("vorpmetabolism:changeValue", "Stamina", 800)
                TriggerEvent("vorpmetabolism:changeValue", "Thirst", selectedAmount*10)
                StopGameplayCamShaking(true)
                carryCanteen()
                AttachEntityToEntity(prop, ped, boneIndex, 0.12, 0.03, -0.07, -65.0, 0.00, -17.00, true, true, false, true, 1, true)
                Citizen.Wait(700)
                startNonLoopedParticle(prop, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.3)
                startNonLoopedParticle(prop, "core", "ent_sht_gloopy_liquid", 0.0, 0.0, 0.1, 0.5)
                Citizen.Wait(300)
                startNonLoopedParticle(prop, "core", "ent_sht_moonshine", 0.0, 0.0, 0.1, 0.3)
                drinking = true
                drinkPrompt = true
                AnimpostfxPlay(fxName)
                TriggerServerEvent('nic_consumables:removeWater')
                Citizen.Wait(1000)
                AnimpostfxStop(fxName)
                AttachEntityToEntity(prop, ped, boneIndex, 0.09, 0.06, -0.05, -65.0, 0.00, -17.00, true, true, false, true, 1, true)
                if not lastCanteen then
                    playKeepkAnimation()
                    Citizen.Wait(1000)
                    DeleteObject(prop, 1, 1)
                    Citizen.Wait(1000)
                    drinkPrompt = false
                    ClearPedTasks(ped)
                    canteen = false
                    inprogress = false
                else
                    Citizen.Wait(200)
                    DetachEntity(prop, 1, 1)
                    ClearPedTasks(ped)
                    Citizen.Wait(1000)
                    DeleteObject(prop, 1, 1)
                    Citizen.Wait(1000)
                    drinkPrompt = false
                    canteen = false
                    inprogress = false
                end
                lastCanteen = false
            elseif drink then
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local animation
                if selectedType == 'drinks_slow' then
                    animation = "mech_inventory@drinking@coffee"
                else
                    animation = "mech_inventory@eating@canned_food@cylinder@d8-2_h10-5"
                end
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                propName = selectedPropModel
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                getItemAnimation()
                carryProp()
                if selectedType == 'drinks_slow' then
                    if category == 'custom' then
                        AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                    else
                        AttachEntityToEntity(prop, ped, boneIndex, 0.11, -0.02, -0.1, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                    end
                    Citizen.Wait(500)
                    TaskPlayAnim(ped, animation, "action", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    inprogress = true
                    Citizen.Wait(1000)
                    TriggerEvent("vorpmetabolism:changeValue", "Stamina", 800)
                    TriggerEvent("vorpmetabolism:changeValue", "Thirst", selectedAmount*10)
                    Citizen.Wait(15000)
                    drinkPrompt = true
                    TaskPlayAnim(ped, animation, "discard", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    Citizen.Wait(2000)
                    DeleteObject(prop)
                    Citizen.Wait(2000)
                    drinkPrompt = false
                    ClearPedTasks(ped)
                    inprogress = false
                else
                    TaskPlayAnim(ped, animation, "right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    if category == 'custom' then
                        AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                    else
                        AttachEntityToEntity(prop, ped, boneIndex, 0.11, -0.03, -0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                    end
                    inprogress = true
                    Citizen.Wait(1500)
                    TriggerEvent("vorpmetabolism:changeValue", "Stamina", 800)
                    TriggerEvent("vorpmetabolism:changeValue", "Thirst", selectedAmount*10)
                    drinkPrompt = true
                    Citizen.Wait(1400)
                    DetachEntity(prop, 1, 1)
                    Citizen.Wait(1100)
                    ClearPedTasks(ped)
                    Citizen.Wait(1000)
                    drinkPrompt = false
                    inprogress = false
                    DeleteObject(prop)
                end
                drink = false
            elseif eat then
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local animation = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich"
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                propName = selectedPropModel
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                Citizen.Wait(200)
                TriggerEvent("vorpmetabolism:changeValue", "Hunger", selectedAmount*10)

                if selectedType == 'food_crunch' then
                    getItemAnimation()
                    carryProp()
                    if category == 'custom' then
                        AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                    else
                        AttachEntityToEntity(prop, ped, boneIndex, 0.11, -0.05, -0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                    end
                    Citizen.Wait(500)
                    TaskPlayAnim(ped, animation, "quick_right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                elseif selectedType == 'food_long' then
                    getItemAnimation()
                    carryProp()
                    if category == 'custom' then
                        AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                    else
                        AttachEntityToEntity(prop, ped, boneIndex, 0.09, -0.15, -0.10, -90.0, 190.00, 0.00, true, true, false, true, 1, true)
                    end
                    Citizen.Wait(500)
                    TaskPlayAnim(ped, animation, "quick_right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                elseif selectedType == 'food' then
                    getItemAnimation()
                    carryProp()
                    if category == 'custom' then
                        AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                    else
                        AttachEntityToEntity(prop, ped, boneIndex, 0.10, 0.0, -0.08, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                    end
                    Citizen.Wait(500)
                    TaskPlayAnim(ped, animation, "quick_right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                end
                inprogress = true
                Citizen.Wait(800)
                eating = true
                Citizen.Wait(1200)
                DeleteObject(prop)
                eatPrompt = true
                Citizen.Wait(800)
                ClearPedTasks(ped)
                Citizen.Wait(1000)
                eatPrompt = false
                eat = false
                inprogress = false
            elseif canned then
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local animation = "mech_inventory@eating@canned_food@cylinder@d8-2_h10-5"
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                getItemAnimation()
                propName = selectedPropModel
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                carryProp()
                if category == 'custom' then
                    AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                else
                    AttachEntityToEntity(prop, ped, boneIndex, 0.11, -0.03, -0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                end
                TriggerEvent("vorpmetabolism:changeValue", "Hunger", selectedAmount*10)
                Citizen.Wait(600)
                TaskPlayAnim(ped, animation, "right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                inprogress = true
                Citizen.Wait(1500)
                eatPrompt = true
                Citizen.Wait(1400)
                DetachEntity(prop, 1, 1)
                Citizen.Wait(1100)
                ClearPedTasks(ped)
                Citizen.Wait(1000)
                eatPrompt = false
                inprogress = false
                DeleteObject(prop)
                canned = false
            elseif medicine and not IsPedInMeleeCombat(ped) then
                DisableControlAction(0, 0xE30CD707, true)
                DisableControlAction(0, 0xB2F377E8, true)
                DisableControlAction(0, 0x07CE1E61, true)
                DisablePlayerFiring(ped, true)
    
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local hp = GetEntityHealth(ped)
                local max = 0
                local animation
                if selectedType == 'medicine_strong' then
                    max = hp + selectedAmount
                    animation = "mech_inventory@drinking@bottle_cylinder_d1-55_h18_neck_a8_b1-8"
                else
                    max = hp + selectedAmount
                    animation = "mech_inventory@item@fallbacks@large_drink@combat@bottle_oval_l5-5w9-5h10_neck_a6_b2-5@unarmed"
                end
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                propName = selectedPropModel
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                getItemAnimation()
                Citizen.Wait(500)
                carryProp()
                if selectedType == 'medicine_strong' then
                    local fxName = "MP_HealthRegen"
                    if category == 'custom' then
                        AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                    else
                        AttachEntityToEntity(prop, ped, boneIndex, 0.06, -0.1, -0.11, -75.0, 0.00, -17.00, true, true, false, true, 1, true)
                    end
                    TaskPlayAnim(ped, animation, "uncork", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    inprogress = true
                    Citizen.Wait(500)
                    startNonLoopedParticle(prop, "core", "ent_sht_gloopy_liquid", 0.0, 0.0, 0.3, 0.5)
                    Citizen.Wait(500)
                    TaskPlayAnim(ped, animation, "chug_a", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    Citizen.Wait(4500)
                    AnimpostfxPlay(fxName)
                    medicinePrompt = true
                    SetEntityHealth(ped, max, 1)
                    Citizen.Wait(1080)
                    AnimpostfxStop(fxName)
                    DetachEntity(prop, 1, 1)
                    ClearPedTasks(ped)
                    Citizen.Wait(1000)
                    DeleteObject(prop)
                    Citizen.Wait(1000)
                    medicinePrompt = false
                    drinkFirstAidS = false
                else
                    local fxName = "MP_HealthRegen"
                    TaskPlayAnim(ped, animation, "quick_consume_drink_large", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    if category == 'custom' then
                        AttachEntityToEntity(prop, ped, boneIndex, objectx, objecty, objectz, objectrotx, objectroty, objectrotz, true, true, false, true, 1, true)
                    else
                        AttachEntityToEntity(prop, ped, boneIndex, 0.09, -0.08, -0.06, -90.0, 0.00, -10.00, true, true, false, true, 1, true)
                    end
                    inprogress = true
                    Citizen.Wait(500)
                    startNonLoopedParticle(prop, "core", "ent_sht_water", 0.5)
                    startNonLoopedParticle(prop, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.5)
                    Citizen.Wait(500)
                    startNonLoopedParticle(prop, "core", "ent_sht_water", 0.5)
                    startNonLoopedParticle(prop, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.5)
                    AnimpostfxPlay(fxName)
                    medicinePrompt = true
                    SetEntityHealth(ped, max, 1)
                    Citizen.Wait(850)
                    AnimpostfxStop(fxName)
                    DetachEntity(prop, 1, 1)
                    Citizen.Wait(500)
                    ClearPedTasks(ped)
                    Citizen.Wait(1000)
                    DeleteObject(prop)
                    Citizen.Wait(1000)
                    medicinePrompt = false
                end
                medicine = false
                DisablePlayerFiring(ped, false)
                EnableControlAction(0, 0xE30CD707, false)
                EnableControlAction(0, 0xB2F377E8, false)
                EnableControlAction(0, 0x07CE1E61, false)
                inprogress = false
            elseif invi and not IsPedInMeleeCombat(ped) then
                DisableControlAction(0, 0xE30CD707, true)
                DisableControlAction(0, 0xB2F377E8, true)
                DisableControlAction(0, 0x07CE1E61, true)
                DisablePlayerFiring(ped, true)
    
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local hp = GetEntityHealth(ped)
                local max = 0
                local animation = "mech_inventory@drinking@bottle_cylinder_d1-55_h18_neck_a8_b1-8"
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                inprogress = true
                propName = "s_craftedmedicine_01x"
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                getItemAnimation()
                Citizen.Wait(500)
                carryProp()
                AttachEntityToEntity(prop, ped, boneIndex, 0.09, -0.08, -0.06, -90.0, 0.00, -10.00, true, true, false, true, 1, true)
                TaskPlayAnim(ped, animation, "uncork", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.Wait(1000)
                TaskPlayAnim(ped, animation, "chug_a", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.Wait(5500)
                inviPrompt = true
                camouflage(true)
                TriggerEvent('nic_consumable:startInviTimer')
                ClearPedTasks(ped)
                Citizen.Wait(1080)
                DetachEntity(prop, 1, 1)
                Citizen.Wait(300)
                Citizen.Wait(1000)
                DeleteObject(prop)
                Citizen.Wait(1000)
                inviPrompt = false
                invi = false
                inprogress = false
                DisablePlayerFiring(ped, false)
                EnableControlAction(0, 0xE30CD707, false)
                EnableControlAction(0, 0xB2F377E8, false)
                EnableControlAction(0, 0x07CE1E61, false)
            elseif not playingAnim and jump and not IsPedInMeleeCombat(ped) then
                DisableControlAction(0, 0xE30CD707, true)
                DisableControlAction(0, 0xB2F377E8, true)
                DisableControlAction(0, 0x07CE1E61, true)
                DisablePlayerFiring(ped, true)
    
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local animation = "mech_inventory@drinking@bottle_cylinder_d1-55_h18_neck_a8_b1-8"
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                inprogress = true
                propName = "p_bottlewine01x"
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                getItemAnimation()
                Citizen.Wait(500)
                carryProp()
                AttachEntityToEntity(prop, ped, boneIndex, 0.04, -0.15, -0.11, -75.0, -0.00, -19.00, true, true, false, true, 1, true)
                TaskPlayAnim(ped, animation, "uncork", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                inprogress = true
                Citizen.Wait(1000)
                TaskPlayAnim(ped, animation, "chug_a", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.Wait(5500)
                jumpPrompt = true
                superjump = true
                TriggerEvent('nic_consumable:startJumpTimer')
                ClearPedTasks(ped)
                playingAnim = true
                Citizen.Wait(1080)
                DetachEntity(prop, 1, 1)
                Citizen.Wait(300)
                Citizen.Wait(1000)
                DeleteObject(prop)
                Citizen.Wait(1000)
                jumpPrompt = false
                inprogress = false
                DisablePlayerFiring(ped, false)
                EnableControlAction(0, 0xE30CD707, false)
                EnableControlAction(0, 0xB2F377E8, false)
                EnableControlAction(0, 0x07CE1E61, false)
            elseif not playingAnim and liquor and not IsPedInMeleeCombat(ped) then
                DisableControlAction(0, 0xE30CD707, true)
                DisableControlAction(0, 0xB2F377E8, true)
                DisableControlAction(0, 0x07CE1E61, true)
                DisablePlayerFiring(ped, true)
    
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local animation = "mech_inventory@drinking@bottle_cylinder_d1-55_h18_neck_a8_b1-8"
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                inprogress = true
                propName = selectedPropModel
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                getItemAnimation()
                Citizen.Wait(500)
                carryProp()
                AttachEntityToEntity(prop, ped, boneIndex, 0.04, -0.15, -0.11, -75.0, -0.00, -19.00, true, true, false, true, 1, true)
                TaskPlayAnim(ped, animation, "uncork", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                inprogress = true
                Citizen.Wait(1000)
                TaskPlayAnim(ped, animation, "chug_a", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.Wait(5500)
                liquorPrompt = true
                dizzy = true
                SetEntityInvincible(ped, true)
                AnimpostfxPlay("PlayerDrunkAberdeen")
                TriggerEvent('nic_consumable:startLiquorTimer')
                ClearPedTasks(ped)
                playingAnim = true
                Citizen.Wait(1080)
                DetachEntity(prop, 1, 1)
                Citizen.Wait(300)
                Citizen.Wait(1000)
                DeleteObject(prop)
                Citizen.Wait(1000)
                liquorPrompt = false
                inprogress = false
                DisablePlayerFiring(ped, false)
                EnableControlAction(0, 0xE30CD707, false)
                EnableControlAction(0, 0xB2F377E8, false)
                EnableControlAction(0, 0x07CE1E61, false)
            elseif tango and not IsPedInMeleeCombat(ped) then
                local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
                local animation = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich"
                RequestAnimDict(animation) 
                while ( not HasAnimDictLoaded(animation ) ) do 
                    Citizen.Wait( 100 )
                end
                selectedAmount = 20
                propName = "s_inv_orchid_ghost_01bx"
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                getItemAnimation()
                carryProp()
                AttachEntityToEntity(prop, ped, boneIndex, 0.11, -0.05, -0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                Citizen.Wait(500)
                TaskPlayAnim(ped, animation, "quick_right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                inprogress = true
                Citizen.Wait(1500)
                DeleteObject(prop)
                TriggerEvent("vorpmetabolism:changeValue", "Hunger", selectedAmount*10)
                TriggerEvent("nic_consumable:tango")
                tangoEffect = true
                eatPrompt = true
                Citizen.Wait(1500)
                ClearPedTasks(ped)
                Citizen.Wait(1000)
                eatPrompt = false
                eat = false
                tango = false
                inprogress = false
            end
            selectedItem = ""
            category = ""
            x, y, z, rotx, roty, rotz = 0
        else
            superjump = false
            invisible = false
            ResetEntityAlpha(ped)
            AnimpostfxStop("PlayerDrunkAberdeen")
			DeleteObject(prop)
        end
    end
end)

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

--  LIQUOR TIMER EVENT
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_consumable:startLiquorTimer')
AddEventHandler('nic_consumable:startLiquorTimer', function()
    liquorStarted = true
    stopTimer = false
    local liquorTimer = 30
    local ped = PlayerPedId()
    
    exports['progressbar']:startUI(liquorTimer*1000, "Drunk")
	Citizen.CreateThread(function()
        if liquorStarted and not stopTimer then
            while liquorTimer > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                liquorTimer = liquorTimer - 1
            end
            
            if liquorTimer == 0 then
                SetEntityInvincible(ped, false)
                Citizen.InvokeNative(0xAE99FB955581844A, ped, -1, 0, 0, 0, 0, 0)
                AnimpostfxStop("PlayerDrunkAberdeen")
                dizzy = false
                liquor = false
                stopTimer = true
                liquorStarted = false
                playingAnim = false
                Citizen.Wait(10000)
            end
        end
	end)
end)

--  SUPERJUMP TIMER EVENT
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_consumable:startJumpTimer')
AddEventHandler('nic_consumable:startJumpTimer', function()
    jumpStarted = true
    stopTimer = false
    local jumpTimer = 20
    local ped = PlayerPedId()
    
    exports['progressbar']:startUI(jumpTimer*1000, "Superjump")
	Citizen.CreateThread(function()
        if jumpStarted and not stopTimer then
            while jumpTimer > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                jumpTimer = jumpTimer - 1
            end
            
            if jumpTimer == 0 then
                superjump = false
                jump = false
                stopTimer = true
                jumpStarted = false
                playingAnim = false
            end
        end
	end)
end)

--  INVISIBLE TIMER EVENT
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_consumable:startInviTimer')
AddEventHandler('nic_consumable:startInviTimer', function()
    inviStarted = true
    stopTimer = false
    local inviTimer = 30
    local ped = PlayerPedId()
    invisible = true
    
    exports['progressbar']:startUI(30000, "Invisibility")
	Citizen.CreateThread(function()
        if inviStarted and not stopTimer then
            while inviTimer > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                inviTimer = inviTimer - 1
            end
            
            if inviTimer == 0 then
                camouflage(false)
                stopTimer = true
                inviStarted = false
                invisible = false
            end
        end
	end)
end)

function camouflage(value)
    local toggle = value
    local ped = PlayerPedId()
    if toggle then
        SetEntityAlpha(ped, 50, false)
    else
        ResetEntityAlpha(ped)
        SetEveryoneIgnorePlayer(ped, false)
    end
end

-- PROMPTS
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 21030))
        local x, y, z = table.unpack(GetEntityCoords(ped))
        if eatPrompt then
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, true, "+~q~"..selectedAmount.." ~d~Hunger")
        end
        if drinkPrompt then
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, true, "+~q~"..selectedAmount.." ~COLOR_REPLAY_BLUE~Thirst")
        end
        if medicinePrompt then
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, true, "+~q~"..selectedAmount.." ~COLOR_OBJECTIVE~Health")
        end
        if inviPrompt then
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, true, "~COLOR_OBJECTIVE~Camouflage!")
        end
        if jumpPrompt then
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, true, "~COLOR_OBJECTIVE~Superjump!")
        end
        if liquorPrompt then
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, true, "~COLOR_OBJECTIVE~Drunk!")
        end
    end
end)

-- CREATE ITEM PROP FUNCTION
----------------------------------------------------------------------------------------------------

function startNonLoopedParticle(entity, dict, lib, x, y, z, size)
    local new_ptfx_dictionary = dict
    local new_ptfx_name = lib
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
        is_particle_effect_active = false	
    end
    
end

function getItemAnimation()
    local ped = PlayerPedId()
    local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    TaskPlayAnim(ped, animation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(600)
end

function playKeepkAnimation()
    local ped = PlayerPedId()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "stn_long_low_skill_exit", 3.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
end

function getCustomValues(objectPlacement, x, y, z, rotx, roty, rotz)
    propPlacement = objectPlacement
    objectx = x
    objecty = y
    objectz = z
    objectrotx = rotx
    objectroty = roty
    objectrotz = rotz
end

function getValues(value, model, type, amount)
    selectedItem = value
    selectedPropModel = model
    selectedType = type
    selectedAmount = amount
end

function cooldownPrompt()
    TriggerEvent("nic_prompt:cooldown_prompt_on")
    Citizen.Wait(2300)
    TriggerEvent("nic_prompt:cooldown_prompt_off")
    return
end

function carryCanteen()
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    prop = CreateObject(GetHashKey('p_cs_canteen_hercule'), x, y, z,  true,  true, true)
end

function carryProp()
    local playerPed = ped
    local x,y,z = table.unpack(GetEntityCoords(ped))
    prop = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
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

-- PARTICLE EFFECT FUNCTION
----------------------------------------------------------------------------------------------------

function playParticleEffect(dict, lib, bone, scale, x, y, z, rotx, roty, rotz)
    local ped = PlayerPedId()
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
 
          local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), particle_bone)
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
end