local display = false
local ragdoll = false
local injuredSound = false
local toggleEffect = true

local serverControl = false
local bleedingEffect = false
local screenOverlay = false
local clumsiness = false
local soundEffect = false
local injuredAnimation = false
local canBeKnockedOut = false
local injuredMovement = false
local canLoseBlood = false
local threshold, knockoutChance = 0, 0
local lowHealth = false
local injured = false
local setMovement = false

local toggleBleed = false

local particle_dict = ""
local particle_name = ""		
local particle_effect = false	
local current_particle_id = false

local fxName = "PlayerHealthPoor"

local Keys = {
  ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

  ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
   
  ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DELETE"] = 0x4AF4D473,
  
  ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41,

  ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,

  ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MDOWN"] = 0x8BDE7443
}

RegisterNetEvent('nic_injury:on')
AddEventHandler('nic_injury:on', function()
  AnimpostfxPlay(fxName)
  SendNUIMessage({
    type = "ui",
    display = true
  })
end)

RegisterNetEvent('nic_injury:off')
AddEventHandler('nic_injury:off', function()
  AnimpostfxStop(fxName)
  SendNUIMessage({
    type = "ui",
    display = false
  })
end)

RegisterNetEvent('nic_injury:useBleedEffect')
AddEventHandler('nic_injury:useBleedEffect', function(source)
    toggleBleed = true
end)

-- configuration

Citizen.CreateThread(function()
  while true do
    Wait(5)
    
    for key, value in pairs(Config.settings) do     
        bleedingEffect = value.bleedingEffect
        screenOverlay = value.screenOverlay
        clumsiness = value.clumsiness
        soundEffect = value.soundEffect
        canBeKnockedOut = value.canBeKnockedOut
        injuredMovement = value.injuredMovement
        canLoseBlood = value.canLoseBlood
        threshold = value.injuryThreshold

        if threshold > 200 then
          threshold = 200
        end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(5)
    local ped = PlayerPedId()
    local hp = GetEntityHealth(ped)
    local max = GetEntityMaxHealth(ped)

    if not IsEntityDead(ped) then
      if hp <= threshold then
        lowHealth = true
        
      elseif hp >= threshold then
        lowHealth = false
        stopEffect()
        
      end
    else
      stopEffect()
    end
    
  end
end)

-- screen effects

Citizen.CreateThread(function()
  while true do
    Wait(5)
    local ped = PlayerPedId()

    if not IsEntityDead(ped) then
      if lowHealth then

        if screenOverlay then
          TriggerEvent("nic_injury:on")
          AnimpostfxPlay("Downed")
          AnimpostfxPlay("PlayerHealthLow")
        end

      end
    end
  end
end)

-- FOR TESTING ----------------------------------

-- Citizen.CreateThread(function()
-- 	while true do
--     Citizen.Wait(5)
--     local ped = PlayerPedId()

--     if IsControlJustPressed(0, Keys['Z']) then
--       if not injured then
--         SetEntityHealth(ped, 40, 1)
--         injured = true
--       else
--         SetEntityHealth(ped, 100, 1)
--         injured = false
--       end
--     end
--   end
-- end)

Citizen.CreateThread(function()
  while true do
    Wait(5)
    local ped = PlayerPedId()

    if not IsEntityDead(ped) then
      if lowHealth then
        local injuryNum = math.random(0, 7)
        local injuryType = ""
  
        if injuredMovement then
          if not setMovement then
            setInjuredMovement(injuryNum, injuryType)
            setMovement = true
          end
        end

        if clumsiness then
          if IsPedSprinting(ped) then
            Citizen.InvokeNative(0xF0A4F1BBF4FA7497, ped, true, 0)
            Citizen.InvokeNative(0xDF993EE5E90ABA25, ped, true)
            Wait(3000)
          end
        end
    
        if soundEffect and not injuredSound then
          injuredSound = true
          playInjuredAudio()
        end
      else
        -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 336, false) -- injured movement
        Citizen.InvokeNative(0x4FD80C3DD84B817B, ped) -- clear walkstyle
        Citizen.InvokeNative(0x58F7DB5BD8FA2288, ped) -- clear tired movement
        -- Citizen.InvokeNative(0x923583741DC87BCE, ped, "default") -- clear tired movement
      end
    end
  end
