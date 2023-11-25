
-- VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------
local clone1, prop, peepee, randomItem, sack
local name = "Clone"
local sprite = 1321928545
local tempsbar = 0
local pedHealth = 100
local cloneControl = false
local cloneDying = false
local double = false
local transferring = false
local doubled = false
local showCloneRadius = false

local dupe = false

local cloneMultiplier = 0

local castingSpell, breakingSpell, droningPrompt = false
local existed = false
local shareItem = false
local cloneIsSharing = false
local offered = false
local spawning = false
local ninja = true
local superjump = false
local restorestamina = false
local delivering = false
local dying = false
local saving = false
local cloneDrinking = false
local cloneIdling = false

local powerAcquired = false

local ragdoll = false
local status = false
local cloneReacting = false
local cloneLaughing = false

local offering = false
local timerStarted = false
local offeredItem = ""
local randomItemPrompt = false
local requested = false
local requestCooldown = false
local itemCooldown = 0
local timer = 0

local weapon
local carriedWeapon = false

local cooldown = false

local cloned = false
local playingAnim = false

local particle_effect_target = false
local smoke_particle_target_id = false

local is_particle_effect_active = false
local current_ptfx_handle_id = false

local is_blood_effect_active = false
local current_blood_handle_id = false

local is_explode_effect_active = false
local current_explode_handle_id = false

local particle_effect = false
local getDirty = false

local nametag = ""

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

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(10)
      local interval = math.random(1000, 8000)
      
      Wait(interval)
      exports['nic_speech']:talkExternal()
    end
end)

function talkClone(dict, message)
    if cloned then
        play_ambient_speech_from_entity(clone1, dict, message,"speech_params_add_blip_shouted_force",0)
    end
end


-- STARTS THE SCRIPT
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_clone:getDirty')
AddEventHandler('nic_clone:getDirty', function(source)
    getDirty = true
	if not particle_effect then
		playEffectAudio()
		playSmokeEffect() 
		playSmoke2Effect()
		playSmoke3Effect()
		playParticleEffect()
        cloneSack()
	else
		stopEffect()
	end
    
end)


RegisterNetEvent('nic_clone:removeDirty')
AddEventHandler('nic_clone:removeDirty', function(source)
    if DoesEntityExist(sack) then
        DeleteEntity(sack)
    end
    stopEffect()
end)

function cloneSack()
    if DoesEntityExist(clone1) then
        local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_Spine2")
        local sack_name = 'p_cs_vegsack_up'
        local x,y,z = table.unpack(GetEntityCoords(clone1))
    
        if DoesEntityExist(sack) then
            DeleteEntity(sack)
        else    
            sack = CreateObject(GetHashKey(sack_name), x, y, z+0.2,  true,  true, true)
            AttachEntityToEntity(sack, clone1, boneIndex, -0.27, -0.41, -0.01, 335.0, 91.0, 0.0, true, true, false, true, 1, true)
        end
    end
end

function stopEffect()
	if flies_particle_id or smoke_particle_id or smoke_particle2_id or smoke_particle3_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, flies_particle_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, smoke_particle_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, smoke_particle2_id) or Citizen.InvokeNative(0x9DD5AFF561E88F2A, smoke_particle3_id) then   -- DoesParticleFxLoopedExist
			Citizen.InvokeNative(0x459598F579C98929, flies_particle_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle2_id, false)   -- RemoveParticleFx
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle3_id, false)   -- RemoveParticleFx
		end
	end
	flies_particle_id = false
	smoke_particle_id = false
	smoke_particle2_id = false
	smoke_particle3_id = false
    getDirty = false    

	particle_effect = false
	Citizen.InvokeNative(0x523C79AEEFCC4A2A, clone1, 10, "ALL")
    Citizen.Wait(200)
	ClearPedTasks(clone1)
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
			Citizen.Wait(5)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_L_Clavicle")

		smoke_particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, clone1, 0, 0, 0, -90.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

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
			Citizen.Wait(5)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_Pelvis")

		smoke_particle2_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, clone1, 0, 0, 0, -90.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

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
			Citizen.Wait(5)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_R_Thigh")
		
		smoke_particle3_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, clone1, 0, 0, 0, -90.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
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
			Citizen.Wait(5)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_Spine0")
		flies_particle_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, clone1, 0, 0, 0, -90.0, 0, 0, boneIndex, 1.0, 0, 0, 0)

		Citizen.InvokeNative(0x46DF918788CB093F, clone1,"PD_Outhouse_Muck_Body_Face", 0.0, 0.0);  -- APPLY_PED_DAMAGE_PACK PD_Vomit for ped with damage 0.0 and mult 0.0

		particle_effect = true
	else
		print("cant load ptfx dictionary!")
	end
end

RegisterNetEvent('nic_clone:usePower')
AddEventHandler('nic_clone:usePower', function(source)
    if ninja and not IsPedOnMount(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedOnVehicle(PlayerPedId(), true) and not IsPedHangingOnToVehicle(PlayerPedId()) and not IsPedInFlyingVehicle(PlayerPedId()) and not IsPedSittingInAnyVehicle(PlayerPedId()) and not cloneControl  then
                
        spawning = true
        castSpell()
    else
        notAllowedPrompt()
    end
end)

RegisterNetEvent('nic_clone:Initialize')
AddEventHandler('nic_clone:Initialize', function(source)
    ninja = true
    powerAcquired = true
    for key, value in pairs(Config.settings) do
        superjump = value.superjump
        restorestamina = value.inifiniteStamina
    end

    TriggerEvent('nic_clone:usePower')
end)



Citizen.CreateThread(function()
    while true do
        Wait(5)

        local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
        
        if IsCloneNearCarryEntity(x, y, z) then
            TaskPickupCarriableEntity(clone1, holding)
        end
    end
end)

function IsCloneNearCarryEntity(x, y, z)
    local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 4 then
        return true
    end
end

-- SPECIAL ABITLITY FUNCTION
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(5)
		if superjump then
			SetSuperJumpThisFrame(PlayerId())
			SetSuperJumpThisFrame(clone1)
		end
		if restorestamina then
			RestorePlayerStamina(PlayerId(),1.0)
		end
	end
end)

-- -- NINJA RUN FUNCTION
-- ----------------------------------------------------------------------------------------------------

-- CreateThread(function()
-- 	while true do
-- 		Wait(5)
--         local animation = "mech_carry_ped@dead"
--         RequestAnimDict(animation)
--         while ( not HasAnimDictLoaded(animation)) do 
--             Citizen.Wait( 100 )
--         end
--         for key, value in pairs(Config.settings) do
--             if ninja and value.ninjaRun then
--                 if IsControlJustReleased(0x8FFC75D6) or IsPedJumping(PlayerPedId()) or IsPedWalking(PlayerPedId()) or IsPedStopped(PlayerPedId()) or IsEntityInAir(PlayerPedId()) or IsPedFalling(PlayerPedId()) or IsPedOnMount(PlayerPedId()) or IsPedClimbing(PlayerPedId()) then
--                     StopAnimTask(PlayerPedId(), animation, "hog_ped_dead_vtm_pre_idl", 1)
--                 end
--                 if IsPedRunning(PlayerPedId()) and not IsPedOnMount(PlayerPedId()) then
--                     TaskPlayAnim(PlayerPedId(), animation, "hog_ped_dead_vtm_pre_idl", 1.0, 8.0, -1, 31, 0, true, 0, false, 0, false)
--                     TaskPlayAnim(clone1, animation, "hog_ped_dead_vtm_pre_idl", 1.0, 8.0, -1, 31, 0, true, 0, false, 0, false)
--                 end
    
--                 if IsPedJumping(clone1) or IsPedWalking(clone1) or IsPedStopped(clone1) or IsEntityInAir(clone1) or IsPedFalling(clone1) or IsPedOnMount(clone1) or IsPedClimbing(clone1) or cloneIsSharing and delivering then
--                     StopAnimTask(clone1, animation, "hog_ped_dead_vtm_pre_idl", 1)
--                 end
--                 if IsPedRunning(clone1) and not IsPedOnMount(clone1) and not cloneIsSharing and not delivering then
--                     TaskPlayAnim(clone1, animation, "hog_ped_dead_vtm_pre_idl", 1.0, 8.0, -1, 31, 0, true, 0, false, 0, false)
--                     TaskPlayAnim(clone1, animation, "hog_ped_dead_vtm_pre_idl", 1.0, 8.0, -1, 31, 0, true, 0, false, 0, false)
--                 end
--                 if Citizen.InvokeNative(0x84D0BF2B21862059, PlayerPedId()) then
--                     Citizen.InvokeNative(0x7DE9692C6F64CFE8, clone1, false, 2, false)
--                     TaskSetCrouchMovement(clone1, true, 1, true)
--                 end
--             end
--         end
-- 	end
-- end)

-- CLONE OFFER FIRSTAID
---------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_L_Hand")
        local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
        local animation2 = "mech_inspection@generic@lh@base"
        local playerHealth = GetEntityHealth(PlayerPedId())
        local cloneHealth = GetEntityHealth(clone1)
        local propModel = "s_firstaidkit_sml01x"
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))
        local crouching = Citizen.InvokeNative(0xD5FE956C70FF370B, PlayerPedId())
        local cHolding = Citizen.InvokeNative(0xD806CD2A4F2C2996, clone1)
        RequestAnimDict(animation)
        while ( not HasAnimDictLoaded(animation)) do 
            Citizen.Wait( 100 )
        end
        RequestAnimDict(animation2)
        while ( not HasAnimDictLoaded(animation2)) do 
            Citizen.Wait( 100 )
        end
        if cloneHealth >= 100 then
            cloneHealth = 100
        end
        cloneHealth = cloneHealth
        if cloneDrinking then            
            DisablePlayerFiring(clone1, true)
        end
        if not IsPedInWrithe(clone1) and IsPedHuman(clone1) and DoesEntityExist(clone1) and cloneHealth <= 40 and not IsPedRagdoll(clone1) and not saving and not IsEntityDead(clone1) then
            Citizen.Wait(3000)
            Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 2, true)
            cloneDrinkFirstaid()
        end
        if DoesEntityExist(clone1) and playerHealth <= 40 and not shareItem and not IsPedRagdoll(clone1) and not cloneDrinking then
            DetachEntity(cHolding, 1, 1)
            delivering = true
            TaskGoToEntity(clone1, PlayerPedId(), 1.0, 1, 12.0, 1, 1)
            saving = true
            shareItem = true
            cloneIsSharing = true
        end
        if saving and not IsEntityDead(clone1) and not cloneControl then
            for key, value in pairs(Config.settings) do
                if IsPedSprinting(clone1) then
                    DrawText3D(cx, cy, cz+0.8, true, "~COLOR_YELLOW~"..value.cloneSprintingSuicideMessage)
                else
                    DrawText3D(cx, cy, cz+0.8, true, "~COLOR_YELLOW~"..value.cloneStandingSuicideMessage)
                end
            end
        end
        if cloneIsSharing then
            
        end
        if IsPlayerNearCloneWithFirstAid(cx, cy, cz) and saving and not IsPedRagdoll(clone1) and playerHealth <= 40 then
            
            local cloneHealth = GetEntityHealth(clone1)
            TaskPlayAnim(clone1, animation2, "hold", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
            offered = true
            delivering = false
            cloneIsSharing = false
            SetEntityHealth(PlayerPedId(), playerHealth+cloneHealth, 0)
            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
            Citizen.InvokeNative(0xAE99FB955581844A, PlayerPedId(), 1000, 0, 0, 0, 0, 0)
            SetEntityHealth(clone1, 0, 0)
            Citizen.Wait(100)
            local qx, qy, qz = table.unpack(GetEntityCoords(clone1, 0))
            AddExplosion(qx, qy, qz, 12, 0.0, true, false, true)
            SetEntityVelocity(PlayerPedId(), 3.5, 3.5, 3.0)
            bloodExplode(clone1)
            bloodExplode(PlayerPedId())
            Citizen.Wait(200)
            DeleteEntity(clone1)
            DeleteObject(prop)
            saving = false
            Citizen.Wait(1000)
        end
    end
end)

