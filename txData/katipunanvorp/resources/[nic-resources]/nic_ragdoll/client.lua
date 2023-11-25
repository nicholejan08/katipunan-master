local ragdoll = false
local text = ""
local spriteVal = 0
local status = false
local prone = false
local cooldownDuration = 1 -- in minutes

function setRagdoll(flag)
    ragdoll = flag
end

-- CLUMSY

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         if IsPedSprinting(PlayerPedId()) and not IsPedRunning(PlayerPedId()) then
--             Citizen.Wait(1000)
--             Citizen.InvokeNative(0xF0A4F1BBF4FA7497, PlayerPedId(), 5000, 0, 0)
--         end
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if prone and IsPedRagdoll(PlayerPedId()) then
            Citizen.InvokeNative(0xAE99FB955581844A, PlayerPedId(), 3000, 0, 0, 0, 0, 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)	
        if IsPedFalling(PlayerPedId()) then
            prone = true
            Citizen.InvokeNative(0xF0A4F1BBF4FA7497, PlayerPedId(), 3000, 0, 0)
            Citizen.Wait(8000)
            prone = false
        end
    end
end)

-- CLUMSY END

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)	
        for key, value in pairs(Config.settings) do

            if value.toggle then	
                if ragdoll then
                  Citizen.InvokeNative(0xAE99FB955581844A, PlayerPedId(), -1, 0, 0, 0, 0, 0)
                  DisableControlAction(0, 0xE8342FF2, true) -- Disable ALT control
                else
                    EnableControlAction(0, 0xE8342FF2, false) -- Enable Jump control
                end
            else
                if ragdoll then
                  Citizen.InvokeNative(0xAE99FB955581844A, PlayerPedId(), 3000, 0, 0, 0, 0, 0)
                  DisableControlAction(0, 0xE8342FF2, true) -- Disable ALT control
                else
                    EnableControlAction(0, 0xE8342FF2, false) -- Enable Jump control
                end
            end
        end
    end
end)

ragdol = true

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local toggleRagdoll = false
        
        for key, value in pairs(Config.settings) do

            if value.toggle then
                if IsControlJustPressed(0, 0x8CC9CD42) then
                    if not toggleRagdoll and not status then
                        toggleRagdoll = true
                        TriggerEvent("nic_prompt:point_off")
                        TriggerEvent("nic_prompt:handsup_off")
                        TriggerEvent("nic_prompt:ragdoll_on")
                        SetCinematicModeActive(false)
                        if (ragdol) then
                            setRagdoll(true)
                            ragdol = false
                            status = true
                        end
                    else
                        TriggerEvent("nic_prompt:ragdoll_off")
                        -- TriggerEvent("nic_prompt:cooldown_prompt_on")
                        -- Citizen.Wait(1500)
                        -- TriggerEvent("nic_prompt:cooldown_prompt_off")
                        setRagdoll(false)
                        ragdol = true
                        status = false
                        toggleRagdoll = false
                    end
                end
            else
                if IsControlJustPressed(0, 0x8CC9CD42) and status == true then
                    -- TriggerEvent("nic_prompt:cooldown_prompt_on")
                    -- Citizen.Wait(1500)
                    -- TriggerEvent("nic_prompt:cooldown_prompt_off")
                elseif IsControlJustReleased(0, 0x8CC9CD42) and status == true then
                    TriggerEvent("nic_prompt:cooldown_prompt_off")
                end
                
                if IsControlJustPressed(0, 0x8CC9CD42) then

                    if status == false then
                        Citizen.Wait(10)
                        TriggerEvent("nic_prompt:point_off")
                        TriggerEvent("nic_prompt:handsup_off")
                        TriggerEvent("nic_prompt:ragdoll_on")
                        SetCinematicModeActive(false)
                        if (ragdol) then
                                setRagdoll(true)
                                ragdol = false
                                status = true
                        end
                    end
                elseif IsControlJustReleased(0, 0x8CC9CD42) then
                    TriggerEvent("nic_prompt:ragdoll_off")
                    setRagdoll(false)
                    ragdol = true
                    status = false
                end
            end

        end

        
    end 
 end)

ragdoll = false


function DrawText3D(x, y, z, text , state)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
    if state then
        DrawSprite("generic_textures", "lock", _x, _y+0.02, 0.02, 0.03, 0.1, 125, 0, 0, 255, 0)
    else
        DrawSprite("generic_textures", "lock", _x, _y+0.0125, 0.04, 0.045, 0.1, 100, 100, 0, 0, 0)
    end
end