

Citizen.CreateThread(function() -- Lay Down emote
    while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped) -- ISPEDHOLDING
		local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)
		local pedtype = GetPedType(holding)
		local model = GetEntityModel(holding)
		entity = holding
		if (IsControlJustPressed(0, 0x4CC0E2FE))  then
            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
    
                RequestAnimDict( "mech_loco_m@generic@reaction@pointing@unarmed@stand" )
    
                while ( not HasAnimDictLoaded( "mech_loco_m@generic@reaction@pointing@unarmed@stand" ) ) do 
                    Citizen.Wait( 100 )
                end
    
                if IsEntityPlayingAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 3) then
					Citizen.Wait( 100 )
                    ClearPedSecondaryTask(ped)
                else
                    TaskPlayAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 1.0, 8.0, 1500, 31, 0, true, 0, false, 0, false)
					Citizen.Wait( 800 )
					DetachEntity(entity, 1, 1)
                end
            end
		end		
    end
end)