
local inprogress = false
local tempsbar = 0
local interact = false
local rendering = false
local toghud = true
local closed = false
local cooldown = 0
local highlightPeds = false
local greeted = false

local old

SetNuiFocus(false, false)
DestroyAllCams(true)

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)

    if show == true then
        toghud = true
    else
        toghud = false
    end

end)

RegisterNUICallback('fine', function()
    local fineRandom = math.random(0, 2)
    local fineStatus = ""
    local fineResponse = ""

    if fineRandom == 0 then
        fineStatus = "Mabuti naman, salamat."
        fineResponse = "Walang anuman."
    elseif fineRandom == 1 then
        fineStatus = "Mabuti naman."
        fineResponse = "Sige po, ako'y lilisan na."
    else
        fineStatus = "Eto, medyo malungkot."
        fineResponse = "Ganun po ba, paumanhin."
    end

    SendNUIMessage({
        action = 'fine',
        fineStatus = fineStatus,
        fineResponse = fineResponse
    })
end)

RegisterNUICallback('time', function()
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    local timeText
    local deny
    local denyResponse

    if hours >= 12 then
        timeText = "pm"
    else
        timeText = "am"
    end

    if hours > 12 then
        hours = hours - 12
    end    
    
    SendNUIMessage({
        action = 'time',
        hours = hours,
        minutes = minutes,
        timeText = timeText
    })
end)

RegisterNUICallback('zone', function()
    local zone = GetCurentTownName()
    local chance = math.random(0, 4)

    SendNUIMessage({
        action = 'zone',
        zone = zone,
        chance = chance
    })
end)

RegisterNUICallback('close', function()
    CloseCam()
end)

SetNuiFocus(false, false)
SendNUIMessage({})

