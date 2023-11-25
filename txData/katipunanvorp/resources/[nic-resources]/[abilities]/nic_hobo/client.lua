	
local particle_effect = false
local particle_effect_target = false

local flies_particle_id = false
local drip_particle_id = false

local smoke_particle_id = false
local smoke_particle2_id = false
local smoke_particle3_id = false

local blood_particle_target_id = false
local smoke_particle_target_id = false

local puke_particle_id = false
local hobo = false
local transforming = false
local poison = false
local poisonedTarget = false

local pukeTask = false
local pukeEnabled = false

local timerStarted = false
local timer = 0

local current_poop_handle_id = false
local is_poop_effect_active = false
local pSHit = false

local sack

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function DrawKey3D(x, y, z, text, text2)    
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

    if not HasStreamedTextureDictLoaded("pm_collectors_bag_mp") or not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("pm_collectors_bag_mp", false)
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("pm_collectors_bag_mp", cVariance, _x, _y, 0.018, 0.03, 0.1, 217, 232, 86, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

RegisterNetEvent('nic_hobo:dirty')
AddEventHandler('nic_hobo:dirty', function(source)
	if not particle_effect then
		playEffectAudio()
		playSmokeEffect() 
		playSmoke2Effect() 
		playSmoke3Effect()
		playParticleEffect()
		TriggerEvent("hobo:sack")
		TriggerEvent("nic_clone:getDirty")
	else
		stopEffect()
		TriggerEvent("nic_clone:removeDirty")
		DeleteEntity(sack)
	end
end)

RegisterNetEvent('hobo:sack') -- Sack
AddEventHandler('hobo:sack', function()
	local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine2")
	
	local ped = PlayerPedId()
	local sack_name = 'p_cs_vegsack_up'
	local x,y,z = table.unpack(GetEntityCoords(ped))

	if not DoesEntityExist(sack) then
		DeleteEntity(sack)
	end

	sack = CreateObject(GetHashKey(sack_name), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(sack, ped, boneIndex, -0.27, -0.41, -0.01, 335.0, 91.0, 0.0, true, true, false, true, 1, true)
end)

RegisterNetEvent('nic_hobo:trigger')
AddEventHandler('nic_hobo:trigger', function(source)
    local playerPed = PlayerPedId()  

	if not Citizen.InvokeNative(0xD5FE956C70FF370B, PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and not IsPedJumping(PlayerPedId()) then
		hobo = true
		transforming = true
        Citizen.InvokeNative(0xB31A277C1AC7B7FF, playerPed, 0, 0, 987239450, 1, 1, 0, 0)
        Citizen.Wait(2600)
		transforming = false
		playParticleEffect()
		playSmokeEffect() 
		playSmoke2Effect() 
		playSmoke3Effect()
		playPukeEffect()
		poison = true
		playEffectAudio()
        AnimpostfxPlay("Mission_GNG0_Ride")
        TriggerEvent("nic_prompt:wolverine_overlay_on")
        TriggerEvent('nic_hobo:timer')
	else
		notAllowedPrompt()
	end
end)


RegisterNetEvent('nic_hobo:timer')
AddEventHandler('nic_hobo:timer', function()
    timerStarted = true   
    
    for key, value in pairs(Config.settings) do
        timer = value.effectTimer
    end

	Citizen.CreateThread(function()
        if hobo and timerStarted then
            while timer > 0 and not IsEntityDead(PlayerPedId()) do
                Citizen.Wait(1000)
                timer = timer - 1
            end
            
            if timer == 0 and hobo then
                stopEffect()
				stopTargetEffect()
            end
        end
	end)
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
		local pHp = GetEntityHealth(PlayerPedId())
		if poison then
			SetEntityHealth(PlayerPedId(), pHp - 1, 0)
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
		if hobo and transforming then
			DisableControlAction(0, 0x8FFC75D6, true) -- Disable Shift control
			DisableControlAction(0, 0xCEFD9220, true) -- Disable E control
			DisableControlAction(0, 0xD9D0E1C0, true) -- Disable Space control
			DisableControlAction(0, 0xDB096B85, true) -- Disable Ctrl control
			DisablePlayerFiring(PlayerPedId(), true) -- Disable Player Firing
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
		if not hobo and not particle_effect and IsControlJustPressed(0, 0xCEE12B50) and not IsEntityDead(PlayerPedId()) then
			TriggerServerEvent("nic_hobo:checkJob")
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
		if hobo and particle_effect and IsControlJustPressed(0, 0xCEE12B50) and not IsPedRagdoll(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
			TriggerEvent("nic_hobo:stopEffect")
		end
    end
end)

RegisterNetEvent('nic_hobo:stopEffect')
AddEventHandler('nic_hobo:stopEffect', function(source)
    playAnimation5()
    Citizen.Wait(800)
	stopEffect()
	stopTargetEffect()
end)

function stopEffect()
	if flies_particle_id or drip_particle_id or smoke_particle_id or smoke_particle2_id or smoke_particle3_id and puke_particle_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, flies_particle_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, puke_particle_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, drip_particle_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, smoke_particle_id) then   -- DoesParticleFxLoopedExist
			Citizen.InvokeNative(0x459598F579C98929, flies_particle_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, drip_particle_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle2_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle3_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, puke_particle_id, false)   -- RemoveParticleFx
		end
	end
	timerStarted = false
	drip_particle_id = false
	flies_particle_id = false
	smoke_particle_id = false
	smoke_particle2_id = false
	smoke_particle3_id = false
	puke_particle_id = false
	if not IsEntityDead(PlayerPedId()) then
		playEffectOffAudio()
	end
	AnimpostfxStopAll()
	TriggerEvent("nic_prompt:wolverine_overlay_off")

	particle_effect = false
	Citizen.InvokeNative(0x523C79AEEFCC4A2A,PlayerPedId(),10, "ALL")
    Citizen.Wait(200)
	ClearPedTasks(PlayerPedId())
	hobo = false
	poison = false
	poisonedTarget = false
end

function playEffectAudio()
    local is_shrink_sound_playing = false
    local shrink_soundset_ref = "RDRO_Poker_Sounds"
    local shrink_soundset_name =  "player_turn_countdown_start"

    if not is_shrink_sound_playing then           
        if shrink_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, shrink_soundset_name, shrink_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5, shrink_soundset_name, shrink_soundset_ref, true, 0);  -- play sound frontend
        is_shrink_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, shrink_soundset_name, shrink_soundset_ref)  -- stop audio
        is_shrink_sound_playing = false
    end
end

function playHurtAudio()
    local is_shrink_sound_playing = false
    local shrink_soundset_ref = "RDRO_Poker_Sounds"
    local shrink_soundset_name =  "player_turn_countdown_start"

    if not is_shrink_sound_playing then           
        if shrink_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, shrink_soundset_name, shrink_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5, shrink_soundset_name, shrink_soundset_ref, true, 0);  -- play sound frontend
        is_shrink_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, shrink_soundset_name, shrink_soundset_ref)  -- stop audio
        is_shrink_sound_playing = false
    end
