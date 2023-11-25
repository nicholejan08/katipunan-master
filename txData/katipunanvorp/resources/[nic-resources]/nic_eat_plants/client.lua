local EatPrompt
local active = false
local eat = false
local amount = 0 
local cooldown = 0 
local oldBush
local pressed = false
local cVariance = ""

Citizen.CreateThread(function()
Wait(2000)
	while true do
		Wait(10)
		local player = PlayerPedId()
		local excludeEntity = player
		local coords = GetEntityCoords(player)
		local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 8.0, 8.0, 8.0, 0.0, 0.0, 0.0, true, 256, excludeEntity)
        local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
        excludeEntity = entityHit
		local model_hash = GetEntityModel(entityHit)
		local plantx, planty, plantz = table.unpack(GetEntityCoords(entityHit, 0))
		local carrying = Citizen.InvokeNative(0xA911EE21EDF69DAF, PlayerPedId())
		
		-- rdr_bush_lrg_aa_sim
		-- rdr_bush_ficus_aa_sim

		if model_hash == 477619010 then
			cVariance = "provision_wldflwr_chocolate_daisy"
		elseif model_hash == 477619010 then
			cVariance = "provision_wldflwr_bitterweed"
		else
			cVariance = "provision_wldflwr_wisteria"
		end

		if not IsPauseMenuActive() or not IsBigmapFull() then
			if not carrying and not IsPedInMeleeCombat(ped) then
				if (model_hash == 477619010 or model_hash == 85102137) and not eat and cooldown < 1 and not IsPedOnMount(player) and not IsPedInAnyVehicle(player) then

					if oldBush ~= entityHit then
						if IsPlayerNearEntity(plantx, planty, plantz, 8.0) then
							DrawGraphic3D(plantx, planty, plantz+1.0, 215)
						end
			
						if IsPlayerNearEntity(plantx, planty, plantz, 1.5) then
							DrawKey3D(plantx, planty, plantz+1.0, "E", "Eat Plant")
	
							if IsControlJustReleased(0, 0xCEFD9220) then -- enter
								pressed = true
								makeEntityFaceEntity(PlayerPedId(), entityHit)
							eating()
							TriggerEvent("nic_prompt:eat_off2")
								eat = true
								oldBush = entityHit
								goEat()
								active = false
								amount = amount +1
				
								if amount == 2 then
									TriggerEvent("nic_prompt:poison_on")
									Wait(5000)
									TriggerEvent("nic_prompt:poison_off")
								elseif amount == 3 then
									TriggerEvent("nic_prompt:poison_on")
									Wait(5000)
									TriggerEvent("nic_prompt:poison_off")
								elseif amount > 4 then
									local chance =  math.random(1,20)
									Wait(2300)
									if chance > 10 then
										startPoisone()							
										TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_VOMIT'), 10000, true, true, false, false)
										FreezeEntityPosition(playerPed, true)
										TriggerEvent("vorp:TipRight", "Nalason ka", 8000)
									end
									startCooldown()
								end
								active = false
							end
						end
					else
						if IsPlayerNearEntity(plantx, planty, plantz, 20.0) then
							DrawGraphic3D(plantx, planty, plantz+1.0, 50)
						end
					end		
				else	
					TriggerEvent("nic_prompt:eat_off")
					Citizen.Wait(500)
				end
			end
		end
	end
end)

function eating()
end

