

local weatherActive = false
local windDirectionSave = 0.00
local windSpeedSave = 0.00
local weatherSave = ""

RegisterCommand('weather', function()
    TriggerEvent("nic_weather:setWeather")
end)

RegisterNetEvent('nic_weather:setWeather')
AddEventHandler('nic_weather:setWeather', function(weather)
    if not weatherActive then
        setWeather(weather)
        weatherActive = true
    else
        TriggerEvent("nic_weather:resetWeather")
    end
end)

RegisterNetEvent('nic_weather:resetWeather')
AddEventHandler('nic_weather:resetWeather', function(source)
    if weatherActive then
        weatherActive = false
        SetWindDirection(windDirectionSave)
        SetWindSpeed(windSpeedSave)
        Citizen.InvokeNative(0x80A398F16FFE3CC3)
        Citizen.InvokeNative(0x59174F1AFE095B5A, weatherSave, true, true, true, 1.0, false)
    end
    weatherActive = false
    weatherSave = ""
    windDirectionSave = 0.00
    windSpeedSave = 0.00
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if weatherActive then
            SetWindDirection(GetWindDirection())
            SetWindSpeed(GetWindSpeed())
        end
    end
end)

function setWeather(weather)
    local transition_time_in_seconds = 1.0
    local next_weather_type = weather
    local next_weather_type_hash = GetHashKey(next_weather_type)
    local windDirection = GetWindDirection()
    local windSpeed = GetWindSpeed()
    local currWeather = Citizen.InvokeNative(0x4BEB42AEBCA732E9)

    weatherSave = currWeather
    windDirectionSave = windDirection
    windSpeedSave = windSpeed
    
    Citizen.InvokeNative(0x80A398F16FFE3CC3)
    Citizen.InvokeNative(0x59174F1AFE095B5A, next_weather_type_hash, true, true, true, transition_time_in_seconds, false)
end