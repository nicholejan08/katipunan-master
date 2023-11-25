

local pee = 0
local prop
local peepee
local status = true
local animation = "WORLD_PLAYER_DYNAMIC_KNEEL"
local running = false
local ragdoll = false
local storage = 0
local minuteSlow = 1800 -- Time in seconds where it will slow you down that you need to Pee so you could sprint and jump again
local slowTrigger = minuteSlow + 1
local peeing = false
local cooldown = 60000 -- How long until you can pee again in seconds

local Keys = {
    ["A"] = 0x7065027D, ["B"] = 0x4CC0E2FE, ["C"] = 0x9959A6F0, ["D"] = 0xB4E465B4, ["E"] = 0xCEFD9220, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["I"] = 0xC1989F95, ["J"] = 0xF3830D8E, ["L"] = 0x80F28E95, ["M"] = 0xE31C6A41, ["N"] = 0x4BC9DABB, ["O"] = 0xF1301666, ["P"] = 0xD82E0BD2, ["Q"] = 0xDE794E3E, ["R"] = 0xE30CD707, ["S"] = 0xD27782E3, ["T"] = 0x9720FCEE, ["U"] = 0xD8F73058, ["V"] = 0x7F8D09B8, ["W"] = 0x8FD015D8, ["X"] = 0x8CC9CD42, ["Z"] = 0x26E9DC00, ["RIGHTBRACKET"] = 0xA5BDCD3C, ["LEFTBRACKET"] = 0x430593AA, ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MWDN"] = 0x8BDE7443, ["CTRL"] = 0xDB096B85, ["TAB"] = 0xB238FE0B, ["SHIFT"] = 0x8FFC75D6, ["SPACE"] = 0xD9D0E1C0, ["ENTER"] = 0xC7B5340A, ["BACKSPACE"] = 0x156F7119, ["LALT"] = 0x8AAA0AD4, ["DEL"] = 0x4AF4D473, ["PGUP"] = 0x446258B6, ["PGDN"] = 0x3C3DD371, ["HOLDLALT"] = 0xE8342FF2, ["HOME"] = 0x064D1698, ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2, ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422, ["DOWN"] = 0x05CA7C52, ["UP"] = 0x6319DB71, ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local dead = Citizen.InvokeNative(0x3317DEDB88C95038, PlayerPedId(), true)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        if dead or IsPedRagdoll(PlayerPedId()) then
            DeleteEntity(peepee)
            pee = 0
            ClearPedTasks(PlayerPedId())
            FreezeEntityPosition(playerPed, false)
            KillPrompts()
        end      
    end
end)

Citizen.CreateThread(function() -- Cancel Animation
    while true do
        Wait(10)
        if peeing then
            FreezeEntityPosition(PlayerPedId(), true)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end 
end)

RegisterNetEvent('nic_pee:startPee')
AddEventHandler('nic_pee:startPee', function()
    local mount = Citizen.InvokeNative(0x460BC76A0E10655E, PlayerPedId())
    
    if not mount then
        if status == true then
            if peeing == false then
                TriggerEvent("nic_prompt:existing_fire_off")
                TriggerEvent("nic_prompt:pee_prompt_off")
                ClearPedTasks(PlayerPedId())
                TriggerEvent("nic_prompt:pee_prompt_off2")
                TriggerEvent("nic_prompt:existing_fire_off2")
                peeing = true
                Citizen.InvokeNative(0xF0A4F1BBF4FA7497, PlayerPedId(), 0, 0, 0)
                Pee(pee, storage)
            else
                TriggerEvent("nic_prompt:cooldown_prompt_on")
                TriggerEvent("nic_prompt:cooldown_prompt_off")
            end
        end
    end
end)

function KillPrompts()
    TriggerEvent("nic_prompt:peeing_prompt_off") 
    TriggerEvent("nic_prompt:pee_prompt_off2")
    TriggerEvent("nic_prompt:existing_fire_off")
    TriggerEvent("nic_prompt:existing_fire_off2")
    TriggerEvent("nic_prompt:harvesting_off") 
    TriggerEvent("nic_prompt:harvesting_off2") 
    TriggerEvent("nic_prompt:harvest_off") 
    TriggerEvent("nic_prompt:harvest_off2") 
