
local prompt1, prompt2, prompt3, prompt4, prompt5, prompt6, cleaning, inprogress = false

RegisterNetEvent("nic_horseitems:haycube")
AddEventHandler(
    "nic_horseitems:haycube",
    function(source)
        local Ped = PlayerPedId()
        local SulCavallo = IsPedOnMount(Ped)
        local _source = source
        local prop
        local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Hand")
        local modelName = "s_horsnack_haycube01x"
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))

        if SulCavallo and not inprogress then
            inprogress = true
            local Cavallo = GetMount(Ped)
            TriggerServerEvent("nic_horseitems:removeItem", "haycube")
            TriggerEvent("vorp_inventory:CloseInv")
            TaskAnimalInteraction(Ped, Cavallo, -224471938, true, true) 
            Citizen.Wait(1500)
            prop = CreateObject(GetHashKey(modelName), px, py, pz, true, true, true)
            AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.1, 0.02, -0.03, 70.0, 0.0, -90.0, true, true, false, true, 1, true)
            Citizen.Wait(1800)
			DeleteEntity(prop)

            local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 0)
            local valueStamina = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 1)

            if not tonumber(valueHealth) then
                valueHealth = 0
            end
            if not tonumber(valueStamina) then
                valueStamina = 0
            end
            Citizen.Wait(1500)
            Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 0, valueHealth + 15)
            Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 1, valueStamina + 15)
            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
            inprogress = false
        elseif inprogress then
            cooldownPrompt()
        else
            TriggerEvent("vorp_inventory:CloseInv")
            exports['nic_messages']:startMessage(4000, "You're not a fucking Horse aren't you?")
        end
    end)

RegisterNetEvent("nic_horseitems:carrot")
AddEventHandler(
    "nic_horseitems:carrot",
    function(source)
        local Ped = PlayerPedId()
        local SulCavallo = IsPedOnMount(Ped)
        local _source = source
        local prop
        local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Hand")
        local modelName = "p_carrot01x" --"s_aplsd_log"
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))

        if SulCavallo and not inprogress then
            inprogress = true
            local Cavallo = GetMount(Ped)
            TriggerServerEvent("nic_horseitems:removeItem", "carrot")
            TriggerEvent("vorp_inventory:CloseInv")
            TaskAnimalInteraction(Ped, Cavallo, -224471938, true, true) --Animazione
            Citizen.Wait(1500)
            prop = CreateObject(GetHashKey(modelName), px, py, pz, true, true, true)
            AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.1, 0.02, -0.03, 70.0, 0.0, -90.0, true, true, false, true, 1, true)
            Citizen.Wait(1800)
			DeleteEntity(prop)
            local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 0)
            local valueStamina = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 1)

            if not tonumber(valueHealth) then
                valueHealth = 0
            end
            if not tonumber(valueStamina) then
                valueStamina = 0
            end
            Citizen.Wait(1000)
            Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 0, valueHealth + 30)
            Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 1, valueStamina + 30)
            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
            inprogress = false
        elseif inprogress then
            cooldownPrompt()
        else
            TriggerEvent("vorp_inventory:CloseInv")
            exports['nic_messages']:startMessage(4000, "Idiot, this is for a Horse")
        end
    end
)

RegisterNetEvent("nic_horseitems:horse_stim")
AddEventHandler(
    "nic_horseitems:horse_stim",
    function(source)
        local Ped = PlayerPedId()
        local SulCavallo = IsPedOnMount(Ped)
        local _source = source
        local prop
        local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Hand")
        local modelName = "p_cs_syringe01x"
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))

        if SulCavallo and not inprogress then
            local Cavallo = GetMount(Ped)
            
            inprogress = true
    
            TriggerServerEvent("nic_horseitems:removeItem", "horse_stim")
            TriggerEvent("vorp_inventory:CloseInv")
            TaskAnimalInteraction(PlayerPedId(), Cavallo, -1355254781, 0, 0)
            Citizen.Wait(800)
            prop = CreateObject(GetHashKey(modelName), px, py, pz, true, true, true)
            AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.1, 0.02, -0.03, 70.0, 0.0, -90.0, true, true, false, true, 1, true)
    
            local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 0)
            local valueStamina = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 1)
    
            if not tonumber(valueHealth) then
                valueHealth = 0
            end
            if not tonumber(valueStamina) then
                valueStamina = 0
            end
            Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 0, valueHealth + 35)
            Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 1, valueStamina + 35)
    
            Citizen.InvokeNative(0xF6A7C08DF2E28B28, Cavallo, 0, 1000.0)
            Citizen.InvokeNative(0xF6A7C08DF2E28B28, Cavallo, 1, 1000.0)
    
            Citizen.InvokeNative(0x50C803A4CD5932C5, true) --core
            Citizen.InvokeNative(0xD4EE21B7CC7FD350, true) --core
            Citizen.Wait(1000)
            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
            Citizen.Wait(750)
            DetachEntity(prop, 1, 1)
            Citizen.Wait(5000)
			DeleteEntity(prop)
            inprogress = false
        elseif inprogress then
            cooldownPrompt()
        else
            TriggerEvent("vorp_inventory:CloseInv")
            exports['nic_messages']:startMessage(4000, "Get your shit together, you're not a Horse")
        end
    end
)

