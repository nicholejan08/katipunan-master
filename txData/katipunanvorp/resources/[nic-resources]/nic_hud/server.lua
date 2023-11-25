-- at the top of the server file
local VORPcore = {}

RegisterServerEvent('nic_hud:registerData')
AddEventHandler('nic_hud:registerData', function()
    local _source = source
    TriggerEvent("getCore", function(core)
        VORPcore = core
        local User = VORPcore.getUser(_source)
        local Character = User.getUsedCharacter 
        TriggerClientEvent('nic_hud:startResource', source, Character.charIdentifier, Character.job, Character.money)

    end)
end)

RegisterServerEvent('nic_hud:Initialize')
AddEventHandler('nic_hud:Initialize', function()
    local _source = source
    TriggerEvent("getCore", function(core)
        VORPcore = core

        local User = VORPcore.getUser(_source)
        local UserGroup = User.getGroup 
        local Character = User.getUsedCharacter

        TriggerClientEvent('nic_hud:getData', source, Character.charIdentifier, Character.job, Character.money)

    end)
end)