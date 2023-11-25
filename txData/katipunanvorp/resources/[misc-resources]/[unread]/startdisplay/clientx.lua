--[[
██╗░░░██╗░█████╗░██╗░░░░░██████╗░███████╗  ░█████╗░░█████╗░██████╗░██╗███╗░░██╗░██████╗░
██║░░░██║██╔══██╗██║░░░░░██╔══██╗██╔════╝  ██╔══██╗██╔══██╗██╔══██╗██║████╗░██║██╔════╝░
╚██╗░██╔╝██║░░██║██║░░░░░██║░░██║█████╗░░  ██║░░╚═╝██║░░██║██║░░██║██║██╔██╗██║██║░░██╗░
░╚████╔╝░██║░░██║██║░░░░░██║░░██║██╔══╝░░  ██║░░██╗██║░░██║██║░░██║██║██║╚████║██║░░╚██╗
░░╚██╔╝░░╚█████╔╝███████╗██████╔╝███████╗  ╚█████╔╝╚█████╔╝██████╔╝██║██║░╚███║╚██████╔╝
░░░╚═╝░░░░╚════╝░╚══════╝╚═════╝░╚══════╝  ░╚════╝░░╚════╝░╚═════╝░╚═╝╚═╝░░╚══╝░╚═════╝░
]]--


AddEventHandler('onClientMapStart', function()
  Citizen.CreateThread(function()
    local display = true
    local startTime = GetGameTimer()
    local delay = 60000 -- ms

    TriggerEvent('Volde_startdisplay:display', true)

    while display do
      Citizen.Wait(1)
      if (GetTimeDifference(GetGameTimer(), startTime) > delay) then
        display = false
        TriggerEvent('Volde_startdisplay:display', false)
      end
      if IsControlJustReleased(0, 0xCEFD9220) then
        display = false
        TriggerEvent('Volde_startdisplay:display', false)
      end
    end
  end)
end)

RegisterNetEvent('Volde_startdisplay:display')
AddEventHandler('Volde_startdisplay:display', function(value)
  SendNUIMessage({
    type = "Volde_startdisplay",
    display = value
  })
end)