-- CALL CLONE

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if DoesEntityExist(clone1) then
            if IsControlJustPressed(0, 0x4BC9DABB) then
                ClearPedTasks(clone1)
                Citizen.InvokeNative(0x5AD23D40115353AC, PlayerPedId(), clone1, 1000, 1, 0, 0)
                Wait(1000)
                Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0,901097731, 1, 1, 0, 0)
                TaskGoToEntity(clone1, PlayerPedId(), 1.0, 1, 12.0, 1, 1)
                SetPedAsGroupMember(clone1, GetPedGroupIndex(PlayerPedId()))
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if DoesEntityExist(clone1) and not IsEntityDead(clone1) and not IsPedHuman(clone1) then
            SetPlayerHealthRechargeMultiplier(clone1, 2.0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))
        
        if cloneDrinking and DoesEntityExist(clone1) then
            DrawMedicine3D(cx, cy, cz+1.1)
        end
        if IsPlayerNearCloneHealthRadius(cx, cy, cz) then
            if not IsEntityDead(clone1) and not saving and not cloneControl then
                SetPlayerHealthRechargeMultiplier(clone1, 0.0)
                for key, value in pairs(Config.settings) do
                    if IsPedOnMount(clone1) and DoesEntityExist(clone1) and IsPedHuman(clone1) and not IsEntityDead(clone1) then
                        if value.displayNametag then
                            if cloned then
                                DrawHeart3D(cx, cy, cz+1.9, "")
                            else
                                DrawHeart3D(cx, cy, cz+1.9, value.nametag)
                            end
                        end
                    elseif DoesEntityExist(clone1) and not IsEntityDead(clone1) then
                        if IsPedHuman(clone1) then
                            if IsPedOnMount(clone1) then
                                cz = cz+0.8
                            end
                            if value.displayNametag then
                                if cloned then
                                    DrawHeart3D(cx, cy, cz+1.1, "")
                                else
                                    DrawHeart3D(cx, cy, cz+1.1, value.nametag)
                                end
                            else
                                DrawHeart3D(cx, cy, cz+1.1, "")
                            end
                        else
                            if value.displayNametag then
                                if cloned then
                                    DrawHeart3D(cx, cy, cz+1.9, "")
                                else
                                    DrawHeart3D(cx, cy, cz+1.9, value.nametag)
                                end
                            else
                                DrawHeart3D(cx, cy, cz+1.9, "")
                            end
                        end
                    end
                end
            elseif cloneControl then
                -- DrawText3D(cx, cy, cz+1.0, true, "~COLOR_YELLOW~Droning...")
            end
            
            if IsEntityDead(clone1) and not IsEntityDead(PlayerPedId()) and DoesEntityExist(clone1) then
                DrawCloneDead3D(cx, cy, cz+1.1)
            end          

        else
            if IsEntityDead(clone1) and not IsEntityDead(PlayerPedId()) and DoesEntityExist(clone1) and not cloneControl then
                DrawCloneDead3D(cx, cy, cz+1.1)
            else
                if not saving then
                    DrawLogo3D(cx, cy, cz+1.1, " " , true)
                end
            end            
        end
    end
end)

-- IF PLAYER IS INVISIBLE
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(200)
        SetEntityAlpha(clone1, GetEntityAlpha(PlayerPedId()), false)
    end
end)

-- IF PLAYER IS DEAD
----------------------------------------------------------------------------------------------------

CreateThread(function()
	while true do
		Wait(5)
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))
        if IsEntityDead(PlayerPedId()) then
            tempsbar = 0
            cameraBars()
            AnimpostfxStop("PlayerDrugsPoisonWell")
            for key, value in pairs(Config.settings) do
                if value.associateType == "custom" and DoesEntityExist(clone1) then
                    spawning = true
                    castSpell()
                    AddExplosion(cx, cy, cz-1.0, 12, 1.0, true, false, true)
                    AddExplosion(cx, cy, cz, 33, 8, false, false, true)
                    Wait(200)
                    DeleteEntity(clone1)
                    spawning = false
                elseif value.associateType == "clone" and DoesEntityExist(clone1) then
                    SetEntityHealth(clone1, 0, 0)
                    breakingSpell = true
                    castSpell()
                end
            end
            castingSpell = false
            cloneControl = false
        end
        if IsPedJumping(PlayerPedId()) then
            Citizen.Wait(500)
            TaskJump(clone1, true)
        end
    end
end)

CreateThread(function()
	while true do
		Wait(5)
        if not IsEntityDead(clone1) or DoesEntityExist(clone1) then
            SetPlayerHealthRechargeMultiplier(clone1, 0.0)
        end
    end
end)

-- CLONE PLAYER FUNCTION
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_clone:offerTimer')
AddEventHandler('nic_clone:offerTimer', function()
    timerStarted = true

    timer = 12
    
	Citizen.CreateThread(function()
		while timer > 0 and DoesEntityExist(clone1) do
			Citizen.Wait(1000)
			timer = timer - 1
		end
        if timer == 0 then
            if DoesEntityExist(offeredProp) or IsEntityAttachedToEntity(offeredProp, clone1) then
                playKeepkAnimation()
                requested = false
                timerStarted = false
            else
                requested = false
                timerStarted = false
            end
        end
	end)
end)


RegisterNetEvent('nic_clone:offerCooldown')
AddEventHandler('nic_clone:offerCooldown', function()
    requestCooldown = true

    itemCooldown = 30
    
	Citizen.CreateThread(function()
		while itemCooldown > 0 and DoesEntityExist(clone1) do
			Citizen.Wait(1000)
			itemCooldown = itemCooldown - 1
		end
        if itemCooldown == 0 then
            timer = 0
            timerStarted = false
            requestCooldown = false
        end
	end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if IsPedRagdoll(clone1) then
            DetachEntity(prop, 1, 1)
            DetachEntity(peepee, 1, 1)
            Citizen.Wait(3000)
            DeleteObject(prop)
            DeleteObject(peepee)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1))
        -- local dic = "mech_loco_m@generic@combat@zero_intensity@pistol@aiming_idle"
        -- local anim = "idle"
        local dic = "mech_loco_m@generic@combat@zero_intensity@pistol@aiming_walk"
        local anim = "move"
        local cloneHealth = GetEntityHealth(clone1)
        local cHolding = Citizen.InvokeNative(0xD806CD2A4F2C2996, clone1)

        RequestAnimDict(dic)
        while not HasAnimDictLoaded(dic) do
            Wait(100)
        end

        if not playingAnim and not IsPedSwimming(clone1) and not Citizen.InvokeNative(0x3AA24CCC0D451379, clone1) and not Citizen.InvokeNative(0xD453BB601D4A606E, clone1) and not IsPedOnMount(PlayerPedId()) and not IsPedOnMount(clone1) and IsPedHuman(clone1) and not IsPedInAnyVehicle(clone1, false) and not IsPedOnVehicle(clone1, true) and not IsPedHangingOnToVehicle(clone1) and not IsPedInFlyingVehicle(clone1) and not IsPedSittingInAnyVehicle(clone1) and not Citizen.InvokeNative(0xA911EE21EDF69DAF, clone1) and not cHolding and not IsPedInMeleeCombat(PlayerPedId()) and not IsPedInMeleeCombat(clone1) and not timerStarted and IsPlayerRequestItem(cx, cy, cz) and not requested and not requestCooldown and not cloneReacting and not cloneLaughing and not cloneDrinking and not IsEntityDead(clone1) and DoesEntityExist(clone1) and not IsPedRagdoll(clone1) and cloneHealth >= 46 then
            DrawRequestItem3D(cx, cy, cz+1.3, "E", "Request Item")
            if IsControlJustPressed(0, 0xCEFD9220) and DoesEntityExist(clone1) and not IsPedRagdoll(clone1) then
                Citizen.InvokeNative(0x5AD23D40115353AC, PlayerPedId(), clone1, 1000, 1, 0, 0)
                Citizen.InvokeNative(0x5AD23D40115353AC, clone1, PlayerPedId(), 1000, 1, 0, 0)
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 2, true)
                Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, 164860528, 1, 1, 0, 0)
                timer = 0
                timerStarted = false
                requested = true
                TriggerEvent('nic_clone:offerTimer')
                DetachEntity(prop, 1, 1)
                ClearPedTasks(clone1)
                getItemAnimation()
                Citizen.Wait(400)
                DeleteObject(prop)
                TaskPlayAnim(clone1, dic, anim, 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                
                offerRandomItem()
            end
        elseif not playingAnim and not Citizen.InvokeNative(0x3AA24CCC0D451379, clone1) and not Citizen.InvokeNative(0xD453BB601D4A606E, clone1) and IsPedHuman(clone1) and Citizen.InvokeNative(0xA911EE21EDF69DAF, clone1) and cHolding and not IsPedInMeleeCombat(PlayerPedId()) and not IsPedInMeleeCombat(clone1) and not timerStarted and IsPlayerRequestItem(cx, cy, cz) and not requested and not requestCooldown and not cloneReacting and not cloneLaughing and not cloneDrinking and not IsEntityDead(clone1) and DoesEntityExist(clone1) and not IsPedRagdoll(clone1) and cloneHealth >= 46 and IsPedFacingPed(PlayerPedId(), clone1, 90.0) then
            DrawCarryItem3D(cx, cy, cz+1.3, "R", "Drop Carrying")
            if IsControlJustPressed(0, 0xE30CD707) and DoesEntityExist(clone1) and not IsPedRagdoll(clone1) then
                DetachEntity(cHolding, 1, 1)
                ClearPedTasks(clone1)
            end
        end
        
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local dic = "mech_loco_m@generic@combat@zero_intensity@pistol@aiming_walk"
        local anim = "move"

        if IsPedRagdoll(clone1) then
            DetachEntity(offeredProp, 1, 1)
            DetachEntity(prop, 1, 1)
            Citizen.Wait(3000)
            DeleteObject(offeredProp)
            DeleteObject(prop)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1))
        local dic = "mech_loco_m@generic@combat@zero_intensity@pistol@aiming_walk"
        local anim = "move"

        RequestAnimDict(dic)
        while not HasAnimDictLoaded(dic) do
            Wait(100)
        end

        if timerStarted and IsPlayerNearRandomItem(cx, cy, cz) and not IsEntityDead(clone1) and DoesEntityExist(clone1) and IsEntityPlayingAnim(clone1, dic, anim, 31) then
            DrawRandomItem3D(cx, cy, cz+1.3, "E", "Get Item", offeredItem)

            if timerStarted and IsPlayerNearGetItem(cx, cy, cz) and IsControlJustPressed(0, 0xCEFD9220) and IsPedFacingPed(PlayerPedId(), clone1, 45.0) and IsPedFacingPed(clone1, PlayerPedId(), 45.0) then
                Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 2, true)
                TriggerEvent("nic_clone:offerCooldown")
                requested = false
                DetachEntity(prop, 1, 1)
                timerStarted = false
                timer = 0
                ClearPedTasks(clone1)
                PlaySoundFrontend("TITLE_SCREEN_EXIT", "DEATH_FAIL_RESPAWN_SOUNDS", true, 0)
                TriggerServerEvent('nic_clone:addRandomItem', offeredItem)
                randomItemPrompt = true
                ClearPedTasks(clone1)
                playPlayerPickupkAnimation()
                Citizen.Wait(600)
                playPlayerKeepkAnimation()
                Citizen.InvokeNative(0x5AD23D40115353AC, PlayerPedId(), clone1, 1000, 1, 0, 0)
                Citizen.Wait(1000)
                Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0, -1801715172, 1, 1, 0, 0)
                randomItemPrompt = false
                Citizen.InvokeNative(0x5AD23D40115353AC, clone1, PlayerPedId(), 1000, 1, 0, 0)
                Citizen.Wait(1000)
                exports['nic_speech']:thankExternal()
                Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, -2121881035, 1, 1, 0, 0)
            end

        end
    end
