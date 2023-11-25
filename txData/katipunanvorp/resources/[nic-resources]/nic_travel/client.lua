
local tempsbar = 0
local inprogress = false
local deducted = false

RegisterNetEvent('nic_travel:proceedToBicol')
AddEventHandler('nic_travel:proceedToBicol', function()
    local Dcoords = vector3(1303.69, -6863.21, 43.3)
    if not deducted then
        deducted = true
        TriggerServerEvent("nic_travel:removeitem", "bticket")
    end
    StartManilaToBicolScenario(Dcoords)
end)

RegisterNetEvent('nic_travel:proceedToManila')
AddEventHandler('nic_travel:proceedToManila', function()
    local Dcoords = vector3(2652.53, -1550.05, 48.31)
    if not deducted then
        deducted = true
        TriggerServerEvent("nic_travel:removeitem", "mticket")
    end
    StartBicolToManilaScenario(Dcoords)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local minDistance = 1
		local betweencoords = GetDistanceBetweenCoords(coords, 2781.58, -1536.2, 48.39, true)
		local betweencoords2 = GetDistanceBetweenCoords(coords, 1284.17, -6871.19, 43.35, true)

        if IsEntityDead(ped) then
            inprogress = false
        end

        if not inprogress then
            if IsPlayerNearEntity(2781.58, -1536.2, 47.0, 8.0) and not IsEntityDead(ped) then
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, 2781.58, -1536.2, 47.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 196, 209, 54, 100, false, false, 2, false, false, false, false)
                if betweencoords < minDistance and not IsPedOnMount(ped) then
                    DrawKey3D(2781.58, -1536.2, 48.4, "E", "Travel to Bicol")
                    if IsControlPressed(0, 0xCEFD9220) then
                        TriggerServerEvent("nic_travel:checkBicolTicket")
                    end
                end
            end
    
            if IsPlayerNearEntity(1284.17, -6871.19, 42.0, 8.0) and not IsEntityDead(ped) then
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, 1284.17, -6871.19, 42.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 196, 209, 54, 100, false, false, 2, false, false, false, false)
                if betweencoords2 < minDistance and not IsPedOnMount(ped) then
                    DrawKey3D(1284.17, -6871.19, 43.35, "E", "Travel to Manila")
                    if IsControlPressed(0, 0xCEFD9220) then
                        TriggerServerEvent("nic_travel:checkManilaTicket")
                    end
                end
            end 
        end
	end
end)

function playScenario(playScenario)
	local ped = PlayerPedId()
    local animation = playScenario
    TaskStartScenarioInPlace(ped, GetHashKey(animation), -1, true, false, false, false)
end

function StartManilaToBicolScenario(Dcoords)
	local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local fx = "skytl_1500_03clouds"
    inprogress = true
    TriggerEvent("vorp_inventory:CloseInv")
    ClearPedTasksImmediately(ped)
    playScenario("WORLD_HUMAN_WRITE_NOTEBOOK")
    FreezeEntityPosition(ped, true)
    Wait(2000)
    cameraBars()
	DisplayHud(false)
	DisplayRadar(false)
	TriggerEvent("vorp:showUi", false)
    tempsbar = 1
    AnimpostfxPlay(fx)
	Wait(2000)
    -- TriggerEvent("nic_typhoon:setWeather")
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1290.45, -6886.49, 44.15, 20.55, 0.0, -70.37, 50.00, false, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)
	DoScreenFadeOut(2000)
    Wait(2000)
    SetEntityCoords(ped, Dcoords)
    SetEntityHeading(ped, 55.25)
    Wait(3000)
    AnimpostfxStop(fx)
    DoScreenFadeIn(2000)
    Wait(5000)
	DoScreenFadeOut(2000)
    ClearPedTasks(ped)
    Wait(3000)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false) 
    DoScreenFadeIn(2000)
    SetCamActive(cam, false)
    DestroyAllCams()
    tempsbar = 0
    DisplayHud(true)
    DisplayRadar(true)
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("vorp:Tip", "Destination", 5000)
    inprogress = false
    deducted = false
end

function StartBicolToManilaScenario(Dcoords)
	local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local fx = "skytl_1500_03clouds"
    inprogress = true
    TriggerEvent("vorp_inventory:CloseInv")
    ClearPedTasksImmediately(ped)
    playScenario("WORLD_HUMAN_WRITE_NOTEBOOK")
    FreezeEntityPosition(ped, true)
    Wait(2000)
    cameraBars()
	DisplayHud(false)
	DisplayRadar(false)
	TriggerEvent("vorp:showUi", false)
    tempsbar = 1
    AnimpostfxPlay(fx)
	Wait(2000)
    -- TriggerEvent("nic_typhoon:resetWeather")
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 2756.95, -1479.0, 47.91, 0.55, 0.0, 180.37, 50.00, false, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)
	DoScreenFadeOut(2000)
    Wait(2000)
    SetEntityCoords(ped, Dcoords)
    SetEntityHeading(ped, 0.71)
    Wait(3000)
    AnimpostfxStop(fx)
    DoScreenFadeIn(2000)
    Wait(5000)
	DoScreenFadeOut(2000)
    ClearPedTasks(ped)
    TaskStartScenarioInPlace(ped, GetHashKey("WORLD_HUMAN_LEAN_RAILING"), -1, true, false, false, false) 
    Wait(3000)
    DoScreenFadeIn(2000)
    FreezeEntityPosition(ped, false) 
    ClearPedTasksImmediately(ped)
    SetCamActive(cam, false)
    DestroyAllCams()
    tempsbar = 0
    DisplayHud(true)
    DisplayRadar(true)
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("vorp:Tip", "Destination", 5000)
    inprogress = false
    deducted = false
end

function cameraBars()
	Citizen.CreateThread(function()
		while tempsbar == 1 do
			Wait(0)
			N_0xe296208c273bd7f0(-1, -1, 0, 17, 0, 0)
		end
	end)
end

function IsPlayerNearEntity(x, y, z, radius)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < radius then
        return true
    end
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

function DrawKey3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dict = "blips"
    local lib = "blip_ambient_riverboat"
    SetTextScale(0.27, 0.22)
    SetTextFontForCurrentCommand(0)
    SetTextColor(0, 0, 0, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.036)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.025,_y-0.038)

    if not HasStreamedTextureDictLoaded(dict) or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") then
        RequestStreamedTextureDict(dict, false)
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x, _y, 0.021, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite(dict, lib, _x, _y, 0.018, 0.03, 0.1, 176, 189, 145, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("generic_textures", "shield", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 255, 255, 255, 200, 0)
    end
end