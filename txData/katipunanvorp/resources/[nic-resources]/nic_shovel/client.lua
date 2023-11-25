
local dig, promptItem, promptNothing, cooldown, stopTimer, displayTimer = false
local shovel
local mainTimer = 0
local selectedItem = ""

RegisterNetEvent('nic_shovel:useShovel')
AddEventHandler('nic_shovel:useShovel', function(bool)
	local player = PlayerPedId()
	
	if IsPedSwimming(PlayerPedId()) or IsPedOnMount(PlayerPedId()) or IsPedInMeleeCombat(PlayerPedId()) or IsEntityDead(PlayerPedId()) or IsPedRagdoll(PlayerPedId()) or IsPedRunning(PlayerPedId()) or IsPedSprinting(PlayerPedId()) or IsPedSwimming(PlayerPedId()) or IsPedWalking(PlayerPedId()) or IsPedJumping(PlayerPedId()) or IsPedOnMount(PlayerPedId()) or IsPedInMeleeCombat(PlayerPedId()) or IsPedFalling(PlayerPedId()) or IsEntityInAir(PlayerPedId()) or IsPedInAnyVehicle(PlayerPedId(), false) then
		TriggerEvent("vorp_inventory:CloseInv")
		notAllowedPrompt()
	else
		if not cooldown and not dig then
			TriggerEvent("vorp_inventory:CloseInv")
			dig = true
		else
			TriggerEvent("vorp_inventory:CloseInv")
			cooldownPrompt()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
		local player = PlayerPedId()

		if dig then
			TriggerEvent("vorp_inventory:CloseInv")
			Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)
			cooldown = true
			equipShovel()
		end
	end
end)

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

function cooldownPrompt()
    TriggerEvent("nic_prompt:cooldown_prompt_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:cooldown_prompt_off")
    return
end

function playKeepkAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
end

CreateThread(function()
	while true do
		Wait(0)
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
        if promptNothing then
			DrawText3D(px, py, pz+1.0, true, "~COLOR_WHITE~You got Nothing")
        end
        if promptItem then
			DrawText3D(px, py, pz+1.0, true, "~COLOR_GOLD~You got: ~COLOR_WHITE~"..selectedItem)
        end
	end
end)

function equipShovel()

	DeleteEntity(shovel)
	local animation = "amb_work@world_human_gravedig@working@male_b@base"
	local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Finger12")
	local propName = "p_hangingshovel03x"
	local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
	RequestAnimDict(animation)
	while ( not HasAnimDictLoaded(animation)) do 
		Citizen.Wait( 100 )
	end
	-- shovel = CreateObject(GetHashKey(propName), px, py, pz,  true,  true, true)
	-- AttachEntityToEntity(shovel, PlayerPedId(), boneIndex, -0.31, 0.23, -0.82, 50.0, 250.0, -110.0, true, true, false, true, 1, true)
	-- -- DetachEntity(shovel, 1, 1)
    -- TaskPlayAnim(PlayerPedId(), animation, "base", 8.0, -1.0, 120000, 1, 0, true, 0, false, 0, false)

	for key, value in pairs(Config.settings) do
		StartAnimation('script@mech@treasure_hunting@grab',0,'PBL_GRAB_01', 0,1, true, value.diggingDuration*1000)
		exports['progressbar']:startUI(value.diggingDuration*1000-3000, "Digging..")
		Citizen.Wait(value.diggingDuration*1000-2000)
	end

	ClearPedTasks(PlayerPedId())
	dig = false
	itemDecide()
end

