

--  GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local name = ""

local size = 1.0
local prize = 0
local trashTalk = ""
local trashTalking = false

local npc, prop, prop2, enemy_prop, enemy_prop2, npcmodel, ref

local timeOutPrompt = false
local existed = false
local fightInprogress = false
local won = false
local existed = false
local winner = false
local pay = false
local lose = false
local enemyOut = false
local finishhim = false
local fight = false
local ready = false
local start = false
local enoughMoney = false
local enoughMoneyPrompt = false
local notFighterPrompt = false
local fightStarted = false
local knockoutPrompt = false

local playerKO = false
local enemyKO = false

local globalEnemyName = ""
local globalDifficulty = ""
local globalPrize = 0
local bet = 0
local cooldown = false

local enemyLife = 0
local plife = GetEntityHealth(ped)
local elife = GetEntityHealth(npc)

local tenSec = false

local keyStorage = 0
local chooseDifficulty = false
local outsideArena = false

local playerFName = ""
local playerLName = ""

SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)

-------------------------------------------------------------------------------------------------
---------------------------------------- EVENTS -------------------------------------------------
-------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_fightclub:cooldown')
AddEventHandler('nic_fightclub:cooldown', function()
    cooldown = true
	local timer = 0
    
    for key, value in pairs(Config.settings) do
        timer = value.cooldown
    end
	Citizen.CreateThread(function()
		while timer > 0 do
			Citizen.Wait(1000)
			timer = timer - 1
		end

        if timer == 85 then
            tenSec = true
        end

        if timer == 0 then
            cooldown = false
        end
	end)
end)

RegisterNetEvent('nic_fightclub:chooseDifficulty')
AddEventHandler('nic_fightclub:chooseDifficulty', function()
    chooseDifficulty = true
end)

RegisterNetEvent('nic_fightclub:enoughMoney')
AddEventHandler('nic_fightclub:enoughMoney', function()
    TriggerServerEvent('nic_fightclub:serverCheck')
end)

RegisterNetEvent('nic_fightclub:notEnoughMoney')
AddEventHandler('nic_fightclub:notEnoughMoney', function()
    enoughMoneyPrompt = true
    Citizen.Wait(4000)
    enoughMoneyPrompt = false
end)

RegisterNetEvent('nic_fightclub:clientCheckMoney')
AddEventHandler('nic_fightclub:clientCheckMoney', function()
    TriggerServerEvent('nic_fightclub:checkMoney', bet)
end)

RegisterNetEvent('nic_fightclub:notFighter')
AddEventHandler('nic_fightclub:notFighter', function()
    notFighterPrompt = true
    Citizen.Wait(4000)
    notFighterPrompt = false
end)

RegisterNetEvent('nic_fightclub:fightStarted')
AddEventHandler('nic_fightclub:fightStarted', function()
    fightStarted = true
    Citizen.Wait(4000)
    fightStarted = false
end)

RegisterNetEvent('nic_fightclub:triggerStart')
AddEventHandler('nic_fightclub:triggerStart', function()
    local ped = PlayerPedId()
    TriggerServerEvent("nic_fightclub:getName")
    TriggerServerEvent('nic_fightclub:loseMoney', bet)
    globalDifficulty = cDifficulty
    fightInprogress = true
    spawnEnemy()

    makeEntityFaceEntity(ref, npc)    
    TaskStartScenarioInPlace(ref, GetHashKey('WORLD_HUMAN_WRITE_NOTEBOOK'), -1, true, false, false, false)

    ClearPedTasksImmediately(ped)
    ClearPedTasksImmediately(npc)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_WAITING_IMPATIENT'), -1, true, false, false, false)
    TaskStartScenarioInPlace(npc, GetHashKey('WORLD_HUMAN_WAITING_IMPATIENT'), -1, true, false, false, false)
    FreezeEntityPosition(ped, true)
    FreezeEntityPosition(npc, true)
    ready = true
    TriggerEvent('nic:toggleUI', false)
    DisplayRadar(false)
    makeEntityFaceEntity(ped, npc)
    FreezeEntityPosition(ped, true)
    FreezeEntityPosition(npc, true)
    createCam()
    Citizen.Wait(1000)
    FreezeEntityPosition(ref, true)
    Citizen.Wait(2000)
    ready = false
    fight = true
    Citizen.Wait(500)
    destroyCam()
    ClearPedTasksImmediately(ped)
    ClearPedTasksImmediately(npc)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(npc, false)
    fight = false
    Citizen.InvokeNative(0xF166E48407BAC484, npc, ped)
    TriggerEvent("nic_fightclub:timer")
end)

RegisterNetEvent('nic:toggleUI')
AddEventHandler('nic:toggleUI', function(value)
    TriggerEvent("vorp:showUi", value)
    TriggerEvent("alpohud:toggleHud", value)
    TriggerEvent("vorp_hud:toggleHud", value)
end)

RegisterNetEvent('nic_fightclub:setName')
AddEventHandler('nic_fightclub:setName', function(fName, lName)
    playerFName = fName
    playerLName = lName
end)