end)

function thankClone(dict, message)
    if cloned then
        play_ambient_speech_from_entity(PlayerPedId(), dict, message,"speech_params_add_blip_shouted_force",0)
    end
end

CreateThread(function()
	while true do
		Wait(5)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        if randomItemPrompt then
			DrawText3D(x, y, z+1.0, true, "~COLOR_HUD_TEXT~+1 ~COLOR_PLATFORM_GREEN~"..offeredItem)
        end
    end
end)

function DrawRandomItem3D(x, y, z, text, text2, text3)    
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
    DisplayText(str2,_x+0.044,_y-0.038)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(213, 235, 91, 215)
    local str3 = CreateVarString(10, "LITERAL_STRING", text3, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str3,_x+0.044,_y-0.023)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("menu_textures", "menu_icon_alert", _x, _y, 0.018, 0.03, 0.1, 255, 255, 255, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.017, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end


function DrawCarryItem3D(x, y, z, text, text2)    
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
    DisplayText(str2,_x+0.06,_y-0.038)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("overhead", "overhead_generic_arrow", _x, _y, 0.018, 0.03, 0.1, 255, 255, 255, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.017, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function DrawRequestItem3D(x, y, z, text, text2)    
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
    DisplayText(str2,_x+0.054,_y-0.038)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("multiwheel_emotes") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("multiwheel_emotes", false)
    else
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.036, 0.1, 255, 255, 255, 155, 0)
        DrawSprite("multiwheel_emotes", "emote_action_prayer_1", _x, _y, 0.018, 0.03, 0.1, 255, 255, 255, 215, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        DrawSprite("menu_textures", "menu_icon_rank", _x+0.016, _y-0.025, 0.017, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end

function IsPlayerRequestItem(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)
    
    if distance < 2.5 then
        return true
    end
end

function IsPlayerNearGetItem(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)
    
    if distance < 1.5 then
        return true
    end
end

function IsPlayerNearRandomItem(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)
    
    if distance < 8.0 then
        return true
    end
end

-- function randomItem()
--     local max = 0
--     for i, row in pairs(Config.items) do
--         max = i
--     end

--     local random = math.random(max)
    
--     for i, row in pairs(Config.items) do
--         print(Config.items[random]["item"])
--         print(Config.items[random]["model"])
--     end
--     Wait(1000)
-- end

function offerRandomItem()
    local cx, cy, cz = table.unpack(GetEntityCoords(clone1))
    local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_R_Hand")
    local max = 0

    for i, row in pairs(Config.items) do
        max = i
    end
    local random = math.random(max)
    
    for i, row in pairs(Config.items) do
        offeredItem = Config.items[random]["item"]
        randomItem = Config.items[random]["model"]
    end

    RequestModel(GetHashKey(randomItem))
    while not HasModelLoaded(GetHashKey(randomItem)) do
        Wait(100)
    end
    
    offeredProp = CreateObject(GetHashKey(randomItem), x, y, z,  true,  true, true)

    if offeredItem == "banana" then
        AttachEntityToEntity(offeredProp, clone1, boneIndex, 0.1, -0.11, -0.12, 259.0, 160.0, 6.0, true, true, false, true, 1, true)
    elseif offeredItem == "firstaid" then
        AttachEntityToEntity(offeredProp, clone1, boneIndex, 0.09, -0.07, -0.08, 275.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif offeredItem == "firstaid-s" then
        AttachEntityToEntity(offeredProp, clone1, boneIndex, 0.09, -0.07, -0.08, 275.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif offeredItem == "apple" then
        AttachEntityToEntity(offeredProp, clone1, boneIndex, 0.08, 0.05, -0.08, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif offeredItem == "pandesal" then
        AttachEntityToEntity(offeredProp, clone1, boneIndex, 0.08, 0.05, -0.08, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif offeredItem == "canteen" then
        AttachEntityToEntity(offeredProp, clone1, boneIndex, 0.08, 0.08, -0.08, 296.0, 13.0, 4.0, true, true, false, true, 1, true)
    else
        AttachEntityToEntity(offeredProp, clone1, boneIndex, 0.08, 0.05, -0.08, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    end
end

function playKeepkAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(clone1, animation, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Wait(1200)
    DeleteObject(offeredProp)
    ClearPedTasks(clone1)
end

function playPlayerPickupkAnimation()
    local animation = "mech_ransack@shelf@h105cm@d70cm@reach_over@putdown@vertical@middle@a"
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_R_Hand")
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "base", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    
    if offeredItem == "banana" then
        AttachEntityToEntity(offeredProp, PlayerPedId(), boneIndex, 0.1, -0.11, -0.12, 259.0, 160.0, 6.0, true, true, false, true, 1, true)
    elseif offeredItem == "firstaid-s" then
        AttachEntityToEntity(offeredProp, PlayerPedId(), boneIndex, 0.09, -0.07, -0.08, 275.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif offeredItem == "pandesal" then
        AttachEntityToEntity(offeredProp, PlayerPedId(), boneIndex, 0.08, 0.05, -0.08, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif offeredItem == "canteen" then
        AttachEntityToEntity(offeredProp, PlayerPedId(), boneIndex, 0.08, 0.08, -0.08, 296.0, 13.0, 4.0, true, true, false, true, 1, true)
    end
end

function playPlayerKeepkAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Wait(950)
    DeleteObject(offeredProp)
    ClearPedTasks(PlayerPedId())
end

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local cloneHealth = GetEntityHealth(clone1)
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))
        local carrying = Citizen.InvokeNative(0xA911EE21EDF69DAF, PlayerPedId())
            
        if IsControlJustPressed(0, 0xCEE12B50) then

            if not carrying then

                TriggerServerEvent("nic_clone:checkJob")
    
                if powerAcquired and not DoesEntityExist(clone1) and not IsPedRagdoll(PlayerPedId()) then
                    TriggerServerEvent("nic_clone:usePower")
                elseif powerAcquired and DoesEntityExist(clone1) and not IsPedRagdoll(PlayerPedId()) then
                    for key, value in pairs(Config.settings) do
                        if value.associateType == "custom" and DoesEntityExist(clone1) then
                            spawning = true
                            Citizen.InvokeNative(0x5AD23D40115353AC, PlayerPedId(), clone1, -1, 1, 1, 1)
                            castSpell()
                            kagebunshin(0.8)
                            playSmokeAudio()
                            Wait(200)
                            DeleteEntity(clone1)
                            spawning = false
                        elseif value.associateType == "clone" and DoesEntityExist(clone1) and not IsPedOnMount(clone1) then
    
    
                        end
                    end
                end
            end
        end

        if not IsPlayerNearClone(cx, cy, cz) then
            SetEntityHealth(clone1, 0, 0)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(5)
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
        local playerMount = GetMount(PlayerPedId())
        if IsPedHuman(clone1) and IsPedOnMount(PlayerPedId()) and not Citizen.InvokeNative(0x95CBC65780DE7EB1, clone1, true) and DoesEntityExist(clone1) and not IsPedRagdoll(clone1) then
            cloneMount(playerMount)
        end
        
        if IsPedHuman(clone1) and IsPedOnMount(PlayerPedId()) and DoesEntityExist(clone1) then
            ClearPedTasks(clone1)
        end
    end
end)

function cloneMount(playerMount)
    ClearPedTasks(clone1)
    kagebunshin(1.0)
    Citizen.InvokeNative(0x028F76B6E78246EB, clone1, playerMount, 0, true)
    playEffectAudio()
end

function playSmokeTargetEffect(target)  
	local particle_dict = "cut_rrtl"
	local particle_name = "cs_rrtl_electric_arcs"
	local current_particle_dict = particle_dict
	local current_particle_name = particle_name

	current_particle_dict = particle_dict
	current_particle_name = particle_name
	if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_particle_dict))  -- RequestNamedPtfxAsset
		local counter = 0
		while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) and counter <= 300 do  -- while not HasNamedPtfxAssetLoaded
			Citizen.Wait(5)
		end
		end
		if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_particle_dict)) then  -- HasNamedPtfxAssetLoaded
		Citizen.InvokeNative(0xA10DB07FC234DD12, current_particle_dict)

		local boneIndex = GetEntityBoneIndexByName(target, "SKEL_ROOT")
		smoke_particle_target_id = Citizen.InvokeNative(0x9C56621462FFE7A6, current_particle_name, target, 0, 0, 0, 0.0, 0, 0, boneIndex, 0.4, 0, 0, 0)

		particle_effect_target = true
	else
		print("cant load ptfx dictionary!")
	end
end

function stopTargetEffect()
	if smoke_particle_target_id then
		if Citizen.InvokeNative(0x9DD5AFF561E88F2A, smoke_particle_target_id) then   -- DoesParticleFxLoopedExist
			Citizen.InvokeNative(0x459598F579C98929, smoke_particle_target_id, false)   -- RemoveParticleFx
		end
	end
	smoke_particle_target_id = false
	particle_effect_target = false
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

ragdoll = true

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local animation = "mech_inventory@binoculars"
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1))
        local playerCoords = vector3(px, py, pz-1.0)
        local cloneCoords = vector3(cx, cy, cz-1.0)
        local playerHeading = GetEntityHeading(PlayerPedId())
        local cloneHeading = GetEntityHeading(clone1)
        local pHealth = GetEntityHealth(PlayerPedId())
        local cHealth = GetEntityHealth(clone1)
        local droneDistance = GetDistanceBetweenCoords(px, py, pz, cx, cy, cz, true) + 0.5
        local carried = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
        local type = false
        
        local cSprite = -758439257

        RequestAnimDict(animation)
        while not HasAnimDictLoaded(animation) do
            Wait(100)
        end
        
        for key, value in pairs(Config.settings) do
            if value.associateType == "clone" then
                type = true
            elseif value.associateType == "custom" then
                type = false
            end
        end
        
        if type and not cloneControl and not IsEntityPlayingAnim(PlayerPedId(), "mech_loco_m@generic@carry@ped@idle", "idle", 31) and DoesEntityExist(clone1) and not IsPedInjured(clone1) and not IsEntityDead(clone1) and IsControlJustPressed(0, 0x26E9DC00) and not IsPedRagdoll(PlayerPedId()) and not IsPedRagdoll(clone1) and not IsPedRagdoll(PlayerPedId()) and not IsPedOnMount(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsEntityInWater(PlayerPedId()) then
            transferring = true
            DetachEntity(carried, true, true)
            exports['progressbar']:startUI(1000, "Transferring Consciousness..")
            makeEntityFaceEntity(PlayerPedId(), clone1)
            TaskPlayAnim(PlayerPedId(), animation, "look", 8.0, -8.0, -1, 1, 0, true, 0, false, 0, false)
            Citizen.Wait(1000)
            transferring = false
            cloneControl = true
            tempsbar = 1
            cameraBars()
            AnimpostfxPlay("PlayerDrugsPoisonWell")
            DisplayRadar(false)
            TriggerEvent("vorp:showUi", false)
            TriggerEvent("alpohud:toggleHud", false)
            TriggerEvent("vorp_hud:toggleHud", false)
            RemoveBlip(blip)
            cBlip = SET_BLIP_TYPE(clone1)
            SetBlipSprite(cBlip, cSprite, 1)
            Citizen.InvokeNative(0x9CB1A1623062F402, cBlip, 'Player')
            ClearPedTasksImmediately(PlayerPedId())
            SetEntityHeading(PlayerPedId(), cloneHeading)
            SetEntityHeading(clone1, playerHeading)
            SetEntityCoords(PlayerPedId(), cloneCoords)
            SetEntityCoords(clone1, playerCoords)
            SetEntityHealth(PlayerPedId(), cHealth, 0)
            SetEntityHealth(clone1, pHealth, 0)
            TaskPlayAnim(clone1, animation, "base", 8.0, -8.0, -1, 1, 0, true, 0, false, 0, false)
            TaskStartScenarioInPlace(clone1, GetHashKey(animation2), -1, true, false, false, false)
            TriggerEvent("vorp:showUi", false)
            TriggerEvent("alpohud:toggleHud", false)
            TriggerEvent("vorp_hud:toggleHud", false)
        else
            type = false   
        end

        if cloneControl then
            Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone, 2, true)
            Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)
            DisableControlAction(0, 0x7F8D09B8, true) 
            DisableControlAction(0, 0xE30CD707, true) 
            DisableControlAction(0, 0xE6F612E4, true) 
            DisableControlAction(0, 0x1CE6D9EB, true) 
            DisableControlAction(0, 0x4F49CC4C, true) 
            DisableControlAction(0, 0x8F9F9E58, true) 
            DisableControlAction(0, 0xAB62E997, true) 
            DisableControlAction(0, 0xA1FDE2A6, true) 
            DisableControlAction(0, 0xB03A913B, true) 
            DisableControlAction(0, 0x42385422, true) 

            DisableControlAction(0, 0xB238FE0B, true) 
            DisableControlAction(0, 0xC1989F95, true)
            TaskSetCrouchMovement(clone1, true, 1, true)
            FreezeEntityPosition(clone1, true)
            for key, value in pairs(Config.settings) do
                if droneDistance > value.cloneRangeDistance-5 then
                    DrawTxt("Spell Range Warning:", 0.5, 0.145, 0.3, 0.3, true, 255, 255, 255, 200, true)
                    DrawTxt("Losing Signal", 0.5, 0.155, 1.0, 1.0, true, 255, 10, 0, 200, true)
                else
                    DrawDroning3D(px, py, pz+1.0)
                    DrawDroningClone3D(cx, cy, cz+1.0)
                    DrawTxt("Drone Mode", 0.5, 0.155, 1.0, 1.0, true, 252, 186, 3, 200, true)
                end
            end
            if not IsPlayerNearClone(cx, cy, cz) or IsEntityDead(clone1) then
                dying = true
                tempsbar = 0
                cameraBars()
                AnimpostfxStop("PlayerDrugsPoisonWell")
                blip = SET_BLIP_TYPE(clone1)
                SetBlipSprite(blip, sprite, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Clone')
                RemoveBlip(blip)
                RemoveBlip(cBlip)
                cloneControl = false
                FreezeEntityPosition(clone1, false)
                if IsPedHuman(clone1) then
                    SetEntityHealth(clone1, 0, 0)
                    SetEntityCoords(PlayerPedId(), cloneCoords)
                    SetEntityCoords(clone1, playerCoords)
                    SetEntityHeading(clone1, playerHeading)
                    TaskPlayAnim(PlayerPedId(), animation, "base", 8.0, -8.0, -1, 1, 0, true, 0, false, 0, false)
                    Citizen.Wait(1000)
                    ClearPedTasks(PlayerPedId())
                else
                    kagebunshin(0.5)
                    playSmokeAudio()
                    Wait(200)
                    DeleteEntity(clone1)
                end
            end
            if IsControlJustPressed(0, 0x26E9DC00) or pHealth <= 35 and not IsPedRagdoll(clone1) and not IsPedRagdoll(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then

                if status == false then
                    Citizen.Wait(10)
                    if (ragdoll) then
                        setRagdoll(true)
                        ragdoll = false
                        status = true
                    end
                end
                
                DetachEntity(carried, true, true)
                tempsbar = 0
                cameraBars()
                AnimpostfxStop("PlayerDrugsPoisonWell")
                saving = false
                RemoveBlip(blip)
                RemoveBlip(cBlip)
                blip = SET_BLIP_TYPE(clone1)
                SetBlipSprite(blip, sprite, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Clone')
                cloneControl = false
                ClearPedTasksImmediately(clone1)
                FreezeEntityPosition(clone1, false)
                TaskSetCrouchMovement(clone1, false, 1, false)
                SetEntityHeading(PlayerPedId(), cloneHeading)
                SetEntityHeading(clone1, playerHeading)
                SetEntityCoords(PlayerPedId(), cloneCoords)
                SetEntityCoords(clone1, playerCoords)
                SetEntityHealth(PlayerPedId(), cHealth, 0)
                SetEntityHealth(clone1, pHealth, 0)
                TaskSetCrouchMovement(PlayerPedId(), true, 1, true)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
                TaskSetCrouchMovement(PlayerPedId(), false, 1, false)
            elseif IsControlJustReleased(0, 0x26E9DC00) then
                setRagdoll(false)
                ragdoll = true
                status = false
            end
        end
    end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)		
            if ragdoll then
            Citizen.InvokeNative(0xAE99FB955581844A, PlayerPedId(), 1000, 0, 0, 0, 0, 0)
            DisableControlAction(0, 0xE8342FF2, true) -- Disable ALT control
            else
                EnableControlAction(0, 0xE8342FF2, false) -- Enable Jump control
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)		
            if ragdoll then
            Citizen.InvokeNative(0xAE99FB955581844A, PlayerPedId(), 1000, 0, 0, 0, 0, 0)
            DisableControlAction(0, 0xE8342FF2, true) -- Disable ALT control
            else
                EnableControlAction(0, 0xE8342FF2, false) -- Enable Jump control
            end
        end
    end)
