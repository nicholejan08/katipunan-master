
local poop
local poop2
local animation = "WORLD_PLAYER_DYNAMIC_KNEEL"
local storage = 0
local status = false

-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         local coords = GetEntityCoords(PlayerPedId())
--         local mount = Citizen.InvokeNative(0x460BC76A0E10655E, PlayerPedId())
--         local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
--         if not mount then
--             if IsControlJustPressed(0, 0x4AF4D473) then 
--                 if status == false then
--                     TriggerEvent("nic_prompt:pooping_prompt_on")    
--                     Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, 987239450, 1, 1, 0, 0)	 
--                     TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_PLAYER_DYNAMIC_KNEEL'), -1, true, false, false, false)
--                     Wait(2000)
--                     exports['progressbar']:startUI(4000, "Dumudumi")
--                     Wait(3000)
--                     Poop()
--                 end
--             end
--         end
--     end 
--  end)

RegisterNetEvent('nic_poop:startPoop')
AddEventHandler('nic_poop:startPoop', function()
    local coords = GetEntityCoords(PlayerPedId())
    local mount = Citizen.InvokeNative(0x460BC76A0E10655E, PlayerPedId())
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    if not mount then
        if status == false then
            TriggerEvent("nic_prompt:pooping_prompt_on")    
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, 987239450, 1, 1, 0, 0)	 
            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_PLAYER_DYNAMIC_KNEEL'), -1, true, false, false, false)
            Wait(2000)
            exports['progressbar']:startUI(4000, "Dumudumi")
            Wait(3000)
            Poop()
        end
    end
end)

 Citizen.CreateThread(function() -- Cooldown
    while true do
        Wait(0)
        if IsControlJustPressed(0, 0x4AF4D473) and status == true then
            DisableControlAction(0, 0x156F7119, true) -- Disable Backspace control
            DisableControlAction(0, 0x8CC9CD42, true) -- Disable X control
            TriggerEvent("nic_prompt:cooldown_prompt_on")
            TriggerEvent("nic_prompt:cooldown_prompt_off")
        elseif IsControlJustReleased(0, 0x4AF4D473) and status == true then
            TriggerEvent("nic_prompt:cooldown_prompt_off")
            DisableControlAction(0, 0x156F7119, true) -- Disable Backspace control
            DisableControlAction(0, 0x8CC9CD42, true) -- Disable X control
	    else
            TriggerEvent("nic_prompt:cooldown_prompt_off")
        end
    end 
end)

Citizen.CreateThread(function() -- Cooldown
    while true do
        Wait(0)
        local x, y, z = table.unpack(GetEntityCoords(poop2))

        if DoesEntityExist(poop2) then
            if IsPlayerNearPoop(x, y, z) then
                DrawText3D(x, y, z+0.1, true, "~COLOR_HUD_TEXT~poop")
            end
        end
    end 
end)

function IsPlayerNearPoop(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 3.0 then
        return true
    end
end

function Poop()
    status = true
    DeleteEntity(poop)
    Wait(1000)
    local propName = "p_horsepoop03x"
    local propName2 = "p_wolfpoop01x"
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
	local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis")
    AddExplosion(x, y, z, 35, 12, false, false, true)
    poop = CreateObject(GetHashKey(propName), x, y, z-2.0,  true,  true, true)
    poop2 = CreateObject(GetHashKey(propName2), x, y, z-3.17,  true,  true, true)
    AttachEntityToEntity(poop, PlayerPedId(), -1, 0.0, -0.15, -0.9, 0.0, 0.0, 0.0, false, true, false, false, 1, true)
    AttachEntityToEntity(poop2, PlayerPedId(), -1, 0.0, -0.15, -0.74, 0.0, 60.0, 0.0, false, true, false, false, 1, true)
    DetachEntity(poop, 1, false)
    DetachEntity(poop2, 1, false)
    Wait(1000)
    ClearPedTasks(PlayerPedId())
    TriggerEvent("nic_prompt:pooping_prompt_off")     
    FreezeEntityPosition(PlayerPedId(), false)
    Citizen.Wait(20000)
    DeleteEntity(poop)
    DeleteEntity(poop2)
    EnableControlAction(0, 0x8CC9CD42, false) -- Enable X control
    EnableControlAction(0, 0x156F7119, false) -- Enable Backspace control
    status = false
end

Citizen.CreateThread(function() -- Poop Checker
	while true do
        Citizen.Wait(10)   
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))   
        local PoopExist = DoesObjectOfTypeExistAtCoords(x, y, z, 4.0, GetHashKey("p_wolfpoop01x"), true)
		local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        if PoopExist then 
            Smell()
        end
	end
end)

function Smell()
    Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, -166523388, 1, 1, 0, 0)
    Citizen.Wait(5000)
end

function DrawText3D(x, y, z, enableShadow, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.25, 0.25)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end