RegisterNetEvent('nic_fightclub:wearGloves') -- Gloves
AddEventHandler('nic_fightclub:wearGloves', function()
    local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_Forearm")
	local boneIndex2 = GetEntityBoneIndexByName(ped, "SKEL_R_Forearm")
	local glove_L_model = 'boxing_gloves_left'
	local glove_R_model = 'boxing_gloves_right'
	prop = CreateObject(GetHashKey(glove_L_model), x, y, z+0.2,  true,  true, true)
	prop2 = CreateObject(GetHashKey(glove_R_model), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, ped, boneIndex, 0.32, 0.01, 0.04, 9.0, 88.0, 259.5, true, true, false, true, 1, true)
	AttachEntityToEntity(prop2, ped, boneIndex2, 0.3, 0.01, -0.04, 99.0, 0.0, 88.0, true, true, false, true, 1, true)
end)

RegisterNetEvent('nic_fightclub:enemyWearGloves') -- Gloves
AddEventHandler('nic_fightclub:enemyWearGloves', function()	
	local x,y,z = table.unpack(GetEntityCoords(npc))
	local boneIndex = GetEntityBoneIndexByName(npc, "SKEL_L_Forearm")
	local boneIndex2 = GetEntityBoneIndexByName(npc, "SKEL_R_Forearm")
	local glove_L_model = 'boxing_gloves_left'
	local glove_R_model = 'boxing_gloves_right'
	enemy_prop = CreateObject(GetHashKey(glove_L_model), x, y, z+0.2,  true,  true, true)
	enemy_prop2 = CreateObject(GetHashKey(glove_R_model), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(enemy_prop, npc, boneIndex, 0.32, 0.01, 0.04, 9.0, 88.0, 259.5, true, true, false, true, 1, true)
	AttachEntityToEntity(enemy_prop2, npc, boneIndex2, 0.3, 0.01, -0.04, 99.0, 0.0, 88.0, true, true, false, true, 1, true)
end)

RegisterNetEvent('nic_fightclub:timer')
AddEventHandler('nic_fightclub:timer', function()
	local timer = 0

    for key, value in pairs(Config.settings) do
        timer = value.roundTime
    end
    
	Citizen.CreateThread(function()
		while timer > 0 and fightInprogress and not IsEntityDead(npc) do
			Citizen.Wait(1000)
			timer = timer - 1
		end
        if timer == 0 then
            decide()
        end
	end)
	Citizen.CreateThread(function()
		while fightInprogress do
            Citizen.Wait(0)
            if timer > 10 then
                DrawTxt(timer.."", 0.5, 0.055, 1.0, 1.0, true, 181, 204, 242, 255, true) 
            else
                DrawTxt(timer.."", 0.5, 0.055, 1.0, 1.0, true, 184, 37, 0, 255, true)  
            end
		end
	end)
end)

RegisterNetEvent("nic_fightclub:finishhim")
AddEventHandler(
    "nic_fightclub:finishhim",
    function(toggle)
        SendNUIMessage(
            {
                type = "finishhim",
                display = toggle
            }
        )
    end
)

-------------------------------------------------------------------------------------------------
---------------------------------------- LOOPS -------------------------------------------------
-------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if not cooldown then
            if not DoesEntityExist(npc) and not fightInprogress and not chooseDifficulty and not IsEntityDead(ped) and not start and not existed then
                for key, value in pairs(Config.location.coords) do
                    if IsPlayerNearCoordsArea(value.x, value.y, value.z) and not enoughMoneyPrompt and not notFighterPrompt and not chooseDifficulty then
                        Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, value.x, value.y, value.z-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 192, 201, 85, 50, false, true, 2, false, false, false, false)
                        DrawFight3D(value.x, value.y, value.z+0.15)
                        DrawText3DSM(value.x, value.y, value.z+0.12, true, "~COLOR_YELLOWSTRONG~FIGHTCLUB") 
    
                        if IsPlayerNearCoords(value.x, value.y, value.z) and not fightInprogress and not existed and not start and not chooseDifficulty then
        
							DrawKey3D(value.x, value.y, value.z+0.3, "F", "Fight")
                
                            if (IsControlJustPressed(0, 0xB2F377E8)) and not exiting and not IsPedJumping(ped) and not IsPedRagdoll(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) and not IsPlayerDead(ped) and not IsPedFalling(ped) and not IsEntityInWater(ped) and not IsEntityInAir(ped) and not IsPedSprinting(ped) and not existed then                                
                                TriggerServerEvent('nic_fightclub:checkJob')
                            end
                        end              
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if fightInprogress then
            if tenSec then
                print("TEST")
                AnimpostfxPlay("MP_FreeRoamCountdown")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if fightInprogress then
            if not IsEntityDead(ped) or not IsEntityDead(npc) then
                if IsPedRagdoll(ped) then
                    playerKO = true
                    Wait(3000)
                    playerKO = false
                    trashTalking = false
                end

                if IsPedRagdoll(npc) then
                    enemyKO = true
                    Wait(3000)
                    enemyKO = false
                    trashTalking = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 21030))
        local eCoords = GetWorldPositionOfEntityBone(npc, GetPedBoneIndex(npc, 21030))
        local num = math.random(0, 5)
        local emote = math.random(0, 5)
        local expression
        
        if fightInprogress then
            if not trashTalking then
                if num == 0 then
                    trashTalk = "Oh bagsak! tang ina mo!"
                elseif num == 1 then
                    trashTalk = "Ano? kaya mo pang hayop ka?"
                elseif num == 2 then
                    trashTalk = "Bobo, amp!"
                elseif num == 3 then
                    trashTalk = "Mahinang nilalang!"
                elseif num == 4 then
                    trashTalk = "Hilo ka no?"
                elseif num == 5 then
                    trashTalk = "tang ina, Inom ka pa gatas"
                end
                
                if emote == 0 then
                    expression = 0x11B0F575
                elseif emote == 1 then
                    expression = 1879954891
                elseif emote == 2 then
                    expression = 0x43F71CA8
                elseif emote == 3 then
                    expression = 0x0CF840A9
                elseif emote == 4 then
                    expression = -221241824
                elseif emote == 5 then
                    expression = -2106738342
                end
                
                Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, expression, 1, 1, 0, 0)
                Citizen.InvokeNative(0xB31A277C1AC7B7FF, npc, 0, 0, expression, 1, 1, 0, 0)
                trashTalking = true
            end

            if not IsEntityDead(ped) and not IsEntityDead(npc) then
                if playerKO then
                    DrawText3DSM(bCoords.x, bCoords.y, bCoords.z+0.5, true, "~COLOR_YELLOWSTRONG~Knocked Out!")
                    DrawText3DSM(eCoords.x, eCoords.y, eCoords.z+0.5, true, "~COLOR_YELLOWSTRONG~"..trashTalk)
                end

                if enemyKO then
                    DrawText3DSM(eCoords.x, eCoords.y, eCoords.z+0.5, true, "~COLOR_YELLOWSTRONG~Knocked Out!")
                    DrawText3DSM(bCoords.x, bCoords.y, bCoords.z+0.5, true, "~COLOR_YELLOWSTRONG~"..trashTalk)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()

        if keyStorage == 0 then
            cDifficulty = "easy"
            bet = 10
        elseif keyStorage == 1 then
            cDifficulty = "normal"
            bet = 100
        elseif keyStorage == 2 then
            cDifficulty = "hard"
            bet = 250
        else
            cDifficulty = "insane"
            bet = 500
        end

        if chooseDifficulty then
                            
            for key, value in pairs(Config.location.coords) do
                if IsPlayerNearCoords(value.x, value.y, value.z) and not fightInprogress and not existed and not start and not enoughMoneyPrompt then
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, value.x, value.y, value.z-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 192, 201, 85, 50, false, true, 2, false, false, false, false)
                    
                        DrawText3DSM(value.x, value.y, value.z+0.12, true, "~COLOR_YELLOWSTRONG~Bet: ~COLOR_WHITE~"..bet.." Php")
                        DrawText3DSM(value.x, value.y, value.z, true, "Choose Difficulty")

                        if cDifficulty == 'easy' then
                            DrawText3D(value.x, value.y, value.z-0.13, true, "~COLOR_YELLOWSTRONG~"..cDifficulty)
                        elseif cDifficulty == 'normal' then
                            DrawText3D(value.x, value.y, value.z-0.13, true, "~COLOR_GREEN~"..cDifficulty)
                        elseif cDifficulty == 'hard' then
                            DrawText3D(value.x, value.y, value.z-0.13, true, "~COLOR_ORANGE~"..cDifficulty)
                        elseif cDifficulty == 'insane' then
                            DrawText3D(value.x, value.y, value.z-0.13, true, "~COLOR_RED~"..cDifficulty)
                        end
                        DrawText3D(value.x, value.y, value.z+0.25, true, "Press [~COLOR_YELLOWSTRONG~MOUSE1~COLOR_WHITE~] to Start the Fight")

                    if (IsControlJustPressed(0, 0x8BDE7443)) then
                        if keyStorage < 3 then
                            keyStorage = keyStorage + 1
                        else
                            keyStorage = 0
                        end
                    elseif (IsControlJustPressed(0, 0x3076E97C)) then
                        if keyStorage >= 0 then
                            keyStorage = keyStorage - 1
                        else
                            keyStorage = 2
                        end
                    end 

                    if (IsControlJustPressed(0, 0x07CE1E61)) and not exiting and not IsPedJumping(ped) and not IsPedRagdoll(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) and not IsPlayerDead(ped) and not IsPedFalling(ped) and not IsEntityInWater(ped) and not IsEntityInAir(ped) and not IsPedSprinting(ped) and not existed then
                        TriggerServerEvent("nic_fightclub:checkMoney", bet)
                    end                    
                else
                    chooseDifficulty = false          
                end
            end                  
        else
            chooseDifficulty = false  
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for key, value in pairs(Config.arena.coords) do
            local ex, ey, ez = value.x, value.y, value.z 
            if fightInprogress and outsideArena and not (IsEntityDead(npc) or IsEntityDead(ped)) then
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, value.x, value.y, value.z-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 255, 15, 15, 200, false, true, 2, false, false, false, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        for key, value in pairs(Config.location.coords) do
            if enoughMoneyPrompt then
                DrawAlert3D(value.x, value.y, value.z)
                DrawText3DSM(value.x, value.y, value.z, true, "You do not have enough Money to Fight")
            end    

            if notFighterPrompt then
                DrawAlert3D(value.x, value.y, value.z)
                DrawText3D(value.x, value.y, value.z, true, "You are not a Registered Fighter")
            end 

            if fightStarted then
                DrawAlert3D(value.x, value.y, value.z)
                DrawText3D(value.x, value.y, value.z, true, "Fight already started, try again later")
            end
        end    

        if knockoutPrompt then
            -- DrawTxt("KNOCKOUT!", 0.5, 0.1, 3.3, 3.3, true, 255, 14, 14, 200, true) 
        end

        if timeOutPrompt then
            DrawTxt("TIME OUT", 0.5, 0.1, 3.3, 3.3, true, 255, 14, 14, 255, true) 
        end

        -- if lose or winner then
        --     if outsideArena and not (IsEntityDead(npc) or IsEntityDead(ped)) then
        --         DrawTxt("OUTSIDE THE ARENA", 0.5, 0.1, 3.3, 3.3, true, 255, 14, 14, 255, true) 
        --     end
        -- end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        
        if fightInprogress then
            Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 6)  -- disable choking peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 4)  -- disable kicking peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 33)  -- disable tackling peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 5)  -- disable shoving peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 26)  -- disable arm grab
            Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 27)  -- disable leg grab
            Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 1)  -- disable grapple

            Citizen.InvokeNative(0xB8DE69D9473B7593, npc, 6)  -- disable choking peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, npc, 4)  -- disable kicking peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, npc, 33)  -- disable tackling peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, npc, 5)  -- disable shoving peds
            Citizen.InvokeNative(0xB8DE69D9473B7593, npc, 26)  -- disable arm grab
            Citizen.InvokeNative(0xB8DE69D9473B7593, npc, 27)  -- disable leg grab
            Citizen.InvokeNative(0xB8DE69D9473B7593, npc, 1)  -- disable grapple
        else
            Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 6)  -- enable choking peds
            Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 4)  -- enable kicking peds
            Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 33)  -- enable tackling peds
            Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 5)  -- enable shoving peds
            Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 26)  -- disable arm grab
            Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 27)  -- disable leg grab
            Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 1)  -- disable grapple
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local hurt = math.random(0, 72)
        local ragdoll = math.random(3000, 5000)
        local stumble = math.random(0, 1)
        local pos = GetEntityForwardVector(npc)

        if fightInprogress then
            if not IsEntityDead(ped) then
                if gotPunched(npc) then

                    if hurt == 2 then
                        if stumble == 0 and IsPedInMeleeCombat(npc) then
                            Citizen.InvokeNative(0xD76632D99E4966C8, npc, ragdoll, ragdoll, 1, -pos, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            Wait(5000)
                        else
                            Citizen.InvokeNative(0xAE99FB955581844A, npc, ragdoll, 0, 0, 0, 0, 0)
                        end
        
                    end
                end
            end
        end        
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local ex, ey, ez = 0.0, 0.0, 0.0

        if fightInprogress then
            if not IsEntityDead(ped) then

                for key, value in pairs(Config.arena.coords) do
                    ex, ey, ez = value.x, value.y, value.z
                end

                DrawTxt(playerFName.." "..playerLName, 0.15, 0.1, 0.5, 0.5, true, 255, 255, 255, 255, true)
                DrawTxt(""..globalEnemyName, 0.85, 0.1, 0.5, 0.5, true, 255, 255, 255, 220, true)

                if not IsEnemyNearFightingArena(ex, ey, ez) then

                    SetPedCanBeTargettedByPlayer(npc, PlayerId(), false)
                    SetPedCanBeTargetted(npc, false)
                    SetEntityCanBeDamaged(npc, false)

                    if globalDifficulty == 'easy' or globalDifficulty == 'normal' then
                        outsideArena = true
                        createEnemyKOCam()
                        victory()
                    end
                else
                    SetPedCanBeTargettedByPlayer(npc, PlayerId(), true)
                    SetPedCanBeTargetted(npc, true)
                    SetEntityCanBeDamaged(npc, true)
                end

                if IsPlayerNearFightingArena(ex, ey, ez) then

                   
                    if globalDifficulty == 'insane' or globalDifficulty == 'hard' then
                        Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, ex, ey, ez-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 8.0, 8.0, 0.5, 255, 15, 15, 200, false, true, 2, false, false, false, false)
                    elseif globalDifficulty == 'easy' or globalDifficulty == 'normal' then
                        Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, ex, ey, ez-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 8.0, 8.0, 0.5, 255, 255, 255, 80, false, true, 2, false, false, false, false)
                    end
                else
                    outsideArena = true
                    -- createPlayerKOCam()
                    defeat()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        
        if fightInprogress and DoesEntityExist(npc) and IsEntityDead(npc) and not chooseDifficulty and not start then
            SetPlayerMeleeWeaponDamageModifier(npc, 1.0)
            knockoutPrompt = true
            finishhim = false
            TriggerEvent("nic_fightclub:finishhim", false)
            createEnemyKOCam()
            Citizen.Wait(2000)
            victory()
        elseif fightInprogress and DoesEntityExist(npc) and IsEntityDead(ped) then
            knockoutPrompt = true
            -- createPlayerKOCam()
            defeat()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        plife = GetEntityHealth(ped)
        elife = GetEntityHealth(npc)

        if fightInprogress then
            DisableControlAction(0, 0x7F8D09B8, true)
            DisableControlAction(0, 0xCEE12B50, true)
            DisableControlAction(0, 0x8AAA0AD4, true)
            DisableControlAction(0, 0xE8342FF2, true)
            DisableControlAction(0, 0x8FFC75D6, true)
            DisableControlAction(0, 0xD9D0E1C0, true)
            DisableControlAction(0, 0x8CC9CD42, true)
            DisableControlAction(0, 0xDB096B85, true)
            DisableControlAction(0, 0x26E9DC00, true)
            toggleUI(plife, elife, true)
        else
            elife = 0
            toggleUI(plife, elife, false)
            EnableControlAction(0, 0x7F8D09B8, false)
            EnableControlAction(0, 0xCEE12B50, false)
            EnableControlAction(0, 0x8AAA0AD4, false)
            EnableControlAction(0, 0xE8342FF2, false)
            EnableControlAction(0, 0x8FFC75D6, false)
            EnableControlAction(0, 0xD9D0E1C0, false)
            EnableControlAction(0, 0x8CC9CD42, false)
            EnableControlAction(0, 0xDB096B85, false)
            EnableControlAction(0, 0x26E9DC00, false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
      Wait(1)
      local eHealth = GetEntityHealth(npc)
      if fightInprogress and globalDifficulty == 'hard' then
          if eHealth < (200/2) then
                eHealth = eHealth + 1
                SetEntityHealth(npc, eHealth, 0)
              Citizen.Wait(1000)
          end
      end
    end
end)

