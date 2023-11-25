local isInZone = false 
local play = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        
        if IsPlayerNearCoords(-312.3, 799.01, 118.46) then
            if not play then 
                TriggerEvent("vorp:TipBottom", "Pindutin ang ~COLOR_BLUE~[SPACE]" .. " ~COLOR_WHITE~para mag Piano", 100)               
            end 
            if IsControlJustPressed(0, 0xD9D0E1C0) then
                play = true
                TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_PIANO'), -312.22 - 0.08, 799.01, 118.43 + 0.03, 102.37, 0, true, true, 0, true) 
            end
        end
        
        
        if IsPlayerNearCoords(1346.95, -1371.76, 80.49) then
            if not play then 
                TriggerEvent("vorp:TipBottom", "Pindutin ang ~COLOR_BLUE~[SPACE]" .. " ~COLOR_WHITE~para mag Piano", 100) 
            end
            if IsControlJustPressed(0, 0xD9D0E1C0) then
                play = true
                TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_PIANO'), 1346.87 - 0.08, -1371.09, 79.92 + 0.03, 351.35, 0, true, true, 0, true)

            end
        end

        -- if IsPlayerNearCoords(1346.95, -1371.76, 80.49) then
        --     if not play then 
        --         TriggerEvent("vorp:TipBottom", "Pulsa G/C para tocar el piano.", 100)
        --     end
        --     if IsControlJustPressed(0, 0x9959A6F0) then
        --         play = true
        --         TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_ABIGAIL_PIANO'), 1346.87 - 0.08, -1371.09, 79.92 + 0.03, 351.35, 0, true, true, 0, true)
                 
        --     end
        -- end

        -- if IsPlayerNearCoords(-312.3, 799.01, 118.46) then
        --     if not play then 
        --         TriggerEvent("vorp:TipBottom", "Pulsa G/C para tocar el piano.", 100)
        --     end 
        --     if IsControlJustPressed(0, 0x9959A6F0) then
        --         play = true
        --         TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_ABIGAIL_PIANO'), -312.22 - 0.08, 799.01, 118.43 + 0.03, 102.37, 0, true, true, 0, true) 
        --     end
        -- end

    end    
end)
    
Citizen.CreateThread(function()    
    while true do 
        Citizen.Wait(1)
        if play then

            TriggerEvent("vorp:TipBottom", "Pindutin ang ~e~[BACKSPACE]~q~ para ikansela", 100)
            if IsControlJustPressed(0, 0x156F7119) then
                play = false
                ClearPedTasks(GetPlayerPed())
                --SetCurrentPedWeapon(GetPlayerPed(), -1569615261, true)
            end    
        end
    end
end)

