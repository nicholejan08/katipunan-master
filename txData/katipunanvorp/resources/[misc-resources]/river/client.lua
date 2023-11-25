local WaterTypes = {
    [1] =  {["name"] = "Sea of Coronado",       ["waterhash"] = -247856387, ["watertype"] = "lake"},
    [2] =  {["name"] = "San Luis River",        ["waterhash"] = -1504425495, ["watertype"] = "river"},
    [3] =  {["name"] = "Lake Don Julio",        ["waterhash"] = -1369817450, ["watertype"] = "lake"},
    [4] =  {["name"] = "Flat Iron Lake",        ["waterhash"] = -1356490953, ["watertype"] = "lake"},
    [5] =  {["name"] = "Upper Montana River",   ["waterhash"] = -1781130443, ["watertype"] = "river"},
    [6] =  {["name"] = "Owanjila",              ["waterhash"] = -1300497193, ["watertype"] = "river"},
    [7] =  {["name"] = "HawkEye Creek",         ["waterhash"] = -1276586360, ["watertype"] = "river"},
    [8] =  {["name"] = "Little Creek River",    ["waterhash"] = -1410384421, ["watertype"] = "river"},
    [9] =  {["name"] = "Dakota River",          ["waterhash"] = 370072007, ["watertype"] = "river"},
    [10] =  {["name"] = "Beartooth Beck",       ["waterhash"] = 650214731, ["watertype"] = "river"},
    [11] =  {["name"] = "Cattail Pond",         ["waterhash"] = -804804953, ["watertype"] = "lake"},
    [12] =  {["name"] = "Moonstone Pond",       ["waterhash"] = -811730579, ["watertype"] = "lake"},
    [13] =  {["name"] = "Roanoke Valley",       ["waterhash"] = -1229593481, ["watertype"] = "river"},
    [14] =  {["name"] = "Elysian Pool",         ["waterhash"] = -105598602, ["watertype"] = "lake"},
    [15] =  {["name"] = "Heartland Overflow",   ["waterhash"] = 1755369577, ["watertype"] = "swamp"},
    [16] =  {["name"] = "Lagras",               ["waterhash"] = -557290573, ["watertype"] = "swamp"},
    [17] =  {["name"] = "Lannahechee River",    ["waterhash"] = -2040708515, ["watertype"] = "river"},
    [18] =  {["name"] = "Dakota River",         ["waterhash"] = 370072007, ["watertype"] = "river"},
    [19] =  {["name"] = "Random1",              ["waterhash"] = 231313522, ["watertype"] = "river"},
    [20] =  {["name"] = "Random2",              ["waterhash"] = 2005774838, ["watertype"] = "river"},
    [21] =  {["name"] = "Random3",              ["waterhash"] = -1287619521, ["watertype"] = "river"},
    [22] =  {["name"] = "Random4",              ["waterhash"] = -1308233316, ["watertype"] = "river"},
    [23] =  {["name"] = "Random5",              ["waterhash"] = -196675805, ["watertype"] = "river"},
}

-- This is for Panning

local RyzeVoda = {
    [1] =  {["name"] = "Deadboot Creek",       ["waterhash"] = 1245451421, ["watertype"] = "river"},
    [2] =  {["name"] = "Spider Gorge",         ["waterhash"] = -218679770, ["watertype"] = "river"},
    [3] =  {["name"] = "O'Creagh's Run",       ["waterhash"] = -1817904483, ["watertype"] = "lake"},
    [4] =  {["name"] = "Cotorra Springs",      ["waterhash"] = 1175365009, ["watertype"] = "pond"},
    [5] =  {["name"] = "Lake Isabella",        ["waterhash"] = 592454541, ["watertype"] = "lake"},
}

local sekund = 9 -- Number of seconds when the prompts will show up if player is in water.
local cislo = 0
local buttons_prompt = GetRandomIntInRange(0, 0xffffff)
local buttons_prompt1 = GetRandomIntInRange(0, 0xffffff)
local buttons_prompt2 = GetRandomIntInRange(0, 0xffffff)