-- CreateThread(function()
-- 	while true do
-- 		Wait(0)
--         local ped = PlayerPedId()
--         local x, y, z = table.unpack(GetEntityCoords(ped))
--         local px, py, pz = table.unpack(GetEntityCoords(npc))
--         local playerHealth = GetEntityHealth(ped)
--         local enemyHealth = GetEntityHealth(npc)

--         if fightInprogress then
--             if enemyHealth < 20 and enemyHealth > 1 and not IsEntityDead(npc) then
--                 ClearPedTasks(npc)
--                 -- finishhim = true
--             end
--         end
--     end
-- end)

CreateThread(function()
	while true do
		Wait(0)
        local ped = PlayerPedId()
        local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 21030))
        local eCoords = GetWorldPositionOfEntityBone(npc, GetPedBoneIndex(npc, 21030))
        local x, y, z = table.unpack(GetEntityCoords(ped))
        local ex, ey, ez = table.unpack(GetEntityCoords(npc))
        for key, value in pairs(Config.settings) do
            if winner then
                DrawTxt("YOU WIN!", 0.5, 0.3, 5.3, 5.3, true, 255, 255, 0, 255, true)  
                DrawTxt("+"..prize.." Php", 0.5, 0.55, 2.5, 2.5, true, 255, 255, 255, 255, true)
            end
            if pay then
                DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, true, "~COLOR_SOCIAL_CLUB~+"..prize.." Php")
            end
            if lose then
                DrawTxt("YOU LOSE!", 0.5, 0.3, 5.3, 5.3, true, 255, 0, 0, 255, true)  
            end
            if enemyOut then
                DrawText3D(eCoords.x, eCoords.y, eCoords.z+0.5, true, "~COLOR_NET_PLAYER29~OUTSIDE THE ARENA")
            end
        end
    end