end

function playEffectOffAudio()
    local is_shrink_sound_playing = false
    local shrink_soundset_ref = "RDRO_Poker_Sounds"
    local shrink_soundset_name =  "player_turn_countdown_start"

    if not is_shrink_sound_playing then           
        if shrink_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, shrink_soundset_name, shrink_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5, shrink_soundset_name, shrink_soundset_ref, true, 0);  -- play sound frontend
        is_shrink_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, shrink_soundset_name, shrink_soundset_ref)  -- stop audio
        is_shrink_sound_playing = false
    end
end

function playAnimation5()
    local playerPed = PlayerPedId()
    local animation = "mech_melee@lasso@_male@_ambient@_healthy@_noncombat"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(playerPed, animation, "attack_kick_push_leftside_dist_far_v1", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

Citizen.CreateThread(function()
	while true do
	  Wait(5)
	  if IsEntityDead(PlayerPedId()) then
		if DoesEntityExist(sack) then
			DeleteEntity(sack)
		end
		stopEffect()
		stopTargetEffect()
	  end
	end
end)

function stopTargetEffect()
	if smoke_particle_target_id or blood_particle_target_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, smoke_particle_target_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, blood_particle_target_id) then   -- DoesParticleFxLoopedExist
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle_target_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, blood_particle_target_id, false)   -- RemoveParticleFx
		end
	end
	smoke_particle_target_id = false
	blood_particle_target_id = false
	particle_effect_target = false
end

-- Citizen.CreateThread(function()
-- 	while true do
-- 	  Wait(0)
	  
-- 		if not pSHit and Citizen.InvokeNative(0xD5FE956C70FF370B, PlayerPedId()) then
-- 		   poop(PlayerPedId())
-- 		   pSHit = true
-- 		   endPoop()
-- 		else
-- 			endPoop()
-- 			pSHit = false
-- 		end
-- 	end
-- end)

function endPoop()
	if current_poop_handle_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_poop_handle_id) then   -- DoesParticleFxLoopedExist
			Citizen.InvokeNative(0x459598F579C98929, current_poop_handle_id, false)   -- RemoveParticleFx
		end
	end
	current_poop_handle_id = false
	is_poop_effect_active = false	
end


