local lootingMoney = false
local gainXP = false
local lootMoney = 0
local lootItem = ""
local lootCount = 0
local lootxp = 0

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		Citizen.InvokeNative(0x6569F31A01B4C097, PlayerPedId(), 3, false)
		Citizen.InvokeNative(0x6569F31A01B4C097, PlayerPedId(), 1, false)

		Citizen.InvokeNative(0x6569F31A01B4C097, PlayerPedId(), 13, true)
		Citizen.InvokeNative(0x6569F31A01B4C097, PlayerPedId(), 0, true)
		Citizen.InvokeNative(0x6569F31A01B4C097, PlayerPedId(), 2, true)
	end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 1101824977) and not IsPedInAnyVehicle(player, true) and not looting then
			local shape = true
			while shape do
				Wait(0)
				local player = PlayerPedId()
				local coords = GetEntityCoords(player)
				local entityHit = 0
				local looted = false
				local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 8, player)
				local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
				local type = GetPedType(entityHit)
				local PressTime = 0
				if type == 4 then
					local looted = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
					if not looted then
						shape = false
						looting = true
						PressTime = GetGameTimer()
						while looting do
							Wait(0)

							if IsControlJustReleased(0,1101824977) then
								KeyHeldTime = GetGameTimer() - PressTime
								PressTime = 0
								if KeyHeldTime > 250 then
									looting = false
									Wait(500)
									local lootedcheck = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
									if lootedcheck then
										local count = 0
										local loot = math.random(1, 20)
										local lootpay = loot / 100
										local loot_xp = math.random (0, 3)
										local loot_xp_pay= loot_xp / 10
										lootMoney = lootpay
										lootCount = count
										lootxp = loot_xp_pay
										TriggerServerEvent('nic_loot:additem', item, count)
										lootItem = item
										TriggerServerEvent('vorp_loot', lootpay, loot_xp_pay)
										playLootAudio()
										lootingMoney = true
										Wait(800)
										gainXP = true
										Wait(3000)
										lootingMoney = false
										Wait(800)
										gainXP = false
									end
								end
							end
						end
					end
				end
			end
		end
    end
end)

function playLootAudio()
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

-- LOOTING PROMPT
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(0)
        local ped = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(ped))
        local bCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 21030))

        if lootingMoney then
			DrawCoin3D(bCoords.x, bCoords.y, bCoords.z+0.56)
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.5, "~COLOR_YELLOW~+"..lootMoney.." pesos")
        end
        if gainXP then
			DrawText3D(bCoords.x, bCoords.y, bCoords.z+0.40, "~COLOR_ORANGE~+"..lootxp.."xp")
        end
    end
end)

function timer()
	Citizen.Wait(5000)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextDropshadow(4, 4, 21, 22, 255)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
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