function IsPlayerNearCoords(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 3 then
        return true
    end
end

local Animation = {
	{
		['Text'] = "Kumatok",
		['hashAnim'] = "WORLD_HUMAN_KNOCK_DOOR",
	},
	
	{
		['Text'] = "Umihi",
		['hashAnim'] = "WORLD_HUMAN_PEE",
	},

	{
		['Text'] = "Umupo sa Sahig",
		['hashAnim'] = "WORLD_HUMAN_FIRE_SIT",
	},


	{
		['Text'] = "Magbantay",
		['hashAnim'] = "WORLD_HUMAN_BADASS",
	},

	{
		['Text'] = "Magsuka",
		['hashAnim'] = "WORLD_HUMAN_VOMIT",
	},

	{
		['Text'] = "Magsuka ng Todo",
		['hashAnim'] = "WORLD_HUMAN_VOMIT_KNEEL",
	},

	{
		['Text'] = "Maghugas ng Kamay",
		['hashAnim'] = "WORLD_HUMAN_WASH_FACE_BUCKET_GROUND",
	},

	{
		['Text'] = "Lumuhod",
		['hashAnim'] = "WORLD_PLAYER_DYNAMIC_KNEEL",
	},

	{
		['Text'] = "Maghintay",
		['hashAnim'] = "WORLD_HUMAN_WAITING_IMPATIENT",
	},

	
	{
		['Text'] = "Manood",
		['hashAnim'] = "WORLD_HUMAN_STAND_WAITING",
	},

	{
		['Text'] = "Mag-imbistiga",
		['hashAnim'] = "WORLD_HUMAN_CROUCH_INSPECT",
	},

	{
		['Text'] = "Mag-obserba",
		['hashAnim'] = "WORLD_HUMAN_INSPECT",
	},

	{
		['Text'] = "Tumambay",
		['hashAnim'] = "WORLD_HUMAN_STARE_STOIC",
	},

	{
		['Text'] = "Maglinis ng Baso",
		['hashAnim'] = "WORLD_HUMAN_BARTENDER_CLEAN_GLASS",
	},

	{
		['Text'] = "Sumandal 1",
		['hashAnim'] = "WORLD_HUMAN_SHOPKEEPER",
	},
	
	{
		['Text'] = "Sumandal 2",
		['hashAnim'] = "WORLD_HUMAN_SHOPKEEPER_CATALOG",
	},

	{
		['Text'] = "Mamaywang",
		['hashAnim'] = "WORLD_HUMAN_STERNGUY_IDLES",
	},

	{
		['Text'] = "Magsulat",
		['hashAnim'] = "WORLD_HUMAN_WRITE_NOTEBOOK",
	},
	
	{
		['Text'] = "Manigarilyo ng Tabako",
		['hashAnim'] = "WORLD_HUMAN_SMOKE_CIGAR",
	},
	
	{
		['Text'] = "Manigarilyo",
		['hashAnim'] = "WORLD_HUMAN_SMOKE_INTERACTION",
	},	
	
    {
        ['Text'] = "Humiga sa Sahig",
        ['hashAnim'] = "WORLD_CAMP_FIRE_SEATED_GROUND",
    },

    {
        ['Text'] = "Matulog sa Sahig 1",
        ['hashAnim'] = "WORLD_HUMAN_SLEEP_GROUND_PILLOW",
    },

    {
        ['Text'] = "Matulog sa Sahig 2",
        ['hashAnim'] = "WORLD_HUMAN_SLEEP_GROUND_ARM",
    },
	
	{
		['Text'] = "Umupo sa Sahig (F)",
		['hashAnim'] = "WORLD_CAMP_FIRE_SIT_GROUND_FEMALE_A",
	},
	
	{
		['Text'] = "Maglinis (F)",
		['hashAnim'] = "WORLD_HUMAN_BROOM_WORKING_FEMALE_B",
	},
	
	{
		['Text'] = "Mag inspeksyon (F)",
		['hashAnim'] = "WORLD_HUMAN_CROUCH_INSPECT_FEMALE_A",
	},
	
	{
		['Text'] = "Mag pakain ng feeds (F)",
		['hashAnim'] = "WORLD_HUMAN_FEED_CHICKENS_FEMALE_A",
	},
	
	{
		['Text'] = "Magbantay (F)",
		['hashAnim'] = "WORLD_HUMAN_GUARD_SCOUT_FEMALE_A",
	},
	
	{
		['Text'] = "Magsulat (F)",
		['hashAnim'] = "WORLD_HUMAN_WRITE_NOTEBOOK_FEMALE_A",
	},
	
	{
		['Text'] = "Matulog (F)",
		['hashAnim'] = "PROP_CAMP_SLEEP_PEW_COLD_FEMALE_B",
	},
	
	{
		['Text'] = "Kumain (F)",
		['hashAnim'] = "PROP_HUMAN_FOODPREP_STEW_RESTING_FEMALE_A",
	}

}

local Animationfille = {

{
	['TextF'] = "Maghilamos",
	['hashAnim'] = "WORLD_HUMAN_WASH_FACE_BUCKET_GROUND",
},


{
	['TextF'] = "Observar en cuclillas",
	['hashAnim'] = "WORLD_PLAYER_DYNAMIC_KNEEL",
},

{
	['TextF'] = "Impaciente",
	['hashAnim'] = "WORLD_HUMAN_WAITING_IMPATIENT",
},

{
	['TextF'] = "Esperar",
	['hashAnim'] = "WORLD_HUMAN_STAND_WAITING",
},


{
	['Text'] = "Limpiar un vaso",
	['hashAnim'] = "WORLD_HUMAN_BARTENDER_CLEAN_GLASS",
},

{
	['TextF'] = "Inspeccionar el suelo",
	['hashAnim'] = "WORLD_HUMAN_CROUCH_INSPECT",
},

{
	['TextF'] = "Inspeccionar",
	['hashAnim'] = "WORLD_HUMAN_INSPECT",
},

{
	['TextF'] = "Cruzar los brazos",
	['hashAnim'] = "WORLD_HUMAN_STARE_STOIC",
},


{
	['TextF'] = "Tomar notas en cuaderno",
	['hashAnim'] = "WORLD_HUMAN_WRITE_NOTEBOOK",
},

}



local Emote = {	
	{
		['Text'] = "Tumawa",
		['HashEmote'] = 0x11B0F575,
	},
	{
		['Text'] = "Bumati",
		['HashEmote'] = -339257980,
	},
	
	{
		['Text'] = "Sumuko",
		['HashEmote'] = 0xC303F8C3,
	},
	
	{
		['Text'] = "Humalik",
		['HashEmote'] = 1927505461,
	},
	
	{
		['Text'] = "Mag Angas",
		['HashEmote'] = 1879954891,
	},
	
	{
		['Text'] = "Maglista",
		['HashEmote'] = 0xBA51B111,
	},
	
	{
		['Text'] = "Sumakit ang Ulo",
		['HashEmote'] = 0xFB4C77D3,
	},
	
	{
		['Text'] = "Sumayaw",
		['HashEmote'] = 0x43F71CA8,
	},
	
	{
		['Text'] = "Manigarilyo",
		['HashEmote'] = 0x8B7F8EEB,
	},
	
	{
		['Text'] = "Magalak",
		['HashEmote'] = 0x0CF840A9,
	},
	
	{
		['Text'] = "Magpasunod",
		['HashEmote'] = 1115379199,
	},
	
	{
		['Text'] = "Magmakaawa",
		['HashEmote'] = 164860528,
	},
	
	{
		['Text'] = "Bumaril sa Kamay 1",
		['HashEmote'] = 1939251934,
	},
	
	{
		['Text'] = "Bumaril sa Kamay 2",
		['HashEmote'] = -1639456476,
	},
	

	{
        ['Text'] = "Pumalakpak",
        ['HashEmote'] = -221241824,
    },

    {
        ['Text'] = "Mag Disapruba",
        ['HashEmote'] = 1509171361,
    },

    {
        ['Text'] = "Magbanta",
        ['HashEmote'] = 1256841324,
    },



	{
		['Text'] = "Magsakitsakitan",
		['HashEmote'] = -110352861,
	},
	
	{
		['Text'] = "Mainis",
		['HashEmote'] = 796723886,
	},
	
	
	{
		['Text'] = "Magsaya",
		['HashEmote'] = -402959,
	},
	
	{
		['Text'] = "Mabahuan",
		['HashEmote'] = -166523388,
	},

	{
		['Text'] = "Aprubahan",
		['HashEmote'] = 425751659,
	},

	{
		['Text'] = "Dumura",
		['HashEmote'] = -2106738342,
	},

	-- {
		-- 	['Text'] = "LetsCraft",
		-- 	['HashEmote'] = -415456998,
		-- },
		
	-- {
	-- 	['Text'] = "PlaySomeCards",
	-- 	['HashEmote'] = -843470756,
	-- },
	
	{
		['Text'] = "Tumingin sa Malayo",
		['HashEmote'] = 935157006,
	},

	{
		['Text'] = "Tumuro sa Malayo",
		['HashEmote'] = 1593752891,
	},
	
	{
		['Text'] = "Magturo ng Direksyon",
		['HashEmote'] = 7918540,
	},
	
	{
		['Text'] = "Mangduro",
		['HashEmote'] = 486225122,
	},
	
	{
		['Text'] = "Magpapunta",
		['HashEmote'] = 474409519,
	},
	
	{
		['Text'] = "Mangisda",
		['HashEmote'] = 1159716480,
	},
	{
		['Text'] = "Magtapangtapangan",
		['HashEmote'] = -773960361,
	},
	
	{
		['Text'] = "Magplano ng Masama",
		['HashEmote'] = 589481092,
	},
	
	
	{
		['Text'] = "Magpahinto",
		['HashEmote'] = -1691237868,
	},
	
	{
		['Text'] = "Lumandi",
		['HashEmote'] = 831975651,
	},
	
	{
		['Text'] = "Kumaway",
		['HashEmote'] = 901097731,
	},
	
	{
		['Text'] = "Walng Anuman",
		['HashEmote'] = -2121881035,
	},
	
	{
		['Text'] = "Sumaludo sa Sumbrero",
		['HashEmote'] = -1457020913,
	},
	
	{
		['Text'] = "Magpasalamat",
		['HashEmote'] = -1801715172,
	},

	{
		['Text'] = "Nagagalak sa Kapwa",
		['HashEmote'] = 523585988,
	},
	
	{
		['Text'] = "Magbunyag",
		['HashEmote'] = -462132925,
	},

	{
		['Text'] = "Masaktan ang Damdamin",
		['HashEmote'] = 1802342943,
	},

	{
		['Text'] = "Maduwal",
		['HashEmote'] = -1118911493,
	},

	{
		['Text'] = "Tumawag ng Pasikreto",
		['HashEmote'] = -1644757697 ,
	},

	{
		['Text'] = "Sumang-Ayon",
		['HashEmote'] = -822629770,
	},

	{
		['Text'] = "Pagtawanan",
		['HashEmote'] = 803206066,
	},

	{
		['Text'] = "Tumanggi",
		['HashEmote'] = -653113914,
	},

	{
		['Text'] = "Pumalakpak ng Mabagal",
		['HashEmote'] = 1023735814,
	},
	
	{
		['Text'] = "Sino? Ako?",
		['HashEmote'] = 329631369,
	},
	
	{
		['Text'] = "Magdiwang",
		['HashEmote'] = 445839715 ,
	},

	{
		['Text'] = "Umiyak",
		['HashEmote'] = 81347960,
	},
	
	{
		['Text'] = "Mang Asar 1",
		['HashEmote'] = 246916594,
	},
	
	{
		['Text'] = "Mang Asar 2",
		['HashEmote'] = 1825177171,
	},
	
	{
		['Text'] = "Mag hamon",
		['HashEmote'] = 354512356,
	},

	{
		['Text'] = "Murahin",
		['HashEmote'] = 969312568,
	},

	{
		['Text'] = "Matyagan",
		['HashEmote'] = -553424129,
	},
	{
		['Text'] = "Mag Yabang",
		['HashEmote'] = 1533402397,
	},

	{
		['Text'] = "Magalit ng Todo",
		['HashEmote'] = 987239450,
	},

	{
		['Text'] = "Mang Angkin",
		['HashEmote'] = -1252070669,
	}

}

Citizen.CreateThread(function()
	
	local sexe =  IsPedMale(PlayerPedId())

	WarMenu.CreateMenu('Anim', 'Mga Aksyon')
	WarMenu.CreateSubMenu('Choix', 'Anim', 'Ekspresyon')
	WarMenu.CreateSubMenu('Select', 'Anim', 'Mga galaw')
	WarMenu.CreateSubMenu('Faire', 'Anim', 'Animationfille')
	--WarMenu.CreateSubMenu('Soin', 'Anim', 'Se Relever')
	-- WarMenu.CreateSubMenu('Brosse', 'Anim', 'Maglinis')
	


	while true do
		Citizen.Wait(0)
		if WarMenu.IsMenuOpened('Anim') then
			DisableControlAction(0, 0xAC4BD4F1, true) -- Disable wheel control
			if WarMenu.MenuButton('Mga Emosyon', 'Choix') then end
			if sexe == 1 then WarMenu.MenuButton('Mga galaw', 'Select') 
			else WarMenu.MenuButton('Animationfille', 'Faire') end
			if WarMenu.MenuButton('Se Relever', 'Soin')	then end
			if WarMenu.MenuButton('Maglinis', 'Brosse') then end
			
			WarMenu.Display()

			elseif WarMenu.IsMenuOpened('Choix') then
				DisableControlAction(0, 0xAC4BD4F1, true) -- Disable wheel control
				for i = 1, #Emote do
					if WarMenu.Button(Emote[i]['Text']) then
						ClearPedTasks(PlayerPedId()) 
						Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0,Emote[i]['HashEmote'], 1, 1, 0, 0)
					end					
				end
			WarMenu.Display()
			
			elseif WarMenu.IsMenuOpened('Select') then
				DisableControlAction(0, 0xAC4BD4F1, true) -- Disable wheel control
				if WarMenu.Button('Tumigil') then
					ClearPedTasks(PlayerPedId())
				end
				for j = 1, #Animation do
					if WarMenu.Button(Animation[j]['Text']) then
						TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(Animation[j]['hashAnim']), -1, true, false, false, false)
					end
				end
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('Faire') then
			DisableControlAction(0, 0xAC4BD4F1, true) -- Disable wheel control
			if WarMenu.Button('Stop') then
				ClearPedTasks(PlayerPedId())
			end
			for j = 1, #Animationfille do
				if WarMenu.Button(Animationfille[j]['Text']) then
					TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(Animation[j]['hashAnim']), -1, true, false, false, false)
				end
			end
			WarMenu.Display()
	
		elseif WarMenu.IsMenuOpened('Soin') then
			DisableControlAction(0, 0xAC4BD4F1, true) -- Disable wheel control
			if WarMenu.Button("Revive") then
				local closestPlayer, closestDistance = GetClosestPlayer()  
				local playerPed = GetPlayerPed(closestPlayer)
				if closestPlayer ~= -1 and closestDistance <= 3.0 then   
										
				   if GetEntityHealth(playerPed) >= 1 then 
					   
					 --  print(GetEntityHealth(playerPed))                                               
					   
				   --    TriggerServerEvent("sv_job:RevivePlayer", closestPlayer)
			   
					   --ReviveInjuredPed(PlayerPedId(playerPed))
				   
					   ResurrectPed(PlayerPedId(playerPed))

					   SetCamActive(gameplaycam, true)
					   DisplayHud(true)
					   DisplayRadar(true)
						 
					else 
					   TriggerEvent("redemrp_notification:start", "The player is not dead", 5, "error")  
				   end
			   else     
				   TriggerEvent("redemrp_notification:start", "There's no player near", 5, "error")       
			   end				
		   end
		WarMenu.Display()
		
	elseif WarMenu.IsMenuOpened('Brosse') then
		DisableControlAction(0, 0xAC4BD4F1, true) -- Disable wheel control
        if WarMenu.Button('Maglinis ng Kabayo') then
            local player = PlayerPedId()
            local currenthorse = GetMount(player)
            ClearPedEnvDirt(currenthorse)
            TaskDismountAnimal(player, 1, 0, 0, 0, 0)
            Wait(3000)
            local dict = "amb_work@world_human_horse_tend_brush_link@paired@male_a@idle_c"
            RequestAnimDict(dict)
            TaskPlayAnim(PlayerPedId(), dict, "idle_h", 1.0, 8.0, -1, 1, 0, false, false, false)
            Wait(10000)
            ClearPedTasks(PlayerPedId())

        elseif WarMenu.Button('Kanselahin') then
            local player = PlayerPedId()
            local player2 = PlayerPedId()
            local player3 = PlayerPedId()
            local player4 = PlayerPedId()
            ClearPedEnvDirt(player)
            ClearPedBloodDamage(player2)
            ClearPedWetness(player3)
            ClearPedDamageDecalByZone(player4)
            Wait(3000)
            ClearPedTasks(PlayerPedId())        
	 
	end
		WarMenu.Display()

	end	
	end
