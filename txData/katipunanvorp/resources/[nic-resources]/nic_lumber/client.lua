
local amount = 0
local sprite = -185399168
local oldTree, dBlip
local treeShareCoords
local chopDecide = false
local treeValue = 0
local noAxePrompt = false

local particle_effect_target = false
local particle_target_id = false

local is_particle_effect_active = false
local particle_target_id = false

local mainProp, globalLog, globalAxe, globalStump

local carryingLog = false
local paid = false
local paid = false

RegisterNetEvent('nic_lumber:chopTreeDecide')
AddEventHandler('nic_lumber:chopTreeDecide', function(bool, entityHit)
	if bool then
        TriggerEvent("nic_lumber:axe", entityHit)
	else
		noAxePrompt = true
		Citizen.Wait(3000)
		noAxePrompt = false
	end
end)

-- 3D prompts

CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()
		local px, py, pz = table.unpack(GetEntityCoords(ped, 0))

		if noAxePrompt then
			DrawText3D(px, py, pz+1.0, true, "You need an Axe")
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
		local ped = PlayerPedId()
		local px, py, pz = table.unpack(GetEntityCoords(ped, 0))

		if paid then
			DrawCoin3D(px, py, pz+1.06)
			DrawText3D(px, py, pz+1.0, true, "~COLOR_YELLOWSTRONG~+"..treeValue.." PHP")
		end
	end
end)

-- 3D prompts

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()
		local excludeEntity = ped
		local coords = GetEntityCoords(ped)
		local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 1.0, 1.0, 8.0, 0.0, 0.0, 0.0, true, 256, excludeEntity)
        local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
        excludeEntity = entityHit
		local model_hash = GetEntityModel(entityHit)
		local plantx, planty, plantz = table.unpack(GetEntityCoords(entityHit, 0))
		local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
        local ex, ey, ez = table.unpack(GetEntityCoords(entityHit, 0))
        local treeCoords = vector3(ex, ey, ez-50.0)
        local animation = "amb_work@world_human_tree_chop@male_a@base"

		if (model_hash == 274401399 or model_hash == 628372137 or model_hash == -952223380 or model_hash == -952223380 or model_hash == -412999584 or model_hash == 9982225 or model_hash == 964002300 or model_hash == -1033480603 or model_hash == 675906039 or model_hash == -1280509677 or model_hash == 83548913 or model_hash == 1647764180 or model_hash == 491752474 or model_hash == -105557501 or model_hash == -1078243089 or model_hash == 731261095 or model_hash == -790301886 or model_hash == -537953851 or model_hash == -483361333 or model_hash == -164348572 or model_hash == 1402550976 or model_hash == -1248229631 or model_hash == -706709595 or model_hash == 1270344049 or model_hash == -764239832 or model_hash == 1668164269 or model_hash == 491752474 or model_hash == 507910956) and oldTree ~= entityHit and not IsPedOnMount(ped) and not IsPedInAnyVehicle(ped) then

            if not IsEntityPlayingAnim(ped, animation, "base", 1) and not IsEntityAttachedToEntity(mainProp, ped) then
                DrawNearTree3D(plantx, planty, plantz+1.0, "BLIPS", "blip_weapon_tomahawk")

                local coords = vector3(ex+1.57, ey+0.8, ez)
                
                if IsEntityNearEntity(ped, entityHit, 1.5) and not IsEntityNearEntity(ped, mainProp, 1.5) then
                    DrawChopTree3D(ex, ey, ez+1.0, "E", "Chop Tree")
                    if IsControlJustPressed(0, 0xCEFD9220) then
                        TriggerServerEvent("nic_lumber:checkAxe", entityHit)
                    end
                end
            end
		end	
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		local ped = PlayerPedId()
		local animation = "mech_loco_m@generic@carry@ped@idle"
		
		if DoesEntityExist(mainProp) then

			if carryingLog and IsEntityAttachedToEntity(mainProp, ped) then

				DisablePlayerFiring(ped, true)

				DisableControlAction(0, 0x8FFC75D6, true) -- LSHIFT
				DisableControlAction(0, 0xD9D0E1C0, true) -- SPACE
				DisableControlAction(0, 0xE8342FF2, true) -- HOLDLALT
				DisableControlAction(0, 0xE31C6A41, true) -- M
				DisableControlAction(0, 0x8CC9CD42, true) -- X
				DisableControlAction(0, 0xE30CD707, true) -- R
				DisableControlAction(0, 0xB2F377E8, true) -- F

				if not IsEntityPlayingAnim(ped, animation, "idle", 31) then
					TaskPlayAnim(ped, animation, "idle", 2.0, 2.0, -1, 31, 0, false, false, false)
				end
			else
				RemoveBlip(dBlip)
				StartGpsMultiRoute(1, false, false)
				SetGpsMultiRouteRender(false)
			end
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Wait(5)
-- 		local ped = PlayerPedId()