function Button_Prompt()
	Citizen.CreateThread(function()
        local str = "Wash"
        Omyt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(Omyt, 0x27D1C284)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(Omyt, str)
        PromptSetEnabled(Omyt, true)
        PromptSetVisible(Omyt, true)
        PromptSetHoldMode(Omyt, true)
        PromptSetGroup(Omyt, buttons_prompt)
        PromptRegisterEnd(Omyt)
	end)
	Citizen.CreateThread(function()
		local str = "Canteen"
		Cutora = Citizen.InvokeNative(0x04F97DE45A519419)
		PromptSetControlAction(Cutora, 0xA1ABB953)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(Cutora, str)
		PromptSetEnabled(Cutora, true)
		PromptSetVisible(Cutora, true)
		PromptSetHoldMode(Cutora, true)
		PromptSetGroup(Cutora, buttons_prompt)
		PromptRegisterEnd(Cutora)
	end)
	Citizen.CreateThread(function()
		local str = "Bucket"
		Kbelik = Citizen.InvokeNative(0x04F97DE45A519419)
		PromptSetControlAction(Kbelik, 0x0522B243)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(Kbelik, str)
		PromptSetEnabled(Kbelik, true)
		PromptSetVisible(Kbelik, true)
		PromptSetHoldMode(Kbelik, true)
		PromptSetGroup(Kbelik, buttons_prompt)
		PromptRegisterEnd(Kbelik)
	end)
    Citizen.CreateThread(function()
		local str = "Pan"
		Ryzovat = Citizen.InvokeNative(0x04F97DE45A519419)
		PromptSetControlAction(Ryzovat, 0xC7B5340A)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(Ryzovat, str)
		PromptSetEnabled(Ryzovat, true)
		PromptSetVisible(Ryzovat, true)
		PromptSetHoldMode(Ryzovat, true)
		PromptSetGroup(Ryzovat, buttons_prompt)
		PromptRegisterEnd(Ryzovat)
	end)
end

function Button_Prompt1()
	Citizen.CreateThread(function()
        local str = "Wash"
        Omyt1 = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(Omyt1, 0x27D1C284)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(Omyt1, str)
        PromptSetEnabled(Omyt1, true)
        PromptSetVisible(Omyt1, true)
        PromptSetHoldMode(Omyt1, true)
        PromptSetGroup(Omyt1, buttons_prompt1)
        PromptRegisterEnd(Omyt1)
	end)
	Citizen.CreateThread(function()
		local str = "Canteen"
		Cutora1 = Citizen.InvokeNative(0x04F97DE45A519419)
		PromptSetControlAction(Cutora1, 0xA1ABB953)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(Cutora1, str)
		PromptSetEnabled(Cutora1, true)
		PromptSetVisible(Cutora1, true)
		PromptSetHoldMode(Cutora1, true)
		PromptSetGroup(Cutora1, buttons_prompt1)
		PromptRegisterEnd(Cutora1)
	end)
	Citizen.CreateThread(function()
		local str = "Bucket"
		Kbelik1 = Citizen.InvokeNative(0x04F97DE45A519419)
		PromptSetControlAction(Kbelik1, 0x0522B243)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(Kbelik1, str)
		PromptSetEnabled(Kbelik1, true)
		PromptSetVisible(Kbelik1, true)
		PromptSetHoldMode(Kbelik1, true)
		PromptSetGroup(Kbelik1, buttons_prompt1)
		PromptRegisterEnd(Kbelik1)
	end)
end

local check = false