end)

Citizen.CreateThread(function()
	 while true do 
		 Citizen.Wait(0)

		 --if isInZone then 
			 if not WarMenu.IsAnyMenuOpened() and (IsControlPressed(0, 0x3076E97C) or IsControlPressed(0, 0x8BDE7443)) then 
				WarMenu.OpenMenu('Anim')
			 end
			 if IsControlPressed(0, 0xF84FA74F) and WarMenu.IsMenuOpened('Anim') then
				WarMenu.CloseMenu()				
			 end
		--isInZone = false 
		end
--	end
end)





function GetDistance3D(coords, coords2)
	return #(coords - coords2)
end

GetClosestPlayer = function(coords)
    local players         = GetPlayers()
    local closestDistance = 5
    local closestPlayer   = -1
    local coords          = coords
    local usePlayerPed    = false
    local playerPed       = PlayerPedId()
    local playerId        = PlayerId()


    if coords == nil then
        usePlayerPed = true
        coords       = GetEntityCoords(playerPed)
    end

    for i=1, #players, 1 do
        local target = GetPlayerPed(players[i])
      --  print(target)

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
            local targetCoords = GetEntityCoords(target)
            local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

            if closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
          --  print(i)
            table.insert(players, i)
        end
    end

    return players
end

Citizen.CreateThread(function() -- Hands up emote
    while true do
        Citizen.Wait(0)
        if (IsControlJustPressed(0, 0xF3830D8E))  then
			TriggerEvent("nic_prompt:handsup_off")
            local ped = PlayerPedId()
            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
    
                RequestAnimDict( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" )
    
                while ( not HasAnimDictLoaded( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" ) ) do 
                    Citizen.Wait( 100 )
                end
    
                if IsEntityPlayingAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3) then
                    ClearPedSecondaryTask(ped)
                else
					TaskPlayAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 8.0, -8.0, 120000, 31, 0, true, 0, false, 0, false)
					TriggerEvent("nic_prompt:handsup_on")
                end
            end
        end
    end
end)

Citizen.CreateThread(function() -- Point emote
    while true do
        Citizen.Wait(0)
        if (IsControlJustPressed(0, 0x4CC0E2FE))  then
			TriggerEvent("nic_prompt:handsup_off")
			TriggerEvent("nic_prompt:ragdoll_off")
            local ped = PlayerPedId()
            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
    
                RequestAnimDict( "mech_loco_m@generic@reaction@pointing@unarmed@stand" )
    
                while ( not HasAnimDictLoaded( "mech_loco_m@generic@reaction@pointing@unarmed@stand" ) ) do 
                    Citizen.Wait( 100 )
                end
    
                if IsEntityPlayingAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 3) then
                    ClearPedSecondaryTask(ped)
                else
                    TaskPlayAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 1.0, 8.0, 1500, 31, 0, true, 0, false, 0, false)
					TriggerEvent("nic_prompt:point_on")
					Citizen.Wait(1000)
					TriggerEvent("nic_prompt:point_off")
                end
            end
        end
    end
