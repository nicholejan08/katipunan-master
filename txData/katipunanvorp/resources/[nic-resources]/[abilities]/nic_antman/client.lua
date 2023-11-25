
-- VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local antman = false
local superjump = false
local restorestamina = false
local shrinked = false
local timerStarted = false
local timer = 0
local scaled = false
local scaleChance = 0
local tiny = false
local giant = false
local gHeading = 0
local num = 1
local overhead = false
local sizing = false

local spark_particle_id = false
local spark_particle_active = false

local helmet
local toShrink = false
local toGrow = false
local spark = false

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DELETE"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,

    ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MDOWN"] = 0x8BDE7443
}

-- STARTS THE SCRIPT
----------------------------------------------------------------------------------------------------

RegisterCommand('antman', function()
    if not antman then
        TriggerServerEvent("nic_antman:checkJob")
    else
        stopAll()
    end
end)

CreateThread(function()
	while true do
		Wait(5)
		if superjump and tiny then
			SetSuperJumpThisFrame(PlayerId())
			SetSuperJumpThisFrame(clone1)
		end
		if restorestamina then
			RestorePlayerStamina(PlayerId(),1.0)
		end
	end
end)

RegisterNetEvent('nic_antman:notAntman')
AddEventHandler('nic_antman:notAntman', function(source)
    antman = false
end)

RegisterNetEvent('nic_antman:setAntman')
AddEventHandler('nic_antman:setAntman', function(source)
    TriggerEvent('vorp:ShowTopNotification', "Ant-Man", "~t6~Activated", 4000)
    antman = true
    equipHelmet()
end)

RegisterNetEvent('nic_antman:usePower')
AddEventHandler('nic_antman:usePower', function(source)
    local ped = PlayerPedId()
    
    if not IsPedHangingOnToVehicle(ped) then
        scaled = true
        if num == 1 then
            playStoreAnimation()
            TriggerEvent('nic_antman:shrink')
        elseif num == 10 then
            playStoreAnimation()
            TriggerEvent('nic_antman:giant')
        else
            playRejectAudio()
        end
    end
end)

RegisterNetEvent('nic_antman:timer')
AddEventHandler('nic_antman:timer', function()
    local ped = PlayerPedId()
    timerStarted = true    
    sizing = false
    
    for key, value in pairs(Config.settings) do
        timer = value.shrinkTimeLimit
    end

	Citizen.CreateThread(function()
        if timerStarted then
            while timer > 0 and not IsEntityDead(ped) do
                Citizen.Wait(1000)
                timer = timer - 1
            end
            
            if timer == 0 then
                if tiny then
                    enlarge()
                elseif giant then
                    shrinkNormal()
                end
                num = 1
            end
        end
	end)
end)

RegisterNetEvent('nic_antman:shrink')
AddEventHandler('nic_antman:shrink', function()
    local ped = PlayerPedId()
    local cHolding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
    local px, py, pz = table.unpack(GetEntityCoords(ped))

    SetEntityAlpha(helmet, 0, true)
    toShrink = true
    sizing = false
    overhead = false
    ClearPedTasks(ped)
    DetachEntity(cHolding, 1, 1)
    timerStarted = false
    timer = 0
    AnimpostfxPlay("Mission_GNG0_Ride")
    TriggerEvent("nic_prompt:pym_overlay_on")
    playShrinkAudio()
    SetPedScale(ped, 0.8)
    Citizen.Wait(50)
    SetPedScale(ped, 0.7)
    Citizen.Wait(50)
    SetPedScale(ped, 0.6)
    Citizen.Wait(50)
    SetPedScale(ped, 0.5)
    Citizen.Wait(50)
    SetPedScale(ped, 0.4)
    Citizen.Wait(50)
    SetPedScale(ped, 0.3)
    Citizen.Wait(50)
    SetPedScale(ped, 0.2)
    Citizen.Wait(50)
    SetPedScale(ped, 0.1)
    Citizen.Wait(50)
    SetPedScale(ped, 0.08)
    Citizen.Wait(50)
    shrinked = true
    tiny = true
    toShrink = false
    spark = false
    TriggerEvent('nic_antman:timer')
end)