end

function Pee()
    local gender =  IsPedMale(PlayerPedId())
    if status == true then
        DisableControlAction(0, 0xE8342FF2, true) -- Disable ALT control  
        local playerPed = PlayerPedId()	
        local count = math.random(0, 7)
        storage = count -- if you want the mushroom to always grow, change "count" to "2"
        Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 0, 1)
        TriggerEvent("nic_prompt:existing_fire_off2")
        TriggerEvent("nic_prompt:pee_prompt_off2")
        TriggerEvent("nic_prompt:peeing_prompt_on")
        TriggerEvent("nic_prompt:existing_fire_off2")
        TriggerEvent("nic_prompt:pee_prompt_off2")
        if gender == 1 then
            TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_PEE'), -1, true, false, false, false)
            Wait(5500)
            CreatePeepee()
            Wait(2500)
        else
            TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_FARMER_WEEDING'), -1, true, false, false, false)
            Wait(2000)
        end	
        exports['progressbar']:startUI(6000, "Umiihi")
        Wait(6000)
        pee = 0
        ClearPedTasks(PlayerPedId())
        Grow()
        TriggerEvent("nic_prompt:tired_prompt_off")
        TriggerEvent("nic_prompt:pee_prompt_off")
        TriggerEvent("nic_prompt:peeing_prompt_off")
        TriggerServerEvent('nic_pee:checkCount')
        peeing = false
        status = false
        Citizen.Wait(1500)
        DeleteEntity(peepee)
        Citizen.Wait(cooldown) -- number in milliseconds on how long it will take before you could Pee again
        status = true
        EnableControlAction(0, 0xE8342FF2, false) -- Enable ALT control
    end
end

function setRagdoll(flag)
    ragdoll = flag
end

function CreatePeepee() -- Create Peepee
    local playerPed = PlayerPedId()	
    local peepeeName = "pp_m"
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis")
    peepeeCheck = true
	-- print(boneIndex)
    peepee = CreateObject(GetHashKey(peepeeName), x, y, z-1.0,  true,  true, true)
    AttachEntityToEntity(peepee, playerPed, 1, 0.235, 0.165, 0.0, 148.0, 90.0, 1.0, false, true, false, false, 1, true)
    EnableControlAction(0, 0x156F7119, false) -- Enable Backspace control
    
    -- AddExplosion(x, y, z, 12, 0.0, false, false, false)
end

Citizen.CreateThread(function() -- Slow
    while true do
        Wait(0)
        if pee == slowTrigger then
            Slow()
        else
            EnableControls()
        end
    end 
end)

Citizen.CreateThread(function() -- Pee Timer
    while true do
        Wait(0)
        pee = pee + 1
        if pee >= minuteSlow then 
            pee = slowTrigger
            Slow(pee)
            Citizen.InvokeNative(0xF0A4F1BBF4FA7497, PlayerPedId(), 0, 0, 0)
            Prompt()
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, 987239450, 1, 1, 0, 0)
        end
        Citizen.Wait(1000)
    end 
end)

Citizen.CreateThread(function() -- Pee Checker
    while true do
        Wait(0)
        if pee <= 0 then
            pee = 0
            EnableControls()            
        end
    end 
end)

function EnableControls()
    EnableControlAction(0, 0xDB096B85, false) -- Enable CTRL control 
    EnableControlAction(0, 0x8FFC75D6, false) -- Enable Sprint control
    EnableControlAction(0, 0xD9D0E1C0, false) -- Enable Jump control
    EnableControlAction(0, 0x8CC9CD42, false) -- Enable X control
    EnableControlAction(0, 0x156F7119, false) -- Enable Backspace control
end

function Prompt()
    if IsPedUsingAnyScenario(PlayerPedId()) then
        TriggerEvent("nic_prompt:existing_fire_off")
        TriggerEvent("nic_prompt:pee_prompt_off")
    else
        TriggerEvent("nic_prompt:tired_prompt_on")
        TriggerEvent("nic_prompt:existing_fire_on")
        Citizen.Wait(3000)
        TriggerEvent("nic_prompt:existing_fire_off")
        Citizen.Wait(500)
        TriggerEvent("nic_prompt:pee_prompt_on")
        Citizen.Wait(3000)
        TriggerEvent("nic_prompt:pee_prompt_off")
    end
