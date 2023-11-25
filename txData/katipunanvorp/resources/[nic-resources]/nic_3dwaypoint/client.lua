

local arrived = false
local waypointSet = false
local notify = false
local gCoords

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(5)
      local ped = PlayerPedId()

      if IsWaypointActive() then
        if arrived then
          print("NOTIFY")
          if not notify then
            TriggerEvent('vorp:ShowTopNotification', "Waypoint", "~t6~You have reached your Destination", 4000)
            Wait(4000)
            notify = true
          end
        end
      end
  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local wCoords = GetWaypointCoords()
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
        local x = wCoords.x
        local y = wCoords.y
        local z = wCoords.z
        local r, g, b, a = 0, 0, 0, 0

        if IsWaypointActive() then
          waypointSet = true
          gCoords = GetWaypointCoords()
          notify = false
        else
          waypointSet = false
        end

        for key, value in pairs(Config.settings) do
          r = value.r
          g = value.g
          b = value.b
          a = value.a
      end

        if waypointSet then

          if not arrived then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, x, y, 30.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2720.0, r, g, b, a, false, true, 2, false, false, false, false)
          else
            arrived = true
          end
        end

    end
end)

function IsEntityNearCoords(entity, coords, dist)
    local eCoords = GetEntityCoords(entity)
    local distance = GetDistanceBetweenCoords(eCoords, coords, true)

    if distance < dist then
        return true
    end
end