RegisterNetEvent('nic_antman:giant')
AddEventHandler('nic_antman:giant', function()
    local ped = PlayerPedId()
    local cHolding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
    local px, py, pz = table.unpack(GetEntityCoords(ped))

    SetEntityAlpha(helmet, 0, true)
    toGrow = true
    sizing = false
    overhead = false
    ClearPedTasks(ped)
    DetachEntity(cHolding, 1, 1)
    timerStarted = false
    timer = 0
    AnimpostfxPlay("ODR3_Injured03Loop")
    TriggerEvent("nic_prompt:pym_overlay_on")
    playShrinkAudio() 
    SetEntityInvincible(ped, true)
    SetPedScale(ped, 1.0)
    Citizen.Wait(50)
    SetPedScale(ped, 1.1)
    Citizen.Wait(50)
    SetPedScale(ped, 1.2)
    Citizen.Wait(50)
    SetPedScale(ped, 1.3)
    Citizen.Wait(50)
    SetPedScale(ped, 1.4)
    AddExplosion(px, py, pz, 12, 0.0, false, false, false)
    Citizen.Wait(50)
    SetPedScale(ped, 1.5)
    Citizen.Wait(50)
    SetPedScale(ped, 1.7)
    Citizen.Wait(50)
    SetPedScale(ped, 1.8)
    Citizen.Wait(50)
    SetPedScale(ped, 1.9)
    Citizen.Wait(50)
    shrinked = true
    giant = true
    toGrow = false
    spark = false
    TriggerEvent('nic_antman:timer')
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local action = not IsPedRagdoll(ped) and not IsEntityDead(ped)
            
        if antman then
            if action then
                if IsControlJustPressed(0, Keys['MOUSE3']) then
                    if shrinked then
                        if tiny then
                            playStoreAnimation()
                            enlarge()
                        elseif giant then
                            playStoreAnimation()
                            shrinkNormal()
                        end
                    else
                        TriggerEvent("nic_antman:usePower")
                    end
                end
                
                if IsControlJustPressed(0, Keys['MWUP']) then
                    playScrollAnimation()
                    overhead = true
                    if num < 10 then
                        num = num + 1
                        playScrollUpAudio()
                    end
                elseif IsControlJustPressed(0, Keys['MDOWN']) then
                    playScrollAnimation()
                    overhead = true
                    if num <= 10 and num > 1 then
                        num = num - 1
                        playScrollDownAudio()
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

        if overhead then
            if num ~= 10 then
                Wait(3000)
            else
                Wait(5000)
            end
            Wait(500)
            playScrollUpAudio()
            ClearPedTasks(ped)
            num = 1
            Wait(500)
            overhead = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local ped = PlayerPedId()

        if antman then
            if IsEntityDead(ped) then
                stopAll()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local ped = PlayerPedId()
		local px, py, pz = table.unpack(GetEntityCoords(ped, 0))

        if overhead and not shrinked then
            if num < 10 then
                DrawNum3D(px, py, pz+0.8, ""..num)
            end
            if num <= 10 and num > 1 then
                DrawNum3D(px, py, pz+0.8, ""..num)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local target = GetClosestPed(ped, 20.0)
        local px, py, pz = table.unpack(GetEntityCoords(ped))

        if antman then

            if IsPedRagdoll(ped) and (toShrink or toGrow) then
                sparkEffect()
            end

            if sizing then
                SetPedCanRagdoll(ped, false)
            end

            if timer < 6 and timer > 0 then
                SetPedCanRagdoll(ped, false)
            end

            if shrinked and timer < 6 and timer > 0 then
                TriggerEvent("nic_prompt:tired_prompt_on")
                Wait(500) 
                playTimerAudio()
                TriggerEvent("nic_prompt:tired_prompt_off")
                Wait(500)  
            end

            if shrinked and IsEntityDead(ped) then
                TriggerEvent("nic_prompt:pym_overlay_off")
                ResetEntityAlpha(ped)
                SetPedScale(ped, 0.95)
                shrinked = false
                tiny = false
            end

            if tiny then
                SetPedScale(ped, 0.05)
                if IsPedInCombat(ped, target) or IsPedInMeleeCombat(ped) or IsPedInMeleeCombat(target) then
                    ClearPedTasks(target)
                end
            elseif giant then
                SetPedScale(ped, 2.8)
            end

            if shrinked then
                DisableControlAction(0, 0x7F8D09B8, true) 
                SetEntityInvincible(ped, true)
                superjump = true
                restorestamina = true
                ResetEntityAlpha(ped)
            elseif not shrinked then
                SetEntityInvincible(ped, false)
                superjump = false
                restorestamina = false
            end

        end
    end
end)