RegisterNetEvent('nic_ped_interact:cooldown')
AddEventHandler('nic_ped_interact:cooldown', function()
    cooldown = true
    local timer = 60

	Citizen.CreateThread(function()
        if cooldown then
            while timer > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                timer = timer - 1
            end
            
            if timer == 0 then
                cooldown = false
            end
        end
	end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if rendering then
            if IsEntityDead(ped) or IsPedRagdoll(ped) then
                CloseCam()
                SetNuiFocus(false, false)
                toghud = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local ped = PlayerPedId()
		local excludeEntity = ped
		local coords = GetEntityCoords(ped)
		local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 1.0, 1.0, 2.0, 0.0, 0.0, 0.0, true, 256, excludeEntity)
        local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
        
        excludeEntity = entityHit

		local model_hash = GetEntityModel(entityHit)

        local target = GetClosestPed(ped, 5.0)
        local bCoords = GetWorldPositionOfEntityBone(target, GetPedBoneIndex(target, 21030))
        local targetFar = GetClosestPed(ped, 22.0)
        local bCoordsFar = GetWorldPositionOfEntityBone(targetFar, GetPedBoneIndex(targetFar, 21030))
        local pedx2, pedy2, pedz2 = table.unpack(GetEntityCoords(targetFar, 0))
        local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
        local pRotation = GetEntityRotation(ped)
        local pedx, pedy, pedz = table.unpack(GetEntityCoords(target, 0))
        local groupIndex = GetPedGroupIndex(target)

        local random = math.random(0, 5)
        local random2 = math.random(0, 5)

        SetEntityMaxHealth(target, 100)

        if IsEntityNearEntity(ped, target, 5.0) then
            for key, value in pairs(Config.settings) do
                if value.healthDisplayType == "bar" then
                    DrawBar3D(bCoordsFar.x, bCoordsFar.y, bCoordsFar.z+0.5, targetFar)
                elseif value.healthDisplayType == "barGradient" then
                    DrawBarGradient3D(bCoordsFar.x, bCoordsFar.y, bCoordsFar.z+0.5, targetFar)
                end
            end
        end
        
        if Citizen.InvokeNative(0x698F456FB909E077) and groupIndex == 0 and not Citizen.InvokeNative(0x083D497D57B7400F, target) then
            if Citizen.InvokeNative(0x8C67C11C68713D25, PlayerId(), target) then
                for key, value in pairs(Config.settings) do
                    if value.healthDisplayType == "bar" then
                        DrawBar3D(bCoordsFar.x, bCoordsFar.y, bCoordsFar.z+0.5, targetFar)
                    elseif value.healthDisplayType == "barGradient" then
                        DrawBarGradient3D(bCoordsFar.x, bCoordsFar.y, bCoordsFar.z+0.5, targetFar)
                    end
                end
            end
        end

        if DoesEntityExist(target) and IsEntityOnScreen(target) and not IsCinematicCamRendering() and not IsPauseMenuActive() and HasEntityClearLosToEntityInFront(ped, target, 0) and IsPlayerFreeAimingAtEntity(PlayerId(), target) and IsPlayerNearNPC(pedx, pedy, pedz) and groupIndex == 0 and not Citizen.InvokeNative(0x083D497D57B7400F, target) then

            if not IsEntityDead(target) and not IsEntityDead(ped) and IsPedFacingPed(ped, target, 90.0) then
                if IsPedOnMount(target) or IsPedInAnyVehicle(target) then
                    for key, value in pairs(Config.settings) do
                        if value.healthDisplayType == "core" then
                            DrawHealth3D(bCoords.x, bCoords.y, bCoords.z+0.5, target)
                        elseif value.healthDisplayType == "bar" then
                            DrawBar3D(bCoords.x, bCoords.y, bCoords.z+0.5, target)
                        elseif value.healthDisplayType == "barGradient" then
                            DrawBarGradient3D(bCoords.x, bCoords.y, bCoords.z+0.5, target)
                        end
                    end
                else
                    for key, value in pairs(Config.settings) do
                        if value.healthDisplayType == "core" then
                            DrawHealth3D(bCoords.x, bCoords.y, bCoords.z+0.5, target)
                        elseif value.healthDisplayType == "bar" then
                            DrawBar3D(bCoords.x, bCoords.y, bCoords.z+0.5, target)
                        elseif value.healthDisplayType == "barGradient" then
                            DrawBarGradient3D(bCoords.x, bCoords.y, bCoords.z+0.5, target)
                        end
                    end
                end
            end
        end

        if not IsCinematicCamRendering() and not IsPauseMenuActive() and HasEntityClearLosToEntityInFront(ped, target, 0) and not IsPedInCombat(target, ped) and not IsPedInCombat(ped, target) and not IsPlayerFreeAimingAtEntity(PlayerId(), target) and not IsPedUsingAnyScenario(ped) and not Citizen.InvokeNative(0x083D497D57B7400F, target) and groupIndex == 0 and old ~= target and not interact and not rendering and IsPedFacingPed(ped, target, 90.0) and not Citizen.InvokeNative(0xD453BB601D4A606E, target) and not Citizen.InvokeNative(0x3AA24CCC0D451379, target) and not Citizen.InvokeNative(0xD453BB601D4A606E, ped) and not Citizen.InvokeNative(0x3AA24CCC0D451379, ped) then
            
            if (IsPedFacingPed(ped, target, 90.0) and IsPedFacingPed(target, ped, 90.0)) and not IsPedInMeleeCombat(target) and not IsPedSwimming(target) and not IsPedInCombat(ped, target) and not IsPedInMeleeCombat(ped) and not IsPedRagdoll(target) and not IsPedRagdoll(ped) and IsPlayerNearPed(pedx, pedy, pedz) and not (IsPedSprinting(ped) or IsPedRunning(ped)) and not (target == ped) then

                if not IsEntityDead(target) and not IsEntityDead(ped) then
                    if IsPedOnMount(target) or IsPedInAnyVehicle(target) then
                        DrawGreet3D(bCoords.x, bCoords.y, bCoords.z+0.7, "R", "Kamustahin")
                    else
                        DrawGreet3D(bCoords.x, bCoords.y, bCoords.z+0.7, "R", "Kamustahin")
                    end
                end

                if IsControlJustPressed(0, 0xE30CD707) then

                    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                    Citizen.Wait(500)
                    Citizen.InvokeNative(0x5AD23D40115353AC, ped, target, 1000, 1, 0, 0)
                    Citizen.InvokeNative(0x5AD23D40115353AC, target, ped, 1000, 1, 0, 0)
                    Citizen.Wait(1000)
    
                    if IsPedSprinting(ped) or IsPedRunning(ped) or IsPedWalking(ped) then
        
                        if random == 1 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -339257980, 1, 1, 0, 0)
                        elseif random == 2 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -1457020913, 1, 1, 0, 0)
                        elseif random == 3 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, 523585988, 1, 1, 0, 0)
                        elseif random == 4 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -1801715172, 1, 1, 0, 0)
                        elseif random == 5 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -2121881035, 1, 1, 0, 0)
                        else
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, 901097731, 1, 1, 0, 0)
                        end

                        if IsPedFacingPed(target, ped, 90.0) then
                            -- makeEntityFaceEntity(ped, target)
    
                            ClearPedTasks(target)
                            if random2 == 1 then
                                Citizen.Wait(800)
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -1457020913, 1, 1, 0, 0)
                            elseif random2 == 2 then
                                Citizen.Wait(800)
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, 901097731, 1, 1, 0, 0)
                            elseif random2 == 3 then
                                Citizen.Wait(800)
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, 329631369, 1, 1, 0, 0)
                            elseif random2 == 4 then
                                Citizen.Wait(800)
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -1801715172, 1, 1, 0, 0)
                            elseif random2 == 5 then
                                Citizen.Wait(800)
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -2121881035, 1, 1, 0, 0)
                            else
                                Citizen.Wait(800)
                                Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -339257980, 1, 1, 0, 0)
                            end

                            if not IsPedOnMount(target) and not IsPedInAnyVehicle(target, false) and not IsPedOnMount(ped) and not IsPedInAnyVehicle(ped, false) then
                                -- makeEntityFaceEntity(target, ped)
                            end
                        end
                    else
                        -- ClearPedTasksImmediately(ped)
                        if not IsPedOnMount(ped) then
                            -- makeEntityFaceEntity(ped, target)
                        end
                        if random == 1 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -339257980, 1, 1, 0, 0)
                        elseif random == 2 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -1457020913, 1, 1, 0, 0)
                        elseif random == 3 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, 523585988, 1, 1, 0, 0)
                        elseif random == 4 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -1801715172, 1, 1, 0, 0)
                        elseif random == 5 then
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, -2121881035, 1, 1, 0, 0)
                        else
                            Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, 901097731, 1, 1, 0, 0)
                        end                            

                        if IsPedFacingPed(target, ped, 90.0) then  
                            
                            if Citizen.InvokeNative(0x84D0BF2B21862059, target) then
                                Citizen.Wait(800)
                                if random2 >= 3 then
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -822629770, 1, 1, 0, 0)
                                else
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -1457020913, 1, 1, 0, 0)
                                end
                                
                            else
                                ClearPedTasks(target)
                                Citizen.Wait(800)
                                if random2 == 1 then
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -1457020913, 1, 1, 0, 0)
                                elseif random2 == 2 then
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, 901097731, 1, 1, 0, 0)
                                elseif random2 == 3 then
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -822629770, 1, 1, 0, 0)
                                elseif random2 == 4 then
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -1801715172, 1, 1, 0, 0)
                                elseif random2 == 5 then
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -2121881035, 1, 1, 0, 0)
                                else
                                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, target, 0, 0, -339257980, 1, 1, 0, 0)
                                end
                                
                                if not IsPedOnMount(target) and not IsPedInAnyVehicle(target, false) and not IsPedOnMount(ped) and not IsPedInAnyVehicle(ped, false) then
                                    -- makeEntityFaceEntity(target, ped)
                                end
                            end
                        end
                    end
                end
            end
            if (IsPedFacingPed(ped, target, 90.0) and IsPedFacingPed(target, ped, 90.0)) and IsPlayerHasSameGroundLevel(ped, target) and not IsPedInMeleeCombat(target) and not IsPedInCombat(ped, target) and not IsPedInMeleeCombat(ped) and not IsPedOnMount(target) and IsPlayerCloseToPed(pedx, pedy, pedz) and not Citizen.InvokeNative(0x84D0BF2B21862059, target) and not rendering then
                
                DrawTalk3D(bCoords.x, bCoords.y, bCoords.z+0.7, "R", "Kausapin")

                if IsControlJustPressed(0, 0xE30CD707) then
                    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 0, false)
                    DisplayRadar(false)
                    TriggerEvent("vorp_inventory:CloseInv")
                    TriggerEvent("vorp:showUi", false)
                    TriggerEvent("alpohud:toggleHud", false)
                    TriggerEvent("vorp_hud:toggleHud", false)
                    ClearPedTasksImmediately(ped)
                    ClearPedTasksImmediately(target)
                    makeEntityFaceEntity(ped, target)
                    makeEntityFaceEntity(target, ped)
                    if IsPedMale(target) then
                        -- TaskStartScenarioInPlace(target, GetHashKey('WORLD_HUMAN_BADASS'), -1, true, false, false, false)
                        TaskStandStill(target, -1) 
                    else
                        TaskStandStill(target, -1)           
                    end
                    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_INSPECT'), -1, true, false, false, false)
                    old = target
                    renderCam(old)
                end
            end
        end
        if rendering then
            hideHUD()
            DisableControlAction(0, 0x3076E97C, true)
            DisableControlAction(0, 0x8BDE7443, true)
            if IsEntityDead(ped) or IsPedRagdoll(ped) or IsControlJustPressed(0, 0x156F7119) or IsControlJustPressed(0, 0xF84FA74F) or IsControlJustPressed(0, 0x4AF4D473) or IsEntityDead(ped) or IsPedDeadOrDying(ped) then
                closed = true
                CloseCam(target)
            end
        else
            showHUD()
        end
        if closed then
            -- ClearPedTasks(target)
            closed = false
        end
        if not rendering and IsCinematicCamRendering() then
            hideHUD()
        elseif rendering and IsCinematicCamRendering() then
            hideHUD()
        elseif rendering and not IsCinematicCamRendering() then
            hideHUD()
        else
            showHUD()
        end
    end
