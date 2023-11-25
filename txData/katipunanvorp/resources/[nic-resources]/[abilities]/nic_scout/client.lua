
local transformed, inprogress, flying = false
local tempsbar = 0
local clone
local sx, sy, sz
local powerAcquired = false
local scout = true
local nx, ny, nz = 0, 0, 0


-- TriggerServerEvent('nic_scout:initiatePower')

FreezeEntityPosition(PlayerPedId(), false)

RegisterNetEvent('nic_scout:Initialize')
AddEventHandler('nic_scout:Initialize', function(source)
    scout = true
    powerAcquired = true
end)

RegisterNetEvent('nic_scout:usePower')
AddEventHandler('nic_scout:usePower', function(source)              
    inprogress = true
    cloneSelf()
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
        local cx, cy, cz = table.unpack(GetEntityCoords(clone, 0))

        if IsControlJustPressed(0, 0xCEE12B50) and not flying then
            TriggerServerEvent("nic_scout:checkJob")

            if powerAcquired and not scout then
                TriggerServerEvent("nic_scout:usePower")
            end
        end

    end
end)


-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         if IsControlJustPressed(0, 0xD8F73058) then
--             TaskJump(PlayerPedId(), true)
--         end
--     end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         if transformed then
--             SetEntityInvincible(PlayerPedId(), true)
--         else
--             SetEntityInvincible(PlayerPedId(), false)
--         end
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local height = GetEntityHeightAboveGround(PlayerPedId())
        
        if inprogress and flying then
            if transformed and height < 9 or (IsControlJustPressed(0, 0xCEE12B50) and flying) then
                fadeScreen()
            end
        end
    end
end)


RegisterNetEvent('nic_scout:clone')
AddEventHandler('nic_scout:clone', function()
    local coords = vector3(nx, ny, nz)
    
    clone = ClonePed(PlayerPedId(), 0.0, true, true)
    SetEntityInvincible(clone, true)
    SetEntityCoords(clone, coords)
    PlaceObjectOnGroundProperly(clone)
    TaskSetCrouchMovement(clone, true, 1, true)
    FreezeEntityPosition(clone, true)
    print(coords)
end)

function cloneSelf()
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local coords = vector3(px, py, pz-1.0)

    nx, ny, nz = px, py, pz

    ClearPedTasks(PlayerPedId())
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_PLAYER_DYNAMIC_KNEEL'), -1, true, false, false, false)
	Wait(2000)
    DoScreenFadeOut(2000)
	Wait(2000)
    TriggerServerEvent('nic_scout:triggerServer')
    SetMonModel('A_C_Raven_01')
    tempsbar = 1
    cameraBars()
	Wait(1000)
    DisplayRadar(false)
    TriggerEvent("vorp:showUi", false)
    TriggerEvent("alpohud:toggleHud", false)
    TriggerEvent("vorp_hud:toggleHud", false)
	DoScreenFadeIn(2000)
	Wait(2000)
    flying = true
end


function fadeScreen()
    local cx, cy, cz = table.unpack(GetEntityCoords(clone, 0))
    local cCoords = vector3(cx, cy, cz)
    SetEntityCoords(PlayerPedId(), cCoords)
    DeleteEntity(clone)
    AnimpostfxStop("PlayerDrugsPoisonWell")
    DoScreenFadeOut(1000)
    DisplayRadar(true)
    ExecuteCommand('rc')
    ExecuteCommand('reloadcloths')
    DoScreenFadeOut(2000)
	Wait(2000)
    cameraBars()
    tempsbar = 1
	Wait(3000)
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("alpohud:toggleHud", true)
    TriggerEvent("vorp_hud:toggleHud", true)
	DoScreenFadeIn(2000)
	Wait(2000)
    tempsbar = 0
    transformed = false
    inprogress = false
    flying = false
end

function cameraBars()
	Citizen.CreateThread(function()
		while tempsbar == 1 do
			Wait(0)
			N_0xe296208c273bd7f0(-1, -1, 0, 17, 0, 0)
		end
	end)
end

function SetMonModel(name)
	local model = GetHashKey(name)
	local player = PlayerId()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local playerCoords = vector3(x, y, z+23)

	
	if not IsModelValid(model) then return end
	PerformRequest(model)
	
	if HasModelLoaded(model) then
		Citizen.InvokeNative(0xED40380076A31506, player, model, false)
		Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), true)
		SetModelAsNoLongerNeeded(model)
        SetEntityCoords(PlayerPedId(), playerCoords)
        transformed = true
        AnimpostfxPlay("PlayerDrugsPoisonWell")
        Citizen.InvokeNative(0xE86A537B5A3C297C, PlayerPedId(), 1)
        -- FreezeEntityPosition(PlayerPedId(), true)
	end

end

function PerformRequest(hash)
    RequestModel(hash, 0)
    local bacon = 1
    while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, hash) do
        Citizen.InvokeNative(0xFA28FE3A6246FC30, hash, 0)
        bacon = bacon + 1
        Citizen.Wait(0)
        if bacon >= 100 then
            break
        end
    end
end