Citizen.CreateThread(function()
    Button_Prompt()
    Button_Prompt1()
	while true do
		Citizen.Wait(3)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local Water = Citizen.InvokeNative(0x5BA7A68A346A5A91,coords.x+3, coords.y+3, coords.z)
        for k,v in pairs(WaterTypes) do 
            if Water == WaterTypes[k]["waterhash"] then 
                if IsPedOnFoot(ped) then
                    if IsEntityInWater(ped) then
						if cislo >= sekund then
                            local item_name2 = CreateVarString(10, 'LITERAL_STRING', "River")
                            PromptSetActiveGroupThisFrame(buttons_prompt1, item_name2)
                            if not check then
                                if PromptHasHoldModeCompleted(Omyt1) then
                                    check = true
                                    cislo = -100
                                    StartWash("amb_misc@world_human_wash_face_bucket@ground@male_a@idle_d", "idle_l")
                                    Wait(5000)
                                    check = false
                                    cislo = 0
                                end
                                if PromptHasHoldModeCompleted(Cutora1) then
                                    check = true
                                    cislo = -100
                                    TriggerServerEvent("popis:cutora_check")
                                end
                                if PromptHasHoldModeCompleted(Kbelik1) then
                                    check = true
                                    cislo = -100
                                    TriggerServerEvent("popis:kbelik_check")
                                end
                            end
						else
							cislo = cislo + 1
							Wait(1000)
					    end
				    else
					    Wait(500)
						cislo = 0
                    end  
                end
            end
        end
        for k,v in pairs(RyzeVoda) do
            if Water == RyzeVoda[k]["waterhash"]  then 
                if IsPedOnFoot(ped) then
                    if IsEntityInWater(ped) then
						if cislo >= sekund then
                            local item_name = CreateVarString(10, 'LITERAL_STRING', "River")
                            PromptSetActiveGroupThisFrame(buttons_prompt, item_name)
                            if not check then
                                if PromptHasHoldModeCompleted(Omyt) then
                                    check = true
                                    cislo = -100
                                    StartWash("amb_misc@world_human_wash_face_bucket@ground@male_a@idle_d", "idle_l")
                                    Wait(5000)
                                    check = false
                                    cislo = 0
                                end
                                if PromptHasHoldModeCompleted(Cutora) then
                                    check = true
                                    cislo = -100
                                    TriggerServerEvent("popis:cutora_check")
                                end
                                if PromptHasHoldModeCompleted(Kbelik) then
                                    check = true
                                    cislo = -100
                                    TriggerServerEvent("popis:kbelik_check")
                                end
                                if PromptHasHoldModeCompleted(Ryzovat) then
                                    check = true
                                    cislo = -100
                                    TriggerServerEvent("popis:ryzovani_check")
                                end
                            end
						else
							cislo = cislo + 1
							Wait(1000)
					    end
				    else
					Wait(500)
					cislo = 0
                    end  
                end
            end
        end
    end
end)

RegisterNetEvent("popis:check_false")
AddEventHandler("popis:check_false", function()
    check = false
    cislo = 0
end)

RegisterNetEvent("popis:cutora_naplneni")
AddEventHandler('popis:cutora_naplneni', function()
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 8000, true, false, false, false)
    exports['progressBars']:startUI(8000, "You are filling Canteen...")
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent("popis:cutora_odmena")
    check = false
    cislo = 0
end)

RegisterNetEvent("popis:kbelik_naplneni")
AddEventHandler('popis:kbelik_naplneni', function()
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 8000, true, false, false, false)
    exports['progressBars']:startUI(8000, "You are filling Bucket...")
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent("popis:kbelik_odmena")
    check = false
    cislo = 0
end)

