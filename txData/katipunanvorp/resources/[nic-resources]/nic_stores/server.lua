
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local VorpCore = {}

local redemrp = false
local price = 0

-- GLOBAL IMPORTS
----------------------------------------------------------------------------------------------------

Inventory = exports.vorp_inventory:vorp_inventoryApi()
VorpCore = exports.vorp_core:vorpAPI()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

TriggerEvent("getCore",function(core)
    VorpCore = core
end)


-- SERVER EVENTS
----------------------------------------------------------------------------------------------------

RegisterServerEvent("stores:openStoreMenu")
AddEventHandler("stores:openStoreMenu", function(src)
	local _source
	
	if not src then 
		_source = source
	else 
		_source = src
	end
	
	TriggerEvent("vorp:getCharacter", _source, function(user)
		local recipient = user.identifier
		
		exports.ghmattimysql:execute("SELECT * FROM telegrams WHERE recipient=@recipient ORDER BY id DESC", { ['@recipient'] = recipient }, function(result)
			TriggerClientEvent("stores:ReturnMessages", _source, result)
		end)
	end)
end)

-- ITEM TRIGGERS
----------------------------------------------------------------------------------------------------

RegisterServerEvent('nic_stores:useItem')
AddEventHandler('nic_stores:useItem', function(t, name, price)
    local _source = source
    local storeType = t
    local User = VorpCore.getUser(_source)    
    local Character = User.getUsedCharacter
    local ItemName = name
    local count = Inventory.getItemCount(_source, name) 
    local quantity = 1
    u_money = Character.money

    TriggerEvent("vorp:getCharacter", source,function(user)

        if u_money < price then
            TriggerClientEvent("nic_stores:nomoney", source)
            return
        else
            TriggerEvent("vorpCore:canCarryItems", tonumber(_source), quantity, function(canCarry) -- chek inv space
                if canCarry then
                    if storeType == "weapons" then
                        TriggerEvent("vorpCore:canCarryWeapons", tonumber(_source), 1, function(canCarry)
                            if canCarry then
                                local ammoList = {
                                    ["AMMO_REPEATER"] = 0
                                }
                                local compsList = {
                                    ["nothing"] = 0
                                }             
                                Character.removeCurrency(0, price)
                                Inventory.createWeapon(source, name, ammoList, compsList)
                                Inventory.giveWeapon(_source, name, 1)
                                TriggerClientEvent("nic_stores:playSound", _source)
                            else
                                TriggerClientEvent("nic_stores:itemfull", source)
                            end                                    
                        end)
                    else   
                        TriggerEvent("vorpCore:canCarryItem", tonumber(_source), ItemName, quantity, function(canCarry2) -- check item count
                            if canCarry2 then    
                                Character.removeCurrency(0, price)
                                Inventory.addItem(_source, name, 1)
                                TriggerClientEvent("nic_stores:playSound", _source)
                            else
                                TriggerClientEvent("nic_stores:itemfull", source)
                            end
                        end)     
                    end
                else
                    TriggerClientEvent("nic_stores:inventoryfull", source)
                end
            end)
        end        
    end)
end)
