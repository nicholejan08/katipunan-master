local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

VorpInv.RegisterUsableItem("canteen_100", function(data)
	VorpInv.subItem(data.source, "canteen_100", 1)
	VorpInv.addItem(data.source, "canteen_75", 1)
	TriggerClientEvent('popis:cutora_napit', data.source)
end)

VorpInv.RegisterUsableItem("canteen_75", function(data)
	VorpInv.subItem(data.source, "canteen_75", 1)
	VorpInv.addItem(data.source, "canteen_50", 1)
	TriggerClientEvent('popis:cutora_napit', data.source)
end)

VorpInv.RegisterUsableItem("canteen_50", function(data)
	VorpInv.subItem(data.source, "canteen_50", 1)
	VorpInv.addItem(data.source, "canteen_25", 1)
	TriggerClientEvent('popis:cutora_napit', data.source)
end)

VorpInv.RegisterUsableItem("canteen_25", function(data)
	VorpInv.subItem(data.source, "canteen_25", 1)
	VorpInv.addItem(data.source, "empty_canteen", 1)
	TriggerClientEvent('popis:cutora_napit', data.source)
end)

RegisterServerEvent("popis:cutora_check")
AddEventHandler("popis:cutora_check", function()
    local _source = source
    local count = VorpInv.getItemCount(_source, "empty_canteen")
    if count >= 1 then
        TriggerClientEvent("popis:cutora_naplneni", _source)
        VorpInv.subItem(_source, "empty_canteen", 1)
    else
        TriggerClientEvent("vorp:TipBottom", _source, 'You dont have Empty Canteen', 4000)
        TriggerClientEvent("popis:check_false", _source)
    end
end)

RegisterServerEvent("popis:kbelik_check")
AddEventHandler("popis:kbelik_check", function()
    local _source = source
    local count = VorpInv.getItemCount(_source, "empty_bucket")
    if count >= 1 then
        TriggerClientEvent("popis:kbelik_naplneni", _source)
        VorpInv.subItem(_source, "empty_bucket", 1)
    else
        TriggerClientEvent("vorp:TipBottom", _source, 'You dont have Empty Bucket', 4000)
        TriggerClientEvent("popis:check_false", _source)
    end
end)

RegisterServerEvent("popis:ryzovani_check")
AddEventHandler("popis:ryzovani_check", function()
    local _source = source
    local count = VorpInv.getItemCount(_source, "gold_pan")
    if count >= 1 then
        TriggerClientEvent("popis:ryzovani_zacatek", _source)
    else
        TriggerClientEvent("vorp:TipBottom", _source, 'You dont have Gold Pan', 4000)
        TriggerClientEvent("popis:check_false", _source)
    end
end)

RegisterServerEvent('popis:cutora_odmena')
AddEventHandler('popis:cutora_odmena', function()
	local _source = source
	VorpInv.addItem(_source, "canteen_100", 1)
	TriggerClientEvent("vorp:TipRight", _source, 'You filled the Canteen', 2000)
    TriggerClientEvent("popis:check_false", _source)
end)

RegisterServerEvent('popis:kbelik_odmena')
AddEventHandler('popis:kbelik_odmena', function()
	local _source = source
	VorpInv.addItem(_source, "bucket", 1)
	TriggerClientEvent("vorp:TipRight", _source, 'You filled the Bucket', 2000)
    TriggerClientEvent("popis:check_false", _source)
end)

RegisterServerEvent("popis:ryzovani_nasel")
AddEventHandler("popis:ryzovani_nasel", function()
    local _source = source
    local name = "golden_nugget"
    local count = math.random(2,6)
    TriggerEvent("vorpCore:canCarryItems", tonumber(_source), count, function(canCarry)
        TriggerEvent("vorpCore:canCarryItem", tonumber(_source), name, count, function(canCarry2)
            if canCarry and canCarry2 then
                VorpInv.addItem(_source, name, count)
                TriggerClientEvent("vorp:TipRight", _source, 'You found '..count.."x Golden Nugget", 4000)
            else
                TriggerClientEvent("vorp:TipRight", _source, "You have full inventory", 4000)
            end
        end)
    end)
end)