end)


Citizen.CreateThread(function()
    while true do
        Wait(5)
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))

        if transferring then
            DrawControlClone3D(px, py, pz+1.1)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsPedRagdoll(clone1) then
            Citizen.InvokeNative(0xAE99FB955581844A, clone1, -1, 0, 0, 0, 0, 0)
        end
    end
end)

ragdoll = false

-- PROMPT FUNCTION
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function() -- Prompt
    while true do
        Wait(5)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local cx, cy, cz = table.unpack(GetEntityCoords(clone1))

        for key, value in pairs(Config.settings) do
            if not IsEntityDead(PlayerPedId()) then
                if castingSpell and not IsEntityDead(PlayerPedId()) then
                    DrawCloning3D(x, y, z+1.0)
                    double = true
                    -- DrawText3D(x, y, z+1.0, true, "~COLOR_YELLOW~"..value.summoningMessage)
                end
                if breakingSpell and not IsEntityDead(PlayerPedId()) and DoesEntityExist(clone1) and IsEntityDead(clone1) and existed then
                    DrawKillClone3D(x, y, z+1.0)
                    -- DrawText3D(x, y, z+1.0, true, "~COLOR_MENU_TEXT_DISABLED~"..value.deleteCloneMessage)
                end
                if droningPrompt then
                    -- DrawText3D(x, y, z+1.0, true, "~COLOR_MENU_TEXT_DISABLED~Droning..")
                end
            end
        end
    end
end)

Citizen.CreateThread(function() -- Prompt
    while true do
        Wait(5)
        if double then
            Wait(900)
            double = false
            doubled = true
        end
        if doubled then
            Wait(3200)
            doubled = false
        end
    end
end)