RegisterNetEvent("popis:ryzovani_zacatek")
AddEventHandler("popis:ryzovani_zacatek", function()
    local ped = PlayerPedId()
    CrouchAnimAndAttach()
    Wait(5000)
    GoldShake()
    exports['progressBars']:startUI(40000, "You are Panning...")
    local rnd = math.random(1,10)
    print(rnd)
    if rnd <= 2 then
        TriggerServerEvent("popis:ryzovani_nasel")
        local emoteType = 'KIT_EMOTE_ACTION_FIST_PUMP_1'
        local emoteclass = Action
        TaskEmote(PlayerPedId(), emoteClass, 2, GetHashKey(emoteType), true, true, true, true, true)
        Wait(3000)
        ClearPedTasks(PlayerPedId())
        DeleteObject(entity)
        check = false
        cislo = 0
    else
        RequestAnimDict("script_re@gold_panner@gold_success")
        while not HasAnimDictLoaded("script_re@gold_panner@gold_success") do
            Citizen.Wait(100)
        end
        TaskPlayAnim(PlayerPedId(), "script_re@gold_panner@gold_success", "agro_n_enter", 8.0, -8.0, -1, 25, 0, true, 0, false, 0, false)
        Wait(3000)
        ClearPedTasks(PlayerPedId())
        DeleteObject(entity)
        check = false
        cislo = 0
    end
end)



StartWash = function(dic, anim)
    LoadAnim(dic)
    TaskPlayAnim(PlayerPedId(), dic, anim, 1.0, 8.0, 5000, 0, 0.0, false, false, false)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
    Citizen.InvokeNative(0x6585D955A68452A5, PlayerPedId())
    Citizen.InvokeNative(0x9C720776DAA43E7E, PlayerPedId())
    Citizen.InvokeNative(0x8FE22675A5A45817, PlayerPedId())
end

LoadAnim = function(dic)
    RequestAnimDict(dic)

    while not (HasAnimDictLoaded(dic)) do
        Citizen.Wait(0)
    end
end

function CrouchAnimAndAttach()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_HAND")
    local modelHash = GetHashKey("P_CS_MININGPAN01X")
    LoadModel(modelHash)
    entity = CreateObject(modelHash, coords.x+0.3, coords.y,coords.z, true, false, false)
    SetEntityVisible(entity, true)
    SetEntityAlpha(entity, 255, false)
    Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
    SetModelAsNoLongerNeeded(modelHash)
    AttachEntityToEntity(entity,ped, boneIndex, 0.2, 0.0, -0.2, -100.0, -50.0, 0.0, false, false, false, true, 2, true)

    TaskPlayAnim(ped, dict, "inspectfloor_player", 1.0, 8.0, -1, 1, 0, false, false, false)
end

function GoldShake()
    local dict = "script_re@gold_panner@gold_success"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), dict, "SEARCH02", 1.0, 8.0, -1, 1, 0, false, false, false)
end


function LoadModel(model)
    local attempts = 0
    while attempts < 100 and not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
        attempts = attempts + 1
    end
    return IsModelValid(model)
end

RegisterNetEvent('popis:cutora_napit')
AddEventHandler('popis:cutora_napit', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local prop = CreateObject("p_cs_canteen_hercule", coords.x, coords.y, coords.z + 0.2, true, true, false, false, true)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Finger12")
    Citizen.InvokeNative(0xFCCC886EDE3C63EC, ped, 2, true)
    Citizen.Wait(0)
    RequestAnimDict("amb_rest_drunk@world_human_drinking@male_a@idle_a")
    while not HasAnimDictLoaded("amb_rest_drunk@world_human_drinking@male_a@idle_a") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb_rest_drunk@world_human_drinking@male_a@idle_a", "idle_a", 8.0, -8.0, 6000, 0, 0, true, 0, false, 0, false)
    AttachEntityToEntity(prop, PlayerPedId(), boneIndex, 0.02, 0.01, 0.05, 15.0, 175.0, 0.0, true, true, false, true, 1, true)
    TriggerEvent("vorp_inventory:CloseInv")
    Wait(6000)
    ClearPedSecondaryTask(ped)
    DeleteEntity(prop)
    TriggerEvent("fred_meta:consume", 0, 100, 0, 0, 0.0, 0.0, 0, 0.0, 0.0)
end)
