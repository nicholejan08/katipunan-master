local notificationInSafeZone = false
local notificationOutSafeZone = false
local closestZoneIndex = 1


--Find and save  the nearest safezone location.
Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local minDistance = 100000
		for i = 1, #Config.zones, 1 do
			local betweencoords = GetDistanceBetweenCoords(coords, Config.zones[i].x, Config.zones[i].y, Config.zones[i].z, true)
			if betweencoords < minDistance then
				minDistance = betweencoords
				closestZoneIndex = i
			end
		end
		Citizen.Wait(15000)
	end
end)

-- Citizen.CreateThread(function()
-- 	while not NetworkIsPlayerActive(PlayerId()) do
-- 		Citizen.Wait(0)
-- 	end
-- 	for i = 1, #Config.zones, 1 do
-- 		local blip = -1282792512
-- 		SetBlipScale(blip, 0.5)
-- 		--Citizen.InvokeNative(0x554d9d53f696d002, 1560611276, Config.zones[i].x, Config.zones[i].y, Config.zones[i].z) -- Add blip icon<
-- 		Citizen.InvokeNative(0x45f13b7e0a15c880, blip, Config.zones[i].x, Config.zones[i].y, Config.zones[i].z, Config.safeRadius) -- Add yellow zone
-- 	end
-- end)

-- Disable Weapon Attack and Melee Attack
Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local betweencoords = GetDistanceBetweenCoords(coords, Config.zones[closestZoneIndex].x, Config.zones[closestZoneIndex].y, Config.zones[closestZoneIndex].z, true)
	
		if betweencoords >= Config.safeRadius then 
			NetworkSetFriendlyFireOption(true)
			if not notificationInSafeZone then
			SetEntityInvincible(playerPed, false) -- Not Invisible
			TriggerEvent("nic_prompt:theatre_off")
			TriggerEvent("nic_prompt:control_off")
			DisablePlayerFiring(playerPed, false) -- Enables firing all together if they somehow bypass inzone Mouse Enable
			EnableControlAction(0, 0x07CE1E61, false) -- Enable attack  control
			EnableControlAction(0, 0xB2F377E8, false) -- Enable MeleeAttack control
			EnableControlAction(0, 0x24978A28, false) -- Enable Horse Whistle
			-- EnableControlAction(0, 0x8CC9CD42, false) -- Enable Ragdoll control
				notificationInSafeZone = true
				notificationOutSafeZone = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetEntityInvincible(playerPed, true) -- Invisible
				-- Citizen.InvokeNative(0x5337B721C51883A9, PlayerPedId(), true, true)	Dismount Horse
				Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)	
				TriggerEvent("redemrp_notification:stop")
				TriggerEvent("nic_prompt:theatre_on")
				Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)	
				DisablePlayerFiring(playerPed, true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
				  DisableControlAction(0, 0x07CE1E61, true) -- Disable attack  control
				  DisableControlAction(0, 0xB2F377E8, true) -- Disable MeleeAttack control
				  DisableControlAction(0, 0x24978A28, true) -- Disable Horse Whistle
				--   DisableControlAction(0, 0x8CC9CD42, true) -- Disable Ragdoll control
				notificationOutSafeZone = true
				notificationInSafeZone = false
			end
		end
		if not notificationInSafeZone then
			SetEntityInvincible(playerPed, true) -- Invisible
			Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)	
			DisablePlayerFiring(playerPed, true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
			  DisableControlAction(0, 0x07CE1E61, true) -- Disable attack  control
			  DisableControlAction(0, 0xB2F377E8, true) -- Disable MeleeAttack control
			  DisableControlAction(0, 0x24978A28, true) -- Disable Horse Whistle
			--   DisableControlAction(0, 0x8CC9CD42, true) -- Disable Ragdoll control
			if IsDisabledControlJustPressed(0, 0x07CE1E61) or IsDisabledControlJustPressed(0, 0xB2F377E8) or IsDisabledControlJustPressed(0, 0x8CC9CD42) then 	
				-- TriggerEvent("redemrp_notification:start", "Bawal yan Kapatid", 2, "error")
				-- ShowNotification("You can not do that in safe zone.")
			elseif IsDisabledControlJustPressed(0, 0x24978A28) then 	
				-- TriggerEvent("redemrp_notification:start", "Bawal ka sumipol Kapatid", 2, "error")
			end
		end
	end
end)

local function ShowNotification( _message )
	local timer = 200
	while timer > 0 do
		DisplayHelp(_message, 0.50, 0.90, 0.6, 0.6, true, 161, 3, 0, 255, true, 10000)
		timer = timer - 1
		Citizen.Wait(0)
	end
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end