function cooldownPrompt()
    TriggerEvent("nic_prompt:cooldown_prompt_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:cooldown_prompt_off")
    return
end

Citizen.CreateThread(function()
	while true do
		Wait(10)

        if cleaning then
            TriggerEvent("nic_horseitems:disableControls")
        end
    end
end)

RegisterNetEvent("nic_horseitems:disableControls")
AddEventHandler("nic_horseitems:disableControls", function(source)
    DisableControlAction(0, 0x8FD015D8, true) 
    DisableControlAction(0, 0x7065027D, true) 
    DisableControlAction(0, 0xD27782E3, true) 
    DisableControlAction(0, 0xB4E465B4, true) 
end)

RegisterNetEvent("nic_horseitems:brush")
AddEventHandler(
    "nic_horseitems:brush",
    function(source)
        local _source = source
        local Ped = PlayerPedId()
        local SulCavallo = IsPedOnMount(Ped)
        local Cavallo = Citizen.InvokeNative(0x4C8B59171957BCF7, PlayerPedId())
        TriggerEvent("StressaPlayer", 10)
        local pCoords = GetEntityCoords(Ped)
        local cCoords = GetEntityCoords(Cavallo)
        local Distanza = GetDistanceBetweenCoords(pCoords, cCoords)
        local prop
        local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Hand")
        local modelName = "p_brushhorse01x"
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))

        if not inprogress then
            inprogress = true
            if SulCavallo then
                TriggerEvent("vorp_inventory:CloseInv")
                TaskAnimalInteraction(Ped, Cavallo, 1968415774, true, true)
                local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 0)            
                Citizen.Wait(1000)
    
                prop = CreateObject(GetHashKey(modelName), px, py, pz, true, true, true)
                AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.1, 0.01, -0.07, 100.0, 120.0, -70.0, true, true, false, true, 1, true)
    
                if not tonumber(valueHealth) then
                    valueHealth = 0
                end
                Citizen.Wait(6500)
                DeleteEntity(prop)
                Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 0, valueHealth + 5) -- Cura il cavallo di poco (5)
                Citizen.InvokeNative(0x6585D955A68452A5, Cavallo) -- Pulisce il cavallo
                Citizen.InvokeNative(0xB5485E4907B53019, Cavallo) -- Setta il cavallo bagnato
                inprogress = false
            elseif not SulCavallo and Distanza <= 1.5 then
                TriggerEvent("vorp_inventory:CloseInv")
                ClearPedTasksImmediately(PlayerPedId())
                TaskAnimalInteraction(Ped, Cavallo, 1968415774, true, true)
                local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, Cavallo, 0)
                Citizen.Wait(1800)
                cleaning = true
    
                prop = CreateObject(GetHashKey(modelName), px, py, pz, true, true, true)
                AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.1, 0.01, -0.07, 100.0, 120.0, -70.0, true, true, false, true, 1, true)
    
                if not tonumber(valueHealth) then
                    valueHealth = 0
                end
                Citizen.Wait(3500)
                cleaning = false
                playKeepAnimation()
                Citizen.Wait(500)
                DeleteEntity(prop)
                Citizen.InvokeNative(0xC6258F41D86676E0, Cavallo, 0, valueHealth + 5) -- Cura il cavallo di poco (5)
                Citizen.InvokeNative(0x6585D955A68452A5, Cavallo) -- Pulisce il cavallo
                Citizen.InvokeNative(0xB5485E4907B53019, Cavallo) -- Setta il cavallo bagnato
                inprogress = false
            elseif not SulCavallo and Distanza < 3.0 then
                inprogress = false
                TriggerEvent("vorp_inventory:CloseInv")
                exports['nic_messages']:startMessage(4000, "Dumb fuck! Get Closer!")
            elseif not SulCavallo and Distanza < 5.0 then
                inprogress = false
                TriggerEvent("vorp_inventory:CloseInv")
                exports['nic_messages']:startMessage(4000, "Closer, Idiot!")
            elseif not SulCavallo and Distanza >= 5.0 then
                inprogress = false
                TriggerEvent("vorp_inventory:CloseInv")
                exports['nic_messages']:startMessage(4000, "Must be near a Horse")
            end
        elseif inprogress then
            TriggerEvent("vorp_inventory:CloseInv")
            cooldownPrompt()
        end
    end
)

function playKeepAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(w, h)
   SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
   SetTextCentre(centre)
   if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, x, y)
end