function goEat()
	Citizen.CreateThread(function()
		local playerPed2 = PlayerPedId()
		local hp = GetEntityHealth(playerPed2)
		Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)
		RequestAnimDict("mech_pickup@plant@berries")
		while not HasAnimDictLoaded("mech_pickup@plant@berries") do
			Wait(100)
		end		
		
		TaskPlayAnim(playerPed2, "mech_pickup@plant@berries", "enter_lf", 8.0, -1.0, -1, 1, 0, true, 0, false, 0, false)	
		Wait(800)
		TaskPlayAnim(playerPed2, "mech_pickup@plant@berries", "base", 8.0, -1.0, -1, 1, 0, true, 0, false, 0, false)
		Wait(2300)	
		TaskPlayAnim(playerPed2, "mech_pickup@plant@berries", "exit_eat", 8.0, -1.0, -1, 1, 0, true, 0, false, 0, false)	
		Wait(2500)
		ClearPedTasks(playerPed2)	
		PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
		TriggerEvent("nic_prompt:hunger_plus_on")
		TriggerEvent("vorpmetabolism:changeValue", "Hunger", 25)
		if GetEntityHealth(PlayerPedId()) <= 99 then
			SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId())+5, 1)
		end
		TriggerEvent("vorpmetabolism:changeValue", "InnerCoreHealth", 5)
		TriggerEvent("nic_prompt:eating_off")
		Wait(3000)
		TriggerEvent("nic_prompt:hunger_plus_off")
		eat = false
		pressed = false
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(60000)
		if amount > 0 then
			amount = amount - 1						
		end
	end
end)

function makeEntityFaceEntity(player, model)
    local p1 = GetEntityCoords(player, true)
    local p2 = GetEntityCoords(model, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(player, heading)
end

function startCooldown()
	cooldown = 10000
    if cooldown > 0 then
        Citizen.CreateThread(function()
            while cooldown > 0 do
                Wait(0)
                cooldown = cooldown - 1
            end
        end)
    end
end

-- 3D TEXT FUNCTION
----------------------------------------------------------------------------------------------------

function startPoisone()
local ojojo = 10
    if ojojo > 0 then
        Citizen.CreateThread(function()
            while ojojo > 0 do
				Wait(5000)
			   	local playerPed2 = PlayerPedId()
				local hp = GetEntityHealth(playerPed2)

				SetEntityHealth(playerPed2,hp-3)
				-- TriggerEvent("vorpmetabolism:changeValue", "Hunger", -100)
                ojojo = ojojo - 1
            end
        end)
    end
end

function IsPlayerNearEntity(x, y, z, radius)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < radius then
        return true
    end
end

function DrawGraphic3D(x, y, z, alpha)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())

    cVariance = "provision_wldflwr_chocolate_daisy"

    if not HasStreamedTextureDictLoaded("pm_collectors_bag_mp") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("pm_collectors_bag_mp", false)
        RequestStreamedTextureDict("generic_textures", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x, _y, 0.024, 0.04, 0.1, 215, 215, 215, alpha, 0)
        DrawSprite("generic_textures", "default_pedshot", _x, _y, 0.021, 0.035, 0.1, 215, 215, 215, 255, 0)
		DrawSprite("pm_collectors_bag_mp", cVariance, _x, _y, 0.015, 0.03, 0.1, 217, 232, 86, alpha, 0)
    end
end

function DrawKey3D(x, y, z, text, text2)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.28, 0.28)
    SetTextFontForCurrentCommand(1)
    SetTextColor(0, 0, 0, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x+0.017,_y-0.036)
    
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str2 = CreateVarString(10, "LITERAL_STRING", text2, Citizen.ResultAsLong())
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str2,_x+0.027,_y-0.038)

    if not HasStreamedTextureDictLoaded("menu_textures") or not HasStreamedTextureDictLoaded("overhead") or not HasStreamedTextureDictLoaded("generic_textures") then
        RequestStreamedTextureDict("generic_textures", false)
        RequestStreamedTextureDict("menu_textures", false)
        RequestStreamedTextureDict("overhead", false)
    else
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.017, _y-0.025, 0.017, 0.029, 0.1, 0, 0, 0, 255, 0)
        DrawSprite("generic_textures", "counter_bg_1b", _x+0.017, _y-0.025, 0.015, 0.027, 0.1, 215, 215, 215, 255, 0)
        DrawSprite("menu_textures", "crafting_highlight_br", _x+0.017, _y-0.002, 0.007, 0.012, 0.1, 215, 215, 215, 215, 0)
        -- DrawSprite("overhead", "overhead_normal", _x+0.016, _y-0.025, 0.014, 0.027, 0.1, 255, 255, 255, 185, 0)
    end
end