
-- GLOBAL VARIABLES DECLARATION
----------------------------------------------------------------------------------------------------

local VorpCore = {}

-- GLOBAL IMPORTS
----------------------------------------------------------------------------------------------------

Inventory = exports.vorp_inventory:vorp_inventoryApi()
VORP = exports.vorp_core:vorpAPI()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

-- SERVER EVENTS
----------------------------------------------------------------------------------------------------

local fightInprogress = false

RegisterServerEvent('nic_fightclub:getName')
AddEventHandler('nic_fightclub:getName', function()
    local _source = source
    local User = VorpCore.getUser(_source)    
    local Character = User.getUsedCharacter

    TriggerEvent("vorp:getCharacter", source,function(user)
        TriggerClientEvent("nic_fightclub:setName", _source, Character.firstname, Character.lastname)
    end)
end)

RegisterServerEvent('nic_fightclub:checkMoney')
AddEventHandler('nic_fightclub:checkMoney', function(value)
    local bet = value
    local _source = source
    local User = VorpCore.getUser(_source)    
    local Character = User.getUsedCharacter
    u_money = Character.money

    if u_money > bet then
        TriggerClientEvent("nic_fightclub:enoughMoney", _source)
    else
        TriggerClientEvent("nic_fightclub:notEnoughMoney", _source)
    end
end)

RegisterServerEvent('nic_fightclub:checkJob')
AddEventHandler('nic_fightclub:checkJob', function()
    local _source = source
    TriggerEvent("vorp:getCharacter" ,source ,function(user)
        if user.job == 'fighter' then
            TriggerClientEvent('nic_fightclub:chooseDifficulty', _source)
        else
            TriggerClientEvent('nic_fightclub:notFighter', _source)
        end
    end)
end)

RegisterServerEvent('nic_fightclub:serverCheck')
AddEventHandler('nic_fightclub:serverCheck', function(value)
    local _source = source
    if not fightInprogress then
        TriggerClientEvent("nic_fightclub:triggerStart", _source)
    else
        TriggerClientEvent('nic_fightclub:fightStarted', _source)
    end
end)

RegisterServerEvent('nic_fightclub:pay')
AddEventHandler('nic_fightclub:pay', function(money)
    TriggerEvent("vorp:getCharacter",source,function(user)
        local _source = source
        VORP.addMoney(_source, 0, money)
	end)
end)

RegisterServerEvent('nic_fightclub:fightRefreshy')
AddEventHandler('nic_fightclub:fightRefresh', function()
    fightInprogress = false
end)


RegisterServerEvent('nic_fightclub:loseMoney')
AddEventHandler('nic_fightclub:loseMoney', function(value)
    local betVal = value
    local _source = source
    local User = VorpCore.getUser(_source)    
    local Character = User.getUsedCharacter

    TriggerEvent("vorp:getCharacter", source,function(user)
        Character.removeCurrency(0, betVal)
    end)
end)