-- 		if not IsEntityDead(ped) then
--             if DoesEntityExist(globalStump) then
--                 local sCoords = GetEntityCoords(globalStump)
--                 if not IsEntityNearCoords(globalStump, sCoords, 30.0) then
--                     DeleteEntity(globalStump)
--                 end
--             end
--         end
--     end
-- end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		local ped = PlayerPedId()
		local animation = "mech_loco_m@generic@carry@ped@idle"
		local coords = GetEntityCoords(ped)
		local zoneRadius = 8.0
		
		local logObject = GetClosestObjectOfType(coords.x, coords.y, coords.z, 8.0, GetHashKey("s_aplsd_log"), false, false, false)

		if DoesEntityExist(logObject) then
			mainProp = logObject
		end
        

		if not IsEntityDead(ped) then

			if IsPedRagdoll(ped) then
				if IsEntityAttachedToEntity(mainProp, ped) then
					StopAnimTask(ped, animation, "idle", 1.0)
					DetachEntity(mainProp, true, true)
                    carryingLog = false
				end
			else
				if DoesEntityExist(mainProp) then
					local propCoords = GetOffsetFromEntityInWorldCoords(mainProp, 0.0, 0.0, 0.0)
					local distanceCheck = #(coords - propCoords)
					local pCoords = GetEntityCoords(mainProp)
		
					if not IsPedGettingUp(ped) then
						if IsEntityNearEntity(ped, mainProp, 8.0) then
							if carryingLog and IsEntityAttachedToEntity(mainProp, ped) then

                                if not IsEntityNearCoords(ped, -1340.95, -270.77, 104.34, 10.0) then
                                    DrawDrop3D(pCoords.x, pCoords.y, pCoords.z, "E", "Drop")
                                else
                                    DrawSell3D(pCoords.x, pCoords.y, pCoords.z, "E", "Sell")
                                end
			
								if IsControlJustPressed(0, 0xCEFD9220) then
                                    dropLog(mainProp)
								end
							else
								if not IsEntityPlayingAnim(ped, animation, "idle", 31) then
									DrawDropped3D(pCoords.x, pCoords.y, pCoords.z+0.8, "overhead", "overhead_generic_arrow")
									if IsEntityNearEntity(ped, mainProp, 1.3) then
										DrawPickup3D(pCoords.x, pCoords.y, pCoords.z+0.8, "E", "Pickup") 
					
										if IsControlJustPressed(0, 0xCEFD9220) then
                                            pickupLog(mainProp)
										end
									end
								end
							end
						end
					end
				end
			end
		else
			if IsEntityAttachedToEntity(mainProp, ped) then
				StopAnimTask(ped, animation, "idle", 1.0)
				DetachEntity(mainProp, true, true)
                carryingLog = false
			end
		end
	end
end)

function IsEntityNearEntity(entity1, entity2, dist)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity1, 0))
    local ex2, ey2, ez2 = table.unpack(GetEntityCoords(entity2, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, ex2, ey2, ez2, true)

    if distance < dist then
        return true
    end
end

function IsEntityNearCoords(entity1, x, y, z, dist)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity1, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, x, y, z, true)

    if distance < dist then
        return true
    end
end

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function destroyCurrentTree(entity)
	local coords = GetEntityCoords(entity)
	stump = CreateObject(GetHashKey("p_treestump02x"), coords,  true,  true, true)
	PlaceObjectOnGroundProperly(stump)
	if IsEntityVisibleToScript(entity) then
		SetEntityVisible(entity, false)
	end
	SetEntityCollision(entity, false, false)
    globalStump = stump
end

function playNonLoopedParticle(entity, dict, particle, x, y, z, size)
    local new_ptfx_dictionary = dict
    local new_ptfx_name = particle
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_particle_effect_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do
                Citizen.Wait(5)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary)
            
            particle_target_id =  Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name, entity, x, y, z, 0, 0, 0, size, 0, 0, 0)
        else
            print("cant load ptfx dictionary!")
        end
    else
        if particle_target_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, particle_target_id) then
                Citizen.InvokeNative(0x459598F579C98929, particle_target_id, false)
            end
        end
        particle_target_id = false
        is_particle_effect_active = false	
    end
end

function playCoinAudio()
    local is_frontend_sound_playing = false
    local frontend_soundset_ref = "HUD_DOMINOS_SOUNDSET"
    local frontend_soundset_name =  "MONEY"

    if not is_frontend_sound_playing then           
        if frontend_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8,frontend_soundset_name, frontend_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5,frontend_soundset_name, frontend_soundset_ref, true, 0);  -- play sound frontend
        is_frontend_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F,frontend_soundset_name, frontend_soundset_ref)  -- stop audio
        is_frontend_sound_playing = false
    end