end)

CreateThread(function()
	while true do
		Wait(0)
        if ready then   
            DrawTxt("Prize: "..globalPrize.." Php", 0.55, 0.3, 0.65, 0.65, true, 255, 255, 255, 255, true)
            DrawTxt("READY", 0.65, 0.3, 4.5, 4.5, true, 191, 124, 42, 255, true)
        end
        if fight then
            DrawTxt("FIGHT!", 0.65, 0.3, 4.5, 4.5, true, 191, 124, 42, 255, true)
        end        
    end
end)

-------------------------------------------------------------------------------------------------
---------------------------------------- FUNCTIONS -------------------------------------------------
-------------------------------------------------------------------------------------------------

function stopAll()
    if IsPedInMeleeCombat(npc) then
        ClearPedTasksImmediately(npc)
    else
        ClearPedTasks(npc)
    end
    ClearPedTasks(ref)
    fightInprogress = false
    Citizen.Wait(1000) 
    Citizen.InvokeNative(0xB31A277C1AC7B7FF, npc, 0, 0, -402959, 1, 1, 0, 0)
    Citizen.Wait(500) 
    TaskWanderStandard(npc, 10, 10)
    TriggerEvent("vorp_hud:toggleHud", true)
    deleteObjects()
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("alpohud:toggleHud", true)
    destroyCam()
    DisplayRadar(true) 
    Citizen.Wait(1000)
    lose = false    
    Citizen.Wait(2000)
    castSpell(npc)
    castSpell(ref)
    outsideArena = false
    Citizen.Wait(1000)
    SetEntityInvincible(ped, true)
    local cx, cy, cz = table.unpack(GetEntityCoords(npc, 0))
    AddExplosion(cx, cy, cz-1.0, 12, 1.0, true, false, true)
    AddExplosion(cx, cy, cz, 33, 8, false, false, true)
    Wait(200)
    DeleteEntity(npc)
    local rx, ry, rz = table.unpack(GetEntityCoords(ref, 0))
    AddExplosion(rx, ry, rz-1.0, 12, 1.0, true, false, true)
    AddExplosion(rx, ry, rz, 33, 8, false, false, true)                    
    Wait(200)
    DeleteEntity(ref)                    
    SetEntityInvincible(ped, false)
    existed = false
    start = false
    chooseDifficulty = false
    TriggerEvent("nic_fightclub:cooldown")