-- IF CLONE IS DEAD
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if DoesEntityExist(clone1) then
            if IsEntityDead(clone1) then
                if DoesEntityExist(sack) then
                    DeleteEntity(sack)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if IsPedSprinting(clone1) or IsPedRunning(clone1) or IsPedWalking(clone1) or IsPedRagdoll(clone1) then
            if DoesEntityExist(clone1) then
                DeleteEntity(peepee)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        
        if existed and IsEntityDead(clone1) then
            lantern = false
            cloneDying = true
            Citizen.Wait(3000)
            cloneDying = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        for key, value in pairs(Config.settings) do
            if IsEntityDead(clone1) and existed then
                timerStarted = false
                timer = 0
                cloned = false
                dying = true
                cloneDying = true
                saving = false
                cloneIsSharing = false
                spawning = true
                if IsPedHuman(clone1) then
                    Citizen.Wait(1800)
                    breakingSpell = false
                    local cx, cy, cz = table.unpack(GetEntityCoords(clone1))
                    if value.vfx then
                        if value.narutoEffect then
                            AddExplosion(cx, cy, cz, 12, 0.0, true, true, true)
                            kagebunshin(1.2)
                        else
                            AddExplosion(cx, cy, cz, 12, 0.001, true, false, true)
                        end
                    else
                        PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                    end
                    Citizen.Wait(200)
                    SetEntityVelocity(clone1, 1.5, 1.5, 2.5)
                    RemoveBlip(blip)
                    existed = false
                    shareItem = false
                    if not value.narutoEffect then
                        if value.vfx then
                            local ex, ey, ez = table.unpack(GetEntityCoords(clone1))
                            spawnExplode(0.3)
                            bloodExplode(clone1)
                        else
                            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                        end
                    end
                    Citizen.Wait(100)
                else
                    breakingSpell = false
                    kagebunshin(0.5)
                    playSmokeAudio()
                    Wait(200)
                    DeleteEntity(clone1)
                    RemoveBlip(blip)
                    existed = false
                    shareItem = false
                end
                spawning = false
                DeleteEntity(clone1)
                dying = false
                cloneDying = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local animation = "amb_misc@world_human_pray_rosary@base"

        RequestAnimDict(animation)
        while not HasAnimDictLoaded(animation) do
            Wait(100)
        end
        if IsEntityPlayingAnim(PlayerPedId(), animation, "base", 3) and DoesEntityExist(clone1) then

            -- face clone when killing

            if not IsPedSprinting(PlayerPedId()) or not IsPedRunning(PlayerPedId()) or not IsPedWalking(PlayerPedId()) or not IsPedRagdoll(PlayerPedId()) then
                Citizen.InvokeNative(0x5AD23D40115353AC, PlayerPedId(), clone1, 2000, 1, 0, 0)
                Citizen.Wait(1000)
            end

            breakingSpell = true
            PlaySoundFrontend("Gain_Point", "HUD_MP_PITP", true, 1)
            
            SetEntityHealth(clone1, 0, 0)
            clearTasks()
            breakingSpell = false

        elseif IsEntityPlayingAnim(PlayerPedId(), animation, "base", 3) and not DoesEntityExist(clone1) then 
            showCloneRadius = true
            Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)
            castingSpell = true
            castSpell()
            Citizen.Wait(800)
            TriggerServerEvent('nic_clone:triggerServer')
            Citizen.Wait(600)
            clearTasks()
            castingSpell = false
            showCloneRadius = false
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(5)
        local playerPed = PlayerPedId()
        local px, py, pz = table.unpack(GetEntityCoords(playerPed, 0))

        if showCloneRadius then
            for key, value in pairs(Config.settings) do
                if value.displayCloneRadius then
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, px, py, pz-0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 4.0, 4.0, 1.0, 255, 0, 0, 45, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if cloneDrinking then
            SetPedCanRagdoll(clone1, false)
        else
            SetPedCanRagdoll(clone1, true)
        end
    end
end)

-- FUNCTIONS
----------------------------------------------------------------------------------------------------

function cameraBars()
	Citizen.CreateThread(function()
		while tempsbar == 1 do
			Wait(5)
			N_0xe296208c273bd7f0(-1, -1, 0, 17, 0, 0)
		end
	end)
end

function cloneGiveFirstAid()
    getItemAnimation(clone1)
end

function castSpell()
    local animation = "amb_misc@world_human_pray_rosary@base"
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Hand")
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    local propName = "s_lev_journal_book"

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "base", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

function cloneCastSpell()
    local animation = "amb_misc@world_human_pray_rosary@base"
    local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_L_Hand")
    local x, y, z = table.unpack(GetEntityCoords(clone1))

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
        
    TaskPlayAnim(clone1, animation, "base", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

function clearTasks()
    ClearPedTasks(PlayerPedId())
end

function cloneDrinkFirstaid()
    local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_R_Hand")
    local cloneHealth = GetEntityHealth(clone1)
    local animation = "mech_inventory@drinking@bottle_cylinder_d1-55_h18_neck_a8_b1-8"
    local propName = "p_bottlemedicine16x"
    local medProp
    local cx, cy, cz = table.unpack(GetEntityCoords(clone1))
    RequestAnimDict(animation) 
    while ( not HasAnimDictLoaded(animation ) ) do 
        Citizen.Wait( 100 )
    end
    getItemAnimation()
    Citizen.Wait(500)
    medProp = CreateObject(GetHashKey(propName), cx, cy, cz,  true,  true, true)
    AttachEntityToEntity(medProp, clone1, boneIndex, 0.06, -0.1, -0.11, -75.0, 0.00, -17.00, true, true, false, true, 1, true)
    TaskPlayAnim(clone1, animation, "uncork", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
    cloneDrinking = true
    TaskPlayAnim(clone1, animation, "chug_a", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(4500)
    SetEntityHealth(clone1, cloneHealth+80, 1)
    Citizen.Wait(1080)
    DetachEntity(medProp, 1, 1)
    cloneDrinking = false
    Citizen.Wait(300)
    ClearPedTasks(clone1)
    Citizen.Wait(1000)
    DeleteObject(medProp)
end

function notAllowedPrompt()
    TriggerEvent("nic_prompt:existing_fire_on")
    Citizen.Wait(1300)
    TriggerEvent("nic_prompt:existing_fire_off")
    return
end

function getItemAnimation()
    local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    TaskPlayAnim(clone1, animation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(600)
end

function IsPlayerNearClone(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    for key, value in pairs(Config.settings) do
        if distance < value.cloneRangeDistance then
            return true
        end
    end
end

function IsPlayerNearCloneHealthRadius(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 8 then
        return true
    end
end

function IsPlayerNearCloneWithFirstAid(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 1 then
        return true
    end
end

function playKeepAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
end

function SET_BLIP_TYPE (clone1)
	return Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, clone1)
end

function DrawText3D(x, y, z, enableShadow, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawText3D2(x, y, z, enableShadow, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.45, 0.45)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function makeEntityFaceEntity(player, clone)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(clone, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
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

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end


Citizen.CreateThread(function()
    while true do
        Wait(5)

        if Citizen.InvokeNative(0xD5FE956C70FF370B, PlayerPedId()) and not (IsPedSprinting(PlayerPedId()) or IsPedRunning(PlayerPedId()) or IsPedWalking(PlayerPedId())) and not cloneControl then
            cloneCrouch()
        end
    end
end)

function cloneCrouch()
    TaskSetCrouchMovement(clone1, true, 0, false)
end

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local cloneHealth = GetEntityHealth(clone1)
        local hour = GetClockHours()
        local cHolding = Citizen.InvokeNative(0xD806CD2A4F2C2996, clone1)
        if not IsPedSwimming(clone1) and not Citizen.InvokeNative(0x3AA24CCC0D451379, clone1) and not Citizen.InvokeNative(0xD453BB601D4A606E, clone1) and not IsPedInWrithe(clone1) and IsPedHuman(clone1) and not Citizen.InvokeNative(0xA911EE21EDF69DAF, clone1) and not cHolding and not Citizen.InvokeNative(0xF29A186ED428B552, clone1, weapon) and not timerStarted and DoesEntityExist(clone1) and IsPedStill(PlayerPedId()) and IsPedStill(clone1) and not cloneControl and not IsPedRagdoll(clone1) and not IsPedInMeleeCombat(clone1) and cloneHealth >= 46 and hour >= 7 and hour <= 19 then            
            playCloneIdleAnim()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if DoesEntityExist(clone1) then
            if GetEntityHealth(clone1) >= 100 then
                SetEntityHealth(clone1, 100, 0)
            else
                SetPlayerHealthRechargeMultiplier(clone1, 0.0)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if DoesEntityExist(clone1) then
            for key, value in pairs(Config.settings) do
                SetPedScale(clone1, value.associateScale)                
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        local hour = GetClockHours()
        local reactionRandom = math.random(0, 6)
        local cloneHealth = GetEntityHealth(clone1)
        local cHolding = Citizen.InvokeNative(0xD806CD2A4F2C2996, clone1)
        
        if not Citizen.InvokeNative(0x3AA24CCC0D451379, clone1) and not Citizen.InvokeNative(0xD453BB601D4A606E, clone1) and not IsPedInWrithe(clone1) and IsPedHuman(clone1) and not Citizen.InvokeNative(0xA911EE21EDF69DAF, clone1) and not cHolding and not Citizen.InvokeNative(0xF29A186ED428B552, clone1, weapon) and not timerStarted and IsPedRagdoll(PlayerPedId()) and not IsPedRagdoll(clone1) and IsPedStill(clone1) and not cloneControl and not cloneReacting and not cloneDrinking and cloneHealth >= 46 and hour >= 7 and hour <= 19 then
            Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 2, true)
            timer = 0
            timerStarted = false
            cloneLaughing = true
            cloneReacting = false
            if not IsPedOnMount(clone1) or not IsPedInAnyVehicle(clone1, false) then
                makeEntityFaceEntity(clone1, PlayerPedId())
            end
            if not IsPedRagdoll(clone1) then
                if reactionRandom == 0 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 0x0CF840A9, 1, 1, 0, 0)
                elseif reactionRandom == 1 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 0x0CF840A9, 1, 1, 0, 0)
                elseif reactionRandom == 2 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, -402959, 1, 1, 0, 0)
                elseif reactionRandom == 3 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 803206066, 1, 1, 0, 0)
                elseif reactionRandom == 4 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 445839715, 1, 1, 0, 0)
                elseif reactionRandom == 5 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 1825177171, 1, 1, 0, 0)
                else
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, -221241824, 1, 1, 0, 0)
                end
            end
        elseif not Citizen.InvokeNative(0x3AA24CCC0D451379, clone1) and not Citizen.InvokeNative(0xD453BB601D4A606E, clone1) and IsPedHuman(clone1) and not Citizen.InvokeNative(0xF29A186ED428B552, clone1, weapon) and not timerStarted and IsPedRagdoll(clone1) and not cloneControl and not cloneReacting and not cloneDrinking and cloneHealth >= 46 and hour >= 7 and hour <= 19 then
            Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 2, true)
            timer = 0
            timerStarted = false
            Citizen.Wait(2000)
            cloneLaughing = true
            cloneReacting = false
            if not IsPedOnMount(clone1) or not IsPedInAnyVehicle(clone1, false) then
                makeEntityFaceEntity(clone1, PlayerPedId())
            end
            if not IsPedRagdoll(clone1) then
                if reactionRandom == 0 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 987239450, 1, 1, 0, 0)
                elseif reactionRandom == 1 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, -553424129, 1, 1, 0, 0)
                elseif reactionRandom == 2 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 969312568, 1, 1, 0, 0)
                elseif reactionRandom == 3 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 354512356, 1, 1, 0, 0)
                elseif reactionRandom == 4 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 81347960, 1, 1, 0, 0)
                elseif reactionRandom == 5 then
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 1802342943, 1, 1, 0, 0)
                else
                    Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 486225122, 1, 1, 0, 0)
                end
            end
        end
        cloneLaughing = false
    end