end

function stopNonLoopParticle()
	if particle_target_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, particle_target_id) then
			Citizen.InvokeNative(0x459598F579C98929, particle_target_id, false)
		end
	end
	particle_target_id = false
	particle_effect_target = false
end

-- 3D TEXT FUNCTION
----------------------------------------------------------------------------------------------------

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

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(w, h)
   SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
   SetTextCentre(centre)
   if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, x, y)
end

CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()
        local animation = "amb_work@world_human_tree_chop@male_a@base"

        RequestAnimDict(animation)
        while not HasAnimDictLoaded(animation) do
            Citizen.Wait(100)
        end
        
        if choppingTree then
            Wait(3000)
            chopEffect()
            Wait(2500)
            chopEffect()
            Wait(6000)
            chopEffect()
            Wait(2500)
            chopEffect()
            Wait(6000)
            chopEffect()
            Wait(700)
        end
    end
end)

function chopEffect()
    playNonLoopedParticle(globalLog, "core", "ent_col_tree_leaves_birch", 0.0, 0.0, 5.0, 0.5)
    playNonLoopedParticle(globalLog, "core", "ent_brk_tree_trunk_bark", 0.0, 0.0, 1.0, 1.5)
end

RegisterNetEvent('nic_lumber:axe')
AddEventHandler('nic_lumber:axe', function(entity)
	local propLog = entity
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local eCoords = GetEntityCoords(propLog)
	local duration = 20200

    local axe_name = 'p_axe02x'
    local axe = CreateObject(GetHashKey(axe_name), coords, true, true, true)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Finger12")
	local animation = "amb_work@world_human_tree_chop@male_a@base"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Citizen.Wait(100)
    end
    makeEntityFaceEntity(ped, propLog)
    globalLog = propLog
    globalAxe = axe
    local rotCoords = GetEntityRotation(ped)
	local cCoords = GetEntityCoords(ped)
    SetEntityCoords(ped, cCoords.x, cCoords.y, cCoords.z-1.0, false, false, false, false)
    SetEntityRotation(ped, rotCoords.x, rotCoords.y, rotCoords.z-50.0, 1, false)
    AttachEntityToEntity(axe, ped, boneIndex, 0.200, -0.0, 0.5010, 1.024, -160.0, -70.0, true, true, false, true, 1, true)
	FreezeEntityPosition(ped, true)
	ClearPedTasksImmediately(ped)
    choppingTree = true
    AnimpostfxPlay("CamTransitionBlink")
    TaskPlayAnim(ped, animation, "base", 8.0, -1, -1, 1, 0, true, 0, false, 0, false)
    exports['progressbar']:startUI(duration, "Chopping Tree")
    Citizen.Wait(duration)
    DeleteObject(axe)
    choppingTree = false
	ClearPedTasksImmediately(ped)
	FreezeEntityPosition(ped, false)
    destroyCurrentTree(propLog)
	spawnLog(propLog)
end)

function spawnLog(entity)
	local ped = PlayerPedId()
	local pCoords = GetEntityCoords(ped)
	local logEntity = entity
	local animation = "mech_loco_m@generic@carry@ped@idle"
	local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_UpperArm")
	local modelName = "s_aplsd_log"
    local treeCoords = GetEntityCoords(logEntity)
	local choppedTreeCoords = vector3(treeCoords.x, treeCoords.y, treeCoords.z+3.5)
    
    if not HasCollisionForModelLoaded(modelName) then
        RequestCollisionForModel(modelName)
    end

	log = CreateObject(GetHashKey(modelName), treeCoords.x, treeCoords.y, treeCoords.z+1.0,  true,  true, true)
	AttachEntityToEntity(log, globalStump, 0.0, 0.0, 0.0, 0.0, 100.0, 0.0, 0.0, true, true, false, true, 1, true)
	DetachEntity(log, true, true)
    SetEntityLoadCollisionFlag(log, true)
    Citizen.InvokeNative(0x5E1CC2E8DC3111DD, log, false)
    SetEntityCoords(log, treeCoords.x, treeCoords.y, pCoords.z+2.4)
    playNonLoopedParticle(log, "core", "ent_brk_tree_trunk_bark", 0.0, -2.0, 0.0, 2.0)
    playNonLoopedParticle(log, "core", "ent_col_tree_leaves_birch", 0.0, 2.0, 0.0, 0.5)
end