end

function makeEntityFaceEntity(player, ped)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(ped, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function decide()
    local ped = PlayerPedId()
    local pHealth = GetEntityHealth(ped)
    local pMaxHealth = GetEntityMaxHealth(ped)
    local pPercent = pHealth / pMaxHealth

    local eHealth = GetEntityHealth(npc)
    local eMaxHealth = GetEntityMaxHealth(npc)
    local ePercent = eHealth / eMaxHealth

    ClearPedTasks(ref)
    fightInprogress = false
    timeOutPrompt = true
    
    if pPercent > ePercent then
        victory()
    else
        defeat()
    end
end

function victory()
    local ped = PlayerPedId()
    SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)

    if IsPedInMeleeCombat(npc) then
        ClearPedTasksImmediately(npc)
    else
        ClearPedTasks(npc)
    end

    ClearPedTasks(ref)
    
    Citizen.InvokeNative(0xB31A277C1AC7B7FF, npc, 0, 0, 796723886, 1, 1, 0, 0)       
    Citizen.Wait(1000)
    TaskWanderStandard(npc, 10, 10)
    for key, value in pairs(Config.location.coords) do
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", value.x, value.y, 95.91, -90.0, 0.0, 0.0, 0.00, false, 0)
        TriggerEvent("vorp:showUi", true)
        deleteObjects()
        TriggerEvent("vorp_hud:toggleHud", true)
        PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
        TriggerServerEvent('nic_fightclub:pay', prize)
        ClearPedTasks(ped)
        DisplayRadar(true)
        fightInprogress = false
        Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 0, 0, 1533402397, 1, 1, 0, 0)  
        Citizen.Wait(1000)
        pay = true
        TriggerEvent("alpohud:toggleHud", true)
        Citizen.Wait(500)
        winner = true
        Citizen.Wait(2000)
        destroyCam()
        outsideArena = false
        timeOutPrompt = false
        knockoutPrompt = false
        pay = false
        Citizen.Wait(1000)
        winner = false
        Citizen.Wait(1000)
        castSpell(npc)
        castSpell(ref)
        Citizen.Wait(1000)
        SetEntityInvincible(ped, true)
        local cx, cy, cz = table.unpack(GetEntityCoords(npc, 0))
        AddExplosion(cx, cy, cz-1.0, 12, 1.0, true, false, true)
        AddExplosion(cx, cy, cz, 33, 8, false, false, true)
        Wait(200)
        DeleteEntity(npc)

        local rx, ry, rz = table.unpack(GetEntityCoords(ref, 0))
        AddExplosion(rx, ry, rz-1.0, 12, 1.0, true, false, true)
        AddExplosion(rx, ry, rz, 33, 8, false, false, true)
        Wait(200)
        DeleteEntity(ref)

        existed = false
        SetEntityInvincible(ped, false)
        start = false
        chooseDifficulty = false
        TriggerEvent("nic_fightclub:cooldown")
        TriggerServerEvent("nic_fightclub:fightRefresh")
    end
