local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Inventory = exports.vorp_inventory:vorp_inventoryApi()