function dropLog(entity)
	local propLog = entity
	local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_UpperArm")
	local animDict = "mech_hogtie@deer"
	local animDict2 = "mech_loco_m@generic@carry@ped@idle"
	local animName = "hog_deer_drop_plyr"
    local duration = 5000

	RequestAnimDict(animDict)
	while ( not HasAnimDictLoaded(animDict)) do 
		Citizen.Wait( 100 )
	end

	RequestAnimDict(animDict2)
	while ( not HasAnimDictLoaded(animDict2)) do 
		Citizen.Wait( 100 )
	end

	ClearPedTasksImmediately(PlayerPedId())
	FreezeEntityPosition(ped, true)
    carryingLog = false
    TaskPlayAnim(ped, animDict, animName, 8.0, -1.0, 120000, 1, 0, true, 0, false, 0, false)
    Citizen.Wait(700)
    DetachEntity(propLog, true, true)
    PlaceObjectOnGroundProperly(propLog)
	FreezeEntityPosition(ped, false)
    StopAnimTask(ped, animDict, animName, 1.0)
    StopAnimTask(ped, animDict2, "idle", 1.0)
    
    if IsEntityNearCoords(ped, -1340.95, -270.77, 104.34, 10.0) then
        if not IsEntityAttachedToEntity(ped, propLog) then
            DeleteEntity(propLog)
            salary()
            TriggerServerEvent("nic_lumber:pay", treeValue)
            playCoinAudio()
            Citizen.Wait(3000)
            paid = false
        end
    end

end

function salary()
	local prize = 0
	for key, value in pairs(Config.settings) do
		prize = math.random(value.minSalary, value.maxSalary)
	end
	treeValue = prize
	paid = true
	return treeValue
end

function pickupLog(entity)
	local propLog = entity
	local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_UpperArm")
	local animDict = "mech_hogtie@deer"
	local animDict2 = "mech_loco_m@generic@carry@ped@idle"
	local animName = "hog_deer_tie_pickup_plyr"
    local duration = 5000

	RequestAnimDict(animDict)
	while ( not HasAnimDictLoaded(animDict)) do 
		Citizen.Wait( 100 )
	end

	RequestAnimDict(animDict2)
	while ( not HasAnimDictLoaded(animDict2)) do 
		Citizen.Wait( 100 )
	end

	ClearPedTasksImmediately(PlayerPedId())
	FreezeEntityPosition(ped, true)
    makeEntityFaceEntity(ped, propLog)
    TaskPlayAnim(ped, animDict, animName, 8.0, -1.0, 120000, 1, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
    AttachEntityToEntity(propLog, ped, boneIndex, 0.0, 0.60, 0.0, 50.0, 0.0, 0.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
	FreezeEntityPosition(ped, false)
    carryingLog = true
    StopAnimTask(ped, animDict, animName, 1.0)

    dBlip = N_0x554d9d53f696d002(203020899, -1340.95, -270.77, 104.34)
    SetBlipSprite(dBlip, -570710357, 1)
    StartGpsMultiRoute(1, true, true)
    AddPointToGpsMultiRoute(-1340.95, -270.77, 104.34)
    SetGpsMultiRouteRender(true)
end

function DrawCoin3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    if not HasStreamedTextureDictLoaded("mp_lobby_textures") then
        RequestStreamedTextureDict("mp_lobby_textures", false)
    else
        DrawSprite("mp_lobby_textures", "leaderboard_cash", _x, _y, 0.015, 0.028, 0.1, 206, 214, 62, 215, 0)
    end
end

function DrawPrompt3D(x, y, z, text, text2, dic, sprite)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.045,_y-0.038)

    if not HasStreamedTextureDictLoaded(dic) or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict(dic, false)
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite(dic, sprite, _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function DrawPickup3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.045,_y-0.038)

    if not HasStreamedTextureDictLoaded("multiwheel_emotes") or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("multiwheel_emotes", false)
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("multiwheel_emotes", "emote_greet_gentlewave", _x, _y, 0.018, 0.03, 0.1, 255, 255, 255, 150, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function DrawDrop3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.035,_y-0.038)

    if not HasStreamedTextureDictLoaded("multiwheel_emotes") or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("multiwheel_emotes", false)
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("multiwheel_emotes", "emote_greet_gentlewave", _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function DrawSell3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.035,_y-0.038)

    if not HasStreamedTextureDictLoaded("overhead") or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("overhead", false)
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("overhead", "overhead_cash_bag", _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function DrawDropped3D(x, y, z, dic, sprite)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.045,_y-0.038)

    if not HasStreamedTextureDictLoaded(dic) or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict(dic, false)
        RequestStreamedTextureDict("generic_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite(dic, sprite, _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
    end
end

function DrawNearTree3D(x, y, z, dic, sprite)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.045,_y-0.038)

    if not HasStreamedTextureDictLoaded(dic) or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict(dic, false)
        RequestStreamedTextureDict("generic_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite(dic, sprite, _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
    end
end

function DrawChopTree3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x+0.016,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.045,_y-0.038)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end