function StartAnimation(animDict,flags,playbackListName,p3,p4,groundZ,time)
	Citizen.CreateThread(function()
		local player = PlayerPedId()
		local aCoord = GetEntityCoords(player)
		local pCoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -10.0, 0.0, 0.0)

		local pRot = GetEntityRotation(player)
		
		TaskStandStill(player, -1)


		if groundZ then
			local a, groundZ = GetGroundZAndNormalFor_3dCoord( aCoord.x, aCoord.y, aCoord.z + 10 )
			aCoord = {x=aCoord.x, y=aCoord.y, z=groundZ}
		end

		local animScene = Citizen.InvokeNative(0x1FCA98E33C1437B3, animDict, flags, playbackListName, 0, 1)
		-- SET_ANIM_SCENE_ORIGIN
		Citizen.InvokeNative(0x020894BF17A02EF2, animScene, aCoord.x, aCoord.y, aCoord.z, pRot.x, pRot.y, pRot.z, 2) 
		-- SET_ANIM_SCENE_ENTITY
		Citizen.InvokeNative(0x8B720AD451CA2AB3, animScene, "player", player, 0)
	    
	    	-- DIG UP A CHEST
	    	--local chest = CreateObjectNoOffset(GetHashKey('p_strongbox_muddy_01x'), pCoord, true, true, false, true)
	    	--Citizen.InvokeNative(0x8B720AD451CA2AB3, animScene, "CHEST", chest, 0)

	    	-- LOAD_ANIM_SCENE
	    	Citizen.InvokeNative(0xAF068580194D9DC7, animScene) 
	    	Citizen.Wait(1000)
	    	-- START_ANIM_SCENE
	    	print('START_ANIM_SCENE: '.. animScene)
	    	Citizen.InvokeNative(0xF4D94AF761768700, animScene) 
			ClearPedTasksImmediately(PlayerPedId())
	    	if time then
	    		Citizen.Wait(tonumber(time))	
	    	else
	   		Citizen.Wait(10000) 
	    	end
			
	    	-- SET CHEST AS OPENED AFTER DUG UP
	    	-- Citizen.InvokeNative(0x188F8071F244B9B8, chest, 1) -- found native sets CHEST as OPENED		
	    	
		-- _DELETE_ANIM_SCENE
	    	Citizen.InvokeNative(0x84EEDB2C6E650000, animScene) 
   	end) 
end

function itemDecide()
	local chance = 0
	local item = ''
	for key, value in pairs(Config.settings) do
		chance = math.random(value.minChance, value.maxChance)

		if chance == 1 then
			item = 'pandesal'
			TriggerServerEvent('nic_shovel:addItem', item)
			selectedItem = item
			giveItem(item)
			ClearPedTasks(PlayerPedId())
		elseif chance == 2 then
			item = 'banana'
			TriggerServerEvent('nic_shovel:addItem', item)
			selectedItem = item
			giveItem(item)
			ClearPedTasks(PlayerPedId())
		elseif chance == 3 then
			item = 'firstaid'
			TriggerServerEvent('nic_shovel:addItem', item)
			selectedItem = item
			giveItem(item)
		elseif chance == 4 then
			item = 'cigarette'
			TriggerServerEvent('nic_shovel:addItem', item)
			selectedItem = item
			giveItem(item)
		elseif chance == 5 then
			item = 'apple'
			TriggerServerEvent('nic_shovel:addItem', item)
			selectedItem = item
			giveItem(item)
		elseif chance == 6 then
			item = 'firstaid-s'
			TriggerServerEvent('nic_shovel:addItem', item)
			selectedItem = item
			giveItem(item)
		elseif chance == 7 then
			item = 'tango'
			TriggerServerEvent('nic_shovel:addItem', item)
			selectedItem = item
			giveItem(item)
		elseif chance == 8 then
			item = 'cornseed'
			giveItem(item)
		elseif chance == 9 then
			item = 'haycube'
			giveItem(item)
		elseif chance == 10 then
			item = 'corn'
			giveItem(item)
		elseif chance == 11 then
			item = 'horse_stim'
			giveItem(item)
		elseif chance > 11 and chance < (value.maxChance - (value.maxChance/1.5)) then -- more chance condition
			item = 'carrot'
			giveItem(item)
		else			
			Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, 796723886, 1, 1, 0, 0)
			promptNothing = true
			Citizen.Wait(3000)
			promptNothing = false
		end
		Citizen.Wait(value.cooldownTime*1000)
	end
	cooldown = false
	dig = false
end

function giveItem(item)
	TriggerServerEvent('nic_shovel:addItem', item)
	selectedItem = item
	promptItem = true
	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
	playKeepkAnimation()
	Citizen.Wait(2000)
	ClearPedTasks(PlayerPedId())
	Citizen.Wait(1000)
	promptItem = false
	selectedItem = ""
end

function IsPlayerNearTree(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

	if distance < 1.5 then
		return true
	end
end

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading-85.50)
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