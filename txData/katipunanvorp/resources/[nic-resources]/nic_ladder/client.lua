
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------
local holdingLadder = false
local propName = ""
local ladder
local nearProp
local blip
local carrying = false
local exist = false
local placed = false
local prompt = false
local duration = 22 -- How long the ladder will stay in seconds
local propLife = 0
local prop
local propModel = "p_beechers_ladder01x"
local centerBone = "SKEL_Spine3"


-- IF CARRYING
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local px, py, pz = table.unpack(GetEntityCoords(prop))
		if carrying then
            Citizen.InvokeNative(0x7DE9692C6F64CFE8, PlayerPedId(), false, 0, false)
            if (IsControlJustPressed(0, 0xF84FA74F) or IsControlJustPressed(0, 0x156F7119)) and not IsEntityDead(PlayerPedId()) then
                TriggerServerEvent('nic_ladder:additem')
                DeleteObject(prop)
                RemoveBlip(blip)
                carrying = false
                playPickAnimation()
                propLife = 0
                placed = false
                exist = false
            end
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz-2.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.6, 1.6, 1.0, 255, 242, 0, 190, false, true, 2, false, false, false, false)
            DrawTxt("Place the ladder '~COLOR_BLUE~properly~COLOR_WHITE~' then press:", 0.5, 0.08, 0.3, 0.4, true, 181, 204, 242, 250, true)  
            DrawTxt("F", 0.5, 0.10, 0.3, 0.7, true, 199, 215, 0, 200, true)
            DisableControlAction(0, 0xD9D0E1C0, true) -- Disable Jump
            DisableControlAction(0, 0x8FFC75D6, true) -- Disable Sprint
       end
    end
end)

-- IF LADDER IS USED
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_ladder:useLadder')
AddEventHandler('nic_ladder:useLadder', function()
    if not exist then
        RequestAnimDict("mech_carry_box")
        while not HasAnimDictLoaded("mech_carry_box") do
            Wait(100)
        end    
        TriggerEvent("vorp_inventory:CloseInv")
        addLadder()
        carryLadder()
        exist = true
        carrying = true
    else
        print("There's an existing Ladder")
        TriggerEvent("vorp:TipBottom", "There's still an existing Ladder", 3000)
    end
end)

-- IF ENTER KEY IS PRESSED
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        propName = "ladder"
        local px, py, pz = table.unpack(GetEntityCoords(prop))
        local heading = GetEntityHeading(PlayerPedId())
        if (IsControlJustPressed(0, 0xB2F377E8)) and carrying and not IsEntityDead(PlayerPedId())  then
            if Citizen.InvokeNative(0xF291396B517E25B2, px, py, pz) then
                carrying = false
                AttachEntityToEntity(prop, PlayerPedId(), centerBone, 0.0, 0.80, 0.20, 90.0, -90.0, 0.00, true, true, false, true, 1, true)
                ClearPedTasks(PlayerPedId())
                TriggerServerEvent('nic_ladder:removeitem')
                TriggerEvent('nic_ladder:timer')
                placed = true
                DetachEntity(prop, 1, 1)
                blip = N_0x554d9d53f696d002(203020899, px, py, pz)
                SetBlipSprite(blip, -487631996, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Ladder')
                SetEntityHeading(prop, heading)
                print(heading)
                ClearPedTasks(PlayerPedId())
                PlaceObjectOnGroundProperly(prop)
            else
                TriggerEvent("vorp:TipBottom", _source, "You can't Place the Ladder here", 3000)
            end
        end
    end
end)

-- IF RAGDOLL
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
		if IsPedRagdoll(PlayerPedId()) and not placed then
			DeleteObject(prop)
            RemoveBlip(blip)
            propLife = 0
            carrying = false
            placed = false
            exist = false
            ClearPedTasks(PlayerPedId())
       end       
    end
end)

-- IF DEL KEY IS PRESSED
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
		local px, py, pz = table.unpack(GetEntityCoords(prop))
        nearProp = DoesObjectOfTypeExistAtCoords(x, y, z, 0.8, propModel, true)
        if nearProp and placed then
            DrawText3DSM(px, py, pz-0.2, "[~t8~MOUSE2~q~]~q~ Store Ladder")
            if (IsControlJustPressed(0, 0xF84FA74F)) and placed and not IsEntityDead(PlayerPedId()) then
                TriggerServerEvent('nic_ladder:additem')
                DeleteObject(prop)
                RemoveBlip(blip)
                carrying = false
                playPickAnimation()
                propLife = 0
                placed = false
                exist = false
            end
        end
    end
end)


-- IF LADDER EXISTS
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
		local px, py, pz = table.unpack(GetEntityCoords(prop))
        nearProp = DoesObjectOfTypeExistAtCoords(x, y, z, 1.5, propModel, true)
        if exist and nearProp and placed and not IsEntityDead(PlayerPedId())  then
            if propLife <= 20 and propLife > 10 then
                DrawText3D(px, py, pz, "~o~LADDER: ~d~"..propLife)
            elseif propLife <= 10 and propLife > 0 then
                DrawText3D(px, py, pz, "~o~LADDER: ~e~"..propLife)
            else
                DrawText3D(px, py, pz, "~o~LADDER: ~q~"..propLife)
            end
        end
    end
end)

-- IF DEAD
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local dead = Citizen.InvokeNative(0x3317DEDB88C95038, PlayerPedId(), true)
		if dead then
            propLife = 0
            carrying = false
            placed = false
            exist = false
			DeleteObject(prop)
            RemoveBlip(blip)
        end      
    end
end)

-- TIMER FUNCTION
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_ladder:timer')
AddEventHandler('nic_ladder:timer', function()
	Citizen.CreateThread(function()
        propLife = duration
		while propLife > 0 and placed do
			Citizen.Wait(1000)
			if propLife > 0 then
				propLife = propLife - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while exist do
            Citizen.Wait(0)
            if propLife < 1 then
                ClearPedTasks(PlayerPedId())
                DeleteObject(prop)
                RemoveBlip(blip)
                placed = false
                carrying = false
                exist = false
                propLife = 0
			end
		end
	end)
end)

-- CLOSE PROMPT FUNCTION
----------------------------------------------------------------------------------------------------

function closePrompt()
    Wait(3000)
    prompt = false
end

-- CARRY PROP FUNCTION
----------------------------------------------------------------------------------------------------

function carryLadder()
    local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Hand")
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.0, 0.80, 0.20, 90.0, -90.0, 0.00, true, true, false, true, 1, true)
    carrying = true
    TaskPlayAnim(PlayerPedId(), "mech_carry_box", "idle", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
end

-- PLAY PICK ANIMATION FUNCTION
----------------------------------------------------------------------------------------------------

function playPickAnimation()
    local animation = "mech_pickup@plant@gold_currant"
    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), animation, "stn_long_low_skill_exit", 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
end

-- ADD PROP FUNCTION
----------------------------------------------------------------------------------------------------

function addLadder()
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    prop = CreateObject(GetHashKey(propModel), x, y, z,  true,  true, true)
end

-- DRAW 2D TEXT IN-GAME FUNCTION
----------------------------------------------------------------------------------------------------

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(w, h)
   SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
   SetTextCentre(centre)
   if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, x, y)
end

-- DRAW 3D TEXT IN-GAME FUNCTION
----------------------------------------------------------------------------------------------------

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.45, 0.45)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

function DrawText3DSM(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.25, 0.25)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end