

-- ////////////////////////////////////// VARIABLES

local killClones = false
local spawned = false
local maxClones = 6
local deathCount = 0

local manualCount = 1
local showCount = false
local startTimer = false
local cloneEmoting = false
local displayTimer = 0
local allowScroll = false

local is_particle_effect_active = false
local current_ptfx_handle_id = false

local dynamicClones = false

local Keys = {
    ["A"] = 0x7065027D, ["B"] = 0x4CC0E2FE, ["C"] = 0x9959A6F0, ["D"] = 0xB4E465B4, ["E"] = 0xCEFD9220, ["F"] = 0xB2F377E8, ["G"] = 0x760A9C6F, ["H"] = 0x24978A28, ["I"] = 0xC1989F95, ["J"] = 0xF3830D8E, ["L"] = 0x80F28E95, ["M"] = 0xE31C6A41, ["N"] = 0x4BC9DABB, ["O"] = 0xF1301666, ["P"] = 0xD82E0BD2, ["Q"] = 0xDE794E3E, ["R"] = 0xE30CD707, ["S"] = 0xD27782E3, ["T"] = 0x9720FCEE, ["U"] = 0xD8F73058, ["V"] = 0x7F8D09B8, ["W"] = 0x8FD015D8, ["X"] = 0x8CC9CD42, ["Z"] = 0x26E9DC00, ["RIGHTBRACKET"] = 0xA5BDCD3C, ["LEFTBRACKET"] = 0x430593AA, ["MOUSE1"] = 0x07CE1E61, ["MOUSE2"] = 0xF84FA74F, ["MOUSE3"] = 0xCEE12B50, ["MWUP"] = 0x3076E97C, ["MWDN"] = 0x8BDE7443, ["CTRL"] = 0xDB096B85, ["TAB"] = 0xB238FE0B, ["SHIFT"] = 0x8FFC75D6, ["SPACE"] = 0xD9D0E1C0, ["ENTER"] = 0xC7B5340A, ["BACKSPACE"] = 0x156F7119, ["LALT"] = 0x8AAA0AD4, ["DEL"] = 0x4AF4D473, ["PGUP"] = 0x446258B6, ["PGDN"] = 0x3C3DD371, ["HOLDLALT"] = 0xE8342FF2, ["HOME"] = 0x064D1698, ["F1"] = 0xA8E3F467, ["F4"] = 0x1F6D95E5, ["F6"] = 0x3C0A40F2, ["1"] = 0xE6F612E4, ["2"] = 0x1CE6D9EB, ["3"] = 0x4F49CC4C, ["4"] = 0x8F9F9E58, ["5"] = 0xAB62E997, ["6"] = 0xA1FDE2A6, ["7"] = 0xB03A913B, ["8"] = 0x42385422, ["DOWN"] = 0x05CA7C52, ["UP"] = 0x6319DB71, ["LEFT"] = 0xA65EBAB4, ["RIGHT"] = 0xDEB34313
}

-- ////////////////////////////////////// SPEECH

local _strblob = string.blob or function(length)
    return string.rep("\0", math.max(40 + 1, length))
end

DataView = {
    EndBig = ">",
    EndLittle = "<",
    Types = {
        Int8 = { code = "i1", size = 1 },
        Uint8 = { code = "I1", size = 1 },
        Int16 = { code = "i2", size = 2 },
        Uint16 = { code = "I2", size = 2 },
        Int32 = { code = "i4", size = 4 },
        Uint32 = { code = "I4", size = 4 },
        Int64 = { code = "i8", size = 8 },
        Uint64 = { code = "I8", size = 8 },

        LuaInt = { code = "j", size = 8 }, 
        UluaInt = { code = "J", size = 8 }, 
        LuaNum = { code = "n", size = 8}, 
        Float32 = { code = "f", size = 4 },
        Float64 = { code = "d", size = 8 }, 
        String = { code = "z", size = -1, }, 
    },

    FixedTypes = {
        String = { code = "c", size = -1, },
        Int = { code = "i", size = -1, },
        Uint = { code = "I", size = -1, },
    },
}
DataView.__index = DataView
local function _ib(o, l, t) return ((t.size < 0 and true) or (o + (t.size - 1) <= l)) end
local function _ef(big) return (big and DataView.EndBig) or DataView.EndLittle end
local SetFixed = nil
function DataView.ArrayBuffer(length)
    return setmetatable({
        offset = 1, length = length, blob = _strblob(length)
    }, DataView)
end
function DataView.Wrap(blob)
    return setmetatable({
        offset = 1, blob = blob, length = blob:len(),
    }, DataView)
end
function DataView:Buffer() return self.blob end
function DataView:ByteLength() return self.length end
function DataView:ByteOffset() return self.offset end
function DataView:SubView(offset)
    return setmetatable({
        offset = offset, blob = self.blob, length = self.length,
    }, DataView)
