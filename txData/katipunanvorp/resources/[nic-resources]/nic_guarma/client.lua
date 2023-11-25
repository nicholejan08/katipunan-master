local guarmaWater = false
local num = 0

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()
      local coords = GetEntityCoords(ped)
      
      local zoneType = 10
        local currentDistrict = GetMapZoneAtCoords(coords, zoneType)

        if currentDistrict == -512529193 then            
            SetMinimapZone(1935063277)
            SetGuarmaWorldhorizonActive(true) 
            if not guarmaWater then
                num = 1
                guarmaWater = true
                toggleGuarmaWater(num)
            end
        else	 
            SetMinimapZone(-1868977180)
            SetGuarmaWorldhorizonActive(false)
            if guarmaWater then
                num = 0
                guarmaWater = false
                toggleGuarmaWater(num)
            end
        end
  end
end)

function toggleGuarmaWater(num)
    SetWorldWaterType(num)
end