end)

function IsPlayerNearNPC(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 5.0 then
        return true
    end
end

function DrawNPCDead3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("honor_display") or not HasStreamedTextureDictLoaded("rpg_textures") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("rpg_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 235, 0)
        DrawSprite("rpg_textures", "rpg_wounded", _x, _y+0.0135, 0.024, 0.04, 0.1, 255, 46, 46, 215, 0)
    end
end

function renderCam(old)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local ex, ey, ez = table.unpack(GetEntityCoords(ped, 0))
    local heading = GetEntityHeading(ped)

    interact = true
    closed = false
    rendering = true
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", ex, ey, ez+0.65, 0.0, 0.0, heading, 40.00, true, 1)
    SetCamFov(cam, 30.0)
    tempsbar = 1
    cameraBars()
    DoScreenFadeOut(10)
	Wait(10)
    DoScreenFadeIn(800)
    tempsbar = 1
	SetEntityAlpha(ped, 0.0, true)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)

    generateDialog(old)
end

function CloseCam(old)
    local ped = PlayerPedId()

    interact = false
    DestroyAllCams(true)
    tempsbar = 0
    cameraBars()
    ClearPedTasksImmediately(ped)
    SetNuiFocus(false, false)
    SendNUIMessage({})
    SetCinematicModeActive(false)
    EnableControlAction(0, 0x3076E97C, false)
    EnableControlAction(0, 0x8BDE7443, false)
    TaskStandStill(old, 0)
    DisplayRadar(true)
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("alpohud:toggleHud", true)
    TriggerEvent("vorp_hud:toggleHud", true)
    SetCamActive(cam, false)
    ResetEntityAlpha(ped)
    rendering = false
    closed = true
    startCooldown()
end

function showHUD()
    DisplayRadar(true)
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("alpohud:toggleHud", true)
    TriggerEvent("vorp_hud:toggleHud", true)
end

function hideHUD()
    DisplayRadar(false)
    TriggerEvent("vorp:showUi", false)
    TriggerEvent("alpohud:toggleHud", false)
    TriggerEvent("vorp_hud:toggleHud", false)
end

function cameraBars()
	Citizen.CreateThread(function()
		while tempsbar == 1 do
			Wait(5)
			N_0xe296208c273bd7f0(-1, -1, 0, 17, 0, 0)
		end
	end)
end

function IsPlayerHasSameGroundLevel(ped, target)
    local ped = PlayerPedId()

    local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
    local ex, ey, ez = table.unpack(GetEntityCoords(target, 0))

    if pz <= ez then
        return true
    end
end

function generateDialog(old)
    local nvm = ""
    local nvmRandom = math.random(0, 2)

    if nvmRandom == 0 then
        nvm = "Di bale na."
    elseif nvmRandom == 1 then
        nvm = "Nakalimutan ko and aking sasabihin."
    else
        nvm = "Gusto ko lang kamustahin ka."
    end

    if IsPedMale(old) then

        if GetEntityModel(old) == -1448273283 then

            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'updateStatusHud',
                show = toghud,
                gender = 'Officer',
                nvm = nvm
            })
        else

            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'updateStatusHud',
                show = toghud,
                gender = 'Male Villager',
                nvm = nvm
            })
        end
    else

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'updateStatusHud',
            show = toghud,
            gender = 'Female Villager'
        })
    end
