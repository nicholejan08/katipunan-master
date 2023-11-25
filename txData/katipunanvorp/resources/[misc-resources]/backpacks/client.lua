
local sack
local reppu1
local reppu2
local reppu3
local flag
local helmet
local plywood
local barrel
local barrel2
local barrel3
local barrel4
local barrel5
local medbox
local plywoodCover = false
local holdingToFront = false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsEntityAttachedToEntity(barrel, PlayerPedId()) then
			TriggerEvent("nic_prompt:peeing_prompt_off")
			DisableControlAction(0, 0xDB096B85, true) -- Disable CTRL control
			DisableControlAction(0, 0xE8342FF2, true) -- Disable ALT control
			TriggerEvent("nic_prompt:armor_on")
		else	
			TriggerEvent("nic_prompt:armor_off")
		end

		if IsControlJustPressed(0, 0x4CC0E2FE) then
			DetachProps()
			EnableControlAction(0, 0xE8342FF2, false) -- Enable ALT control
			TriggerEvent("nic_prompt:armor_off")
		end
		
	end 
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Hand")
		local boneIndex2 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")
		RequestAnimDict("mech_loco_m@character@arthur@carry@crate_tnt@walk") 
        while ( not HasAnimDictLoaded("mech_loco_m@character@arthur@carry@crate_tnt@walk" ) ) do 
            Citizen.Wait( 100 )
        end
		if IsEntityAttachedToEntity(plywood, playerPed) and IsControlJustPressed(0, 0x26E9DC00) then
			if not plywoodCover then
				Citizen.InvokeNative(0xFCCC886EDE3C63EC, playerPed, 1, true)
				holdingToFront = true
				TaskPlayAnim(PlayerPedId(), "mech_loco_m@character@arthur@carry@crate_tnt@walk", "walk", 8.0, -8.0, 120000, 31, 0, true, 0, false, 0, false)
				AttachEntityToEntity(plywood, playerPed, boneIndex, 0.15, -0.30, 0.40, -100.0, 80.0, 0.0, true, true, false, true, 1, true)
				plywoodCover = true
			else
				holdingToFront = false
				ClearPedTasks(playerPed)
				AttachEntityToEntity(plywood, playerPed, boneIndex2, -0.55, -0.42, -0.05, 155.0, 270.0, 175.5, true, true, false, true, 1, true)
				plywoodCover = false
			end
		end
		if IsPedRagdoll(PlayerPedId()) then
			ClearPedTasks(playerPed)
			AttachEntityToEntity(plywood, playerPed, boneIndex2, -0.55, -0.42, -0.05, 155.0, 270.0, 175.5, true, true, false, true, 1, true)
			plywoodCover = false
       end
	end 
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(plywood))
		if IsEntityAttachedToEntity(plywood, playerPed) then
			if not plywoodCover then
				DrawText3D(px, py, pz, "~COLOR_YELLOW~[Z] ~COLOR_WHITE~ switch to front")
			else	
				DrawText3D(px, py, pz, "~COLOR_YELLOW~[Z] ~COLOR_WHITE~ switch to back")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		if IsEntityAttachedToEntity(plywood, playerPed) then
			if holdingToFront then
				DisablePlayerFiring(playerPed, true)
				DisableControlAction(0, 0xF84FA74F, true) -- Disable Aim control
			end
		else
			holding = false
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityDead(PlayerPedId()) then
			DetachProps()
			holdingToFront = false
			EnableControlAction(0, 0xE8342FF2, false) -- Enable ALT control
			TriggerEvent("nic_prompt:armor_off")
        end      
    end
end)

function DetachProps()
	DetachEntity(sack, 1, 1)
	DetachEntity(reppu1, 1, 1)
	DetachEntity(reppu2, 1, 1)
	DetachEntity(reppu3, 1, 1)
	DetachEntity(helmet, 1, 1)
	DetachEntity(flag, 1, 1)
	DetachEntity(plywood, 1, 1)
	DetachEntity(barrel, 1, 1)
	DetachEntity(medbox, 1, 1)
	DetachEntity(barrel2, 1, 1)
	DetachEntity(barrel3, 1, 1)
	DetachEntity(barrel4, 1, 1)
	DetachEntity(barrel5, 1, 1)
	Wait(4000)
	DetachEntity(sack, 1, 1)
	DeleteObject(reppu1)
	DeleteObject(reppu2)
	DeleteObject(reppu3)
	DeleteObject(helmet)
	DeleteObject(flag)
	DeleteObject(plywood)
	DeleteObject(barrel)
	DeleteObject(medbox)
	DeleteObject(barrel2)
	DeleteObject(barrel3)
	DeleteObject(barrel4)
	DeleteObject(barrel5)
