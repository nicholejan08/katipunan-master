


local prop
local selectedProp, selectedBone, selectedAnimation, modelName = ""
local display, editing = false
local position = { x = 0.0, y = 0.0, z = 0.0 }
local rotation = { x = 0.0, y = 0.0, z = 0.0 }

TaskStandStill(PlayerPedId(), 0)

Citizen.CreateThread(function()
	while true do
		Wait(10)
		local rot = GetEntityRotation(prop, 1)
		local coord = GetEntityCoords(prop)
		local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(), 0))
		local ex, ey, ez = table.unpack(GetEntityCoords(prop, 0))

		if display then
			Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), 2, true)

			Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, px, py, pz-0.96, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.5, 3.5, 1.0, 255, 242, 0, 100, false, true, 2, false, false, false, false)

			-- gizmo
			
			for key, value in pairs(Config.settings) do
				Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, ex, ey, ez, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, value.gizmoSize, value.gizmoSize, 1.0, 255, 0, 0, 80, false, true, 2, false, false, false, false) -- Red
				Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, ex, ey, ez, 0.0, 0.0, 0.0, 0.0, 90.0, 0.0, value.gizmoSize, value.gizmoSize, 1.0, 0, 255, 0, 80, false, true, 2, false, false, false, false) -- Green
				Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, ex, ey, ez, 0.0, 0.0, 0.0, 0, 0.0, 0.0, value.gizmoSize, value.gizmoSize, 1.0, 0, 0, 255, 80, false, true, 2, false, false, false, false) -- Blue
			end

			-- heading

			DrawTxt("~COLOR_YELLOWSTRONG~EDIT MODE", 0.5, 0.05, 1.0, 1.0, true, 211, 222, 129, 200, true)
			DrawTxt("~COLOR_GREEN~Attached Bone: ~COLOR_WHITE~"..selectedBone, 0.4, 0.15, 0.4, 0.4, true, 211, 222, 129, 200, true)
			DrawTxt("~COLOR_YELLOWSTRONG~|", 0.5, 0.15, 0.4, 0.4, true, 211, 222, 129, 200, true)

			DrawTxt("~COLOR_GREEN~Selected Prop: ~COLOR_WHITE~"..selectedProp, 0.6, 0.15, 0.4, 0.4, true, 211, 222, 129, 200, true)

			DrawTxt("~COLOR_GREEN~Selected Animation: ~COLOR_WHITE~"..selectedAnimation, 0.5, 0.18, 0.4, 0.4, true, 211, 222, 129, 200, true)

			-- coords

			DrawTxt("~COLOR_BLUE~x: ~COLOR_WHITE~"..position.x.." ~COLOR_BLUE~y: ~COLOR_WHITE~"..position.y.." ~COLOR_BLUE~z: ~COLOR_WHITE~"..position.z, 0.5, 0.22, 0.6, 0.6, true, 211, 222, 129, 200, true)
			DrawTxt("~COLOR_BLUE~rotx: ~COLOR_WHITE~"..rotation.x.."~COLOR_BLUE~ roty: ~COLOR_WHITE~"..rotation.y.."~COLOR_BLUE~ rotz: ~COLOR_WHITE~"..rotation.z, 0.5, 0.25, 0.6, 0.6, true, 237, 240, 213, 200, true)

			-- instructions

			DrawTxt("[~COLOR_GOLD~Q~COLOR_YELLOWSTRONG~] [~COLOR_GOLD~E~COLOR_YELLOWSTRONG~]~COLOR_WHITE~ - LEFT & RIGHT", 0.35, 0.85, 0.6, 0.6, true, 211, 222, 129, 200, true)
			DrawTxt("~COLOR_YELLOWSTRONG~[~COLOR_GOLD~W~COLOR_YELLOWSTRONG~] [~COLOR_GOLD~S~COLOR_YELLOWSTRONG~]~COLOR_WHITE~ - FORWARD & BACKWARD", 0.35, 0.88, 0.6, 0.6, true, 211, 222, 129, 200, true)
			DrawTxt("[~COLOR_GOLD~A~COLOR_YELLOWSTRONG~] ~COLOR_WHITE~[~COLOR_GOLD~D~COLOR_YELLOWSTRONG~]~COLOR_WHITE~ - UP & DOWN", 0.35, 0.91, 0.6, 0.6, true, 211, 222, 129, 200, true)


			DrawTxt("~COLOR_WHITE~[~COLOR_GOLD~BACKSPACE~COLOR_WHITE~] - RESET", 0.35, 0.80, 0.6, 0.6, true, 211, 222, 129, 200, true)
			DrawTxt("~COLOR_WHITE~[~COLOR_GOLD~U~COLOR_WHITE~] - SHOW/HIDE UI", 0.55, 0.80, 0.6, 0.6, true, 211, 222, 129, 200, true)
			DrawTxt("~COLOR_WHITE~[~COLOR_GOLD~DEL~COLOR_WHITE~] - EXIT", 0.75, 0.80, 0.6, 0.6, true, 211, 222, 129, 200, true)

			DrawTxt("[~COLOR_BLUE~LEFT~COLOR_YELLOWSTRONG~] [~COLOR_BLUE~RIGHT~COLOR_YELLOWSTRONG~]~COLOR_WHITE~ - ROTATE ON BLUE AXIS", 0.70, 0.85, 0.6, 0.6, true, 211, 222, 129, 200, true)
			DrawTxt("~COLOR_YELLOWSTRONG~[~COLOR_RED~CTRL~COLOR_YELLOWSTRONG~]+~COLOR_YELLOWSTRONG~[~COLOR_RED~Q~COLOR_YELLOWSTRONG~] [~COLOR_RED~E~COLOR_YELLOWSTRONG~]~COLOR_WHITE~ - ROTATE ON RED AXIS", 0.70, 0.88, 0.6, 0.6, true, 211, 222, 129, 200, true)
			DrawTxt("[~COLOR_GREEN~UP~COLOR_YELLOWSTRONG~]~COLOR_YELLOWSTRONG~ [~COLOR_GREEN~DOWN~COLOR_YELLOWSTRONG~]~COLOR_WHITE~ - ROTATE ON GREEN AXIS", 0.70, 0.91, 0.6, 0.6, true, 211, 222, 129, 200, true)
		end		

		if editing then
			if IsControlJustPressed(0, 0x4AF4D473) then -- DEL
				editing = false
				display = false
				position = { x = 0.0, y = 0.0, z = 0.0 }
				rotation = { x = 0.0, y = 0.0, z = 0.0 }
				TaskStandStill(PlayerPedId(), 0)
				FreezeEntityPosition(PlayerPedId(), false)
				DeleteObject(prop)
				ClearPedTasks( PlayerPedId())
			end
	
			if IsControlJustPressed(0, 0x156F7119) then -- BACKSPACE
				rGizmoY = 20.0
				gGizmoY = 15.0
				redAxisY = 0
				greenAxisY = 0
				position = { x = 0.0, y = 0.0, z = 0.0 }
				rotation = { x = 0.0, y = 0.0, z = 0.0 }
				TaskStandStill(PlayerPedId(), -1)
				ClearPedTasks( PlayerPedId())
			end
			if display and IsControlJustPressed(0, 0xD8F73058) and not IsPedWalking(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and not IsPedOnMount(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedRagdoll(PlayerPedId()) then -- U
				display = false
				TaskStandStill(PlayerPedId(), 0)
				FreezeEntityPosition(PlayerPedId(), false)
				ClearPedTasks( PlayerPedId())
			elseif not display and IsControlJustPressed(0, 0xD8F73058) and not IsPedWalking(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and not IsPedOnMount(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedRagdoll(PlayerPedId()) then
				display = true
				TaskStandStill(PlayerPedId(), -1)
				-- ClearPedTasks( PlayerPedId())
				playAnimation()
			end
		end
	end
end)


function playAnimation()
	local animDict = ""
	local anim = ""

	for key, value in pairs(Config.settings) do
		animDict = value.animDict
		anim = value.anim
		selectedAnimation = anim
	end
	
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Wait(100)
    end

	print(animDict.." | "..anim)
    TaskPlayAnim(PlayerPedId(), animDict, anim, 1.0, -1.0, -1, 31, 0, true, 0, false, 0, false)
end

Citizen.CreateThread(function()
	while true do
		Wait(10)

		for key, value in pairs(Config.settings) do
			selectedBone = value.bone
		end		

		if editing then			
	
			while true do
				Wait(5)
				local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), selectedBone)

				AttachEntityToEntity(prop, PlayerPedId(), boneIndex, position.x, position.y, position.z, rotation.x, rotation.y, rotation.z, true, true, false, true, 1, true)
	
				if display and editing then
					if IsControlPressed(0, 0xDB096B85) and IsControlPressed(0, 0xDE794E3E) and rotation.y > 0 then -- CTRL + Q
						DrawTxt("~COLOR_BLACK~[CTRL]+[Q] - ROTATE ON RED AXIS", 0.70, 0.88, 0.6, 0.6, true, 211, 222, 129, 200, true)
						rotation.y = rotation.y - 1
					elseif IsControlPressed(0, 0xDB096B85) and IsControlPressed(0, 0xCEFD9220) and rotation.y < 360.0 then -- CTRL + E
						DrawTxt("~COLOR_BLACK~[CTRL]+[E] - ROTATE ON RED AXIS", 0.70, 0.88, 0.6, 0.6, true, 211, 222, 129, 200, true)
						rotation.y = rotation.y + 1
					elseif IsControlPressed(0, 0x6319DB71) and rotation.x < 360.0 and not IsControlPressed(0, 0xDB096B85) then -- DOWN
							DrawTxt("~COLOR_BLACK~[UP] [DOWN] - ROTATE ON GREEN AXIS", 0.70, 0.91, 0.6, 0.6, true, 211, 222, 129, 200, true)
							rotation.x = rotation.x + 1
					elseif IsControlPressed(0, 0x05CA7C52) and rotation.x > 0 then -- UP
							DrawTxt("~COLOR_BLACK~[UP] [DOWN] - ROTATE ON GREEN AXIS", 0.70, 0.91, 0.6, 0.6, true, 211, 222, 129, 200, true)
							rotation.x = rotation.x - 1
					elseif IsControlPressed(0, 0xDEB34313) and rotation.z < 360.0 then -- RIGHT
							DrawTxt("~COLOR_BLACK~[LEFT] [RIGHT] - ROTATE ON BLUE AXIS", 0.70, 0.85, 0.6, 0.6, true, 211, 222, 129, 200, true)
							rotation.z = rotation.z + 1
					elseif IsControlPressed(0, 0xA65EBAB4) and rotation.z > 0 then -- LEFT
							DrawTxt("~COLOR_BLACK~[LEFT] [RIGHT] - ROTATE ON BLUE AXIS", 0.70, 0.85, 0.6, 0.6, true, 211, 222, 129, 200, true)
							rotation.z = rotation.z - 1
	
	
					elseif IsControlPressed(0, 0xDE794E3E) then -- Q
							DrawTxt("~COLOR_BLACK~[Q] - LEFT & RIGHT", 0.35, 0.85, 0.6, 0.6, true, 211, 222, 129, 200, true)
							position.x = position.x + 0.005
					elseif IsControlPressed(0, 0xCEFD9220) then -- E
							DrawTxt("~COLOR_BLACK~[E] - LEFT & RIGHT", 0.35, 0.85, 0.6, 0.6, true, 211, 222, 129, 200, true)
							position.x = position.x - 0.005
					elseif IsControlPressed(0, 0xD27782E3) and position.y < 0.85 then -- S
							DrawTxt("~COLOR_BLACK~[W] [S] - FORWARD & BACKWARD", 0.35, 0.88, 0.6, 0.6, true, 211, 222, 129, 200, true)
							position.y = position.y + 0.005
					elseif IsControlPressed(0, 0x8FD015D8) and position.y > -0.85 then -- W
							DrawTxt("~COLOR_BLACK~[W] [S] - FORWARD & BACKWARD", 0.35, 0.88, 0.6, 0.6, true, 211, 222, 129, 200, true)
							position.y = position.y - 0.005
					elseif IsControlPressed(0, 0x7065027D) and position.z < 0.85 then -- A
							DrawTxt("~COLOR_BLACK~[A] [D] - UP & DOWN", 0.35, 0.91, 0.6, 0.6, true, 211, 222, 129, 200, true)
							position.z = position.z + 0.005
					elseif IsControlPressed(0, 0xB4E465B4) and position.z > -0.85 then -- D
							DrawTxt("~COLOR_BLACK~[A] [D] - UP & DOWN", 0.35, 0.91, 0.6, 0.6, true, 211, 222, 129, 200, true)
							position.z = position.z - 0.005
					elseif IsControlJustReleased(0, 0xC7B5340A) then -- ENTER
							print(position.x, position.y, position.z)
							print(rotation.x, rotation.y, rotation.z)
							break
					end
				end
			end
		end
	end
end)


RegisterNetEvent('nic_attach:startEditing')
AddEventHandler('nic_attach:startEditing', function()
	if not IsPedOnMount(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedOnVehicle(PlayerPedId(), true) and not IsPedHangingOnToVehicle(PlayerPedId()) and not IsPedInFlyingVehicle(PlayerPedId()) and not IsPedSittingInAnyVehicle(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) and not IsEntityDead(PlayerPedId()) and not IsPedInMeleeCombat(PlayerPedId()) then


		position = { x = 0.0, y = 0.0, z = 0.0 }
		rotation = { x = 0.0, y = 0.0, z = 0.0 }
		
		display = true
		editing = true

		for key, value in pairs(Config.settings) do
			modelName = value.propName
		end

		local coords = GetEntityCoords(PlayerPedId())
		
		selectedProp = modelName
		prop = CreateObject(GetHashKey(modelName), coords, true, true, true)

		playAnimation()
		TaskStandStill(PlayerPedId(), -1)
	end
end)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
     local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
     SetTextScale(w, h)
     SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
     SetTextCentre(centre)
     if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
     Citizen.InvokeNative(0xADA9255D, 10);
     DisplayText(str, x, y)
end