end

function defeat()
    local ped = PlayerPedId()
    PlaySoundFrontend("Gain_Point", "HUD_MP_PITP", true, 1)
    SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)

    if IsPedInMeleeCombat(npc) then
        ClearPedTasksImmediately(npc)
    else
        ClearPedTasks(npc)
    end

    ClearPedTasks(ref)
    local cx, cy, cz = table.unpack(GetEntityCoords(npc, 0))  

    fightInprogress = false
    ClearPedTasks(npc)
    Citizen.Wait(1500)
    ClearPedTasksImmediately(npc)  
    Citizen.Wait(1000)
    lose = true
    Citizen.InvokeNative(0xB31A277C1AC7B7FF, npc, 0, 0, -402959, 1, 1, 0, 0)
    Citizen.Wait(500) 
    TaskWanderStandard(npc, 10, 10)
    TriggerEvent("vorp_hud:toggleHud", true)
    deleteObjects()
    TriggerEvent("vorp:showUi", true)
    TriggerEvent("alpohud:toggleHud", true)
    DisplayRadar(true) 
    -- destroyCam()
    Citizen.Wait(1000)
    timeOutPrompt = false
    knockoutPrompt = false
    lose = false 
    Citizen.Wait(1000)
    castSpell(npc)
    castSpell(ref)
    Citizen.Wait(1000)
    SetEntityInvincible(ped, true)
    local cx, cy, cz = table.unpack(GetEntityCoords(npc, 0))
    AddExplosion(cx, cy, cz-1.0, 12, 1.0, true, false, true)
    AddExplosion(cx, cy, cz, 33, 8, false, false, true)
    Wait(200)
    DeleteEntity(npc)

    local rx, ry, rz = table.unpack(GetEntityCoords(ref, 0))
    AddExplosion(rx, ry, rz-1.0, 12, 1.0, true, false, true)
    AddExplosion(rx, ry, rz, 33, 8, false, false, true)
    Wait(200)
    DeleteEntity(ref)

    SetEntityInvincible(ped, false)
    existed = false
    start = false
    chooseDifficulty = false
    TriggerEvent("nic_fightclub:cooldown")
