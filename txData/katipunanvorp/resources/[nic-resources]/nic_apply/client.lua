
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local prop
local holding = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        
    end
end)

-- EVENTS
----------------------------------------------------------------------------------------------------

RegisterNetEvent('nic_inspect:inspect')
AddEventHandler('nic_inspect:inspect', function(model, bone, animDict, animation, x, y, z, rotx, roty, rotz)
    TriggerServerEvent("nic_inspect:useItem")
    TriggerEvent("vorp_inventory:CloseInv")
    DeleteObject(prop, 1, 1)
    playStoreAnimation(model, bone, animDict, animation, x, y, z, rotx, roty, rotz)
end)

-- PLAY STORE ANIMATION FUNCTION
----------------------------------------------------------------------------------------------------