end
for label,datatype in pairs(DataView.Types) do
    DataView["Get" .. label] = function(self, offset, endian)
        local o = self.offset + offset
        if _ib(o, self.length, datatype) then
            local v,_ = string.unpack(_ef(endian) .. datatype.code, self.blob, o)
            return v
        end
        return nil
    end

    DataView["Set" .. label] = function(self, offset, value, endian)
        local o = self.offset + offset
        if _ib(o, self.length, datatype) then
            return SetFixed(self, o, value, _ef(endian) .. datatype.code)
        end
        return self
    end
    if datatype.size >= 0 and string.packsize(datatype.code) ~= datatype.size then
        local msg = "Pack size of %s (%d) does not match cached length: (%d)"
        error(msg:format(label, string.packsize(fmt[#fmt]), datatype.size))
        return nil
    end
end
for label,datatype in pairs(DataView.FixedTypes) do
    DataView["GetFixed" .. label] = function(self, offset, typelen, endian)
        local o = self.offset + offset
        if o + (typelen - 1) <= self.length then
            local code = _ef(endian) .. "c" .. tostring(typelen)
            local v,_ = string.unpack(code, self.blob, o)
            return v
        end
        return nil
    end
    DataView["SetFixed" .. label] = function(self, offset, typelen, value, endian)
        local o = self.offset + offset
        if o + (typelen - 1) <= self.length then
            local code = _ef(endian) .. "c" .. tostring(typelen)
            return SetFixed(self, o, value, code)
        end
        return self
    end
end

SetFixed = function(self, offset, value, code)
    local fmt = { }
    local values = { }
    if self.offset < offset then
        local size = offset - self.offset
        fmt[#fmt + 1] = "c" .. tostring(size)
        values[#values + 1] = self.blob:sub(self.offset, size)
    end
    fmt[#fmt + 1] = code
    values[#values + 1] = value
    local ps = string.packsize(fmt[#fmt])
    if (offset + ps) <= self.length then
        local newoff = offset + ps
        local size = self.length - newoff + 1

        fmt[#fmt + 1] = "c" .. tostring(size)
        values[#values + 1] = self.blob:sub(newoff, self.length)
    end
    self.blob = string.pack(table.concat(fmt, ""), table.unpack(values))
    self.length = self.blob:len()
    return self
end

DataStream = { }
DataStream.__index = DataStream

function DataStream.New(view)
    return setmetatable({ view = view, offset = 0, }, DataStream)
end

for label,datatype in pairs(DataView.Types) do
    DataStream[label] = function(self, endian, align)
        local o = self.offset + self.view.offset
        if not _ib(o, self.view.length, datatype) then
            return nil
        end
        local v,no = string.unpack(_ef(endian) .. datatype.code, self.view:Buffer(), o)
        if align then
            self.offset = self.offset + math.max(no - o, align)
        else
            self.offset = no - self.view.offset
        end
        return v
    end
end

local function play_ambient_speech_from_entity(entity_id,sound_ref_string,sound_name_string,speech_params_string,speech_line)
    local struct = DataView.ArrayBuffer(128)
    local sound_name = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", sound_name_string,Citizen.ResultAsLong())
    local sound_ref  = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING",sound_ref_string,Citizen.ResultAsLong())
    local speech_params = GetHashKey(speech_params_string)
    local sound_name_BigInt =  DataView.ArrayBuffer(16)
    sound_name_BigInt:SetInt64(0,sound_name)
    local sound_ref_BigInt =  DataView.ArrayBuffer(16)
    sound_ref_BigInt:SetInt64(0,sound_ref)
    local speech_params_BigInt = DataView.ArrayBuffer(16)
    speech_params_BigInt:SetInt64(0,speech_params)
    struct:SetInt64(0,sound_name_BigInt:GetInt64(0))
    struct:SetInt64(8,sound_ref_BigInt:GetInt64(0))
    struct:SetInt32(16, speech_line)   
    struct:SetInt64(24,speech_params_BigInt:GetInt64(0))
    struct:SetInt32(32, 0)
    struct:SetInt32(40, 1)
    struct:SetInt32(48, 1)
    struct:SetInt32(56, 1)
    Citizen.InvokeNative(0x8E04FEDD28D42462, entity_id, struct:Buffer());
end

local function play_ambient_speech_from_position(x,y,z,sound_ref_string,sound_name_string,speech_line)
    local struct = DataView.ArrayBuffer(128)
    local sound_name = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", sound_name_string,Citizen.ResultAsLong())
    local sound_ref  = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING",sound_ref_string,Citizen.ResultAsLong())
    local sound_name_BigInt =  DataView.ArrayBuffer(16)
    sound_name_BigInt:SetInt64(0,sound_name)
    local sound_ref_BigInt =  DataView.ArrayBuffer(16)
    sound_ref_BigInt:SetInt64(0,sound_ref)
    local speech_params_BigInt = DataView.ArrayBuffer(16)
    speech_params_BigInt:SetInt64(0,291934926)
    struct:SetInt64(0,sound_name_BigInt:GetInt64(0))
    struct:SetInt64(8,sound_ref_BigInt:GetInt64(0))
    struct:SetInt32(16, speech_line)   
    struct:SetInt64(24,speech_params_BigInt:GetInt64(0))
    struct:SetInt32(32, 0)
    struct:SetInt32(40, 1)
    struct:SetInt32(48, 1)
    struct:SetInt32(56, 1)
    Citizen.InvokeNative(0xED640017ED337E45,x,y,z,struct:Buffer())
end

-- ////////////////////////////////////// EVENTS

RegisterNetEvent('nic_sombra:allowScroll')
AddEventHandler('nic_sombra:allowScroll', function(source)
    allowScroll = true
end)

RegisterNetEvent('nic_sombra:Initialize')
AddEventHandler('nic_sombra:Initialize', function(source)
    local ped = PlayerPedId()
    spellAnimation()
    for key, value in pairs(Config.settings) do

        if value.cloneSpawnType == "manual" then
            if value.numberOfClones > maxClones then
                for i = 3, 1, -1 do
                    TriggerEvent("nic_sombra:spawnClone")
                end
            else
                for i = value.numberOfClones, 1, -1 do
                    TriggerEvent("nic_sombra:spawnClone")
                end
            end
        elseif value.cloneSpawnType == "healthBased" then
            local hp = GetEntityHealth(ped)
            local cloneCount = 0

            if hp > 100 then
                cloneCount = 6
            elseif hp < 100 and hp > 84.4 then
                cloneCount = 5
            elseif hp < 83.4 and hp > 67.8 then
                cloneCount = 4
            elseif hp < 66.8 and hp > 51.2 then
                cloneCount = 3
            elseif hp < 50.2 and hp > 34.6 then
                cloneCount = 2
            elseif hp < 33.6 and hp > 18.6 then
                cloneCount = 1
            elseif hp < 17.6 then
                cloneCount = 0
            end

            for i = cloneCount, 1, -1 do
                TriggerEvent("nic_sombra:spawnClone")
            end
        elseif value.cloneSpawnType == "random" then
            local sRnd = math.random(0, maxClones)

            for i = sRnd, 1, -1 do
                TriggerEvent("nic_sombra:spawnClone")
            end
        elseif value.cloneSpawnType == "dynamic" then
            for i = manualCount, 1, -1 do
                TriggerEvent("nic_sombra:spawnClone")
            end
        else
            if value.numberOfClones > maxClones then
                for i = 3, 1, -1 do
                    TriggerEvent("nic_sombra:spawnClone")
                end
            else
                for i = value.numberOfClones, 1, -1 do
                    TriggerEvent("nic_sombra:spawnClone")
                end
            end
        end
    end
end)

RegisterNetEvent('nic_sombra:spawnClone')
AddEventHandler('nic_sombra:spawnClone', function()
    local ped = PlayerPedId()
    local playerHealth = GetEntityHealth(ped)
    local coords = GetEntityCoords(ped)
    local player = PlayerId()
    local group = GetPedGroupIndex(ped)

    local clone = ClonePed(ped, true, true, true)
    local cCoords = GetEntityCoords(clone)
    local cBlip = AddBlipForEntity(clone)
    local blipSprite = 1321928545
    local xPlace = math.random(0, 1)
    local yPlace = math.random(0, 1)
    local weapon = ""

    local xLoc = math.random(1, 2)
    local yLoc = math.random(1, 2)

    if xPlace == 0 then
        xLoc = xLoc * -1
    end

    if yPlace == 0 then
        yLoc = yLoc * -1
    end

    SetEntityCoords(clone, coords.x+xLoc, coords.y+yLoc, coords.z-1.0)
    AddExplosion(cCoords, 12, 0.0, true, false, 0.5)
    startNonLoopedParticle(clone, "scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", 0.0, 0.0, -0.2, 0.8)
    SetBlipSprite(cBlip, blipSprite, 1)
    SetBlipName(cBlip, "Clone")
    SetEntityHealth(clone, playerHealth, 0)

	for key, value in pairs(Config.settings) do
        SetPedScale(clone, value.cloneScale)
	end

    SetPedNameDebug(clone, "Clone")
    SetPedPromptName(clone, "Clone")
    
    SetPedAsGroupMember(clone, group)
    SetPedCanBeTargettedByPlayer(clone, player, true)
    SetPedCanBeTargetted(clone, true)
    SetPedCanBeTargettedByTeam(clone, group, true)
    SetEntityCanBeDamaged(clone, true)

    SetPedCanPlayAmbientAnims(clone, true)
    SetPedCanPlayAmbientBaseAnims(clone, true)
    SetPedCanPlayGestureAnims(clone, true)
    SetPedCanUseAutoConversationLookat(clone, true)

    SetPedConfigFlag(clone, 294, false) -- DisableShockingEvents
    SetPedConfigFlag(clone, 229, true) -- DisablePanicInVehicle
    SetPedConfigFlag(clone, 208, true) -- DisableExplosionReactions
    SetPedConfigFlag(clone, 140, true) -- CanAttackFriendly
    SetPedConfigFlag(clone, 128, true) -- CanBeAgitated
    SetPedConfigFlag(clone, 184, true) -- PreventAutoShuffleToDriversSeat

	for key, value in pairs(Config.settings) do
        if value.cloneWeapons then
            local wRnd = math.random(0, 15)

            if wRnd == 0 then
                weapon = "WEAPON_BOW_IMPROVED"
            elseif wRnd == 1 then
                weapon = "WEAPON_BOW"
            elseif wRnd == 2 then
                weapon = "WEAPON_MELEE_MACHETE"
            elseif wRnd == 3 then
                weapon = "WEAPON_MELEE_KNIFE"
            elseif wRnd == 4 then
                weapon = "WEAPON_MELEE_MACHETE"
            elseif wRnd == 5 then
                weapon = "WEAPON_MELEE_CLEAVER"
            elseif wRnd == 6 then
                weapon = "WEAPON_RIFLE_VARMINT"
            elseif wRnd == 7 then
                weapon = "WEAPON_RIFLE_SPRINGFIELD"
            elseif wRnd == 8 then
                weapon = "WEAPON_REVOLVER_CATTLEMAN"
            elseif wRnd == 9 then
                weapon = "WEAPON_REPEATER_HENRY"
            elseif wRnd == 10 then
                weapon = "WEAPON_REPEATER_CARBINE"
            elseif wRnd == 11 then
                weapon = "WEAPON_PISTOL_MAUSER"
            elseif wRnd == 12 then
                weapon = "WEAPON_PISTOL_M1899"
            elseif wRnd == 13 then
                weapon = "WEAPON_SHOTGUN_PUMP"
            elseif wRnd == 14 then
                weapon = "WEAPON_SHOTGUN_SAWEDOFF"
            elseif wRnd == 15 then
                weapon = "WEAPON_SHOTGUN_DOUBLEBARREL"
            end
        end
	end

    GiveWeaponToPed_2(clone, GetHashKey(weapon), 10, true, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
    SetCurrentPedWeapon(clone, GetHashKey(weapon), true)

    local emoteRnd = math.random(0, 14)

    if emoteRnd == 0 then
        TaskPlayEmote(clone, 0x3AD8141A)
    elseif emoteRnd == 1 then
        TaskPlayEmote(clone, 0x711D2A1F)
    elseif emoteRnd == 2 then
        TaskPlayEmote(clone, 0x949C021C)
    elseif emoteRnd == 3 then
        TaskPlayEmote(clone, 0xE4746943)
    elseif emoteRnd == 4 then
        TaskPlayEmote(clone, 0xF2D01E20)
    elseif emoteRnd == 5 then
        TaskPlayEmote(clone, 0xA38D1E64)
    elseif emoteRnd == 6 then
        TaskPlayEmote(clone, 0x0CF840A9)
    elseif emoteRnd == 7 then
        TaskPlayEmote(clone, 0x43F71CA8)
    elseif emoteRnd == 8 then
        TaskPlayEmote(clone, 0x8186AA35)
    elseif emoteRnd == 9 then
        TaskPlayEmote(clone, 0x847214D2)
    elseif emoteRnd == 10 then
        TaskPlayEmote(clone, 0x1960746B)
    elseif emoteRnd == 11 then
        TaskPlayEmote(clone, 0xC84FB6B6)
    elseif emoteRnd == 12 then
        TaskPlayEmote(clone, 0xAD799324)
    elseif emoteRnd == 13 then
        TaskPlayEmote(clone, 0x344F2AAD)
    elseif emoteRnd == 14 then
        TaskPlayEmote(clone, 0xE953BBB7)
    end
    

    spawned = true

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local ped = PlayerPedId()
            
            if DoesEntityExist(clone) then
                
                if IsEntityNearEntity(ped, clone, 12.0) then

                    for key, value in pairs(Config.settings) do

                        if value.showCloneHealthBar then
                            if not IsPauseMenuActive() and not IsCinematicCamRendering() and IsAppActive(`MAP`) ~= 1 then
                                DrawHealth3D(clone)
                            end
                        end

                    end

                else
                    for key, value in pairs(Config.settings) do
                        if value.showCloneHealthBar then
                            DrawDot3D(clone)
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
            local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
            
            if DoesEntityExist(clone) then
                local hCoords = GetEntityCoords(holding)
                if IsEntityNearCoords(clone, hCoords, 4.0) and canAction(clone) then
                    TaskPickupCarriableEntity(clone, holding)
                end
            end
        end
    end)

    
    Citizen.CreateThread(function()
        while true do
            Wait(5)
            local ped = PlayerPedId()
            local hour = GetClockHours()

            if DoesEntityExist(clone) and not IsEntityDead(clone) then

                if hour >= 7 and hour <= 19 then
                    if not IsPedCarryingWeapon(clone, 0x67DC3FDE) then
                        SetCurrentPedWeapon(clone1, 0x67DC3FDE, true)
                    end
                end

            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local ped = PlayerPedId()

            if DoesEntityExist(clone) then
                local cloneHealth = GetEntityHealth(clone)

                if cloneHealth > 130 then
                    SetEntityHealth(clone, 130, 1)
                end

                if GetPedCurrentHeldWeapon(clone) ~= nil then
                    if IsPedStill(clone) and canActionVehicle(clone) then
                        playIdleAnim(clone)
                    end
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local ped = PlayerPedId()

            if DoesEntityExist(clone) then
                if not IsPedCarryingSomething(clone) then
                    if IsPedSprinting(clone) or IsPedRunning(clone) then
                        SetPedRagdollOnCollision(clone, 2000, 0, 0)
                    end
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local laughChance = math.random(0, 1)
        local laughType = math.random(0, 1)

            if DoesEntityExist(clone) then
                if IsPedRagdoll(ped) then
                    if not IsEmoteTaskRunning(ped, 1) then
                        if laughChance == 0 then
                            if laughType == 0 then
                                TaskPlayEmote(clone, 0x2FDFF3B2)
                            else
                                TaskPlayEmote(clone, 0x11B0F575)
                            end
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

            if DoesEntityExist(clone) then
                for key, value in pairs(Config.settings) do
                    SetPedScale(clone, value.cloneScale)                
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local speechInterval = math.random(1000, 4000)
        local sRnd = math.random(0, 1)
        local pRnd = math.random(0, 2)
        local emoteType = math.random(0, 12)
        local turnFace = math.random(0, 3)
        local animation = "mech_loco_m@generic@reaction@pointing@unarmed@stand"
        
            RequestAnimDict(animation)
            while not HasAnimDictLoaded(animation) do
                Wait(100)
            end
        
            if DoesEntityExist(clone) then
                Wait(speechInterval)
                if not IsPedPlayingAnyAnims(ped) then
                    TaskLookAtEntity(clone, ped, 2000, 2000, 2048, 3)
                    exports['nic_speech']:talkSombraClone(clone)
                    Wait(1000)
                    if sRnd == 0 then
                        TaskLookAtEntity(ped, clone, 2000, 2000, 2048, 3)
                        exports['nic_speech']:talkSombraClone(ped)
                    else
                        if not cloneEmoting then
                            if not IsPedMoving(ped) and not (IsAimCamActive() or IsPlayerFreeAiming(PlayerId())) then
                                if turnFace == 0 then
                                    TaskTurnPedToFaceEntity(ped, clone, 2000)
                                    Wait(2000)
                                    if pRnd == 0 then
                                        ClearPedTasks(ped)
                                        HidePedWeapons(ped)

                                        if IsEntityNearEntity(ped, clone, 7.0) then
                                            if emoteType == 0 then
                                                TaskPlayEmote(ped, 969312568)
                                            elseif emoteType == 1 then
                                                TaskPlayEmote(ped, 1256841324)
                                            elseif emoteType == 2 then
                                                TaskPlayEmote(ped, 0xB755B5B1)
                                                TaskPlayEmote(clone, 0xB755B5B1)
                                            elseif emoteType == 3 then
                                                TaskPlayEmote(ped, 0xD0528D38)
                                            elseif emoteType == 4 then
                                                TaskPlayEmote(ped, 0xFFF9D9F1)
                                            elseif emoteType == 5 then
                                                TaskPlayEmote(ped, 0xAD799324)
                                            elseif emoteType == 6 then
                                                TaskPlayEmote(ped, 0xD91245C6)
                                            elseif emoteType == 7 then
                                                TaskPlayEmote(ped, 0x13A5C689)
                                            elseif emoteType == 8 then
                                                TaskPlayEmote(ped, 0x5B65DD1D)
                                            elseif emoteType == 9 then
                                                TaskPlayEmote(ped, 0x5B65DD1D)
                                            elseif emoteType == 10 then
                                                TaskPlayEmote(ped, 0x711D2A1F)
                                            elseif emoteType == 11 then
                                                TaskPlayEmote(ped, 0x6B6D921F)
                                            else
                                                TaskPlayAnim(ped, animation, "point_fwd_0", 1.0, 8.0, 1500, 31, 0, true, 0, false, 0, false)
                                            end
                                        else
                                            if emoteType == 0 then
                                                TaskPlayEmote(ped, 0x427B55FF)
                                            elseif emoteType == 1 then
                                                TaskPlayEmote(ped, 0x5EFEBD3B)
                                            elseif emoteType == 2 then
                                                TaskPlayEmote(ped, 0x37BD5D0E)
                                            elseif emoteType == 3 then
                                                TaskPlayEmote(ped, 0x3AD8141A)
                                            elseif emoteType == 4 then
                                                TaskPlayEmote(ped, 0xD91245C6)
                                            elseif emoteType == 5 then
                                                TaskPlayEmote(ped, 0x344F2AAD)
                                            else
                                                TaskPlayEmote(ped, 0x9CA62011)
                                            end
                                        end

                                        cloneEmoting = true
                                    end
                                end
                                Wait(1000)
                                exports['nic_speech']:talkSombraClone(ped)
                                cloneEmoting = false
                            end
                        end
                    end
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local ped = PlayerPedId()

            if deathCount == maxClones then
                killClones = false
                spawned = false
                deathCount = 0
            end

            if DoesEntityExist(clone) then

                if not IsEntityNearEntity(clone, ped, 32.0) then
                    SetEntityHealth(clone, 0, 1)
                end

                if IsPedInMeleeCombat(ped) then
                    SetBlockingOfNonTemporaryEvents(clone, false)
                else
                    SetBlockingOfNonTemporaryEvents(clone, true)
                end

                if IsEntityDead(clone) then
                    Wait(2000)
                    local cCoords = GetEntityCoords(clone)
                    AddExplosion(cCoords, 12, 0.0, true, false, 0.5)
                    startNonLoopedParticle(clone, "scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", 0.0, 0.0, -0.2, 0.8)
                    Wait(50)
                    DeleteEntity(clone)
                    if deathCount < maxClones then
                        deathCount = deathCount + 1
                    end
                end

                if IsEntityDead(ped) then
                    killClones = true
                end

                if killClones then 
                    SetEntityHealth(clone, 0, 1)
                    Wait(2000)
                    local cCoords = GetEntityCoords(clone)
                    AddExplosion(cCoords, 12, 0.0, true, false, 0.5)
                    startNonLoopedParticle(clone, "scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", 0.0, 0.0, -0.2, 0.8)
                    Wait(50)
                    DeleteEntity(clone)
                    startNonLoopedParticle(cloneProp, "scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", 0.0, 0.0, -0.2, 0.2)
                    DeleteEntity(cloneProp)
                    killClones = false
                    spawned = false
                    deathCount = 0
                end
            end
        end
    end)

end)

-- ////////////////////////////////////// LOOPS

-- key press

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()

        if allowScroll then
        
            if canAction(ped) and not spawned then
    
                for key, value in pairs(Config.settings) do
                    if value.cloneSpawnType == "dynamic" then
                
                        if IsControlJustPressed(0, Keys['MWUP']) then
                            displayTimer = 3
                            TriggerServerEvent("nic_sombra:allowServerScroll")
                        end
                        if IsControlJustPressed(0, Keys['MWDN']) then
                            displayTimer = 3
                            TriggerServerEvent("nic_sombra:allowServerScroll")
                        end
        
                    end
                end
            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()
      
      if allowScroll then
        if canAction(ped) and not spawned then
  
          for key, value in pairs(Config.settings) do
              if value.cloneSpawnType == "dynamic" then
                  if IsControlJustPressed(0, Keys['MWUP']) then
                      if manualCount < maxClones then
                          manualCount = manualCount + 1
                          playScrollAudio()
                      end
                  elseif IsControlJustPressed(0, Keys['MWDN']) then
                      if manualCount > 1 then
                          manualCount = manualCount - 1
                          playScrollAudio()
                      end
                  end
              end
          end
      end

      end
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()

      if not spawned then
        if displayTimer > 0 then
          displayTimer = displayTimer - 1
          Wait(1000)
        end
        
        if displayTimer == 0 then
          displayTimer = 0
          showCount = false
          startTimer = false
        end
      end
      
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()
      local coords = GetEntityCoords(ped)

      if not spawned then
        if displayTimer > 0 then
            DrawText3D(coords.x, coords.y, coords.z+1.0, ""..manualCount)
        end
      end
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()
      
      if canAction(ped) then
        if IsControlJustPressed(0, Keys['MOUSE3']) then
            if not spawned then
                if deathCount == 0 then
                    TriggerServerEvent("nic_sombra:checkJob")
                end
            else
                spellAnimation()
                killClones = true
            end
        end
      end
    end
end)

-- events

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()

      SetPedConfigFlag(ped, 140, true) -- CanAttackFriendly
    end
end)

-- ////////////////////////////////////// FUNCTIONS

function IsPedCarryingWeapon(entity, weapon)
    return Citizen.InvokeNative(0xF29A186ED428B552, entity, weapon)
end

function IsPedPlayingAnyAnims()
    if IsPedUsingAnyScenario(entity) or IsEmoteTaskRunning(entity, 1) or IsPedCarryingSomething(entity) then
        return true
    end
end

function GetPedCurrentHeldWeapon(entity)
    return Citizen.InvokeNative(0x8425C5F057012DAB, entity)
end

function HidePedWeapons(entity)
    return Citizen.InvokeNative(0xFCCC886EDE3C63EC, entity, 1, true, false)
end

function IsAimCamActive()
    if Citizen.InvokeNative(0x698F456FB909E077) then
        return true
    end
end

function IsEmoteTaskRunning(entity)
    return Citizen.InvokeNative(0xCF9B71C0AF824036, entity, 1)
end

function TaskPlayEmote(entity, emote)
    return Citizen.InvokeNative(0xB31A277C1AC7B7FF, entity, 0, 0, emote, 1, 1, 0, 0)
end

function TaskTurnPedToFaceEntity(entity, target, duration)
    return Citizen.InvokeNative(0x5AD23D40115353AC, entity, target, duration, 1, 1, 1)
end

function playScrollAudio()
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

function IsPedHogtied(entity)
    return Citizen.InvokeNative(0x3AA24CCC0D451379, entity)
end

function IsPedBeingHogtied(entity)
    return Citizen.InvokeNative(0xD453BB601D4A606E, entity)
end

function IsPedCarryingSomething(entity)
    return Citizen.InvokeNative(0xA911EE21EDF69DAF, entity)
end

function IsPedMoving(entity)
    if IsPedWalking(entity) or IsPedRunning(entity) or IsPedSprinting(entity) or IsPedClimbing(entity) or IsPedJumping(entity) then
        return true
    end
end

function canAction(entity)
    local hp = GetEntityHealth(entity)
    if not IsEntityDead(entity) and not IsPedRagdoll(entity) and not IsPedGettingUp(entity) and not IsPedInAnyVehicle(entity) and not IsPedFalling(entity) and not IsPedInMeleeCombat(entity) and not IsPedHogtied(entity) and not IsPedBeingHogtied(entity) and not IsPedCarryingSomething(entity) then
        return true
    end
end

function canActionVehicle(entity)
    local hp = GetEntityHealth(entity)
    if not IsEntityDead(entity) and not IsPedRagdoll(entity) and not IsPedGettingUp(entity) and not IsPedFalling(entity) and not IsPedInMeleeCombat(entity) and not IsPedHogtied(entity) and not IsPedBeingHogtied(entity) and not IsPedCarryingSomething(entity) then
        return true
    end
end

function AddBlipForEntity(entity)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, entity)
end

function SetBlipName(blip, blipName)
    return Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipName)
end

function SetPedRagdollOnCollision(entity, duration, bool1, bool2)
    return Citizen.InvokeNative(0xF0A4F1BBF4FA7497, entity, duration, bool1, bool2)
end

function IsEntityNearCoords(entity, coords, dist)
    local eCoords = GetEntityCoords(entity)
    local distance = GetDistanceBetweenCoords(eCoords, coords, true)

    if distance < dist then
        return true
    end
end

function IsEntityNearEntity(entity1, entity2, dist)
    local ex, ey, ez = table.unpack(GetEntityCoords(entity1, 0))
    local ex2, ey2, ez2 = table.unpack(GetEntityCoords(entity2, 0))
    local distance = GetDistanceBetweenCoords(ex, ey, ez, ex2, ey2, ez2, true)

    if distance < dist then
        return true
    end
end

function spellAnimation()
    local ped = PlayerPedId()
    local animation = "amb_misc@world_human_pray_rosary@base"
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_L_Hand")
    local coords = GetEntityCoords(ped)

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end

    TaskPlayAnim(ped, animation, "base", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(800)
    StopAnimTask(ped, animation, "base", 1)
end

function startNonLoopedParticle(entity, dict, lib, x, y, z, size)
    local new_ptfx_dictionary = dict
    local new_ptfx_name = lib
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

            
            current_ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, entity, x, y, z, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_ptfx_handle_id = false
        is_particle_effect_active = false	
    end
    
end

function playSmokeAudio()
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

function playIdleAnim(entity)
    local ped = PlayerPedId()
    local boneIndex = GetEntityBoneIndexByName(entity, "SKEL_R_Hand")
    local canteenAnimation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    local cannedAnimation = "mech_inventory@eating@canned_food@cylinder@d8-2_h10-5"
    local foodAnimation = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich"
    local drinkWaterAnimation = "amb_rest_drunk@world_human_bucket_drink@ground@male_a@idle_b"
    local washAnimation = "amb_misc@world_human_wash_face_bucket@ground@male_a@idle_d"
    local propName = ""
    local animRandom = 0
    local cloneProp
    local urineChance = math.random(0, 8)

    local getWater1 = "mech_pickup@system@rh"
    local getWater2 = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    
    HidePedWeapons(entity)

    if IsEntityInWater(entity) and not IsPedSwimming(entity) and not IsPedOnMount(entity) then
        animRandom = math.random(1, 4)
    else
        animRandom = math.random(4, 50)
    end

    if not IsPedSprinting(entity) or not IsPedRunning(entity) or not IsPedWalking(entity) and not IsPedRagdoll(entity) and not entityHealth <= 45 and not IsPedInMeleeCombat(ped) or not IsPedInMeleeCombat(entity) then
        local rndDuration = math.random(3000, 7000)
        Wait(rndDuration)
        HidePedWeapons(entity)

        if animRandom == 1 and IsPedStill(entity) then
            if not IsPedOnMount(entity) and not IsPedInAnyVehicle(entity, false) and not IsPedOnVehicle(entity, true) and not IsPedHangingOnToVehicle(entity) and not IsPedInFlyingVehicle(entity) and not IsPedSittingInAnyVehicle(entity) then
                RequestAnimDict(drinkWaterAnimation)
                while ( not HasAnimDictLoaded(drinkWaterAnimation)) do 
                    Citizen.Wait( 100 )
                end
                TaskPlayAnim(entity, drinkWaterAnimation, "idle_f", 8.0, -8.0, -1, 0, 0, true, 0, false, 0, false)
                Wait(9000)
                ClearPedTasks(entity)
            end
        elseif animRandom == 2 and IsPedStill(entity) then  
            if not IsPedOnMount(entity) and not IsPedInAnyVehicle(entity, false) and not IsPedOnVehicle(entity, true) and not IsPedHangingOnToVehicle(entity) and not IsPedInFlyingVehicle(entity) and not IsPedSittingInAnyVehicle(entity) then
                TaskStartScenarioInPlace(entity, GetHashKey('WORLD_HUMAN_WASH_FACE_BUCKET_GROUND_NO_BUCKET'), -1, true, false, false, false)
                Wait(9000)
                Citizen.InvokeNative(0x523C79AEEFCC4A2A,entity,10, "ALL")
                Citizen.InvokeNative(0x6585D955A68452A5, entity)
                Citizen.InvokeNative(0x9C720776DAA43E7E, entity)
                Citizen.InvokeNative(0x8FE22675A5A45817, entity)
                ClearPedEnvDirt(entity)
                ClearPedBloodDamage(entity)
                ClearPedDamageDecalByZone(entity)
                ClearPedTasks(entity)
            end
        elseif animRandom == 3 and IsPedStill(entity) then  
            if not DoesEntityExist(cloneProp) then
                if not IsPedOnMount(entity) and not IsPedInAnyVehicle(entity, false) and not IsPedOnVehicle(entity, true) and not IsPedHangingOnToVehicle(entity) and not IsPedInFlyingVehicle(entity) and not IsPedSittingInAnyVehicle(entity) then
                    RequestAnimDict(getWater1)
                    while ( not HasAnimDictLoaded(getWater1)) do 
                        Citizen.Wait( 100 )
                    end
                    TaskPlayAnim(entity, getWater2, "use_quick", 8.0, -1.0, 120000, 23, 0, true, 0, false, 0, false)
                    Citizen.Wait(1000)
                    local pCoords = GetEntityCoords(cloneProp)
                    cloneProp = CreateObject(GetHashKey('p_cs_canteen_hercule'), pCoords,  true,  true, true)
                    AttachEntityToEntity(cloneProp, entity, boneIndex, 0.12, 0.03, -0.07, -65.0, 0.00, -17.00, true, true, false, true, 1, true)
                    Citizen.Wait(300)
                    TaskPlayAnim(entity, getWater1, "ground_far_swipe", 3.0, -1.0, 120000, 23, 0, true, 0, false, 0, false)
                    startNonLoopedParticle(cloneProp, "core", "ent_sht_water", 0.3)
                    startNonLoopedParticle(cloneProp, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.3)
                    Citizen.Wait(1100)
                    startNonLoopedParticle(cloneProp, "core", "ent_sht_water", 0.3)
                    startNonLoopedParticle(cloneProp, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.3)
                    Citizen.Wait(300)

                    if IsEntityAttachedToEntity(cloneProp, entity) then
                        playKeepkAnimation(entity)
                    else
                        startNonLoopedParticle(cloneProp, "scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", 0.0, 0.0, -0.2, 0.2)
                    end
                    DeleteEntity(cloneProp)
                    Citizen.Wait(1000)
                    ClearPedTasks(entity)
                end
            end
        elseif animRandom == 4 and IsPedStill(entity) then
            if urineChance == 0 then
                if not IsPedOnMount(entity) and not IsPedInAnyVehicle(entity, false) and not IsPedOnVehicle(entity, true) and not IsPedHangingOnToVehicle(entity) and not IsPedInFlyingVehicle(entity) and not IsPedSittingInAnyVehicle(entity) then
                    TaskStartScenarioInPlace(entity, GetHashKey('WORLD_HUMAN_PEE'), -1, true, false, false, false)
                    Wait(6000)
                    local peepeeName = "p_cs_sausage01x"
                    local x, y, z = table.unpack(GetEntityCoords(entity))
                    local boneIndex = GetEntityBoneIndexByName(entity, "SKEL_Pelvis")
                    cloneProp = CreateObject(GetHashKey(peepeeName), x, y, z-1.0,  true,  true, true)
                    AttachEntityToEntity(cloneProp, entity, 1, 0.21, 0.13, -0.01, 2.0, 0.05, -35.21, false, true, false, false, 1, true)
                    Wait(22000)
                    ClearPedTasks(entity)
                    Citizen.Wait(1000)
                    DeleteEntity(cloneProp)
                end
            end
        elseif animRandom == 5 then
            if not DoesEntityExist(cloneProp) then
                RequestAnimDict(cannedAnimation) 
                while ( not HasAnimDictLoaded(cannedAnimation)) do 
                    Citizen.Wait( 100 )
                end
                getItemAnimation(entity)
                propName = "proc_can01x"

                RequestModel(GetHashKey(propName))
                while not HasModelLoaded(GetHashKey(propName)) do
                    Wait(100)
                end

                local pCoords = GetEntityCoords(cloneProp)
                cloneProp = CreateObject(GetHashKey(propName), pCoords,  true,  true, true)
                AttachEntityToEntity(cloneProp, entity, boneIndex, 0.11, -0.03, -0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                Citizen.Wait(600)
                TaskPlayAnim(entity, cannedAnimation, "right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.Wait(2900)
                DetachEntity(cloneProp, 1, 1)
                Citizen.Wait(100)
                ClearPedTasks(entity)
                Citizen.Wait(1000)
                startNonLoopedParticle(cloneProp, "scr_fme_spawn_effects", "scr_net_fetch_smoke_puff", 0.0, 0.0, -0.2, 0.2)
                DeleteEntity(cloneProp)
            end
        elseif animRandom == 6 then
            if not DoesEntityExist(cloneProp) then
                RequestAnimDict(foodAnimation) 
                while ( not HasAnimDictLoaded(foodAnimation)) do 
                    Citizen.Wait( 100 )
                end
                getItemAnimation(entity)
                local fRnd = math.random(0, 5)

                if fRnd == 0 then
                    propName = "p_banana_day_04x"
                elseif fRnd == 1 then
                    propName = "s_bit_bread06"
                elseif fRnd == 2 then
                    propName = "p_apple02x"
                elseif fRnd == 3 then
                    propName = "p_pear_01x"
                elseif fRnd == 4 then
                    propName = "s_cheesewedge1x"
                else
                    propName = "p_bread_14_ab_s_b"
                end

                RequestModel(GetHashKey(propName))
                while not HasModelLoaded(GetHashKey(propName)) do
                    Wait(100)
                end

                local pCoords = GetEntityCoords(cloneProp)
                cloneProp = CreateObject(GetHashKey(propName), pCoords,  true,  true, true)

                if propName == "p_banana_day_04x" then
                    AttachEntityToEntity(cloneProp, entity, boneIndex, 0.09, -0.15, -0.10, -90.0, 190.00, 0.00, true, true, false, true, 1, true)
                elseif propName == "p_apple02x" or propName == "p_pear_01x" then
                    AttachEntityToEntity(cloneProp, entity, boneIndex, 0.11, -0.05, -0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                else
                    AttachEntityToEntity(cloneProp, entity, boneIndex, 0.10, 0.0, -0.08, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
                end

                Citizen.Wait(500)
                TaskPlayAnim(entity, foodAnimation, "quick_right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.Wait(1500)
                DeleteEntity(cloneProp)
                Citizen.Wait(1000)
                ClearPedTasks(entity)
            end
        elseif animRandom == 7 then
            if not DoesEntityExist(cloneProp) then
                RequestAnimDict(canteenAnimation) 
                while ( not HasAnimDictLoaded(canteenAnimation)) do 
                    Citizen.Wait( 100 )
                end
                TaskPlayAnim(entity, canteenAnimation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                Citizen.Wait(700)
                local pCoords = GetEntityCoords(cloneProp)
                cloneProp = CreateObject(GetHashKey('p_cs_canteen_hercule'), pCoords,  true,  true, true)
                AttachEntityToEntity(cloneProp, entity, boneIndex, 0.12, 0.03, -0.07, -65.0, 0.00, -17.00, true, true, false, true, 1, true)
                Citizen.Wait(700)
                startNonLoopedParticle(cloneProp, "core", "bul_decal_water", 0.0, 0.0, 0.1, 0.3)
                startNonLoopedParticle(cloneProp, "core", "ent_sht_gloopy_liquid", 0.0, 0.0, 0.1, 0.5)
                Citizen.Wait(1300)
                startNonLoopedParticle(cloneProp, "core", "ent_sht_moonshine", 0.0, 0.0, 0.1, 0.3)
                AttachEntityToEntity(cloneProp, entity, boneIndex, 0.09, 0.06, -0.05, -65.0, 0.00, -17.00, true, true, false, true, 1, true)            
                if IsEntityAttachedToEntity(cloneProp, entity) then
                    playKeepkAnimation(entity)
                    DeleteEntity(cloneProp)
                    Citizen.Wait(1000)
                    ClearPedTasks(entity)
                else
                    ClearPedTasks(entity)
                end
            end
        elseif animRandom == 0 then    
            TaskPlayEmote(entity, 0x8B7F8EEB)
            ClearPedTasks(entity)
        elseif animRandom == 1 then
            TaskPlayEmote(entity, 0x81615BA3)
        elseif animRandom == 2 then
            TaskPlayEmote(entity, 0xBA51B111)
        elseif animRandom == 3 then
            TaskPlayEmote(entity, 0x43F71CA8)
        elseif animRandom == 4 then
            TaskPlayEmote(entity, 1256841324)
        elseif animRandom == 5 then
            TaskPlayEmote(entity, 1939251934)
        elseif animRandom == 6 then
            TaskPlayEmote(entity, 796723886)
        elseif animRandom == 7 then
            TaskPlayEmote(entity, -2106738342)
        elseif animRandom == 8 then
            TaskPlayEmote(entity, 935157006)
        elseif animRandom == 9 then
            TaskPlayEmote(entity, 901097731)
        elseif animRandom == 10 then
            TaskPlayEmote(entity, 831975651)
        elseif animRandom == 11 then
            TaskPlayEmote(entity, -1118911493)
        elseif animRandom == 12 then
            TaskPlayEmote(entity, 246916594)
        elseif animRandom == 13 then
            TaskPlayEmote(entity, 969312568)
        elseif animRandom == 14 then
            TaskTurnPedToFaceEntity(entity, ped, 1000)
            TaskPlayEmote(entity, 1927505461)
        elseif animRandom == 15 then
            TaskPlayEmote(entity, 0xCDB9A85C)
        elseif animRandom == 16 then
            TaskPlayEmote(entity, 0xE73CA11A)
        elseif animRandom == 17 then
            TaskPlayEmote(entity, 0xB55EEAF3)
        elseif animRandom == 18 then
            TaskPlayEmote(entity, 0xE953BBB7)
        elseif animRandom == 19 then
            TaskPlayEmote(entity, 0xD1DE4D57)
        elseif animRandom == 20 then
            TaskPlayEmote(entity, 0x325069E6)
        elseif animRandom == 20 then
            TaskPlayEmote(entity, 0xB755B5B1)
        elseif animRandom == 21 then
            TaskPlayEmote(entity, 0xEE810879)
        elseif animRandom == 22 then
            TaskPlayEmote(entity, 0xF504A733)
        elseif animRandom == 23 then
            TaskPlayEmote(entity, 0x9B31C214)
        elseif animRandom == 24 then
            TaskPlayEmote(entity, 0xD0528D38)
        elseif animRandom == 25 then
            TaskPlayEmote(entity, 0x3196F0E3)
        elseif animRandom == 26 then
            TaskPlayEmote(entity, 0x9CA62011)
        elseif animRandom == 27 then
            TaskPlayEmote(entity, 0xE68763B3)
        elseif animRandom == 28 then
            TaskPlayEmote(entity, 0xCEF7AA76)
        elseif animRandom == 29 then
            TaskPlayEmote(entity, 0xB1C3DE80)
        elseif animRandom == 30 then
            TaskPlayEmote(entity, 0xB1C3DE80)
        elseif animRandom == 31 then
            TaskPlayEmote(entity, 0xF96C2623)
        elseif animRandom == 32 then
            TaskPlayEmote(entity, 0xD91245C6)
        elseif animRandom == 33 then
            TaskPlayEmote(entity, 0xAFF1D9B3)
        elseif animRandom == 34 then
            TaskPlayEmote(entity, 0x0EB7A5F2)
        elseif animRandom == 35 then
            TaskPlayEmote(entity, 0x6CC9FE53)
        elseif animRandom == 36 then
            TaskPlayEmote(entity, 0x299BD92F)
        elseif animRandom == 37 then
            TaskPlayEmote(entity, 0xA25C7339)
        elseif animRandom == 38 then
            TaskPlayEmote(entity, 0xBA4E4740)
        elseif animRandom == 39 then
            TaskPlayEmote(entity, 0x711D2A1F)
        elseif animRandom == 40 then
            TaskPlayEmote(entity, 0xDF036AFF)
        elseif animRandom == 41 then
            TaskPlayEmote(entity, 0x5B65DD1D)
        elseif animRandom == 42 then
            TaskPlayEmote(entity, 0x828C7F5B)
        elseif animRandom == 43 then
            TaskPlayEmote(entity, 0x3AD8141A)
        elseif animRandom == 44 then
            TaskPlayEmote(entity, 0xF6130E04)
        elseif animRandom == 45 then
            TaskPlayEmote(entity, 0xCFC7AEBA)
        elseif animRandom == 46 then
            TaskPlayEmote(entity, 0xFED34C73)
        elseif animRandom == 47 then
            TaskPlayEmote(entity, 0x6FBDDC68)
        elseif animRandom == 48 then
            TaskPlayEmote(entity, 0xCC2CC3AC)
        elseif animRandom == 49 then
            TaskPlayEmote(entity, 0xEEC55CB7)
        elseif animRandom == 50 then
            TaskPlayEmote(entity, 0x344F2AAD)
        end
    end
end

function HidePedWeapons(entity)
    return Citizen.InvokeNative(0xFCCC886EDE3C63EC, entity, 2, true)
end

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function playKeepkAnimation(entity)
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(entity, animation, "stn_long_low_skill_exit", 3.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Wait(1200)
    ClearPedTasks(entity)
end

function getItemAnimation(entity)
    local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    TaskPlayAnim(entity, animation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(600)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.45, 0.45)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextDropshadow(4, 4, 21, 22, 255)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawDot3D(entity)
    local boneIndex = GetEntityBoneIndexByName(entity, "SKEL_Head")
    local bCoords = GetWorldPositionOfEntityBone(entity, GetPedBoneIndex(entity, 0))
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(bCoords.x, bCoords.y, bCoords.z+1.2)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("BLIPS") then
        RequestStreamedTextureDict("BLIPS", false)
    else
        if GetEntityHealth(entity) <= 0 then
            DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 158, 28, 28, 215, 0)
        elseif GetEntityHealth(entity) <= 5 then
            DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 158, 28, 28, 215, 0)
        elseif GetEntityHealth(entity) <= 25 then
            DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 191, 127, 15, 215, 0)
        elseif GetEntityHealth(entity) <= 50 then
            DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 191, 127, 15, 215, 0)
        elseif GetEntityHealth(entity) <= 75 then
            DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 38, 97, 33, 215, 0)
        else
            DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 38, 97, 33, 215, 0)
        end
    end
end

function DrawHealth3D(entity)
    local boneIndex = GetEntityBoneIndexByName(entity, "SKEL_Head")
    local bCoords = GetWorldPositionOfEntityBone(entity, GetPedBoneIndex(entity, 0))
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(bCoords.x, bCoords.y, bCoords.z+1.2)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x,_y+0.03)

    for key, value in pairs(Config.settings) do
    
        if value.cloneHealthDisplayType == "hearts" then
            if not HasStreamedTextureDictLoaded("itemtype_textures") then
                RequestStreamedTextureDict("itemtype_textures", false)
            else
                if GetEntityHealth(entity) <= 0 then
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                elseif GetEntityHealth(entity) <= 5 then
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                elseif GetEntityHealth(entity) <= 25 then
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                elseif GetEntityHealth(entity) <= 50 then
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                elseif GetEntityHealth(entity) <= 75 then
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                else
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                    DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                end
            end
        elseif value.cloneHealthDisplayType == "ring" then
            if not HasStreamedTextureDictLoaded("rpg_menu_item_effects") then
                RequestStreamedTextureDict("rpg_menu_item_effects", false)
            else
                if GetEntityHealth(entity) <= 0 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_1", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 5 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_2", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 25 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_3", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 50 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_6", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 75 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_8", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 90 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_8", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                else
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_10", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                end
                DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
            end
        elseif value.cloneHealthDisplayType == "simple" then
            if not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("honor_display") then
                RequestStreamedTextureDict("menu_textures", false)
                RequestStreamedTextureDict("honor_display", false)
            else
                if GetEntityHealth(entity) <= 0 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 0, 0, 0, 0, 0)
                elseif GetEntityHealth(entity) <= 5 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 161, 0, 0, 215, 0)
                elseif GetEntityHealth(entity) <= 25 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 0, 0, 215, 0)
                elseif GetEntityHealth(entity) <= 50 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 204, 147, 41, 215, 0)
                elseif GetEntityHealth(entity) <= 75 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 204, 204, 41, 215, 0)
                else
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 41, 234, 63, 215, 0)
                end
            end
        elseif value.cloneHealthDisplayType == "plus" then
            if not HasStreamedTextureDictLoaded("overhead") then
                RequestStreamedTextureDict("overhead", false)
            else
                if GetEntityHealth(entity) <= 0 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 0, 0, 0, 0, 0)
                elseif GetEntityHealth(entity) <= 5 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 161, 0, 0, 215, 0)
                elseif GetEntityHealth(entity) <= 25 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 0, 0, 215, 0)
                elseif GetEntityHealth(entity) <= 50 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 147, 41, 215, 0)
                elseif GetEntityHealth(entity) <= 75 then
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 204, 204, 41, 215, 0)
                else
                    DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 41, 234, 63, 215, 0)
                end
                DrawSprite("overhead", "overhead_revive", _x, _y+0.0125, 0.018, 0.032, 0.1, 255, 255, 255, 200, 0)
            end
        elseif value.cloneHealthDisplayType == "dot" then
            if not HasStreamedTextureDictLoaded("BLIPS") then
                RequestStreamedTextureDict("BLIPS", false)
            else
                if GetEntityHealth(entity) <= 0 then
                    DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 158, 28, 28, 215, 0)
                elseif GetEntityHealth(entity) <= 5 then
                    DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 158, 28, 28, 215, 0)
                elseif GetEntityHealth(entity) <= 25 then
                    DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 191, 127, 15, 215, 0)
                elseif GetEntityHealth(entity) <= 50 then
                    DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 191, 127, 15, 215, 0)
                elseif GetEntityHealth(entity) <= 75 then
                    DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 38, 97, 33, 215, 0)
                else
                    DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 38, 97, 33, 215, 0)
                end
            end
        elseif value.cloneHealthDisplayType == "core" then
            if not HasStreamedTextureDictLoaded("rpg_menu_item_effects") then
                RequestStreamedTextureDict("rpg_menu_item_effects", false)
            else
                if GetEntityHealth(entity) <= 5 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_01", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                elseif GetEntityHealth(entity) <= 20 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_02", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                elseif GetEntityHealth(entity) <= 25 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_03", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                elseif GetEntityHealth(entity) <= 30 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_04", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                elseif GetEntityHealth(entity) <= 35 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_05", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                elseif GetEntityHealth(entity) <= 40 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_06", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 45 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_07", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 50 then
                    DrawSprite("rpg_menu_item_effects", "effect_health_core_08", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 55 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_1", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 60 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_2", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 65 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_3", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 60 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_4", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 75 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_5", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 70 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_6", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 85 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_7", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 80 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_8", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                elseif GetEntityHealth(entity) <= 95 then
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_9", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                else
                    DrawSprite("rpg_menu_item_effects", "rpg_tank_10", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                end
            end
            
        elseif value.cloneHealthDisplayType == "bar" then
            if not HasStreamedTextureDictLoaded("hud_textures") then
                RequestStreamedTextureDict("hud_textures", false)
            else
                if GetEntityHealth(entity) <= 5 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0198, _y+0.0125, 0.000, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 10 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0148, _y+0.0125, 0.015, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 15 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0134, _y+0.0125, 0.018, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 20 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0108, _y+0.0125, 0.023, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 25 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0087, _y+0.0125, 0.027, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 30 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0082, _y+0.0125, 0.028, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 35 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0075, _y+0.0125, 0.030, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 40 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0070, _y+0.0125, 0.031, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 45 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0067, _y+0.0125, 0.032, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 50 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0058, _y+0.0125, 0.034, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 55 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0052, _y+0.0125, 0.035, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 60 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0047, _y+0.0125, 0.036, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 65 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0039, _y+0.0125, 0.038, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 70 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0031, _y+0.0125, 0.039, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 75 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0023, _y+0.0125, 0.040, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 80 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0015, _y+0.0125, 0.042, 0.008, 0.1, 38, 97, 33, 215, 0)
                elseif GetEntityHealth(entity) <= 95 then
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0007, _y+0.0125, 0.044, 0.008, 0.1, 38, 97, 33, 215, 0)
                else
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                    DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.045, 0.008, 0.1, 38, 97, 33, 215, 0)
                end
            end
        end
    end 
