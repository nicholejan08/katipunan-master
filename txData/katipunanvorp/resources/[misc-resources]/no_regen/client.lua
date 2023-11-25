Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if GetEntityHealth(PlayerPedId()) >= 50 then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.05)
        else
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.01)
        end
    end
end)