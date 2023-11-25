RegisterNetEvent('vorp:PlayerForceRespawn')
AddEventHandler('vorp:PlayerForceRespawn', function()
  TriggerServerEvent('syn_death:delete')
end)