end)


-- Citizen.CreateThread(function() -- Point emote
--     while true do
--         Citizen.Wait(0)
--         if (IsControlJustPressed(0, 0x4CC0E2FE))  then
--             local ped = PlayerPedId()
--             if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
    
--                 RequestAnimDict( "mech_loco_m@generic@reaction@pointing@unarmed@stand" )
    
--                 while ( not HasAnimDictLoaded( "mech_loco_m@generic@reaction@pointing@unarmed@stand" ) ) do 
--                     Citizen.Wait( 100 )
--                 end
    
--                 if IsEntityPlayingAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 3) then
--                     ClearPedSecondaryTask(ped)
--                 else
--                     TaskPlayAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 1.0, 8.0, 1500, 31, 0, true, 0, false, 0, false)
--                 end
--             end
--         end
--     end
-- end)

-- Citizen.CreateThread(function() -- Iventory emote
--     while true do
--         Citizen.Wait(0)
--         if (IsControlJustPressed(0, 0xC1989F95))  then
--             local ped = PlayerPedId()
--             if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
    
--                 RequestAnimDict( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" )
    
--                 while ( not HasAnimDictLoaded( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" ) ) do 
--                     Citizen.Wait( 100 )
--                 end
    
--                 if IsEntityPlayingAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3) then
--                     ClearPedSecondaryTask(ped)
--                 else
--                     TaskPlayAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 8.0, -8.0, 120000, 31, 0, true, 0, false, 0, false)
--                 end
--             end
--         end
--     end
-- end)



Citizen.CreateThread(function()
        while true do
            Wait(0)
            if IsControlJustPressed(0, 0x156F7119) then
		    DisableControlAction(0, 0x156F7119, true) -- Disable Backspace control
			ClearPedTasks(PlayerPedId())
			FreezeEntityPosition(playerPed, false)
			TriggerEvent("nic_prompt:ragdoll_off")
			TriggerEvent("nic_prompt:point_off")
			TriggerEvent("nic_prompt:handsup_off")
			Citizen.Wait(5000)
			EnableControlAction(0, 0x156F7119, false) -- Enable- Backspace control
            end
        end 
 end)

 Citizen.CreateThread(function() -- Log emote
    while true do
        FreezeEntityPosition(playerPed, false)
        Citizen.Wait(0)
        if (IsControlJustPressed(0, 0xD8F73058))  then
            local ped = PlayerPedId()
            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
				print("Play Emote")
                RequestAnimDict( "mech_carry_ped@enters@idle" )
    
                while ( not HasAnimDictLoaded( "mech_carry_ped@enters@idle" ) ) do 
                    Citizen.Wait( 100 )
                end
    
                if IsEntityPlayingAnim(ped, "mech_carry_ped@enters@idle", "react_look_backright_enter", 3) then
                    ClearPedSecondaryTask(ped)
				else
					print("Play Emote")
                    TaskPlayAnim(ped, "mech_carry_ped@enters@idle", "point_fwd_0", 1.0, 8.0, 1500, 31, 0, true, 0, false, 0, false)
                end
            end
        end
    end
end)

--  Citizen.CreateThread(function()
-- 	while true do
-- 		Wait(0)
-- 		if IsControlJustPressed(0, 0x4AF4D473) then
-- 			ClearPedTasksImmediately(PlayerPedId())
-- 		end
-- 	end 
-- end)

 
-- TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_PIANO'), -312.22 - 0.08, 799.01, 118.43 + 0.03, 102.37, 0, true, true, 0, true) (PIANO)