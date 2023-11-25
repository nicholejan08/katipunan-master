
local tempsbar = 0
local teleporting1, teleporting2, teleporting3 = false

function Animation2()
    local animation = "WORLD_HUMAN_WRITE_NOTEBOOK"
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(animation), -1, true, false, false, false)
end

-- Animation function
function ClearAnimation()
    ClearPedTasks(PlayerPedId())
    Wait(4000)
    ClearPedTasksImmediately(PlayerPedId())   
end


--The camera script here
function StartScenario(Dcoords)
    ClearPedTasksImmediately(PlayerPedId())
    local animation = "WORLD_HUMAN_GRAVE_MOURNING_KNEEL"
    local animation2 = "mech_inspection@generic@lh@base"
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
    TriggerEvent("vorp_inventory:CloseInv")
	local ped = PlayerPedId()
    TriggerEvent("vorp:showUi", false)
    TriggerEvent("alpohud:toggleHud", false)
    TriggerEvent("vorp_hud:toggleHud", false)
    local coords = GetEntityCoords(ped) 
    RequestAnimDict(animation2)
    while ( not HasAnimDictLoaded(animation2)) do 
        Citizen.Wait( 100 )
    end
    DisableControlAction(0, 0x8FD015D8, true)
    DisableControlAction(0, 0x7065027D, true)
    DisableControlAction(0, 0xD27782E3, true)
    DisableControlAction(0, 0xB4E465B4, true)
    DisablePlayerFiring(PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(animation), -1, true, false, false, false)
    FreezeEntityPosition(ped, true)
    Wait(3000)
    SetEntityAlpha(PlayerPedId(), 255, false)
    teleporting1 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 200, false)
    teleporting2 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 150, false)
    DoScreenFadeOut(2000)
    teleporting3 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 100, false)
    teleporting4 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 50, false)
    teleporting5 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 0, false)
    teleporting6 = true
    cameraBars()
    tempsbar = 1
	Wait(2000)
    teleporting1 = false
    teleporting2 = false
    teleporting3 = false
    teleporting4 = false
    teleporting5 = false
    teleporting6 = false
	PlaySoundFrontend("Gain_Point", "HUD_MP_PITP", true, 1)
    SetEntityCoords(ped, Dcoords)
    TaskPlayAnim(ped, animation2, "hold", 8.0, -1.0, 120000, 23, 0, true, 0, false, 0, false)
    SetEntityAlpha(PlayerPedId(), 0, false)
    SetEntityHeading(ped, 243.23)
    Wait(2000)
    DoScreenFadeIn(2000)
    teleporting6 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 50, false)
    teleporting5 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 100, false)
    teleporting4 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 150, false)
    teleporting3 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 200, false)
    teleporting2 = true
    Wait(500)
    SetEntityAlpha(PlayerPedId(), 255, false)
    teleporting1 = true
    teleporting1 = false
    teleporting2 = false
    teleporting3 = false
    teleporting4 = false
    teleporting5 = false
    teleporting6 = false
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(ped, false) 
    EnableControlAction(0, 0x8FD015D8, true)
    EnableControlAction(0, 0x7065027D, true)
    EnableControlAction(0, 0xD27782E3, true)
    EnableControlAction(0, 0xB4E465B4, true)
    DisablePlayerFiring(PlayerPedId(), false)
    teleporting = false
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("alpohud:toggleHud", true)
    TriggerEvent("vorp_hud:toggleHud", true)
    tempsbar = 0
    TriggerEvent("vorp:showUi", true)
    DestroyAllCams()
    TriggerEvent("vorp:Tip", "Destination", 5000)
end

function cameraBars()
	Citizen.CreateThread(function()
		while tempsbar == 1 do
			Wait(0)
			N_0xe296208c273bd7f0(-1, -1, 0, 17, 0, 0)
		end
	end)
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
        if teleporting1 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.4, 2.4, 1.0, 52, 186, 235, 190, false, true, 2, false, false, false, false)
        end
        if teleporting2 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz-0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.2, 2.2, 1.0, 52, 186, 235, 190, false, true, 2, false, false, false, false)
        end
        if teleporting3 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz-0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.9, 1.9, 1.0, 52, 186, 235, 190, false, true, 2, false, false, false, false)
        end
        if teleporting4 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.6, 1.6, 1.0, 52, 186, 235, 190, false, true, 2, false, false, false, false)
        end
        if teleporting5 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz+0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.3, 1.3, 1.0, 52, 186, 235, 190, false, true, 2, false, false, false, false)
        end
        if teleporting6 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz+0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 52, 186, 235, 190, false, true, 2, false, false, false, false)
        end
    end
end)

--This is the snip for tp and using one item

RegisterNetEvent('nic_townportal:useItem')
AddEventHandler('nic_townportal:useItem', function()
    local Dcoords = vector3(2829.81, -1229.23, 47.58)
    if not IsPedInMeleeCombat(PlayerPedId()) then
        StartScenario(Dcoords)  
    end
end)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(w, h)
   SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
   SetTextCentre(centre)
   if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, x, y)
end