end

function castSpell(ped)
    local ped = PlayerPedId()
    local animation = "amb_misc@world_human_pray_rosary@base"
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_Hand")
    local x, y, z = table.unpack(GetEntityCoords(ped))

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "base", 8.0, -8.0, 1000, 31, 0, true, 0, false, 0, false)
end

function toggleUI(plife, elife, display)
	SendNUIMessage({
		type = "ui",
		display = display,
        plife = plife,
        elife = elife
	})
end

function createCam()
    for key, value in pairs(Config.arena.coords) do
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", value.x, value.y+0.5, value.z+0.3, 0.0, 0.0, 113.0, 75.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 500, true, true, 0)
    end
end

function createEnemyKOCam()
    for key, value in pairs(Config.arena.coords) do
        local coords = vector3(value.x, value.y+2.0, value.z+1.0)  
        TriggerServerEvent('nic_fightclub:loseMoney', bet)   
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0.00, 0.00, 0.00, 75.00, false, 0)
        PointCamAtEntity(cam, npc, 1, 1, 0, true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end
end

function createPlayerKOCam()
    local ped = PlayerPedId()
    for key, value in pairs(Config.arena.coords) do
        local coords = vector3(value.x, value.y+2.0, value.z+2.0)  
        TriggerServerEvent('nic_fightclub:loseMoney', bet)   
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, 0.00, 0.00, 0.00, 75.00, false, 0)    
        PointCamAtEntity(cam, ped, 1, 1, 0, true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end
end

function destroyCam()
    SetCamActive(cam, false)
    DestroyAllCams()
end

function deleteObjects()
    DeleteObject(prop)
    DeleteObject(prop2)
    DeleteObject(enemy_prop)
    DeleteObject(enemy_prop2)
end

function gotPunched(entity)
    if Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, entity, 0xA2719263, 100) then
        return true
    end
end

function IsPlayerNearFightingArena(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)
    if distance < 4 then
        return true
    end
end

function IsEnemyNearFightingArena(x, y, z)
    local enemyx, enemyy, enemyz = table.unpack(GetEntityCoords(npc, 0))
    local distance = GetDistanceBetweenCoords(enemyx, enemyy, enemyz, x, y, z, true)
    if distance < 4 then
        return true
    end
end

function IsPlayerNearCoords(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)
    if distance < 1.0 then
        return true
    end
end