function stopAll()
    TriggerEvent('vorp:ShowTopNotification', "Ant-Man", "~e~Deactivated", 4000)
    local ped = PlayerPedId()
    ResetEntityAlpha(ped)
    SetPedScale(ped, 0.95)
    antman = false
    superjump = false
    restorestamina = false
    shrinked = false
    timerStarted = false
    timer = 0
    scaled = false
    scaleChance = 0
    tiny = false
    giant = false
    gHeading = 0
    num = 1
    overhead = false
    sizing = false
    
    spark_particle_id = false
    spark_particle_active = false
    
    toShrink = false
    toGrow = false
    spark = false

    if DoesEntityExist(helmet) then
        DeleteEntity(helmet)
    end
end

function equipHelmet()
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Head")
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local propModel = "antman_helmet"
    
    if not DoesEntityExist(helmet) then
        helmet = CreateObject(GetHashKey(propModel), x, y, z, true, true, true)
        AttachEntityToEntity(helmet, ped, boneIndex, 0.05, 0.0, 0.0, 170.0, -90.0, 0.0, true, true, false, true, 1, true)
    end
end

function sparkEffect()
    local new_ptfx_dictionary = "core"
    local new_ptfx_name = "ent_col_electrical"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not spark_particle_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))  -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
                Citizen.Wait(5)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then  -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary) -- UseParticleFxAsset
            
            spark_particle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, ped, 0, 0, 0, 0, 0, 0, 1.0, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if spark_particle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, spark_particle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, spark_particle_id, false)   -- RemoveParticleFx
            end
        end
        spark_particle_id = false
        spark_particle_active = false	
    end
end

function playStoreAnimation()
    local ped = PlayerPedId()
    local animation = "mech_inspection@generic@lh@base"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    sizing = true
    TaskPlayAnim(ped, animation, "hold", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
    Wait(500)
end

function playScrollAnimation()
    local ped = PlayerPedId()
    local animation = "mech_inventory@item@pocketwatch@unarmed@base"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(ped, animation, "inspect_base", 12.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
end

function IsValidTarget(ped)
	return not IsPedDeadOrDying(ped) and IsPedHuman(ped) and not (IsPedAPlayer(ped) and not IsPvpEnabled()) and not IsPedRagdoll(ped)
end

function GetClosestPed(playerPed, radius)
    local ped = PlayerPedId()
	local playerCoords = GetEntityCoords(ped)

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

function shrinkNormal()
    local ped = PlayerPedId()
    toShrink = true
    sizing = false
    overhead = false
    ClearPedTasks(ped)
    playEnlargeAudio()
    TriggerEvent("nic_prompt:pym_overlay_off")
    AnimpostfxStop("ODR3_Injured03Loop")
    timerStarted = false
    timer = 0
    shrinked = false
    giant = false
    SetPedScale(ped, 1.7)
    Citizen.Wait(50)
    SetPedScale(ped, 1.6)
    Citizen.Wait(50)
    SetPedScale(ped, 1.5)
    Citizen.Wait(50)
    SetPedScale(ped, 1.4)
    Citizen.Wait(50)
    SetPedScale(ped, 1.3)
    ResetEntityAlpha(helmet)
    toShrink = false
    spark = false
end

function enlarge()
    local ped = PlayerPedId()
    toGrow = true
    sizing = false
    overhead = false
    ClearPedTasks(ped)
    playEnlargeAudio()
    TriggerEvent("nic_prompt:pym_overlay_off")
    AnimpostfxStop("Mission_GNG0_Ride")
    timerStarted = false
    timer = 0
    shrinked = false
    tiny = false
    SetPedScale(ped, 0.4)
    Citizen.Wait(50)
    SetPedScale(ped, 0.5)
    Citizen.Wait(50)
    SetPedScale(ped, 0.6)
    Citizen.Wait(50)
    ResetEntityAlpha(ped)
    SetPedScale(ped, 0.7)
    Citizen.Wait(50)
    SetPedScale(ped, 0.8)
    ResetEntityAlpha(helmet)
    toGrow = false
    spark = false
end


function playShrinkAudio()
    local is_shrink_sound_playing = false
    local shrink_soundset_ref = "HUD_REWARD_SOUNDSET"
    local shrink_soundset_name =  "REWARD_NEW_GUN"

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

function playRejectAudio()
    local is_reject_sound_playing = false
    local reject_soundset_ref = "Ledger_Sounds"
    local reject_soundset_name =  "UNAFFORDABLE"

    if not is_reject_sound_playing then           
        if reject_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, reject_soundset_name, reject_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5, reject_soundset_name, reject_soundset_ref, true, 0);  -- play sound frontend
        is_reject_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, reject_soundset_name, reject_soundset_ref)  -- stop audio
        is_reject_sound_playing = false
    end
end

