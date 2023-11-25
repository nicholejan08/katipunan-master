VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    VorpInv.RegisterUsableItem("saddlebag", function(data)
        local user = VorpCore.getUser(data.source).getUsedCharacter
        local skin = user.skin
        local comps = user.comps
        TriggerClientEvent("bagon", data.source)
        VorpInv.CloseInv(data.source)
    end)
end)