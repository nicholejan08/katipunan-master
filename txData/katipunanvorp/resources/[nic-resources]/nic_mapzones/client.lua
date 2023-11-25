

local guarmaWater = false
local num = 0

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(10)
      local x, y, z =  table.unpack(GetEntityCoords(PlayerPedId()))

      local ZoneTypeId = 10
        local current_district = Citizen.InvokeNative(0x43AD8FC02B429D33 ,x,y,z,ZoneTypeId)
        if current_district == -512529193 then            
            Citizen.InvokeNative(0xA657EC9DBC6CC900, 1935063277)
            Citizen.InvokeNative(0x74E2261D2A66849A, true) 
            if not guarmaWater then
                num = 1
                guarmaWater = true
                toggleGuarmaWater(num)
                TriggerEvent("nic_typhoon:setWeather")
            end
        else	 
            Citizen.InvokeNative(0xA657EC9DBC6CC900, -1868977180)
            Citizen.InvokeNative(0x74E2261D2A66849A, false)
            if guarmaWater then
                num = 0
                guarmaWater = false
                toggleGuarmaWater(num)
                TriggerEvent("nic_typhoon:resetWeather")
            end
        end
  end
end)

function toggleGuarmaWater(num)
    Citizen.InvokeNative(0xE8770EE02AEE45C2, num)
end