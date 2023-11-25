local mapOpened = false
local prop

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()

		if IsAppActive(`MAP`) ~= 0 and not mapOpened then
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			mapOpened = true
			takeOutMap()
            -- DisplayRadar(false)
            TriggerEvent("alpohud:toggleHud", false)
            TriggerEvent("vorp_hud:toggleHud", false)
            TriggerEvent("vorp_inventory:CloseInv")
		end
        if IsAppActive(`MAP`) ~= 1 and mapOpened then
            mapOpened = false
            hideMap()
            -- DisplayRadar(true)
            TriggerEvent("alpohud:toggleHud", true)
            TriggerEvent("vorp_hud:toggleHud", true)
            TriggerEvent("vorp_inventory:CloseInv")
            ClearPedTasks(playerPed) 
		end
	end
end)

function takeOutMap()
    local dic = "mech_inspection@two_fold_map@base"
    local anim = "hold_inspect_tilt_down"
    local playerPed = PlayerPedId()
    local bone = "SKEL_R_Hand"
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), bone)
    local propModel = "s_maprolledxglue_01x"
    local px, py, pz = table.unpack(GetEntityCoords(playerPed))

    RequestAnimDict(dic)
    while not HasAnimDictLoaded(dic) do
        Wait(100)
    end
    TaskPlayAnim(playerPed, dic, anim, 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    prop = CreateObject(GetHashKey(propModel), px, py, pz,  true,  true, true)
    AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.06, -0.27, 70.0, 88.0, 182.0, true, true, false, true, 1, true)
end

function hideMap()
    local anim = "mech_pickup@plant@gold_currant"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), anim, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(500)
    DeleteObject(prop, 1, 1)
    Citizen.Wait(800)
end