end

function IsValidTarget(ped)
	return not IsPedDeadOrDying(ped) and IsPedHuman(ped) and not IsPedAPlayer(ped) and not IsPedRagdoll(ped)
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

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function startCooldown()
	cooldown = 10000
    if cooldown > 0 then
        Citizen.CreateThread(function()
            while cooldown > 0 do
                Wait(5)
                cooldown = cooldown - 1
            end
        end)
    end
end

function IsPlayerNearPed(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 32 and distance > 1.6 then
        return true
    end
end

function IsPlayerCloseToPed(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 1.5 and distance > 0.8 then
        return true
    end
end

function IsPlayerTooCloseToPed(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 0.5 then
        return true
    end
end

function IsEntityNearEntity(entity1, entity2, dist)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity1, 0))
    local ex2, ey2, ez2 = table.unpack(GetEntityCoords(entity2, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, ex2, ey2, ez2, true)

    if distance < dist then
        return true
    end
end

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
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

function DrawCheck3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px, py ,pz = table.unpack(GetGameplayCamCoord())

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("scoretimer_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("scoretimer_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("scoretimer_textures", "scoretimer_generic_tick", _x, _y, 0.018, 0.027, 0.1, 255, 255, 255, 215, 0)
    end
end

function DrawGreet3D(x, y, z, text, text2)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.27, 0.22)
    SetTextFontForCurrentCommand(0)
    SetTextColor(0, 0, 0, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.034)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.054,_y-0.038)

    if not HasStreamedTextureDictLoaded("multiwheel_emotes") or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("multiwheel_emotes", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.016, _y-0.025, 0.017, 0.029, 0.1, 0, 0, 0, 215, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.016, _y-0.025, 0.015, 0.027, 0.1, 215, 215, 215, 255, 0)

        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("multiwheel_emotes", "emote_greet", _x, _y, 0.018, 0.027, 0.1, 255, 255, 255, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
    end
end

function DrawTalk3D(x, y, z, text, text2) 
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.27, 0.22)
    SetTextFontForCurrentCommand(0)
    SetTextColor(0, 0, 0, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.034)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.047,_y-0.038)

    if not HasStreamedTextureDictLoaded("multiwheel_emotes") or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("multiwheel_emotes", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.016, _y-0.025, 0.017, 0.029, 0.1, 0, 0, 0, 215, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.016, _y-0.025, 0.015, 0.027, 0.1, 215, 215, 215, 255, 0)

        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("menu_textures", "menu_icon_alert", _x, _y, 0.018, 0.03, 0.1, 255, 255, 255, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
    end
end

function GetCurentTownName()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords, 1)

    if town_hash == GetHashKey("Annesburg") then        
        return "Annesburg"
    elseif town_hash == GetHashKey("Armadillo") then
        return "Armadillo"
    elseif town_hash == GetHashKey("Blackwater") then
        return "Cavite"
    elseif town_hash == GetHashKey("BeechersHope") then
        return "BeechersHope"
    elseif town_hash == GetHashKey("Braithwaite") then
        return "Braithwaite"
    elseif town_hash == GetHashKey("Butcher") then
        return "Butcher"
    elseif town_hash == GetHashKey("Caliga") then
        return "Caliga"
    elseif town_hash == GetHashKey("cornwall") then
        return "Cornwall"
    elseif town_hash == GetHashKey("Emerald") then
        return "Emerald"
    elseif town_hash == GetHashKey("lagras") then
        return "lagras"
    elseif town_hash == GetHashKey("Manzanita") then
        return "Manzanita"
    elseif town_hash == GetHashKey("Rhodes") then 
        return "Caloocan"
    elseif town_hash == GetHashKey("Siska") then
        return "Siska"
    elseif town_hash == GetHashKey("StDenis") then 
        return "Maynila"
    elseif town_hash == GetHashKey("Strawberry") then
        return "Baguio"
    elseif town_hash == GetHashKey("Tumbleweed") then
        return "Tumbleweed"
    elseif town_hash == GetHashKey("valentine") then
        return "Laguna"
    elseif town_hash == GetHashKey("VANHORN") then
        return "Vanhorn"
    elseif town_hash == GetHashKey("Wallace") then
        return "Wallace"
    elseif town_hash == GetHashKey("wapiti") then
        return "Wapiti"
    elseif town_hash == GetHashKey("AguasdulcesFarm") then
        return "Bicol"
    elseif town_hash == GetHashKey("AguasdulcesRuins") then
        return "Bicol"
    elseif town_hash == GetHashKey("AguasdulcesVilla") then
        return "Bicol"
    elseif town_hash == GetHashKey("Manicato") then
        return "Manicato"
    elseif town_hash == GetHashKey("Guarma") then
        return "Bicol"
    else
        return "Pilipinas"
    end
