

-- GLOBAL VARIABLES DECLARATIONS
----------------------------------------------------------------------------------------------------

local detonated, holdingsticky_bomb, placed, holdingDetonator, inprogress, pressed = false
local sticky_bombProp, detonatorProp, blip
local sprite = -1489164512


RegisterNetEvent('nic_sticky_bomb:use_sticky_bomb')
AddEventHandler('nic_sticky_bomb:use_sticky_bomb', function()
    if not IsPedRagdoll(PlayerPedId()) and not holdingsticky_bomb and not pressed then
        TriggerEvent("vorp_inventory:CloseInv")
        Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 1, true)
        TriggerServerEvent("nic_sticky_bomb:remove_sticky_bomb")
        inprogress = true
        pressed = true
        getItemsticky_bomb()
    end
end)


Citizen.CreateThread(function()
    while true do 
        Wait(10)
        local animation = "mech_crouch@generic@base"
        local animation2 = "mech_inventory@binoculars"
        local animation3 = "mech_inspection@generic@lh@base"
        local playerPed = PlayerPedId()
        local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_R_Hand")
        local bx, by, bz = table.unpack(GetEntityCoords(sticky_bombProp, 0))
        
        RequestAnimDict(animation) 
        while (not HasAnimDictLoaded(animation)) do 
            Citizen.Wait(100)
        end
        
        if inprogress then
            if holdingsticky_bomb then
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 1, true)
                DrawTxt("Place the sticky_bomb to your desired location then press:", 0.5, 0.08, 0.3, 0.4, true, 181, 204, 242, 250, true)  
                DrawTxt("MOUSE1", 0.5, 0.10, 0.3, 0.7, true, 199, 215, 0, 200, true)
                DisableControlAction(0, 0xC1989F95, true)
                if IsControlJustPressed(0, 0x07CE1E61) then
                    ClearPedTasksImmediately(PlayerPedId())
                    TaskPlayAnim(playerPed, animation2, "hold", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    TaskPlayAnim(playerPed, animation, "idle", 8.0, -1.0, 120000, 1, 0, true, 0, false, 0, false)
                    Citizen.Wait(1000)
                    DetachEntity(sticky_bombProp, true, true)
                    SetEntityCollision(sticky_bombProp, true, false)
                    Citizen.InvokeNative(0x9587913B9E772D29, sticky_bombProp, true)
                    blip = SET_BLIP_TYPE(sticky_bombProp)
                    SetBlipSprite(blip, sprite, 1)
                    Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'sticky_bomb')
                    ClearPedTasks(PlayerPedId())
                    holdingsticky_bomb = false
                    placed = true
                    holdingDetonator = true
                elseif IsControlJustPressed(0, 0x4AF4D473) then
                    playKeepkAnimation()
                    TriggerServerEvent("nic_sticky_bomb:add_sticky_bomb")
                    RemoveBlip(blip)
                    DeleteEntity(sticky_bombProp)
                    DeleteEntity(detonatorProp)
                    ClearPedTasks(PlayerPedId())
                    holdingsticky_bomb = false
                    holdingDetonator = false
                    inprogress = false
                    pressed = false
                end
            end
            if placed then
                if IsPlayerNearsticky_bombArea(bx, by, bz) then
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, bx, by, bz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 190, false, true, 2, false, false, false, false)
    
                    DrawTxt("Press MOUSE1 to", 0.5, 0.08, 0.3, 0.4, true, 181, 204, 242, 250, true)  
                    DrawTxt("Detonate", 0.5, 0.10, 0.3, 0.7, true, 199, 215, 0, 200, true)
                    if IsControlJustPressed(0, 0x07CE1E61) and not IsPedRagdoll(PlayerPedId()) then
                        holdDetonator()
                        RemoveBlip(blip)
                        Citizen.Wait(200)
                        for key, value in pairs(Config.settings) do
                            AddExplosion(bx, by, bz, 23, value.sticky_bombExplosionRadius, true, false, true)
                        end
                        Citizen.Wait(800)
                        DeleteEntity(sticky_bombProp)
                        DeleteEntity(detonatorProp)
                        ClearPedTasks(PlayerPedId())
                        placed = false
                        holdingDetonator = false
                        inprogress = false
                        pressed = false
                    end
                else
                    DrawTxt("Alert:", 0.5, 0.08, 0.3, 0.4, true, 252, 91, 91, 250, true)  
                    DrawTxt("Signal Out of Range", 0.5, 0.10, 0.3, 0.7, true, 255, 0, 0, 200, true)
                end
            else
                if IsControlJustPressed(0, 0x4AF4D473) then
                    playKeepkAnimation()
                    TriggerServerEvent("nic_sticky_bomb:add_sticky_bomb")
                    RemoveBlip(blip)
                    DeleteEntity(sticky_bombProp)
                    DeleteEntity(detonatorProp)
                    ClearPedTasks(PlayerPedId())
                    holdingDetonator = false
                    holdingsticky_bomb = false
                    inprogress = false
                    pressed = false
                end
            end
            if IsControlJustPressed(0, 0xB238FE0B) or IsControlJustPressed(0, 0x156F7119) or IsEntityDead(PlayerPedId()) or IsPedRagdoll(PlayerPedId()) or IsPedSwimming(PlayerPedId()) then
                if not placed and not holdingDetonator then
                    RemoveBlip(blip)
                    TriggerServerEvent("nic_sticky_bomb:add_sticky_bomb")
                    DeleteEntity(sticky_bombProp)
                    DeleteEntity(detonatorProp)
                    ClearPedTasks(PlayerPedId())
                    holdingDetonator = false
                    holdingsticky_bomb = false
                    inprogress = false
                    pressed = false
                end
            end
            if IsPlayerNearsticky_bomb(bx, by, bz) and not holdingsticky_bomb and placed then
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, bx, by, bz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 190, false, true, 2, false, false, false, false)
            end
        end
	end
end)

function SET_BLIP_TYPE (sticky_bombProp)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, sticky_bombProp)
end

function getItemsticky_bomb()
    local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    local animation2 = "mech_inventory@binoculars"
    local propName = "p_colognebox01x"
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_R_Hand")
    RequestAnimDict(animation2) 
    while (not HasAnimDictLoaded(animation2)) do 
        Citizen.Wait(100)
    end
    TaskPlayAnim(playerPed, animation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
    sticky_bombProp = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(sticky_bombProp, playerPed, boneIndex, 0.12, 0.02, -0.15, -60.0, -20.00, 0.00, true, true, false, true, 1, true)
    TaskPlayAnim(playerPed, animation2, "hold", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    holdingsticky_bomb = true
end

function IsPlayerNearsticky_bomb(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 4.0 then
        return true
    end
end

function IsPlayerNearsticky_bombArea(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    for key, value in pairs(Config.settings) do
        if distance < value.sticky_bombSignalRange then
            return true
        end
    end
end

-- PLAY DETONATOR ANIMATION FUNCTION
----------------------------------------------------------------------------------------------------

function holdDetonator()
    local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    local animation2 = "mech_inspection@generic@lh@base"
    local propName = "p_camerabox_film01x"
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_L_Hand")
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    RequestAnimDict(animation2)
    while not HasAnimDictLoaded(animation2) do
        Wait(100)
    end
    detonatorProp = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
    AttachEntityToEntity(detonatorProp, playerPed, boneIndex, 0.10, 0.05, 0.05, 0.0, 0.0, -30.0, true, true, false, true, 1, true)
    TaskPlayAnim(playerPed, animation2, "hold", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

function playKeepkAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(800)
end

-- FUNCTION UTILS
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