end)

-- knockout

CreateThread(function()
	while true do
		Wait(5)
    local ped = PlayerPedId()
    local hp = GetEntityHealth(ped)

    if lowHealth then

      if canLoseBlood then
        if not IsEntityDead(ped) then  
          SetEntityHealth(ped, hp-1, 1)
          Wait(4000)
        end
      end
    end
  end
end)

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()
        local hp = GetEntityHealth(ped)
        local max = GetPedMaxHealth(ped)
        local ragdoll = math.random(2000, 7000)
        local stumble = math.random(0, 1)
        local pos = GetEntityForwardVector(ped)

        if canBeKnockedOut then
          if Citizen.InvokeNative(0x9E2D5D6BC97A5F1E, ped, 0xA2719263, 100) then
            local hurt = math.random(0, 72)
  
            if hurt == 2 then
  
                if stumble == 0 and IsPedInMeleeCombat(ped) then
                    Citizen.InvokeNative(0xD76632D99E4966C8, ped, ragdoll, ragdoll, 1, -pos, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                else
                    Citizen.InvokeNative(0xAE99FB955581844A, ped, ragdoll, 0, 0, 0, 0, 0)
                end
                
                AnimpostfxPlay("CamTransition01")
            end
         end
      end
    end
end)

-- bleeding

local bleed = false

Citizen.CreateThread(function()
  while true do
    Wait(5)
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_Head")

    if not IsEntityDead(ped) then
      if lowHealth then
        if bleedingEffect then
          if not bleed then
            Citizen.InvokeNative(0xFFD54D9FE71B966A,  ped, 2, 14411, 0.0, 0.0, 0.0, 0.0, 0.5, -1.0, 0.1)
            bleed = true
          end
        end
      else
        bleed = false
      end
    end

  end
end)

function stopEffect()
  local ped = PlayerPedId()
  
  toggleBleed = false
  current_particle_id = false
  particle_effect = false
  lowHealth = false
  serverControl = false
  AnimpostfxStop("MP_Downed")
  AnimpostfxStop("PlayerHealthLow")
  TriggerEvent("nic_injury:off")
  
  -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 336, false) -- clear injured movement
  -- Citizen.InvokeNative(0x923583741DC87BCE, ped, "arthur_healthy") -- reset walkstyle
  -- Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "normal") -- reset tired movement

  Citizen.InvokeNative(0x66B1CB778D911F49, ped, 0.0)

  if IsEntityPlayingAnim(ped, animation, anim, 31) then
    injuredSound = false
    ClearPedTasks(ped)
  end
  
  setMovement = false

end

function setInjuredMovement(num, string)
  local ped = PlayerPedId()

  if num == 0 then
    string = "dehydrated_unarmed"
  elseif num == 1 then
    string = "very_drunk"
  elseif num == 2 then
    string = "agitated"
  elseif num == 3 then
    string = "stealth"
  elseif num == 4 then
    string = "injured_left_leg"
  elseif num == 5 then
    string = "injured_right_leg"
  elseif num == 6 then
    string = "injured_left_arm"
  elseif num == 7 then
    string = "injured_right_arm"
  end

  -- Citizen.InvokeNative(0x1913FE4CBF41C463, ped, 336, true) -- injured movement
  Citizen.InvokeNative(0x923583741DC87BCE, ped, "default") -- set walkstyle
  -- Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, string) -- set tired movement
end

function playInjuredAudio()
  local is_shrink_sound_playing = false
  local shrink_soundset_ref = "Objective_Sounds"
  local shrink_soundset_name =  "FAIL"

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