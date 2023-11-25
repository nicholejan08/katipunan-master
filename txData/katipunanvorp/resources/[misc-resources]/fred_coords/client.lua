

-- function DrawCoords()
--     if 1 == 1 then
--         local _source = source
--         local ent = GetPlayerPed(_source)
--         local pp = GetEntityCoords(ent)
--         local hd = GetEntityHeading(ent)
--         DrawTxt("x = ~COLOR_YELLOWSTRONG~" .. tonumber(string.format("%.2f", pp.x)) .. "~COLOR_WHITE~ y  ~COLOR_WHITE~= ~COLOR_YELLOWSTRONG~" .. tonumber(string.format("%.2f", pp.y)) .. "~COLOR_WHITE~ z = ~COLOR_YELLOWSTRONG~" .. tonumber(string.format("%.2f", pp.z)) .. "~COLOR_WHITE~ | H: ~COLOR_YELLOWSTRONG~" .. tonumber(string.format("%.2f", hd)), 0.70, 0.01, 0.8, 0.4, true, 255, 255, 255, 150, false)
--     end
-- end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    SetTextFontForCurrentCommand(1) -- Cambiar tipo de fuente: 1,2,3,...
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    DisplayText(str, x, y)
end

local showCoords = false

Citizen.CreateThread(function()
	while true do
		Wait(10)
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
        local pHeading = GetEntityHeading(PlayerPedId())

		if showCoords then
            DrawTxt("x: "..px, 0.5, 0.1, 0.4, 0.4, true, 255, 255, 255, 255, true)
            DrawTxt("y: "..py, 0.5, 0.15, 0.4, 0.4, true, 255, 255, 255, 255, true)
            DrawTxt("z: "..pz, 0.5, 0.2, 0.4, 0.4, true, 255, 255, 255, 255, true)
            DrawTxt("h: "..pHeading, 0.5, 0.25, 0.4, 0.4, true, 255, 255, 255, 255, true)
        end
	end
end)

RegisterCommand("coords",function()
    if not showCoords then
        showCoords = true
        print(showCoords)
    else
        showCoords = false
    end
end)

function DrawCoords3D(x, y, z, text, text2, text3, text4)    
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())

    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(text4,_x,_y+0.07)

    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(text3,_x,_y+0.05)

    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(text2,_x,_y+0.03)

    SetTextScale(0.37, 0.32)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextCentre(1)
    SetTextDropshadow(4, 4, 21, 22, 255)
    DisplayText(text,_x,_y+0.01)

    if not HasStreamedTextureDictLoaded("feeds") then
        RequestStreamedTextureDict("feeds", false)
    else
        DrawSprite("feeds", "help_text_bg", _x, _y+0.052, 0.098, 0.093, 0.1, 0, 0, 0, 200, 0)
    end
end