function IsPlayerNearCoordsArea(x, y, z)
    local ped = PlayerPedId()
    local playerx, playery, playerz = table.unpack(GetEntityCoords(ped, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)
    if distance < 5.0 then
        return true
    end
end

function cameraBars()
	Citizen.CreateThread(function()
		while tempsbar == 1 do
			Wait(0)
			N_0xe296208c273bd7f0(-1, -1, 0, 17, 0, 0)
		end
	end)
end

function spawnEnemy()
    local ped = PlayerPedId()

    if not DoesEntityExist(npc) and not existed then
        local refModel = "A_M_M_BlWUpperClass_01"

        if globalDifficulty == 'insane' then
            enemyLife = 200
            prize = 1000
            SetPlayerMeleeWeaponDamageModifier(PlayerId(), 0.1)
            npcmodel = "CS_WELSHFIGHTER"
            name = "Rocky"

            globalEnemyName = name
            globalPrize = prize

        elseif globalDifficulty == 'hard' then
            enemyLife = 200
            prize = 500
            npcmodel = "MP_PREDATOR"
            SetPlayerMeleeWeaponDamageModifier(PlayerId(), 0.4)
            name = "Cultist"

            globalEnemyName = name
            globalPrize = prize
            
        elseif globalDifficulty == 'normal' then
            enemyLife = 200
            prize = 200
            npcmodel = "A_M_M_RHDObeseMen_01"
            SetPlayerMeleeWeaponDamageModifier(PlayerId(), 1.0)
            name = "Kingpin"

            globalEnemyName = name
            globalPrize = prize
            
        elseif globalDifficulty == 'easy' then
            enemyLife = 200
            prize = 20
            npcmodel = "A_M_M_GuaTownfolk_01"
            SetPlayerMeleeWeaponDamageModifier(PlayerId(), 8.0)
            name = "Convict"

            globalEnemyName = name
            globalPrize = prize
            
        end
        
        RequestModel(GetHashKey(npcmodel))
        while not HasModelLoaded(GetHashKey(npcmodel)) do
            Wait(100)
        end
        
        for key, value in pairs(Config.arena.coords) do
            npc = CreatePed(npcmodel, value.x-1.0, value.y-0.6, value.z-1.0, 283.03, true, true)
        end
        
        SetEntityInvincible(npc, true)
        SetPedMaxHealth(npc, enemyLife)
        SetEntityHealth(npc, enemyLife, 0)
        
        local cx, cy, cz = table.unpack(GetEntityCoords(npc, 0))
        Wait(100)
        -- AddExplosion(cx, cy, cz-1.0, 12, 1.0, true, false, true)
        -- AddExplosion(cx, cy, cz, 33, 8, false, false, true)
        Wait(100)
        SetEntityInvincible(npc, false)

        PlaceObjectOnGroundProperly(1, 1)
        makeEntityFaceEntity(npc, ped)
        SetPedNameDebug(npc, name)
        SetPedPromptName(npc, name)
        SetPedRandomComponentVariation(npc, 2)
        SetBlockingOfNonTemporaryEvents(npc, false)
        SetEntityInvincible(npc, false)
        SetPedCanBeTargettedByPlayer(npc, ped, false)

        makeEntityFaceEntity(npc, ped)

        for key, value in pairs(Config.settings) do
            if value.gloves then
                TriggerEvent('nic_fightclub:wearGloves')
                TriggerEvent('nic_fightclub:enemyWearGloves')
            end
        end

        RequestModel(GetHashKey(refModel))
        while not HasModelLoaded(GetHashKey(refModel)) do
            Wait(100)
        end

        local pHeading = GetEntityHeading(ped)
        
        for key, value in pairs(Config.location.coords) do
            ref = CreatePed(refModel, value.x, value.y, value.z, pHeading, true, true)
        end
        SetEntityInvincible(ref, true)
        local rx, ry, rz = table.unpack(GetEntityCoords(ref, 0))
        Wait(100)
        -- AddExplosion(rx, ry, rz-1.0, 12, 1.0, true, false, true)
        -- AddExplosion(rx, ry, rz, 33, 8, false, false, true)
        Wait(100)
        SetEntityInvincible(ref, false)

        PlaceObjectOnGroundProperly(1, 1)
        makeEntityFaceEntity(ref, ped)
        SetPedNameDebug(ref, 'Referee')
        SetPedPromptName(ref, 'Referee')
        SetPedAsGroupMember(ref, GetPedGroupIndex(3))
        SetPedRandomComponentVariation(ref, 2)
        SetBlockingOfNonTemporaryEvents(ref, true)
        SetEntityInvincible(ref, false)
        SetPedCanBeTargetted(ref, false)
        SetPedCanBeTargettedByPlayer(ref, ped, false)
        SetPedCanBeTargetted(ref, false)
        SetEntityCanBeDamaged(ref, false)
    end
end

-- UTILS FUNCTION
----------------------------------------------------------------------------------------------------

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    --Citizen.InvokeNative(0x66E0276CC5F6B9DA, 2)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

function DrawText3D(x, y, z, enableShadow, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.45, 0.45)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawText3DSM(x, y, z, enableShadow, text)
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

function DrawFight3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z+0.2)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.10, 0.10)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("multiwheel_emotes") or not HasStreamedTextureDictLoaded("honor_display") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("multiwheel_emotes", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 175, 0)
        DrawSprite("multiwheel_emotes", "emote_threaten", _x, _y+0.0122, 0.017, 0.026, 0.1, 255, 255, 255, 215, 0)
    end
end

function makeEntityFaceEntity(player, clone)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(clone, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function DrawAlert3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z+0.2)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.10, 0.10)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("honor_display") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 175, 0)
        DrawSprite("menu_textures", "menu_icon_alert", _x, _y+0.0122, 0.017, 0.032, 0.1, 255, 255, 255, 215, 0)
    end
end

function DrawKey3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.28, 0.28)
    SetTextFontForCurrentCommand(1)
    SetTextColor(0, 0, 0, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x+0.017,_y-0.036)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.027,_y-0.038)

    if not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.017, _y-0.025, 0.017, 0.029, 0.1, 0, 0, 0, 255, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.017, _y-0.025, 0.015, 0.027, 0.1, 215, 215, 215, 255, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        -- DrawSprite("overhead", "overhead_normal", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 255, 255, 255, 185, 0)
    end
end