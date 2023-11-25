
local prompt = false
local inprogress = false
local gText = ""

Citizen.CreateThread(function()
	while true do
		Wait(10)
		if prompt then
			DrawTxt(gText, 0.5, 0.055, 0.5, 0.5, true, 214, 232, 79, 200, true)
		end
	end
end)

RegisterNetEvent('nic_messages:timer')
AddEventHandler('nic_messages:timer', function(time)
    local timer = time
    local stopTimer = false

	Citizen.CreateThread(function()
        if not stopTimer then
            while timer > 0 and not IsEntityDead(PlayerPedId()) do
                Citizen.Wait(1000)
                timer = timer - 1000
            end
            
            if timer == 0 then
                stopTimer = true
                prompt = false
                inprogress = false
            end
        end
	end)
end)

function startMessage(time, text2)
    if not inprogress then
        inprogress = true
        gText = text2
        PlaySoundFrontend("TITLE_SCREEN_EXIT", "DEATH_FAIL_RESPAWN_SOUNDS", true, 0)
        prompt = true
        TriggerEvent('nic_messages:timer', time)
    else
        notAllowedPrompt()
        inprogress = false
    end
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

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end