end)


function playCloneIdleAnim()

    local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_R_Hand")
    local canteenAnimation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    local cannedAnimation = "mech_inventory@eating@canned_food@cylinder@d8-2_h10-5"
    local foodAnimation = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich"
    local drinkWaterAnimation = "amb_rest_drunk@world_human_bucket_drink@ground@male_a@idle_b"
    local washAnimation = "amb_misc@world_human_wash_face_bucket@ground@male_a@idle_d"
    local propName = ""
    local animRandom = 0

    local getWater1 = "mech_pickup@system@rh"
    local getWater2 = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 2, true)
    cloneReacting = true
    DetachEntity(offeredProp, 1, 1)

    cloneIdling = true

    if not timerStarted then
        if IsEntityInWater(clone1) and not IsPedSwimming(clone1) and not IsPedOnMount(clone1) then
            animRandom = math.random(19, 21)
        else
            animRandom = math.random(0, 18)
        end
    end

    if not timerStarted and not cloneControl and not cloneLaughing and not IsPedSprinting(clone1) or not IsPedRunning(clone1) or not IsPedWalking(clone1) and not IsPedRagdoll(clone1) and not cloneDrinking and not cloneHealth <= 45 and not IsPedInMeleeCombat(PlayerPedId()) or not IsPedInMeleeCombat(clone1) then
        timer = 0
        playingAnim = true
        timerStarted = false
        DeleteObject(offeredProp)
        Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 2, true)
        if animRandom == 0 then    
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 0x8B7F8EEB, 1, 1, 0, 0)
            Citizen.Wait(12000)
            ClearPedTasks(clone1)
        elseif animRandom == 1 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 0x81615BA3, 1, 1, 0, 0)
            Citizen.Wait(12000)
            ClearPedTasks(clone1)
        elseif animRandom == 2 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 0xBA51B111, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 3 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 0x43F71CA8, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 4 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 1256841324, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 5 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 1939251934, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 6 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 796723886, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 7 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, -2106738342, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 8 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 935157006, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 9 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 901097731, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 10 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 831975651, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 11 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, -1118911493, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 12 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 246916594, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 13 then
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 969312568, 1, 1, 0, 0)
            Citizen.Wait(8000)
            ClearPedTasks(clone1)
        elseif animRandom == 14 then
            RequestAnimDict(canteenAnimation) 
            while ( not HasAnimDictLoaded(canteenAnimation)) do 
                Citizen.Wait( 100 )
            end
            TaskPlayAnim(clone1, canteenAnimation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
            Citizen.Wait(700)
            carryCloneCanteen()
            AttachEntityToEntity(prop, clone1, boneIndex, 0.12, 0.03, -0.07, -65.0, 0.00, -17.00, true, true, false, true, 1, true)
            Citizen.Wait(2000)
            AttachEntityToEntity(prop, clone1, boneIndex, 0.09, 0.06, -0.05, -65.0, 0.00, -17.00, true, true, false, true, 1, true)            
            if IsEntityAttachedToEntity(prop, clone1) then
                playCloneKeepkAnimation()
                Citizen.Wait(500)
                DeleteObject(prop)
                Citizen.Wait(1000)
                ClearPedTasks(clone1)
            else
                ClearPedTasks(clone1)
            end
        elseif animRandom == 15 then
            RequestAnimDict(cannedAnimation) 
            while ( not HasAnimDictLoaded(cannedAnimation)) do 
                Citizen.Wait( 100 )
            end
            getItemAnimation()
            propName = "proc_can01x"
            carryCloneProp(propName)
            AttachEntityToEntity(prop, clone1, boneIndex, 0.11, -0.03, -0.07, -90.0, 0.00, 0.00, true, true, false, true, 1, true)
            Citizen.Wait(600)
            TaskPlayAnim(clone1, cannedAnimation, "right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
            Citizen.Wait(2900)
            DetachEntity(prop, 1, 1)
            Citizen.Wait(100)
            ClearPedTasks(clone1)
            Citizen.Wait(1000)
            DeleteObject(prop)
        elseif animRandom == 16 then
            RequestAnimDict(foodAnimation) 
            while ( not HasAnimDictLoaded(foodAnimation)) do 
                Citizen.Wait( 100 )
            end
            getItemAnimation()
            propName = "p_banana_day_04x"
            carryCloneProp(propName)
            AttachEntityToEntity(prop, clone1, boneIndex, 0.09, -0.15, -0.10, -90.0, 190.00, 0.00, true, true, false, true, 1, true)
            Citizen.Wait(500)
            TaskPlayAnim(clone1, foodAnimation, "quick_right_hand", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
            Citizen.Wait(1500)
            DeleteObject(prop)
            Citizen.Wait(1000)
            ClearPedTasks(clone1)
        elseif animRandom == 17 then
            makeEntityFaceEntity(clone1, PlayerPedId())
            Citizen.InvokeNative(0xB31A277C1AC7B7FF, clone1, 0, 0, 1927505461, 1, 1, 0, 0)
        elseif animRandom == 18 and IsPedStill(clone1) then
            if not IsPedOnMount(clone1) and not IsPedInAnyVehicle(clone1, false) and not IsPedOnVehicle(clone1, true) and not IsPedHangingOnToVehicle(clone1) and not IsPedInFlyingVehicle(clone1) and not IsPedSittingInAnyVehicle(clone1) then
                TaskStartScenarioInPlace(clone1, GetHashKey('WORLD_HUMAN_PEE'), -1, true, false, false, false)
                Wait(6000)
                CreatePeepee()
                Wait(22000)
                ClearPedTasks(clone1)
                Citizen.Wait(1000)
                DeleteEntity(peepee)
            end
        elseif animRandom == 19 and IsPedStill(clone1) then
            if not IsPedOnMount(clone1) and not IsPedInAnyVehicle(clone1, false) and not IsPedOnVehicle(clone1, true) and not IsPedHangingOnToVehicle(clone1) and not IsPedInFlyingVehicle(clone1) and not IsPedSittingInAnyVehicle(clone1) then
                RequestAnimDict(drinkWaterAnimation)
                while ( not HasAnimDictLoaded(drinkWaterAnimation)) do 
                    Citizen.Wait( 100 )
                end
                TaskPlayAnim(clone1, drinkWaterAnimation, "idle_f", 8.0, -8.0, -1, 0, 0, true, 0, false, 0, false)
                Wait(9000)
                ClearPedTasks(clone1)
            end
        elseif animRandom == 20 and IsPedStill(clone1) then  
            if not IsPedOnMount(clone1) and not IsPedInAnyVehicle(clone1, false) and not IsPedOnVehicle(clone1, true) and not IsPedHangingOnToVehicle(clone1) and not IsPedInFlyingVehicle(clone1) and not IsPedSittingInAnyVehicle(clone1) then
                TaskStartScenarioInPlace(clone1, GetHashKey('WORLD_HUMAN_WASH_FACE_BUCKET_GROUND_NO_BUCKET'), -1, true, false, false, false)
                Wait(9000)
                Citizen.InvokeNative(0x523C79AEEFCC4A2A,clone1,10, "ALL")
                Citizen.InvokeNative(0x6585D955A68452A5, clone1)
                Citizen.InvokeNative(0x9C720776DAA43E7E, clone1)
                Citizen.InvokeNative(0x8FE22675A5A45817, clone1)
                ClearPedEnvDirt(clone1)
                ClearPedBloodDamage(clone1)
                ClearPedDamageDecalByZone(clone1)
                ClearPedTasks(clone1)
            end
        elseif animRandom == 21 and IsPedStill(clone1) then  
            if not IsPedOnMount(clone1) and not IsPedInAnyVehicle(clone1, false) and not IsPedOnVehicle(clone1, true) and not IsPedHangingOnToVehicle(clone1) and not IsPedInFlyingVehicle(clone1) and not IsPedSittingInAnyVehicle(clone1) then
                RequestAnimDict(getWater1)
                while ( not HasAnimDictLoaded(getWater1)) do 
                    Citizen.Wait( 100 )
                end
                TaskPlayAnim(clone1, getWater2, "use_quick", 8.0, -1.0, 120000, 23, 0, true, 0, false, 0, false)
                Citizen.Wait(1000)
                carryCloneCanteen()
                AttachEntityToEntity(prop, clone1, boneIndex, 0.12, 0.03, -0.07, -65.0, 0.00, -17.00, true, true, false, true, 1, true)
                Citizen.Wait(300)
                TaskPlayAnim(clone1, getWater1, "ground_far_swipe", 8.0, -1.0, 120000, 23, 0, true, 0, false, 0, false)
                Citizen.Wait(1400)
                if IsEntityAttachedToEntity(prop, clone1) then
                    playCloneKeepkAnimation()
                    Citizen.Wait(1000)
                end
                DeleteObject(prop)
                Citizen.Wait(1000)
                ClearPedTasks(clone1)
            end
        end
        playingAnim = false
        cloneReacting = false  
        cloneIdling = false
        Citizen.Wait(5000)
    end
end

function CreatePeepee() -- Create Peepee
    local peepeeName = "p_cs_sausage01x"
    local x, y, z = table.unpack(GetEntityCoords(clone1))
    local boneIndex = GetEntityBoneIndexByName(clone1, "SKEL_Pelvis")
    peepee = CreateObject(GetHashKey(peepeeName), x, y, z-1.0,  true,  true, true)
    AttachEntityToEntity(peepee, clone1, 1, 0.21, 0.13, -0.01, 2.0, 0.05, -35.21, false, true, false, false, 1, true)
    -- AddExplosion(x, y, z, 12, 0.0, false, false, false)
end

-- CREATE ITEM PROP FUNCTION
----------------------------------------------------------------------------------------------------

function getCloneItemAnimation()
    local animation = "mech_inventory@item@fallbacks@tonic_potent@offhand"
    TaskPlayAnim(PlayerPedId(), animation, "use_quick", 8.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(600)
end

function carryCloneProp(propName)
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    prop = CreateObject(GetHashKey(propName), x, y, z,  true,  true, true)
end

function carryCloneCanteen()
    local x,y,z = table.unpack(GetEntityCoords(clone1))
    prop = CreateObject(GetHashKey('p_cs_canteen_hercule'), x, y, z,  true,  true, true)
end

function playCloneKeepkAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(clone1, animation, "stn_long_low_skill_exit", 8.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
end

function setRagdoll(flag)
    ragdoll = flag
end

-- EVENTS
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local carrying = Citizen.InvokeNative(0xA911EE21EDF69DAF, clone1)
        if IsPedHuman(clone1) and DoesEntityExist(clone1) and not Citizen.InvokeNative(0xA911EE21EDF69DAF, clone1) and not cloneDrinking then

            
            for key, value in pairs(Config.settings) do
                if (cloned and value) or not carrying then
                    if IsPedSprinting(clone1) or IsPedRunning(clone1) then
                        Citizen.InvokeNative(0xF0A4F1BBF4FA7497, clone1, -1, 0, 0)
                    end
                end
            end
            Citizen.InvokeNative(0xDF993EE5E90ABA25, clone1, true)
            Wait(5000)
        end

        if IsPedRagdoll(clone1) then
            SetPedToRagdoll(clone1, 2000, 2000, 0, true, true, true)
        end
    end
end)

RegisterNetEvent('nic_clone:associate')
AddEventHandler('nic_clone:associate', function()
    if not DoesEntityExist(clone1) then
        spawnCompanion()
    end
end)

function spawnCompanion()

    local model = ""
    local player = PlayerPedId()
    local companionName = "Companion"
    local px, py, pz = table.unpack(GetEntityCoords(player, 0))
    local num = math.random(2, 30)/10

    for key, value in pairs(Config.settings) do
        model = value.associateModel
    end

    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(100)
    end

    clone1 = CreatePed(model, px, py, pz, GetEntityHeading(player), false, true) 
    local coords = vector3(px+num, py+num, pz-0.5)
    SetEntityCoords(clone1, coords)    
    local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))   
    playSmokeAudio()
    kagebunshin(0.8)

    local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))
    local blip = SET_BLIP_TYPE(clone1) 
    SetEntityAlpha(clone1, 120, false)
    SetBlipSprite(blip, sprite, 1)
    for key, value in pairs(Config.settings) do
        if value.displayNametag then
            SetPedPromptName(clone1, value.nametag)
            SetPedNameDebug(clone1, value.nametag)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, value.nametag)
        else
            SetPedPromptName(clone1, companionName)
            SetPedNameDebug(clone1, companionName)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, companionName)
        end
    end
    SetPedRandomComponentVariation(clone1, 0)
    SetPedOutfitPreset(clone1, 0, false)
    Citizen.InvokeNative(0x283978A15512B2FE, clone1, true)
    SetBlockingOfNonTemporaryEvents(clone1, false)
    SetPedAsGroupMember(clone1, GetPedGroupIndex(PlayerPedId()))

    if not IsPedHuman(clone1) then
        Citizen.InvokeNative(0x166E7CF68597D8B5, clone1, 800)
        SetEntityHealth(clone1, 800, 0)
        for key, value in pairs(Config.settings) do
            SetPedScale(clone1, value.associateScale)
        end
    else
        SetEntityHealth(clone1, GetEntityHealth(PlayerPedId()), 0)
    end

    if Citizen.InvokeNative(0xC346A546612C49A9, clone1) then
        TaskFlyingCircle(clone1, 1, 1, 1, 1, 1, 1)
    end

    existed = true
    spawning = false
    cloned = false
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

