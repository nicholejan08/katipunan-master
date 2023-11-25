
local inprogress = false

RegisterNetEvent('nic_cigars:useCigarette')
AddEventHandler('nic_cigars:useCigarette', function()
    TriggerEvent("vorp_inventory:CloseInv")

    if not inprogress then
        inprogress = true
        if not (Citizen.InvokeNative(0xD5FE956C70FF370B, PlayerPedId()) or IsPedSprinting(PlayerPedId()) or IsPedRunning(PlayerPedId()) or IsPedWalking(PlayerPedId())) then
            TriggerServerEvent("nic_cigars:removeCigarette")
            TriggerEvent("vorp_inventory:CloseInv")
            getItemAnimation()
            Citizen.Wait(800)
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0,0x8B7F8EEB, 1, 1, 0, 0)
            TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealth", 5)   
            print("consumed Cigarette")
            -- exports['progressbar']:startUI(13000, "smoking")
            Citizen.Wait(13000)
            ClearPedTasks(PlayerPedId())
            inprogress = false
        else
            exports['nic_messages']:startMessage(4000, "STAND STILL")
            Citizen.Wait(1000)
            inprogress = false
        end
    else
        notAllowedPrompt()
    end
end)

RegisterNetEvent('nic_cigars:usecigar')
AddEventHandler('nic_cigars:usecigar', function()

    if not inprogress then
        inprogress = true
        if not (Citizen.InvokeNative(0xD5FE956C70FF370B, PlayerPedId()) or IsPedSprinting(PlayerPedId()) or IsPedRunning(PlayerPedId()) or IsPedWalking(PlayerPedId())) then
            TriggerServerEvent("nic_cigars:removecigar")
            TriggerEvent("vorp_inventory:CloseInv")
            getItemAnimation()
            Citizen.Wait(1000)
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0,0x81615BA3, 1, 1, 0, 0)
            TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealth", 5)   
            print("consumed cigar")
            -- exports['progressbar']:startUI(14000, "smoking")
            Citizen.Wait(14000)
            ClearPedTasks(PlayerPedId())
            inprogress = false
        else
            exports['nic_messages']:startMessage(4000, "STAND STILL")
            Citizen.Wait(1000)
            inprogress = false
        end
    else
        notAllowedPrompt()
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        if DoesEntityExist(PlayerPedId()) and inprogress then
            disableControls()
        end
    end
end)

function getItemAnimation()
    local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    TaskPlayAnim(PlayerPedId(), animation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
end

function breakLoop()
    return
end

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

function disableControls()
    Citizen.InvokeNative(0xB128377056A54E2A, PlayerPedId(), false)
    DisableControlAction(0, 0x8CC9CD42, true) -- Disable X
    DisableControlAction(0, 0x8FFC75D6, true) -- Disable Sprint
    DisableControlAction(0, 0xDB096B85, true) -- Disable Crouch
    DisableControlAction(0, 0x8AAA0AD4, true) -- Disable ALT
    DisableControlAction(0, 0xE8342FF2, true) -- Disable HOLDALT
    DisableControlAction(0, 0xD9D0E1C0, true) -- Disable SPACE
    DisableControlAction(0, 0x07CE1E61, true) -- MOUSE1
    DisableControlAction(0, 0xF84FA74F, true) -- MOUSE2
    DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3
end