end

function DrawHealth3D(x, y, z, ped)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("rpg_menu_item_effects") then
        RequestStreamedTextureDict("rpg_menu_item_effects", false)
    else
        if GetEntityHealth(ped) <= 7 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_01", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 11 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_02", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 15 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_03", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 19 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_04", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 23 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_05", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 27 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_06", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 31 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_07", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 35 then
            DrawSprite("rpg_menu_item_effects", "effect_health_core_08", _x, _y+0.0125, 0.022, 0.038, 0.1, 148, 18, 9, 255, 0)
        elseif GetEntityHealth(ped) <= 39 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_1", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 43 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_2", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 47 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_3", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 51 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_4", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 55 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_5", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 59 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_6", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 63 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_7", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 67 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_8", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        elseif GetEntityHealth(ped) <= 71 then
            DrawSprite("rpg_menu_item_effects", "rpg_tank_9", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        else
            DrawSprite("rpg_menu_item_effects", "rpg_tank_10", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
            DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
        end
    end
end

function DrawBar3D(x, y, z, ped)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextDropshadow(4, 4, 21, 22, 255)

    -- SetEntityHealth(ped, 75, 0)

    if not HasStreamedTextureDictLoaded("hud_textures") then
        RequestStreamedTextureDict("hud_textures", false)
    else
        if GetEntityHealth(ped) <= 7 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0198, _y+0.0125, 0.005, 0.008, 0.1, 133, 25, 17, 215, 0)
        elseif GetEntityHealth(ped) <= 11 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0148, _y+0.0125, 0.015, 0.008, 0.1, 133, 25, 17, 215, 0)
        elseif GetEntityHealth(ped) <= 15 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0134, _y+0.0125, 0.018, 0.008, 0.1, 133, 25, 17, 215, 0)
        elseif GetEntityHealth(ped) <= 19 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0108, _y+0.0125, 0.023, 0.008, 0.1, 214, 151, 34, 215, 0)
        elseif GetEntityHealth(ped) <= 23 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0087, _y+0.0125, 0.027, 0.008, 0.1, 214, 151, 34, 215, 0)
        elseif GetEntityHealth(ped) <= 27 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0082, _y+0.0125, 0.028, 0.008, 0.1, 214, 151, 34, 215, 0)
        elseif GetEntityHealth(ped) <= 31 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0075, _y+0.0125, 0.030, 0.008, 0.1, 214, 151, 34, 215, 0)
        elseif GetEntityHealth(ped) <= 35 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0070, _y+0.0125, 0.031, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 39 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0067, _y+0.0125, 0.032, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 43 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0058, _y+0.0125, 0.034, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 47 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0052, _y+0.0125, 0.035, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 51 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0047, _y+0.0125, 0.036, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 55 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0039, _y+0.0125, 0.038, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 59 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0031, _y+0.0125, 0.039, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 63 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0023, _y+0.0125, 0.040, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 67 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0015, _y+0.0125, 0.042, 0.008, 0.1, 42, 176, 56, 215, 0)
        elseif GetEntityHealth(ped) <= 71 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0007, _y+0.0125, 0.044, 0.008, 0.1, 42, 176, 56, 215, 0)
        else
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.045, 0.008, 0.1, 42, 176, 56, 215, 0)
        end
    end
