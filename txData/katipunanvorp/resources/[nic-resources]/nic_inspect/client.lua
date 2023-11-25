
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local prop
local holding = false
local propModel, animDict, animation = ""
local propx, propy, propz, proprotx, proproty, proprotz = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        
        if holding then
            Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
            Citizen.InvokeNative(0x7DE9692C6F64CFE8, PlayerPedId(), false, 0, false)
            if (IsControlJustPressed(0, 0x4AF4D473) or IsControlJustPressed(0, 0xF84FA74F) or IsControlJustPressed(0, 0x156F7119)) and not IsPlayerDead(PlayerPedId()) or IsPedSwimming(PlayerPedId()) or IsEntityInAir(PlayerPedId()) or IsPedFalling(PlayerPedId()) then
                holding = false
                playKeepkAnimation()
                DeleteObject(prop, 1, 1)
                ClearPedTasks(PlayerPedId()) 
            end
        end
        if IsPedRagdoll(PlayerPedId()) or IsPlayerDead(PlayerPedId()) then
            holding = false
            DeleteObject(prop, 1, 1)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if holding then
            disableControls()
        end
    end
end)

-- EVENTS
----------------------------------------------------------------------------------------------------


RegisterNetEvent('nic_inspect:inspect')
AddEventHandler('nic_inspect:inspect', function(model, bone, animDict, animation, x, y, z, rotx, roty, rotz)
    TriggerServerEvent("nic_inspect:useItem")
    TriggerEvent("vorp_inventory:CloseInv")
    DeleteObject(prop, 1, 1)
    playStoreAnimation(model, bone, animDict, animation, x, y, z, rotx, roty, rotz)
end)

RegisterNetEvent('nic_inspect:triggerStart')
AddEventHandler('nic_inspect:triggerStart', function(model, bone, animDict, animation, x, y, z, rotx, roty, rotz)
    holding = true
end)

-- PLAY STORE ANIMATION FUNCTION
----------------------------------------------------------------------------------------------------

function getValues(model, x, y, z, rotx, roty, rotz)
    propModel = model
    propx = x
    propx = y
    propx = z
    proprotx = rotx
    proproty = roty
    proprotz = rotz
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
    DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3
end

function getItemAnimation()
    local anim = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    TaskPlayAnim(PlayerPedId(), anim, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
end

function playStoreAnimation(model, bone, animDict, animation, x, y, z, rotx, roty, rotz)
    local anim = animDict
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), bone)
    local playerPed = PlayerPedId()
    local px,py,pz = table.unpack(GetEntityCoords(playerPed))
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(100)
    end
    getItemAnimation()
    prop = CreateObject(GetHashKey(model), px, py, pz,  true,  true, true)
    AttachEntityToEntity(prop, playerPed, boneIndex, x, y, z, rotx, roty, rotz, true, true, false, true, 1, true)
    TaskPlayAnim(PlayerPedId(), anim, animation, 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

function playKeepkAnimation()
    local anim = "mech_pickup@plant@gold_currant"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), anim, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
end