RegisterNetEvent('nic_clone:shadowClone')
AddEventHandler('nic_clone:shadowClone', function()

    local ped = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
    local target = GetClosestPed(ped, 3.0)
    local pos = GetEntityForwardVector(ped)
    local multiplier = 7.0
    local stagger = math.random(1000, 5000)

    if target == nil or IsEntityDead(target) then
        for key, value in pairs(Config.settings) do
            local hurtDuration = math.random(0, 0)
            local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
    
            if value.narutoEffect then
                clone1 = ClonePed(ped, 0.0, true, true)
                local coords = vector3(px+2.2, py+2.2, pz-1.1)
                SetEntityCoords(clone1, coords)
                local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))
                if value.vfx then
                    AddExplosion(cx, cy, cz, 12, 0.0, true, true, true)
                    kagebunshin(1.2)
                else
                    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                end
            else
                playEffectAudio()
                TriggerEvent("nic_prompt:pym_overlay_on")
                AnimpostfxPlay("Mission_GNG0_Ride")
                clone1 = ClonePed(ped, true, true, true)
                local cPos = GetEntityForwardVector(clone1)
                local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
                local coords = vector3(px, py, pz-1.0)
                SetEntityCoords(clone1, coords)
                local cx, cy, cz = table.unpack(GetEntityCoords(clone1, 0))

                Citizen.InvokeNative(0xAE99FB955581844A, ped, stagger, 0, 0, 0, 0, 0)
                Citizen.InvokeNative(0xAE99FB955581844A, clone1, stagger, 0, 0, 0, 0, 0)

                -- SetEntityVelocity(ped, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier)
                -- SetEntityVelocity(clone1, pos.x*multiplier, pos.y*multiplier, pos.z*multiplier)

                if value.vfx then
                    local px, py, pz = table.unpack(GetEntityCoords(ped, 0))
                    AddExplosion(px, py, pz, 12, 0.0, true, true, true)
                    spawnExplode(0.3)
                    bloodExplode(clone1)
                    bloodExplode(ped)
                    applyBloodDecals()
                    local hp = GetEntityHealth(ped)
                    if hp >= 35 then
                        SetEntityHealth(ped, hp-10, 0)
                    end
                    Citizen.Wait(250)
                else
                    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
                end
            end
    
            TriggerEvent("nic_prompt:pym_overlay_off")
            AnimpostfxStopAll()
            local cloneHealth = GetEntityHealth(clone1)
            Citizen.InvokeNative(0xAE99FB955581844A, ped, hurtDuration, 0, 0, 0, 0, 0)
            Citizen.InvokeNative(0xAE99FB955581844A, clone1 , hurtDuration, 0, 0, 0, 0, 0)
            local x, y, z = table.unpack(GetEntityCoords(clone1, 0))
            local blip = SET_BLIP_TYPE(clone1)
            SetBlipSprite(blip, sprite, 1)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Clone')
            existed = true
            SetPedScale(clone1, value.associateScale)
            SetEntityHealth(clone1, GetEntityHealth(ped), 0)
            SetPedNameDebug(clone1, name)
            SetPedPromptName(clone1, name)
            SetBlockingOfNonTemporaryEvents(clone1, false)
            SetPedAsGroupMember(clone1, GetPedGroupIndex(ped))
            SetPedCanBeTargettedByPlayer(clone1, ped, true)
            SetPedCanBeTargetted(clone1, true)
            SetPedCanBeTargettedByTeam(clone1, GetPedGroupIndex(ped, true))
            SetEntityCanBeDamaged(clone1, true)
            
            if getDirty then
                if not particle_effect then
                    playEffectAudio()
                    playSmokeEffect() 
                    playSmoke2Effect() 
                    playSmoke3Effect()
                    playParticleEffect()
                    cloneSack()
                else
                    stopEffect()
                end
            end
        end
        cloned = true
        spawning = false
    else
        notAllowedPrompt()
    end
    
end)

function applyBloodDecals()    
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Blood_Spray_Front_att", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Blood_Spray_FRONT_V1", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Dead_John_bloody_back_vic", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Dead_John_bloody_chest_vic", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Mob4_Bitten_Leg_Blood_Soak_R", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_AnimalBlood_Lrg_Bloody", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Blood_Spray_Right_V2", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Blood_face_left", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Blood_face_right", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Blood_Soak_Right_Arm_Murder_for_Hire_Bump", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, PlayerPedId(), "PD_Blood_Soak_Left_Arm_Murder_for_Hire_Bump", 0.0, 0.0)

    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Blood_Spray_Front_att", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Blood_Spray_FRONT_V1", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Dead_John_bloody_back_vic", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Dead_John_bloody_chest_vic", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Mob4_Bitten_Leg_Blood_Soak_R", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_AnimalBlood_Lrg_Bloody", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Blood_Spray_Right_V2", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Blood_face_left", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Blood_face_right", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Blood_Soak_Right_Arm_Murder_for_Hire_Bump", 0.0, 0.0)
    Citizen.InvokeNative(0x46DF918788CB093F, clone1, "PD_Blood_Soak_Left_Arm_Murder_for_Hire_Bump", 0.0, 0.0)
end

function spawnExplode(size)
    local new_ptfx_dictionary = "core"
    local new_ptfx_name = "exp_grd_dynamite"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_explode_effect_active then
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

            
            current_explode_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, clone1, 0, 0, 0, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_explode_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_explode_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_explode_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_explode_handle_id = false
        is_explode_effect_active = false	
    end
end

function kagebunshin(size)
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

            
            current_ptfx_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, clone1, 0, 0, -0.2, 0, 0, 0, size, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
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

function bloodExplode(ped)
    local new_ptfx_dictionary = "core"
    local new_ptfx_name = "blood_explosive_bullet"
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name

    if not is_blood_effect_active then
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
            
            current_blood_handle_id =  Citizen.InvokeNative(0xE6CFE43937061143,current_ptfx_name, ped, 0, 0, 0, 0, 0, 0, 1.0, 0, 0, 0)    -- StartNetworkedParticleFxNonLoopedOnEntity
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_blood_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_blood_handle_id) then   -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_blood_handle_id, false)   -- RemoveParticleFx
            end
        end
        current_blood_handle_id = false
        is_blood_effect_active = false	
    end
end


Citizen.CreateThread(function()
    while true do
        Wait(5)
        local hour = GetClockHours()
        local carryingLantern = Citizen.InvokeNative(0xF29A186ED428B552, clone1, 0xF62FB3A3)

        if DoesEntityExist(clone1) and not IsEntityDead(clone1) then
            if hour >= 7 and hour <= 19 then
                weapon = nil
                if not carryingLantern then
                    if IsPedInMeleeCombat(PlayerPedId()) then

                        local wRandom = math.random(0, 9)

                        if wRandom == 0 then
                            weapon = 0xA2719263 -- Unarmed
                        elseif wRandom == 1 then
                            weapon = 0x7067E7A7 -- Molotov
                        elseif wRandom == 2 then
                            weapon = 0xDB21AC8C -- Knife
                        elseif wRandom == 3 then
                            weapon = 0xF5175BA1 -- Carbine
                        elseif wRandom == 4 then
                            weapon = 0x8580C63E -- Mauser
                        elseif wRandom == 5 then
                            weapon = 0x88A8505C -- Bow
                        elseif wRandom == 6 then
                            weapon = 0x28950C71 -- Machete
                        elseif wRandom == 7 then
                            weapon = 0x7DF4D025 -- Varmint
                        elseif wRandom == 8 then
                            weapon = 0xA64DAA5E -- Dynamite
                        elseif wRandom == 9 then
                            weapon = 0x6DFA071B -- Shotgun
                        end
                        carriedWeapon = true
                    else
                        Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 1, true, false)
                    end
                end
            Citizen.InvokeNative(0x4899CB088EDF59B8, clone1, 0xF62FB3A3, true, 0xF77DE93D)
            else
                if IsPedInMeleeCombat(clone1) then
                    Citizen.InvokeNative(0xFCCC886EDE3C63EC, clone1, 1, true)
                end
                weapon = 0xF62FB3A3
            end
            TriggerEvent("nic_clone:cloneEquipWeapon", weapon)
            Citizen.Wait(8000)
        end
    end