end


function DrawBarGradient3D(x, y, z, ped)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextDropshadow(4, 4, 21, 22, 255)

    -- SetEntityHealth(ped, 75, 0)

    if not HasStreamedTextureDictLoaded("hud_textures") or not HasStreamedTextureDictLoaded("honor_display") then
        RequestStreamedTextureDict("hud_textures", false)
        RequestStreamedTextureDict("honor_display", false)
    else
        if GetEntityHealth(ped) <= 7 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0198, _y+0.0125, 0.005, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 11 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0148, _y+0.0125, 0.015, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 15 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0134, _y+0.0125, 0.018, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 19 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0108, _y+0.0125, 0.023, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 23 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0087, _y+0.0125, 0.027, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 27 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0082, _y+0.0125, 0.028, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 31 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0075, _y+0.0125, 0.030, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 35 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0070, _y+0.0125, 0.031, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 39 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0067, _y+0.0125, 0.032, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 43 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0058, _y+0.0125, 0.034, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 47 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0052, _y+0.0125, 0.035, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 51 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0047, _y+0.0125, 0.036, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 55 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0039, _y+0.0125, 0.038, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 59 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0031, _y+0.0125, 0.039, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 63 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0023, _y+0.0125, 0.040, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 67 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0015, _y+0.0125, 0.042, 0.008, 0.1, 38, 97, 33, 215, 0)
        elseif GetEntityHealth(ped) <= 71 then
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x-0.0007, _y+0.0125, 0.044, 0.008, 0.1, 38, 97, 33, 215, 0)
        else
            DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 255, 0)
            DrawSprite("honor_display", "honor_bar_grad_half", _x, _y+0.0125, 0.045, 0.008, 0.1, 38, 97, 33, 255, 0)
        end
    end
end