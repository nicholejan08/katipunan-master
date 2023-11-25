-- Made by Blue & Dungeon for Syn County RP
-- credits to malik & the creator of kcrp_boats_vorp
local campfire = 0 
local crafting = {

    --Food
	[1] = {
		['Text'] = "cooked meat", -- name of item to craft on list
		['SubText'] = "",
		['Desc'] = "",
		['Param'] = {
            ['Item'] = "meat", -- this always needs to be filled. crafting will always look for the first item.
            ['Item2'] = "fish", -- this can be left empty if you do not want to use a 2nd item
            ['Item3'] = "", -- this can be left empty if you do not want to use a 3nd item
            ['Count'] = 3, -- this needs to always be more than 1. it will determine how much to check for to allow crafting and how much of item 1 to remove
            ['Count2'] = 2, -- this has to be set to 0 if you do not want to use an item 2
            ['Count3'] = 0, -- this has to be set to 0 if you do not want to use an item 3
            ['Reward'] = "consumable_meat_greavy", -- result item 
            ['RewardCount'] = 1, -- how much of the result item do you want
		}
    },
    [2] = {
		['Text'] = "moonshine",
		['SubText'] = "",
		['Desc'] = "",
		['Param'] = {
            ['Item'] = "sugar",
            ['Item2'] = "",
            ['Item3'] = "",
            ['Count'] = 5,
            ['Count2'] = 0,
            ['Count3'] = 0,
            ['Reward'] = "moonshine",
            ['RewardCount'] = 2,
		}
    },
    [3] = {
		['Text'] = "cigarette",
		['SubText'] = "",
		['Desc'] = "",
		['Param'] = {
            ['Item'] = "tobacco",
            ['Item2'] = "rollingpaper",
            ['Item3'] = "cigarettefilter",
            ['Count'] = 5,
            ['Count2'] = 2,
            ['Count3'] = 2,
            ['Reward'] = "cigarette",
            ['RewardCount'] = 1,
		}
    },
    [4] = {
		['Text'] = "cigar",
		['SubText'] = "",
		['Desc'] = "",
		['Param'] = {
            ['Item'] = "tobacco",
            ['Item2'] = "rollingpaper",
            ['Item3'] = "cigarettefilter",
            ['Count'] = 7,
            ['Count2'] = 3,
            ['Count3'] = 0,
            ['Reward'] = "cigar",
            ['RewardCount'] = 1,
		}
    },
    --Items


    --Weapons
}
keys = {
    -- Letter E
    ["E"] = 0xCEFD9220,
}

function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

local keyopen = false

Citizen.CreateThread(function()
    WarMenu.CreateMenu('Craft', "Craft")
    WarMenu.SetSubTitle('Craft', 'Time to craft' )

    local _source = source
    while true do

        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(PlayerPedId())

        if WarMenu.IsMenuOpened('Craft') then
            if WarMenu.MenuButton('lets craft', "Craft") then
                OpenCraftMenu()
			end
            WarMenu.Display()
        end
        Citizen.Wait(0)
    end
end)

function OpenCraftMenu()
	WarMenu.OpenMenu('craftmenu')
end

Citizen.CreateThread( function()
	WarMenu.CreateMenu('craftmenu', 'Craft')
	repeat
		if WarMenu.IsMenuOpened('craftmenu') then
			for i = 1, #crafting do
				if WarMenu.Button(crafting[i]['Text'], crafting[i]['SubText'], crafting[i]['Desc']) then
					TriggerServerEvent('syn:craftingalg', crafting[i]['Param'])
					Citizen.Wait(500)
					WarMenu.CloseMenu()
				end
			end
			WarMenu.Display()
		end
		Citizen.Wait(0)
	until false
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        local player = PlayerPedId()
        local Coords = GetEntityCoords(player)
        local campfire = DoesObjectOfTypeExistAtCoords(Coords.x, Coords.y, Coords.z, 2.5, GetHashKey("p_campfire02x"), 0) -- prop required to interact
        if campfire ~= false then 
            TriggerEvent("vorp:TipBottom", "Press [E] to craft", 2000) 
            if whenKeyJustPressed(keys["E"]) then
                if keyopen == false then
                WarMenu.OpenMenu('Craft')
                else end
            end
        end
    end
end)


RegisterNetEvent("syn:crafting")
AddEventHandler("syn:crafting", function()
    local playerPed = PlayerPedId()
    
        TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 15000, true, false, false, false)
        exports['progressBars']:startUI(15000, "You're crafting...")
        Citizen.Wait(15000)

        keyopen = false
    
end)


-- if you are using maliks campfire you can comment out below function
