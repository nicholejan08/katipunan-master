local healing = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if not DoesEntityExist(samueljackson) then
            RequestModel(GetHashKey("CS_SDDoctor_01"))

            while not HasModelLoaded(GetHashKey("CS_SDDoctor_01")) do
                Wait(100)
            end

            samueljackson = CreatePed("CS_SDDoctor_01", -1806.127, -429.076, 158.833, 244.099, false, true)
            SetPedRandomComponentVariation(samueljackson, 0)
            SetBlockingOfNonTemporaryEvents(samueljackson, true)
            SetEntityInvincible(samueljackson, true)
            SetPedCanBeTargettedByPlayer(samueljackson, GetPlayerPed(), false)
        end

        if IsPlayerNearCoords(-1804.512, -429.958, 158.831, 1) then
            if not healing then
                DisplayNPCText("Duktor ng Baguio", 0.40, 0.40, 0.5, 0.85, 164, 0, 20, 1)
                DisplayNPCText("Pindutin ang [~COLOR_GREEN~E~COLOR_WHITE~] para magpagamot", 0.35, 0.35, 0.5, 0.88, 255, 255, 255, 0)
                TriggerEvent('redem_roleplay:Tip', "Pindutin ang ~COLOR_RED~ ~INPUT_ENTER~ ~COLOR_WHITE~ para magpagaling sa Duktor", 100)
                if IsControlJustPressed(0, 0xCEFD9220) then                    
                    local playerPed = PlayerPedId()
                    Citizen.Wait(0)
                    ClearPedTasks(PlayerPedId())
                    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_WRITE_NOTEBOOK'), 10000, true, false, false, false)
                    Citizen.Wait(2000)                    
                    ClearPedTasks(PlayerPedId())
                    HealPlayer()
                end
                -- if IsControlJustReleased(0, 0xCEFD9220) then
                --    HealPlayer()
                -- end
            end
        end
    end
end)

function IsPlayerNearCoords(x, y, z, radius)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < radius then
        return true
    end
end

function DisplayNPCText(text, s1, s2, x, y, r, g, b, font)
    SetTextScale(s1, s2)
    SetTextColor(r, g, b, 255)--r,g,b,a
    SetTextCentre(true)--true,false
    SetTextDropshadow(1, 0, 0, 0, 200)--distance,r,g,b,a
    SetTextFontForCurrentCommand(font)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

function HealPlayer()
    healing = true

    Wait(10000)
    if IsPlayerNearCoords(-1804.512, -429.958, 158.831, 1) then
        Citizen.InvokeNative(0x50C803A4CD5932C5, true)
        Citizen.InvokeNative(0xC6258F41D86676E0, GetPlayerPed(), 0, 100)
        Citizen.InvokeNative(0xC6258F41D86676E0, GetPlayerPed(), 1, 100)
        TriggerEvent('redem_roleplay:NotifyLeft', "Healing successful", "Stay safe out there, cowboy.", "generic_textures", "tick", 8000)
        healing = false
    else
        TriggerEvent('redem_roleplay:NotifyLeft', "Nakansela ang iyong pagpapagamot", "Gumalaw ka habang ginagamot ng ~COLOR_GREEN~Duktor", "menu_textures", "cross", 8000)
        healing = false
    end
end