end

function Slow()
    DisableControlAction(0, 0xDB096B85, true) -- Disable CTRL control 
    DisableControlAction(0, 0x8FFC75D6, true) -- Disable Sprint control
    DisableControlAction(0, 0xD9D0E1C0, true) -- Disable Jump control
    DisableControlAction(0, 0x8CC9CD42, true) -- Disable X control
    DisableControlAction(0, 0x156F7119, true) -- Disable Backspace control
end


function DeleteMush()
    DeleteEntity(prop)
end

function Grow()
    if storage == 2 then
        local playerPed = PlayerPedId()	
        local propName = "s_flyamush"
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis")
        pee = 0
        prop = CreateObject(GetHashKey(propName), x, y, z-1.5,  true,  true, true)
        AttachEntityToEntity(prop, playerPed, -1, -0.05, 0.81, -0.96, 8.5, 0.0, 5.5, false, true, false, false, 1, true)
        DetachEntity(prop, 1, 1)
        PlaceObjectOnGroundProperly(prop)
        PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
        TriggerEvent("nic_prompt:peeing_prompt_off")
        TriggerEvent("nic_prompt:existing_fire_off")
        TriggerEvent("nic_prompt:pee_prompt_off")
        EnableControlAction(0, 0xD9D0E1C0, false) -- Enable Jump control
        EnableControlAction(0, 0x8FFC75D6, false) -- Enable Sprint control
    end
end

Citizen.CreateThread(function() -- Mushroom Checker
	while true do
        Citizen.Wait(10)   
		local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))   
        local MushroomExist = DoesObjectOfTypeExistAtCoords(x, y, z, 1.0, GetHashKey("s_flyamush"), true)
		local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
		if MushroomExist then 
            Harvest()
        else
            TriggerEvent("nic_prompt:harvest_off2")      
        end
	end
end)

function Harvest()
    local ped = PlayerPedId()
    TriggerEvent("nic_prompt:harvest_on2")
    if IsControlJustPressed(0, 0xD9D0E1C0) then 
        ClearPedTasks(PlayerPedId())
        TriggerEvent("nic_prompt:harvest_off")
        TriggerEvent("nic_prompt:harvesting_on")
        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
            RequestAnimDict( "mech_pickup@loot_body@face_up@loot@base" )
            while ( not HasAnimDictLoaded( "mech_pickup@loot_body@face_up@loot@base" ) ) do 
                Citizen.Wait( 100 )
            end
            if IsEntityPlayingAnim(ped, "mech_pickup@loot_body@face_up@loot@base", "nothing", 3) then
                ClearPedSecondaryTask(ped)
                ClearPedTasks(GetPlayerPed()) 
                TriggerEvent("nic_prompt:harvesting_on")
                TriggerEvent("nic_prompt:harvesting_off2") 
                TriggerEvent("nic_prompt:harvest_off2") 
            else
                TriggerEvent("nic_prompt:harvesting_off") 
                TriggerEvent("nic_prompt:harvesting_on")
                TriggerEvent("nic_prompt:harvest_off2")
                FreezeEntityPosition(PlayerPedId(), true)
                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(animation), -1, true, false, false, false)
                Citizen.Wait(2000)
                TaskPlayAnim(ped, "mech_pickup@loot_body@face_up@loot@base", "nothing", 1.0, 9.0, -1, 31, 0, true, 0, false, 0, false)
                exports['progressbar']:startUI(2500, "Nag-aani")
                Citizen.Wait(1500)
                TriggerEvent("nic_prompt:harvesting_off2") 
                Citizen.Wait(1000)
                TriggerServerEvent('nic_pee:additem')
                PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                DeleteMush(prop)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                TriggerEvent("nic_prompt:mushroom_plus_on")
                Wait(3000)
                TriggerEvent("nic_prompt:mushroom_plus_off")
            end
        end
    end
end

function IsPlayerNearCoords(mx, my, mz)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, mx, my, mz, true)

    if distance < 2 then
        return true
    end
end