end

function PropTime()
	TriggerEvent("nic_prompt:armor_off")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_on")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_off")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_on")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_off")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_on")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_off")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_on")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_off")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_on")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_off")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_on")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_off")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_on")
	Citizen.Wait(50)
	TriggerEvent("nic_prompt:armor_off")
end

RegisterNetEvent("Perry_Reput:PoistaReppu")
AddEventHandler("Perry_Reput:PoistaReppu",function()
	DeleteObject(prop)
end)

RegisterCommand('putawaypack', function()
  TriggerEvent("Perry_Reput:PoistaReppu")
end)

RegisterNetEvent('Perry_Reput:sack') -- Sack
AddEventHandler('Perry_Reput:sack', function()
	boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine2")
	
	local sack_name = 'p_cs_vegsack_up'
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	sack = CreateObject(GetHashKey(sack_name), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(sack, playerPed, boneIndex, -0.27, -0.41, -0.01, 335.0, 91.0, 0.0, true, true, false, true, 1, true)
	Wait(120000)
	DetachEntity(sack, 1, 1)
	Wait(4000)
	DeleteObject(sack)
end)

RegisterNetEvent('Perry_Reput:reppu1') -- Näppäimistö
AddEventHandler('Perry_Reput:reppu1', function()
	boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")
	
	local reppu1_name = 'p_floursack06x'
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	reppu1 = CreateObject(GetHashKey(reppu1_name), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(reppu1, playerPed, boneIndex, -0.32, -0.38, -0.05, 155.0, 270.0, 172.5, true, true, false, true, 1, true)
	Wait(120000)
	DetachEntity(reppu1, 1, 1)
	Wait(4000)
	DeleteObject(reppu1)
end)

RegisterNetEvent('Perry_Reput:reppu2') -- Näppäimistö
AddEventHandler('Perry_Reput:reppu2', function()
	boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")	
	local reppu2_name = 'p_cs_bucket01bx'
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    reppu2 = CreateObject(GetHashKey(reppu2_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(reppu2, playerPed, boneIndex, 0.08, -0.07, -0.00, 94.5, 0.0, 21.5, false, true, false, false, 1, true)
	Wait(120000)
	DetachEntity(reppu2, 1, 1)
	Wait(4000)
	DeleteObject(reppu2)
end)

RegisterNetEvent('Perry_Reput:reppu3') -- Näppäimistö
AddEventHandler('Perry_Reput:reppu3', function()
	boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")
	local reppu3_name = 'p_ambpack01x'
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	reppu3 = CreateObject(GetHashKey(reppu3_name), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(reppu1, playerPed, boneIndex, -0.32, -0.38, -0.05, 155.0, 270.0, 172.5, true, true, false, true, 1, true)
	Wait(120000)
	DetachEntity(reppu3, 1, 1)
	Wait(4000)
	DeleteObject(reppu3)
end)

RegisterNetEvent('nic_attach:medbox') -- Näppäimistö
AddEventHandler('nic_attach:medbox', function()
	boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")	
	local medbox_name = 'p_boxmedmedical01x'
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    medbox = CreateObject(GetHashKey(medbox_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(medbox, playerPed, boneIndex, 0.08, -0.07, -0.00, 94.5, 0.0, 21.5, false, true, false, false, 1, true)
	Wait(120000)
	DetachEntity(medbox, 1, 1)
	Wait(4000)
	DeleteObject(medbox)
end)

RegisterNetEvent('nic_attach:helmet') -- Näppäimistö
AddEventHandler('nic_attach:helmet', function(prop)
	boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Head")
	local helmet_name = 'p_cs_bucket01bx'
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	helmet = CreateObject(GetHashKey(helmet_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(helmet, playerPed, 144, 0.24, -0.01, -0.00, 155.0, 115.0, 82.5, true, true, false, true, 1, true)
	Wait(120000)
	DetachEntity(helmet, 1, 1)
	Wait(4000)
	DeleteObject(helmet)
end)

RegisterNetEvent('nic_attach:flag') -- Flag
AddEventHandler('nic_attach:flag', function()
	local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")
	local flag_name = 'mp001_p_mp_flag01x'
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    flag = CreateObject(GetHashKey(flag_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(flag, playerPed, boneIndex, -0.57, -0.22, -0.05, 158.0, 295.0, 132.5, true, true, false, true, 1, true)
end)

function DetachArmor()
	DetachEntity(barrel, 1, 1)
	DetachEntity(helmet, 1, 1)
	Citizen.Wait(4000)
	DeleteObject(barrel)
	DeleteObject(helmet)
end

function DetachPlywood()
	DetachEntity(plywood, 1, 1)
	Citizen.Wait(4000)
	DeleteObject(plywood)
end

RegisterNetEvent('nic_attach:plywood') -- Plywood
AddEventHandler('nic_attach:plywood', function()
	local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")
	local playerPed = PlayerPedId()
	ClearPedTasks(PlayerPedId())
	local plywood_name = 'p_cratedamagedebris01x_sea' --p_crateweaponsbreak02x
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    plywood = CreateObject(GetHashKey(plywood_name), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(plywood, playerPed, boneIndex, -0.55, -0.42, -0.05, 155.0, 270.0, 175.5, true, true, false, true, 1, true)
	DetachArmor()
	Wait(120000)
	DetachEntity(plywood, 1, 1)
	Wait(4000)
	DeleteObject(plywood)
end)

RegisterNetEvent('nic_attach:juggernaut') -- Armor
AddEventHandler('nic_attach:juggernaut', function()
	boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine3")
	boneIndex2 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Head")
	
	boneIndex3 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Forearm")
	boneIndex4 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Forearm")
	
	boneIndex5 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Calf")
	boneIndex6 = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Calf")
	
	local barrel_name = 'p_barrel04b'
	local helmet_name = 'p_cs_bucket01bx'
	local barrel2_name = 'p_group_barrel01x_sd'
	local barrel3_name = 'p_group_barrel01x_sd'
	local barrel4_name = 'p_group_barrel01x_sd'
	local barrel5_name = 'p_group_barrel01x_sd'
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	barrel = CreateObject(GetHashKey(barrel_name), x, y, z+0.2,  true,  true, true)
	helmet = CreateObject(GetHashKey(helmet_name), x, y, z+0.2,  true,  true, true)
	barrel2 = CreateObject(GetHashKey(barrel2_name), x, y, z+0.2,  true,  true, true)
	barrel3 = CreateObject(GetHashKey(barrel3_name), x, y, z+0.2,  true,  true, true)
	barrel4 = CreateObject(GetHashKey(barrel4_name), x, y, z+0.2,  true,  true, true)
	barrel5 = CreateObject(GetHashKey(barrel5_name), x, y, z+0.2,  true,  true, true)
	PlaySoundFrontend("Gain_Point", "HUD_MP_PITP", true, 1)
	AttachEntityToEntity(barrel, playerPed, boneIndex, -0.51, -0.14, -0.05, 148.0, 290.0, 132.5, true, true, false, true, 1, true)
	AttachEntityToEntity(helmet, playerPed, 144, 0.24, -0.01, -0.00, 155.0, 115.0, 82.5, true, true, false, true, 1, true)
	AttachEntityToEntity(barrel2, playerPed, 200, 0.40, 0.00, 0.00, 155.0, 115.0, 82.5, true, true, false, true, 1, true)
	AttachEntityToEntity(barrel3, playerPed, 298, 0.40, 0.00, 0.00, 155.0, 115.0, 82.5, true, true, false, true, 1, true)
	AttachEntityToEntity(barrel4, playerPed, 3, 0.40, 0.00, 0.00, 155.0, 115.0, 82.5, true, true, false, true, 1, true)
	AttachEntityToEntity(barrel5, playerPed, 34, 0.40, 0.00, 0.00, 155.0, 115.0, 82.5, true, true, false, true, 1, true)
	DetachPlywood()
	Wait(120000)  -- duration of armor
	if IsEntityAttachedToEntity(barrel, PlayerPedId()) then
		PropTime()
	else		
	end
	Wait(6000)
	EnableControlAction(0, 0xDB096B85, false) -- Enable Backspace control
	EnableControlAction(0, 0xE8342FF2, false) -- Enable Backspace control
	DetachEntity(barrel, 1, 1)
	DetachEntity(helmet, 1, 1)
	DetachEntity(barrel2, 1, 1)
	DetachEntity(barrel3, 1, 1)
	DetachEntity(barrel4, 1, 1)
	DetachEntity(barrel5, 1, 1)
	Wait(5000)
	DeleteObject(barrel)
	DeleteObject(helmet)
	DeleteObject(ball)
	DeleteObject(barrel2)
	DeleteObject(barrel3)
	DeleteObject(barrel4)
	DeleteObject(barrel5)
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.25, 0.25)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end