function poop(ped)
    local new_ptfx_dictionary = "anm_animals"
    local new_ptfx_name = "ent_anim_animal_shit"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_poop_effect_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))  -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
                Citizen.Wait(0)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then  -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary) -- UseParticleFxAsset
            
			Citizen.Wait(2000)
            current_poop_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, ped, -0.15, -0.15, -0.6, 0, 0, 0, 1.0, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_poop_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_poop_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_poop_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_poop_handle_id = false
        is_poop_effect_active = false	
    end
end

Citizen.CreateThread(function()
	while true do
	  Wait(0)
	  local target = GetClosestPed(PlayerPedId(), 2.0)
	  local x, y, z = table.unpack(GetEntityCoords(target, 0))
	  local hp = GetEntityHealth(target)
	  
	  if poison and not IsEntityDead(PlayerPedId()) then		
		if IsNPCNearPoison(x, y, z) and not IsEntityDead(target) then
			if not particle_effect_target then
				playBloodTargetEffect(target)
				playSmokeTargetEffect(target)
				Citizen.Wait(400)
			end
		elseif IsNPCNearPoison(x, y, z) and IsEntityDead(target) then
			stopTargetEffect()
		elseif not IsNPCNearPoison(x, y, z) and IsEntityDead(target) then
			stopTargetEffect()
		end

		if IsNPCNearPoison(x, y, z) and not IsEntityDead(target) then
			Citizen.Wait(50)
			playHurtAudio()
		end

		if IsNPCNearPoison(x, y, z) and not IsEntityDead(target) then
			SetEntityHealth(target, hp - 1, 0)
			Citizen.Wait(50)
		end


	  end
	end
end)

Citizen.CreateThread(function()
	while true do
	  Wait(0)
	  if hobo and IsPedSwimming(PlayerPedId()) then
		stopEffect()
		stopTargetEffect()
	  end
	end
end)

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

function IsPlayerNearNPC(x, y, z)
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)

    if distance < 3 and distance > 0 then
        return true
    end
end

function IsNPCNearPoison(x, y, z)
    local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)

    if distance < 2 then
        return true
    end
end

function IsValidTarget(ped)
	return not IsPedDeadOrDying(ped) and IsPedHuman(ped) and not (IsPedAPlayer(ped) and not IsPvpEnabled()) and not IsPedRagdoll(ped)
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

function playParticleEffect()
	local particle_dict = "scr_fme_spawn_effects"
	local particle_name = "scr_animal_poop_flies"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine0")
		flies_particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, PlayerPedId(), 0, 0, 0, -90.0, 0, 0, boneIndex, 1.0, 0, 0, 0)

		Citizen.InvokeNative(0x46DF918788CB093F,PlayerPedId(),"PD_Outhouse_Muck_Body_Face", 0.0, 0.0);  -- APPLY_PED_DAMAGE_PACK PD_Vomit for ped with damage 0.0 and mult 0.0

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playDripEffect()  
	local particle_dict = "scr_mg_cleaning_stalls"
	local particle_name = "scr_mg_stalls_manure_flies"	
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Head")
		drip_particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, PlayerPedId(), 0, 0, 0, 0.0, 0, 0, boneIndex, 1.0, 0, 0, 0)

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playPukeEffect()  
	local particle_dict = "scr_reverend1"
	local particle_name = "scr_rev_puke"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Spine0")
		puke_particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, PlayerPedId(), 0, 0, 0, 0.0, 0, 0, boneIndex, 1.0, 0, 0, 0)

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playSmokeEffect()  
	local particle_dict = "core"
	local particle_name = "ent_amb_ann_vapor"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Clavicle")

		smoke_particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, PlayerPedId(), 0, 0, 0, -90.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playSmoke2Effect()  
	local particle_dict = "core"
	local particle_name = "ent_amb_ann_vapor"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis")

		smoke_particle2_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, PlayerPedId(), 0, 0, 0, -90.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playSmoke3Effect()  
	local particle_dict = "core"
	local particle_name = "ent_amb_ann_vapor"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Thigh")
		
		smoke_particle3_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, PlayerPedId(), 0, 0, 0, -90.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playBloodTargetEffect(target)  
	local particle_dict = "anm_blood"
	local particle_name = "ent_anim_blood_drips"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(target, "SKEL_Head")
		blood_particle_target_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, target, 0, 0, 0, 0.0, 0, 0, boneIndex, 0.8, 0, 0, 0)

		particle_effect_target = true
	else
		print("cant load ptfx dictionary!")
	end
end

function playSmokeTargetEffect(target)  
	local particle_dict = "core"
	local particle_name = "ent_amb_ann_vapor"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(0)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(target, "SKEL_L_Clavicle")
		smoke_particle_target_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, target, 0, 0, 0, 0.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

		particle_effect_target = true
	else
		print("cant load ptfx dictionary!")
	end
end