end

function talkClone(entity, dict, message)
    play_ambient_speech_from_entity(entity, dict, message,"speech_params_add_blip_shouted_force", 0)
end

local function play_ambient_speech_from_entity(entity_id,sound_ref_string,sound_name_string,speech_params_string,speech_line)
    local struct = DataView.ArrayBuffer(128)
    local sound_name = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", sound_name_string,Citizen.ResultAsLong())
    local sound_ref  = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING",sound_ref_string,Citizen.ResultAsLong())
    local speech_params = GetHashKey(speech_params_string)
    local sound_name_BigInt =  DataView.ArrayBuffer(16)
    sound_name_BigInt:SetInt64(0,sound_name)
    local sound_ref_BigInt =  DataView.ArrayBuffer(16)
    sound_ref_BigInt:SetInt64(0,sound_ref)
    local speech_params_BigInt = DataView.ArrayBuffer(16)
    speech_params_BigInt:SetInt64(0,speech_params)
    struct:SetInt64(0,sound_name_BigInt:GetInt64(0))
    struct:SetInt64(8,sound_ref_BigInt:GetInt64(0))
    struct:SetInt32(16, speech_line)   
    struct:SetInt64(24,speech_params_BigInt:GetInt64(0))
    struct:SetInt32(32, 0)
    struct:SetInt32(40, 1)
    struct:SetInt32(48, 1)
    struct:SetInt32(56, 1)
    Citizen.InvokeNative(0x8E04FEDD28D42462, entity_id, struct:Buffer());
end

