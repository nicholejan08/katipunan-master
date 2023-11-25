local infoOn = false   
local coordsText = ""   
local headingText = "" 
local modelText = "" 

local propName = ""
local kx, ky, kz = "", "", ""

Citizen.CreateThread(function()                
    while true do
        local ex, ey, ez = 0, 0, 0
        local pause = 250                                 
        if infoOn then                                    
            pause = 5                                      
            local player = GetPlayerPed(-1)                 
            if IsPlayerFreeAiming(PlayerId()) then         
                local entity = getEntity(PlayerId())
                local coords = GetEntityCoords(entity)
                local heading = GetEntityHeading(entity)    
                local model = GetEntityModel(entity)        
                coordsText = coords                         
                headingText = heading                       
                modelText = model
                ex, ey, ez = table.unpack(GetEntityCoords(entity, 0)) 
            end
            kx, ky, kz = ex, ey, ez
            local _text = (""..modelText)
            -- local _text = ("Coords: " .. coordsText .. "\nHeading: " .. headingText .. "\nHash: " .. modelText)
            DrawTxt(_text, 0.5, 0.1, 0.4, 0.4, true, 255, 255, 255, 255, false)
            DrawKey3D(kx, ky, kz+1.3, ""..modelText)
            propName = modelText
        end                                                
        Citizen.Wait(pause)                       
    end                                                    
end)

function getEntity(player)                                          
    local result, entity = GetEntityPlayerIsFreeAimingAt(player)    
    return entity                                                   
end                                                                


function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    
    SetTextScale(w, h)
    SetTextFontForCurrentCommand(1)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)

    if enableShadow then
        SetTextDropshadow(1, 0, 0, 0, 255)
    end

    DisplayText(str, x, y)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("feeds") then
        RequestStreamedTextureDict("feeds", false)
    else
        DrawSprite("feeds", "help_text_bg", x, y+0.013, 0.084, 0.037, 0.1, 0, 0, 0, 185, 0)
    end
end
    
function CreateVarString(p0, p1, variadic)
    return Citizen.InvokeNative(0xFA925AC00EB830B9, p0, p1, variadic, Citizen.ResultAsLong())
end

ToggleInfos = function()              
    infoOn = not infoOn               
end                                   

RegisterCommand("pg", function()     
    ToggleInfos()                      
end)     

function DrawKey3D(x, y, z, text)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(str,_x,_y-0.013)

    if not HasStreamedTextureDictLoaded("generic_textures") or not HasStreamedTextureDictLoaded("feeds") then
        RequestStreamedTextureDict("feeds", false)
    else
        DrawSprite("feeds", "help_text_bg", _x, _y, 0.054, 0.027, 0.1, 0, 0, 0, 185, 0)
    end
end