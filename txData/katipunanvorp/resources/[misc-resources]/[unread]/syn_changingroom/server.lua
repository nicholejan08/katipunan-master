-- Made by Blue

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterServerEvent("syn:getoutfits")
AddEventHandler("syn:getoutfits", function()
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier



    exports.ghmattimysql:execute('SELECT * FROM outfits WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)
        local playeroutfits = {}
        if result[1] ~= nil then 
            for i=1, #result, 1 do
            table.insert(playeroutfits, {
                title        = result[i].title,
                comps  = result[i].comps,
            })
            TriggerClientEvent("syn:listoutfits", _source, playeroutfits)
            end
        else
            playeroutfits = 0
            TriggerClientEvent("syn:listoutfits", _source, playeroutfits)

        end
    
    end)
end)

RegisterServerEvent("syn:setoutfit")
AddEventHandler("syn:setoutfit", function(jsonCloths)
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local compPlayer = jsonCloths

    local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid , ['compPlayer'] = compPlayer}

    exports.ghmattimysql:execute("UPDATE characters Set compPlayer=@compPlayer WHERE identifier=@identifier AND charidentifier = @charidentifier", Parameters)

end)


RegisterServerEvent("syn:getskin")
AddEventHandler("syn:getskin", function()
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier



    exports.ghmattimysql:execute('SELECT skinPlayer FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)
        local playeroutfits = {}
        if result[1] ~= nil then 
            
            skin        = result[1].skinPlayer

            TriggerClientEvent("syn:getskins", _source, skin)
            
        else
            skin = 0
            TriggerClientEvent("syn:getskins", _source, skin)

        end
    
    end)
end)