end)

RegisterNetEvent('nic_clone:cloneEquipWeapon')
AddEventHandler('nic_clone:cloneEquipWeapon', function(weapon)
    
    for key, value in pairs(Config.settings) do
        if IsPedHuman(clone1) and value.carryRandomWeapon then 
            GiveWeaponToPed_2(clone1, weapon, 10, true, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
            SetCurrentPedWeapon(clone1, weapon, true)
        end
    end
end)

function DrawMedicine3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.10, 0.10)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("honor_display") or not HasStreamedTextureDictLoaded("itemtype_textures") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("itemtype_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 0, 0)
        DrawSprite("itemtype_textures", "itemtype_upgrades", _x, _y+0.0125, 0.015, 0.027, 0.1, 255, 255, 255, 215, 0)
    end
end

function DrawCloning3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.10, 0.10)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    
    if not HasStreamedTextureDictLoaded("BLIPS_MP") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("BLIPS_MP", false)
        RequestStreamedTextureDict("generic_textures", false)
    else
        if doubled then
            DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.022, 0.034, 0.1, 255, 255, 255, 155, 0)
            DrawSprite("BLIPS_MP", "blip_adversary_medium", _x, _y, 0.018, 0.03, 0.1, 255, 255, 255, 215, 0)
        elseif double then
            DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.017, 0.03, 0.1, 255, 255, 255, 155, 0)
            DrawSprite("BLIPS_MP", "blip_adversary_small", _x, _y-0.002, 0.015, 0.025, 0.1, 255, 255, 255, 215, 0)
        end
    end
end

function DrawLogo3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not cloneDrinking then
        if not HasStreamedTextureDictLoaded("BLIPS") then
        else
            if GetEntityHealth(clone1) <= 0 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 0, 0, 0, 0, 0)
            elseif GetEntityHealth(clone1) <= 5 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 161, 0, 0, 255, 0)
            elseif GetEntityHealth(clone1) <= 25 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 255, 0, 0, 255, 0)
            elseif GetEntityHealth(clone1) <= 50 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 204, 147, 41, 255, 0)
            elseif GetEntityHealth(clone1) <= 75 then
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 204, 204, 41, 255, 0)
            else
                DrawSprite("BLIPS", "blip_ambient_companion", _x, _y+0.0125, 0.012, 0.022, 0.1, 41, 204, 63, 255, 0)
            end
        end
    end
end

function DrawCloneDead3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("honor_display") or not HasStreamedTextureDictLoaded("rpg_textures") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("rpg_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 235, 0)
        DrawSprite("rpg_textures", "rpg_wounded", _x, _y+0.0135, 0.024, 0.04, 0.1, 255, 46, 46, 215, 0)
    end
end

function DrawKillClone3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("honor_display") or not HasStreamedTextureDictLoaded("rpg_textures") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("rpg_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 235, 0)
        DrawSprite("ammo_types", "bullet_split_point", _x+0.0008, _y+0.013, 0.014, 0.025, 0.1, 255, 46, 46, 215, 0)
    end
end

function DrawControlClone3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("honor_display") or not HasStreamedTextureDictLoaded("rpg_textures") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("rpg_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 235, 0)
        DrawSprite("ammo_types", "arrow_type_confusion", _x+0.0008, _y+0.013, 0.014, 0.025, 0.1, 245, 239, 86, 215, 0)
    end
end

function DrawDroningClone3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("honor_display") or not HasStreamedTextureDictLoaded("rpg_textures") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("rpg_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 235, 0)
        DrawSprite("ammo_types", "arrow_type_confusion", _x+0.0008, _y+0.013, 0.014, 0.025, 0.1, 245, 239, 86, 215, 0)
    end
end

function DrawDroning3D(x, y, z)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.12, 0.12)
    SetTextFontForCurrentCommand(1)
    SetTextColor(222, 202, 138, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)

    if not HasStreamedTextureDictLoaded("honor_display") or not HasStreamedTextureDictLoaded("rpg_textures") then
        RequestStreamedTextureDict("honor_display", false)
        RequestStreamedTextureDict("rpg_textures", false)
    else
        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.019, 0.035, 0.1, 0, 0, 0, 235, 0)
        DrawSprite("rpg_textures", "rpg_confusion", _x+0.0008, _y+0.013, 0.024, 0.04, 0.1, 245, 239, 86, 215, 0)
    end
end

function DrawHeart3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x,_y+0.03)

    if not cloneDrinking then
        for key, value in pairs(Config.settings) do
    
            if value.cloneHealthDisplayType == "hearts" then
                if not HasStreamedTextureDictLoaded("itemtype_textures") then
                    RequestStreamedTextureDict("itemtype_textures", false)
                else
                    if GetEntityHealth(clone1) <= 0 then
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    elseif GetEntityHealth(clone1) <= 5 then
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    elseif GetEntityHealth(clone1) <= 25 then
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    elseif GetEntityHealth(clone1) <= 50 then
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.024, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.012, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x-0.0, _y+0.0122, 0.012, 0.023, 0.1, 255, 255, 255, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.012, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                        DrawSprite("itemtype_textures", "itemtype_player_health", _x+0.024, _y+0.0122, 0.012, 0.023, 0.1, 0, 0, 0, 155, 0)
                    elseif GetEntityHealth(clone1) <= 75 then
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
                    if GetEntityHealth(clone1) <= 0 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_1", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 5 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_2", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 25 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_3", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 50 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_6", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 75 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_8", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 90 then
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
                    if GetEntityHealth(clone1) <= 0 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 0, 0, 0, 0, 0)
                    elseif GetEntityHealth(clone1) <= 5 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 161, 0, 0, 215, 0)
                    elseif GetEntityHealth(clone1) <= 25 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 0, 0, 215, 0)
                    elseif GetEntityHealth(clone1) <= 50 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 255, 255, 255, 200, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0125, 0.022, 0.036, 0.1, 204, 147, 41, 215, 0)
                    elseif GetEntityHealth(clone1) <= 75 then
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
                    if GetEntityHealth(clone1) <= 0 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 0, 0, 0, 0, 0)
                    elseif GetEntityHealth(clone1) <= 5 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 161, 0, 0, 215, 0)
                    elseif GetEntityHealth(clone1) <= 25 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 0, 0, 215, 0)
                    elseif GetEntityHealth(clone1) <= 50 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 147, 41, 215, 0)
                    elseif GetEntityHealth(clone1) <= 75 then
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 204, 204, 41, 215, 0)
                    else
                        DrawSprite("honor_display", "honor_background", _x, _y+0.0122, 0.017, 0.030, 0.1, 41, 234, 63, 215, 0)
                    end
                    DrawSprite("overhead", "overhead_revive", _x, _y+0.0125, 0.018, 0.032, 0.1, 255, 255, 255, 200, 0)
                end
            elseif value.cloneHealthDisplayType == "dot" then
                if GetEntityHealth(clone1) <= 0 then
                    DrawSprite("overhead", "overhead_normal", _x, _y+0.0125, 0.012, 0.022, 0.1, 0, 0, 0, 0, 0)
                elseif GetEntityHealth(clone1) <= 5 then
                    DrawSprite("overhead", "overhead_normal", _x, _y+0.0125, 0.012, 0.022, 0.1, 161, 0, 0, 215, 0)
                elseif GetEntityHealth(clone1) <= 25 then
                    DrawSprite("overhead", "overhead_normal", _x, _y+0.0125, 0.012, 0.022, 0.1, 255, 0, 0, 215, 0)
                elseif GetEntityHealth(clone1) <= 50 then
                    DrawSprite("overhead", "overhead_normal", _x, _y+0.0125, 0.012, 0.022, 0.1, 204, 147, 41, 215, 0)
                elseif GetEntityHealth(clone1) <= 75 then
                    DrawSprite("overhead", "overhead_normal", _x, _y+0.0125, 0.012, 0.022, 0.1, 204, 204, 41, 215, 0)
                else
                    DrawSprite("overhead", "overhead_normal", _x, _y+0.0125, 0.012, 0.022, 0.1, 41, 204, 63, 215, 0)
                end
            elseif value.cloneHealthDisplayType == "core" then
                if not HasStreamedTextureDictLoaded("rpg_menu_item_effects") then
                    RequestStreamedTextureDict("rpg_menu_item_effects", false)
                else
                    if GetEntityHealth(clone1) <= 5 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_01", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                    elseif GetEntityHealth(clone1) <= 20 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_02", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                    elseif GetEntityHealth(clone1) <= 25 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_03", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                    elseif GetEntityHealth(clone1) <= 30 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_04", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                    elseif GetEntityHealth(clone1) <= 35 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_05", _x, _y+0.0125, 0.022, 0.038, 0.1, 224, 63, 63, 215, 0)
                    elseif GetEntityHealth(clone1) <= 40 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_06", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 45 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_07", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 50 then
                        DrawSprite("rpg_menu_item_effects", "effect_health_core_08", _x, _y+0.0125, 0.022, 0.038, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 55 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_1", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 60 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_2", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 65 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_3", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 60 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_4", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 75 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_5", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 70 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_6", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 85 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_7", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 80 then
                        DrawSprite("rpg_menu_item_effects", "rpg_tank_8", _x, _y+0.0125, 0.022, 0.036, 0.1, 255, 255, 255, 215, 0)
                        DrawSprite("blips_mp", "blip_health", _x, _y+0.0137, 0.017, 0.027, 0.1, 255, 255, 255, 215, 0)
                    elseif GetEntityHealth(clone1) <= 95 then
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
                    if GetEntityHealth(clone1) <= 5 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0198, _y+0.0125, 0.005, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 10 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0148, _y+0.0125, 0.015, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 15 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0134, _y+0.0125, 0.018, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 20 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0108, _y+0.0125, 0.023, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 25 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0087, _y+0.0125, 0.027, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 30 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0082, _y+0.0125, 0.028, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 35 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0075, _y+0.0125, 0.030, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 40 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0070, _y+0.0125, 0.031, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 45 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0067, _y+0.0125, 0.032, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 50 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0058, _y+0.0125, 0.034, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 55 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0052, _y+0.0125, 0.035, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 60 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0047, _y+0.0125, 0.036, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 65 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0039, _y+0.0125, 0.038, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 70 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0031, _y+0.0125, 0.039, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 75 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0023, _y+0.0125, 0.040, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 80 then
                        DrawSprite("hud_textures", "game_update_bg_1a", _x, _y+0.0125, 0.047, 0.012, 0.1, 0, 0, 0, 215, 0)
                        DrawSprite("hud_textures", "game_update_bg_1a", _x-0.0015, _y+0.0125, 0.042, 0.008, 0.1, 38, 97, 33, 215, 0)
                    elseif GetEntityHealth(clone1) <= 95 then
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
end
