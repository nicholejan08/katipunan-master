
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Ped = PlayerId()
        Citizen.InvokeNative(0x4CC5F2FC1332577F ,GetHashKey("HUD_CTX_IN_FAST_TRAVEL_MENU"))
		Citizen.InvokeNative(0xDF993EE5E90ABA25, PlayerPedId(), true)		
        Citizen.InvokeNative(0x4CC5F2FC1332577F , -2106452847)		
        Citizen.InvokeNative(0x8BC7C1F929D07BF3 , 100665617)	
        Citizen.InvokeNative(0x8BC7C1F929D07BF3 , -859384195)
        Citizen.InvokeNative(0x4CC5F2FC1332577F, 1058184710)
        Citizen.InvokeNative(0x4CC5F2FC1332577F, -66088566)
        if IsPlayerFreeAiming(Ped) and IsPedWeaponReadyToShoot(PlayerPed) then
            --Citizen.InvokeNative(0x90DA5BA5C2635416)
            --firstperson = Citizen.InvokeNative(0x90DA5BA5C2635416)                
            if firstperson ~= true then
                weapon, weponhash = GetCurrentPedWeapon(PlayerPed, true)
                isBow = GetHashKey("WEAPON_BOW")
                if weponhash ~= isBow then                
                    Citizen.InvokeNative(0x4CC5F2FC1332577F, 0xBB47198C)
                 
                end
            end
        end
    end
end)