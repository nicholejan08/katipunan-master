local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()


VorpInv.RegisterUsableItem("book1", function(data) --change item name here "book1" to "youritemname"

    VorpInv.subItem(data.source, "book1", 1) --change item name here "book1" to "youritemname"
    local Character = VorpCore.getUser(data.source).getUsedCharacter
    local sender1 = Character.firstname 
    local sender2 = Character.lastname
    TriggerClientEvent('warp_info:Vulture', data.source, sender1, sender2)
end)

VorpInv.RegisterUsableItem("book2", function(data)

    VorpInv.subItem(data.source, "book2", 1)
    local Character = VorpCore.getUser(data.source).getUsedCharacter
    local sender1 = Character.firstname 
    local sender2 = Character.lastname
    TriggerClientEvent('warp_info:Vulture2', data.source, sender1, sender2)
end)


VorpInv.RegisterUsableItem("book3", function(data)

    VorpInv.subItem(data.source, "book3", 1)
    local Character = VorpCore.getUser(data.source).getUsedCharacter
    local sender1 = Character.firstname 
    local sender2 = Character.lastname
    TriggerClientEvent('warp_info:Vulture3', data.source, sender1, sender2)
end)

