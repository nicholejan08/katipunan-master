
local dummy
local is_particle_effect_active = false
local ptfx_handle_id = false

local particle_effect = false

local Keys = {
    ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2,

    ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422,
     
    ["BACKSPACE"] = 0x156F7119, ["TAB"] = 0xB238FE0B, ["ENTER"] = 0xC7B5340A, ["LEFTSHIFT"] = 0x8FFC75D6, ["LEFTCTRL"] = 0xDB096B85, ["LEFTALT"] = 0x8AAA0AD4, ["SPACE"] = 0xD9D0E1C0, ["PAGEUP"] = 0x446258B6, ["PAGEDOWN"] = 0x3C3DD371, ["DELETE"] = 0x4AF4D473,
    
    ["Q"] = 0xDE794E3E, ["W"] = 0x8FD015D8, ["E"] = 0xCEFD9220, ["R"] = 0xE30CD707, ["U"] = 0xD8F73058, ["P"] = 0xD82E0BD2, ["A"] = 0x7065027D, ["S"] = 0xD27782E3, ["D"] = 0xB4E465B4, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["L"] = 0x80F28E95, ["Z"] = 0x26E9DC00, ["X"] = 0x8CC9CD42, ["C"] = 0x9959A6F0, ["V"] = 0x7F8D09B8, ["B"] = 0x4CC0E2FE, ["N"] = 0x4BC9DABB, ["M"] = 0xE31C6A41,

    ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313, ["UP"] = 0x6319DB71, ["DOWN"] = 0x05CA7C52,

    ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MDOWN"] = 0x8BDE7443
}

CreateThread(function()
	while true do
		Wait(5)
        local ped = PlayerPedId()

        if not IsEntityDead(ped) then
            if IsControlJustPressed(0, Keys['U']) then
                if not DoesEntityExist(dummy) then
                    spawnDummyPed()
                else
                    removeDummyPed()
                end
            end
        else
            removeDummyPed()
        end
	end
end)

CreateThread(function()
	while true do
		Wait(5)

        if DoesEntityExist(dummy) then
            if IsEntityDead(dummy) then
                Wait(1000)
                removeDummyPed()
                Wait(1000)
                spawnDummyPed()
            end
        end
	end
end)

function spawnDummyPed()

    local model = ""
    local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
    local num = math.random(2, 30)/10
    local hostile = false

    for key, value in pairs(Config.settings) do
        model = value.dummyModel
    end

    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(100)
    end

    dummy = CreatePed(model, px, py, pz, GetEntityHeading(ped), false, true) 

    local coords = vector3(px+num, py+num, pz-0.5)
    SetEntityCoords(dummy, coords)    

    local cx, cy, cz = table.unpack(GetEntityCoords(dummy, 0))
    local blip = SET_BLIP_TYPE(dummy)
    local sprite = 1321928545
    SetBlipSprite(blip, sprite, 1)

    SetPedPromptName(dummy, "Dummy")
    SetPedNameDebug(dummy, "Dummy")
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Dummy")

    SetPedRandomComponentVariation(dummy, 0)
    Citizen.InvokeNative(0x740CB4F3F602C9F4, dummy, true)

    for key, value in pairs(Config.settings) do
        hostile = value.hostile
    end

    if hostile then
        TaskCombatPed(dummy, ped)
    end

    for key, value in pairs(Config.settings) do
        GiveWeaponToPed_2(dummy, value.weapon, 10, true, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
        SetCurrentPedWeapon(dummy, value.weapon, true)
    end

    SetEntityHealth(dummy, GetEntityHealth(ped), 0)
    Wait(200)
    playParticle("scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", dummy, 0.8)
end

function removeDummyPed()
    playParticle("scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", dummy, 0.8)
    Wait(200)
    DeleteEntity(dummy)
end

function SET_BLIP_TYPE (entity)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, entity)
end

function playParticle(pDict, pName, entity, size)
    local new_ptfx_dictionary = "scr_fme_spawn_effects"
    local new_ptfx_name = "scr_net_fetch_smoke_puff"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_particle_effect_active then
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

            
            ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name, entity, 0, 0, 0, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, ptfx_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, ptfx_handle_id, false)   -- RemoveParticleFx
            end
        end
        ptfx_handle_id = false
        is_particle_effect_active = false	
    end
end