function playTimerAudio()
    local is_timer_sound_playing = false
    local timer_soundset_ref = "RDRO_Sniper_Tension_Sounds"
    local timer_soundset_name =  "Heartbeat"

    if not is_timer_sound_playing then           
        if timer_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, timer_soundset_name, timer_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5, timer_soundset_name, timer_soundset_ref, true, 0);  -- play sound frontend
        is_timer_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, timer_soundset_name, timer_soundset_ref)  -- stop audio
        is_timer_sound_playing = false
    end
end

function playEnlargeAudio()
    local is_enlarge_sound_playing = false
    local enlarge_soundset_ref = "Photo_Mode_Sounds"
    local enlarge_soundset_name =  "take_photo"

    if not is_enlarge_sound_playing then           
        if enlarge_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, enlarge_soundset_name, enlarge_soundset_ref);   -- load sound frontend
        end
        Citizen.InvokeNative(0x67C540AA08E4A6F5, enlarge_soundset_name, enlarge_soundset_ref, true, 0);  -- play sound frontend
        is_enlarge_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, enlarge_soundset_name, enlarge_soundset_ref)  -- stop audio
        is_enlarge_sound_playing = false
    end
end

function playScrollUpAudio()
    local is_scroll_sound_playing = false
    local scroll_soundset_ref = "HUD_POKER"
    local scroll_soundset_name =  "BET_AMOUNT"

    if not is_scroll_sound_playing then           
        if scroll_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, scroll_soundset_name, scroll_soundset_ref);   -- load sound frontend
        end
        Citizen.InvokeNative(0x67C540AA08E4A6F5, scroll_soundset_name, scroll_soundset_ref, true, 0);  -- play sound frontend
        is_scroll_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, scroll_soundset_name, scroll_soundset_ref)  -- stop audio
        is_scroll_sound_playing = false
    end
end

function playScrollDownAudio()
    local is_scroll_sound_playing = false
    local scroll_soundset_ref = "HUD_POKER"
    local scroll_soundset_name =  "BET_AMOUNT"

    if not is_scroll_sound_playing then           
        if scroll_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8, scroll_soundset_name, scroll_soundset_ref);   -- load sound frontend
        end
        Citizen.InvokeNative(0x67C540AA08E4A6F5, scroll_soundset_name, scroll_soundset_ref, true, 0);  -- play sound frontend
        is_scroll_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F, scroll_soundset_name, scroll_soundset_ref)  -- stop audio
        is_scroll_sound_playing = false
    end
end


function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

function DrawNum3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    if num == 1 then
        SetTextColor(255, 255, 255, 215)
    elseif num == 10 then
        SetTextColor(64, 134, 247, 215)
    else
        SetTextColor(255, 255, 255, 45)
    end
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    -- DisplayText(str,_x,_y-0.038)
     
    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("swatches_gunsmith_mp")  then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("swatches_gunsmith_mp", false)
    else
        -- DrawSprite("menu_textures", "menu_icon_rank", _x, _y-0.025, 0.014, 0.027, 0.1, 0, 0, 0, 185, 0)
        DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.036, 0.007, 0.043, 0.1, 0, 0, 0, 80, 0)
        DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.045 , _y+0.036, 0.001, 0.05, 0.3, 223, 232, 247, 115, 0)

        DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.041 , _y+0.061, 0.01, 0.001, 0.1, 223, 232, 247, 255, 150, 0)
        -- DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.042 , _y+0.011 , 0.01, 0.001, 0.1, 223, 232, 247, 255, 150, 0)
        
        if num == 1 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
        elseif num == 2 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
        elseif num == 3 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
        elseif num == 4 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
        elseif num == 5 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
        elseif num == 6 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
        elseif num == 7 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
        elseif num == 8 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
        elseif num == 9 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
        elseif num == 10 then
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.054, 0.005, 0.002, 0.1, 66, 135, 245, 50, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.050, 0.005, 0.002, 0.1, 66, 135, 245, 70, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.046, 0.005, 0.002, 0.1, 66, 135, 245, 80, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.042, 0.005, 0.002, 0.1, 66, 135, 245, 90, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.038, 0.005, 0.002, 0.1, 66, 135, 245, 100, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.034, 0.005, 0.002, 0.1, 66, 135, 245, 120, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.030, 0.005, 0.002, 0.1, 66, 135, 245, 150, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.026, 0.005, 0.002, 0.1, 66, 135, 245, 180, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.022, 0.005, 0.002, 0.1, 66, 135, 245, 200, 0)
            DrawSprite("swatches_gunsmith_mp", "bowstring_tint_row_34", _x+0.04 , _y+0.018, 0.005, 0.002, 0.1, 66, 135, 245, 250, 0)
        end
    end
end