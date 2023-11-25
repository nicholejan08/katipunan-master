local hasLoaded = false


Citizen.CreateThread(function()
    Citizen.Wait(10000)
    if not hasLoaded then
        TriggerEvent("vorpcharacter:refreshPlayerSkin")
        print("^2I LOADED YOU!")
        ExecuteCommand('reloadcloths')
        hasLoaded = true

    else
        print("^1I COULDN'T FIND YOUR EXISTANCE")
    end 
    Citizen.Wait(0)
end)


