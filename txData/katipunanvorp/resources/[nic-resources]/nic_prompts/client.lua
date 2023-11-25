

RegisterNetEvent("nic_prompt:canteen_show")
AddEventHandler("nic_prompt:canteen_show",function()
        SendNUIMessage(
            {
                type = "canteen",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:canteen_hide")
AddEventHandler("nic_prompt:canteen_hide",function()
        SendNUIMessage(
            {
                type = "canteen",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:canteen_fadein")
AddEventHandler("nic_prompt:canteen_fadein",function()
        SendNUIMessage(
            {
                type = "canteen",
                display = "fadein"
            }
        )
    end
)

RegisterNetEvent("nic_prompt:canteen_fadeout")
AddEventHandler("nic_prompt:canteen_fadeout",function()
        SendNUIMessage(
            {
                type = "canteen",
                display = "fadeout"
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:canteen_drinking_show")
AddEventHandler("nic_prompt:canteen_drinking_show",function()
        SendNUIMessage(
            {
                type = "canteen_drinking",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:canteen_drinking_hide")
AddEventHandler("nic_prompt:canteen_drinking_hide",function()
        SendNUIMessage(
            {
                type = "canteen_drinking",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:canteen_drinking_fadein")
AddEventHandler("nic_prompt:canteen_drinking_fadein",function()
        SendNUIMessage(
            {
                type = "canteen_drinking",
                display = "fadein"
            }
        )
    end
)

RegisterNetEvent("nic_prompt:canteen_drinking_fadeout")
AddEventHandler("nic_prompt:canteen_drinking_fadeout",function()
        SendNUIMessage(
            {
                type = "canteen_drinking",
                display = "fadeout"
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:drink_on")
AddEventHandler(
    "nic_prompt:drink_on",
    function()
        SendNUIMessage(
            {
                type = "drink",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:drink_off")
AddEventHandler(
    "nic_prompt:drink_off",
    function()
        SendNUIMessage(
            {
                type = "drink",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:drink_fadein")
AddEventHandler(
    "nic_prompt:drink_fadein",
    function()
        SendNUIMessage(
            {
                type = "drink2",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:drink_fadeout")
AddEventHandler(
    "nic_prompt:drink_fadeout",
    function()
        SendNUIMessage(
            {
                type = "drink2",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:drinking_on")
AddEventHandler(
    "nic_prompt:drinking_on",
    function()
        SendNUIMessage(
            {
                type = "drinking",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:drinking_off")
AddEventHandler(
    "nic_prompt:drinking_off",
    function()
        SendNUIMessage(
            {
                type = "drinking",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:drinking_fadein")
AddEventHandler(
    "nic_prompt:drinking_fadein",
    function()
        SendNUIMessage(
            {
                type = "drinking",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:drinking_fadeout")
AddEventHandler(
    "nic_prompt:drinking_fadeout",
    function()
        SendNUIMessage(
            {
                type = "drinking",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:wash_on")
AddEventHandler(
    "nic_prompt:wash_on",
    function()
        SendNUIMessage(
            {
                type = "wash",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:wash_off")
AddEventHandler(
    "nic_prompt:wash_off",
    function()
        SendNUIMessage(
            {
                type = "wash",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:wash_fadein")
AddEventHandler(
    "nic_prompt:wash_fadein",
    function()
        SendNUIMessage(
            {
                type = "wash2",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:wash_fadeout")
AddEventHandler(
    "nic_prompt:wash_fadeout",
    function()
        SendNUIMessage(
            {
                type = "wash2",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:washing_on")
AddEventHandler(
    "nic_prompt:washing_on",
    function()
        SendNUIMessage(
            {
                type = "washing",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:washing_off")
AddEventHandler(
    "nic_prompt:washing_off",
    function()
        SendNUIMessage(
            {
                type = "washing",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:washing_fadein")
AddEventHandler(
    "nic_prompt:washing_fadein",
    function()
        SendNUIMessage(
            {
                type = "washing2",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:washing_fadeout")
AddEventHandler(
    "nic_prompt:washing_fadeout",
    function()
        SendNUIMessage(
            {
                type = "washing2",
                display = false
            }
        )
    end
)



--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_




RegisterNetEvent("nic_prompt:eat_on")
AddEventHandler(
    "nic_prompt:eat_on",
    function()
        SendNUIMessage(
            {
                type = "eat",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:eat_off")
AddEventHandler(
    "nic_prompt:eat_off",
    function()
        SendNUIMessage(
            {
                type = "eat",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:eat_off2")
AddEventHandler(
    "nic_prompt:eat_off2",
    function()
        SendNUIMessage(
            {
                type = "eat2",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:eating_on")
AddEventHandler(
    "nic_prompt:eating_on",
    function()
        SendNUIMessage(
            {
                type = "eating",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:eating_on3")
AddEventHandler(
    "nic_prompt:eating_on3",
    function()
        SendNUIMessage(
            {
                type = "eating3",
                display = true
            }
        )
    end
)


RegisterNetEvent("nic_prompt:eating_off")
AddEventHandler(
    "nic_prompt:eating_off",
    function()
        SendNUIMessage(
            {
                type = "eating",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:eating_off2")
AddEventHandler(
    "nic_prompt:eating_off2",
    function()
        SendNUIMessage(
            {
                type = "eating2",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:poster_on")
AddEventHandler(
    "nic_prompt:poster_on",
    function()
        SendNUIMessage(
            {
                type = "poster",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:poster_off")
AddEventHandler(
    "nic_prompt:poster_off",
    function()
        SendNUIMessage(
            {
                type = "poster",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:poster_butcher_on")
AddEventHandler(
    "nic_prompt:poster_butcher_on",
    function()
        SendNUIMessage(
            {
                type = "poster_butcher",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:poster_butcher_off")
AddEventHandler(
    "nic_prompt:poster_butcher_off",
    function()
        SendNUIMessage(
            {
                type = "poster_butcher",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:overlay_on")
AddEventHandler(
    "nic_prompt:overlay_on",
    function()
        SendNUIMessage(
            {
                type = "overlay",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:overlay_off")
AddEventHandler(
    "nic_prompt:overlay_off",
    function()
        SendNUIMessage(
            {
                type = "overlay",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:wolverine_overlay_on")
AddEventHandler(
    "nic_prompt:wolverine_overlay_on",
    function()
        SendNUIMessage(
            {
                type = "wolverine",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:wolverine_overlay_off")
AddEventHandler(
    "nic_prompt:wolverine_overlay_off",
    function()
        SendNUIMessage(
            {
                type = "wolverine",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:focus_overlay_on")
AddEventHandler(
    "nic_prompt:focus_overlay_on",
    function()
        SendNUIMessage(
            {
                type = "focus",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:focus_overlay_off")
AddEventHandler(
    "nic_prompt:focus_overlay_off",
    function()
        SendNUIMessage(
            {
                type = "focus",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:pym_overlay_on")
AddEventHandler(
    "nic_prompt:pym_overlay_on",
    function()
        SendNUIMessage(
            {
                type = "pym",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:pym_overlay_off")
AddEventHandler(
    "nic_prompt:pym_overlay_off",
    function()
        SendNUIMessage(
            {
                type = "pym",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:kill_fire_on")
AddEventHandler(
    "nic_prompt:kill_fire_on",
    function()
        SendNUIMessage(
            {
                type = "kill_fire",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:kill_fire_off")
AddEventHandler(
    "nic_prompt:kill_fire_off",
    function()
        SendNUIMessage(
            {
                type = "kill_fire",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:kill_fire_fadein")
AddEventHandler(
    "nic_prompt:kill_fire_fadein",
    function()
        SendNUIMessage(
            {
                type = "kill_fire2",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:kill_fire_fadeout")
AddEventHandler(
    "nic_prompt:kill_fire_fadeout",
    function()
        SendNUIMessage(
            {
                type = "kill_fire2",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:killing_fire_on")
AddEventHandler(
    "nic_prompt:killing_fire_on",
    function()
        SendNUIMessage(
            {
                type = "killing_fire",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:killing_fire_off")
AddEventHandler(
    "nic_prompt:killing_fire_off",
    function()
        SendNUIMessage(
            {
                type = "killing_fire",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:killing_fire_fadein")
AddEventHandler(
    "nic_prompt:killing_fire_fadein",
    function()
        SendNUIMessage(
            {
                type = "killing_fire2",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:killing_fire_fadeout")
AddEventHandler(
    "nic_prompt:killing_fire_fadeout",
    function()
        SendNUIMessage(
            {
                type = "killing_fire2",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:poison_on")
AddEventHandler(
    "nic_prompt:poison_on",
    function()
        SendNUIMessage(
            {
                type = "poison",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:poison_off")
AddEventHandler(
    "nic_prompt:poison_off",
    function()
        SendNUIMessage(
            {
                type = "poison",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:loot_on")
AddEventHandler(
    "nic_prompt:loot_on",
    function()
        SendNUIMessage(
            {
                type = "loot",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:loot_off")
AddEventHandler(
    "nic_prompt:loot_off",
    function()
        SendNUIMessage(
            {
                type = "loot",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

function playNotAllowedAudio()
    local is_frontend_sound_playing = false
    local frontend_soundset_ref = "Ledger_Sounds"
    local frontend_soundset_name =  "UNAFFORDABLE"

    if not is_frontend_sound_playing then           
        if frontend_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8,frontend_soundset_name, frontend_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5,frontend_soundset_name, frontend_soundset_ref, true, 0);  -- play sound frontend
        is_frontend_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F,frontend_soundset_name, frontend_soundset_ref)  -- stop audio
        is_frontend_sound_playing = false
    end
end

function playCooldownAudio()
    local is_frontend_sound_playing = false
    local frontend_soundset_ref = "Player_Core_Empty_Sounds"
    local frontend_soundset_name =  "DEADEYE"

    if not is_frontend_sound_playing then           
        if frontend_soundset_ref ~= 0 then
          Citizen.InvokeNative(0x0F2A2175734926D8,frontend_soundset_name, frontend_soundset_ref);   -- load sound frontend
        end    
        Citizen.InvokeNative(0x67C540AA08E4A6F5,frontend_soundset_name, frontend_soundset_ref, true, 0);  -- play sound frontend
        is_frontend_sound_playing = true
      else
        Citizen.InvokeNative(0x9D746964E0CF2C5F,frontend_soundset_name, frontend_soundset_ref)  -- stop audio
        is_frontend_sound_playing = false
    end
end

RegisterNetEvent("nic_prompt:existing_fire_on")
AddEventHandler(
    "nic_prompt:existing_fire_on",
    function()
        playNotAllowedAudio()
        SendNUIMessage(
            {
                type = "existing_fire",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:existing_fire_off")
AddEventHandler(
    "nic_prompt:existing_fire_off",
    function()
        SendNUIMessage(
            {
                type = "existing_fire",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:existing_fire_off2")
AddEventHandler(
    "nic_prompt:existing_fire_off2",
    function()
        SendNUIMessage(
            {
                type = "existing_fire2",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:hunger_plus_on")
AddEventHandler(
    "nic_prompt:hunger_plus_on",
    function()
        SendNUIMessage(
            {
                type = "hunger_plus",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:hunger_plus_off")
AddEventHandler(
    "nic_prompt:hunger_plus_off",
    function()
        SendNUIMessage(
            {
                type = "hunger_plus",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:mushroom_plus_on")
AddEventHandler(
    "nic_prompt:mushroom_plus_on",
    function()
        SendNUIMessage(
            {
                type = "mushroom_plus",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:mushroom_plus_off")
AddEventHandler(
    "nic_prompt:mushroom_plus_off",
    function()
        SendNUIMessage(
            {
                type = "mushroom_plus",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_




RegisterNetEvent("nic_prompt:thirst_plus_on")
AddEventHandler(
    "nic_prompt:thirst_plus_on",
    function()
        SendNUIMessage(
            {
                type = "thirst_plus",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:thirst_plus_off")
AddEventHandler(
    "nic_prompt:thirst_plus_off",
    function()
        SendNUIMessage(
            {
                type = "thirst_plus",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:safezone_on")
AddEventHandler(
    "nic_prompt:safezone_on",
    function()
        SendNUIMessage(
            {
                type = "safezone",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:safezone_off")
AddEventHandler(
    "nic_prompt:safezone_off",
    function()
        SendNUIMessage(
            {
                type = "safezone",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:buy_on")
AddEventHandler(
    "nic_prompt:buy_on",
    function()
        SendNUIMessage(
            {
                type = "buy",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:buy_off")
AddEventHandler(
    "nic_prompt:buy_off",
    function()
        SendNUIMessage(
            {
                type = "buy",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:ragdoll_on")
AddEventHandler(
    "nic_prompt:ragdoll_on",
    function()
        SendNUIMessage(
            {
                type = "ragdoll",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:ragdoll_off")
AddEventHandler(
    "nic_prompt:ragdoll_off",
    function()
        SendNUIMessage(
            {
                type = "ragdoll",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:point_on")
AddEventHandler(
    "nic_prompt:point_on",
    function()
        SendNUIMessage(
            {
                type = "point",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:point_off")
AddEventHandler(
    "nic_prompt:point_off",
    function()
        SendNUIMessage(
            {
                type = "point",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:handsup_on")
AddEventHandler(
    "nic_prompt:handsup_on",
    function()
        SendNUIMessage(
            {
                type = "handsup",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:handsup_off")
AddEventHandler(
    "nic_prompt:handsup_off",
    function()
        SendNUIMessage(
            {
                type = "handsup",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:bought_prompt_on")
AddEventHandler(
    "nic_prompt:bought_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "bought_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:bought_prompt_off")
AddEventHandler(
    "nic_prompt:bought_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "bought_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:control_on")
AddEventHandler(
    "nic_prompt:control_on",
    function()
        SendNUIMessage(
            {
                type = "control",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:control_off")
AddEventHandler(
    "nic_prompt:control_off",
    function()
        SendNUIMessage(
            {
                type = "control",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:theatre_on")
AddEventHandler(
    "nic_prompt:theatre_on",
    function()
        SendNUIMessage(
            {
                type = "theatre",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:theatre_off")
AddEventHandler(
    "nic_prompt:theatre_off",
    function()
        SendNUIMessage(
            {
                type = "theatre",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:armor_on")
AddEventHandler(
    "nic_prompt:armor_on",
    function()
        SendNUIMessage(
            {
                type = "armor",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:armor_off")
AddEventHandler(
    "nic_prompt:armor_off",
    function()
        SendNUIMessage(
            {
                type = "armor",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:emote_controls_on")
AddEventHandler(
    "nic_prompt:emote_controls_on",
    function()
        SendNUIMessage(
            {
                type = "emote_controls",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:emote_controls_off")
AddEventHandler(
    "nic_prompt:emote_controls_off",
    function()
        SendNUIMessage(
            {
                type = "emote_controls",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_




RegisterNetEvent("nic_prompt:quiapo_prompt_on")
AddEventHandler(
    "nic_prompt:quiapo_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "quiapo_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:quiapo_prompt_off")
AddEventHandler(
    "nic_prompt:quiapo_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "quiapo_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_




RegisterNetEvent("nic_prompt:talipapa_prompt_on")
AddEventHandler(
    "nic_prompt:talipapa_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "talipapa_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:talipapa_prompt_off")
AddEventHandler(
    "nic_prompt:talipapa_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "talipapa_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_




RegisterNetEvent("nic_prompt:binondo_prompt_on")
AddEventHandler(
    "nic_prompt:binondo_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "binondo_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:binondo_prompt_off")
AddEventHandler(
    "nic_prompt:binondo_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "binondo_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:baguio_prompt_on")
AddEventHandler(
    "nic_prompt:baguio_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "baguio_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:baguio_prompt_off")
AddEventHandler(
    "nic_prompt:baguio_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "baguio_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:typhoon_prompt_on")
AddEventHandler(
    "nic_prompt:typhoon_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "typhoon_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:typhoon_prompt_off")
AddEventHandler(
    "nic_prompt:typhoon_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "typhoon_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:pee_prompt_on")
AddEventHandler(
    "nic_prompt:pee_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "pee_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:pee_prompt_off")
AddEventHandler(
    "nic_prompt:pee_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "pee_prompt",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:pee_prompt_off2")
AddEventHandler(
    "nic_prompt:pee_prompt_off2",
    function()
        SendNUIMessage(
            {
                type = "pee_prompt2",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:peeing_prompt_on")
AddEventHandler(
    "nic_prompt:peeing_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "peeing_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:peeing_prompt_off")
AddEventHandler(
    "nic_prompt:peeing_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "peeing_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:pooping_prompt_on")
AddEventHandler(
    "nic_prompt:pooping_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "pooping_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:pooping_prompt_off")
AddEventHandler(
    "nic_prompt:pooping_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "pooping_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:harvest_on")
AddEventHandler(
    "nic_prompt:harvest_on",
    function()
        SendNUIMessage(
            {
                type = "harvest",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:harvest_off")
AddEventHandler(
    "nic_prompt:harvest_off",
    function()
        SendNUIMessage(
            {
                type = "harvest",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:harvest_on2")
AddEventHandler(
    "nic_prompt:harvest_on2",
    function()
        SendNUIMessage(
            {
                type = "harvest2",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:harvest_off2")
AddEventHandler(
    "nic_prompt:harvest_off2",
    function()
        SendNUIMessage(
            {
                type = "harvest2",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:harvesting_on")
AddEventHandler(
    "nic_prompt:harvesting_on",
    function()
        SendNUIMessage(
            {
                type = "harvesting",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:harvesting_off")
AddEventHandler(
    "nic_prompt:harvesting_off",
    function()
        SendNUIMessage(
            {
                type = "harvesting",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:harvesting_on2")
AddEventHandler(
    "nic_prompt:harvesting_on2",
    function()
        SendNUIMessage(
            {
                type = "harvesting2",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:harvesting_off2")
AddEventHandler(
    "nic_prompt:harvesting_off2",
    function()
        SendNUIMessage(
            {
                type = "harvesting2",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:tired_prompt_on")
AddEventHandler(
    "nic_prompt:tired_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "tired",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:tired_prompt_off")
AddEventHandler(
    "nic_prompt:tired_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "tired",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

RegisterNetEvent("nic_prompt:falls1_prompt_on")
AddEventHandler(
    "nic_prompt:falls1_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "falls1_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:falls1_prompt_off")
AddEventHandler(
    "nic_prompt:falls1_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "falls1_prompt",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

RegisterNetEvent("nic_prompt:falls2_prompt_on")
AddEventHandler(
    "nic_prompt:falls2_prompt_on",
    function()
        SendNUIMessage(
            {
                type = "falls2_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:falls2_prompt_off")
AddEventHandler(
    "nic_prompt:falls2_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "falls2_prompt",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:butcher_overlay_on")
AddEventHandler(
    "nic_prompt:butcher_overlay_on",
    function()
        SendNUIMessage(
            {
                type = "butcher_overlay",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:butcher_overlay_off")
AddEventHandler(
    "nic_prompt:butcher_overlay_off",
    function()
        SendNUIMessage(
            {
                type = "butcher_overlay",
                display = false
            }
        )
    end
)


RegisterNetEvent("nic_prompt:bounty_overlay_on")
AddEventHandler(
    "nic_prompt:bounty_overlay_on",
    function()
        SendNUIMessage(
            {
                type = "bounty_overlay",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:bounty_overlay_off")
AddEventHandler(
    "nic_prompt:bounty_overlay_off",
    function()
        SendNUIMessage(
            {
                type = "bounty_overlay",
                display = false
            }
        )
    end
)

--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_



RegisterNetEvent("nic_prompt:cooldown_prompt_on")
AddEventHandler(
    "nic_prompt:cooldown_prompt_on",
    function()
        playCooldownAudio()
        SendNUIMessage(
            {
                type = "cooldown_prompt",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:cooldown_prompt_off")
AddEventHandler(
    "nic_prompt:cooldown_prompt_off",
    function()
        SendNUIMessage(
            {
                type = "cooldown_prompt",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:bicol_overlay_on")
AddEventHandler(
    "nic_prompt:bicol_overlay_on",
    function()
        SendNUIMessage(
            {
                type = "bicol_overlay",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:bicol_overlay_off")
AddEventHandler(
    "nic_prompt:bicol_overlay_off",
    function()
        SendNUIMessage(
            {
                type = "bicol_overlay",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_




RegisterNetEvent("nic_prompt:chop_on")
AddEventHandler(
    "nic_prompt:chop_on",
    function()
        SendNUIMessage(
            {
                type = "chop",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:chop_off")
AddEventHandler(
    "nic_prompt:chop_off",
    function()
        SendNUIMessage(
            {
                type = "chop",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:chop_off2")
AddEventHandler(
    "nic_prompt:chop_off2",
    function()
        SendNUIMessage(
            {
                type = "chop2",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:chopping_on")
AddEventHandler(
    "nic_prompt:chopping_on",
    function()
        SendNUIMessage(
            {
                type = "chopping",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:chopping_on3")
AddEventHandler(
    "nic_prompt:chopping_on3",
    function()
        SendNUIMessage(
            {
                type = "chopping3",
                display = true
            }
        )
    end
)


RegisterNetEvent("nic_prompt:chopping_off")
AddEventHandler(
    "nic_prompt:chopping_off",
    function()
        SendNUIMessage(
            {
                type = "chopping",
                display = false
            }
        )
    end
)

RegisterNetEvent("nic_prompt:chopping_off2")
AddEventHandler(
    "nic_prompt:chopping_off2",
    function()
        SendNUIMessage(
            {
                type = "chopping2",
                display = false
            }
        )
    end
)



--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_


RegisterNetEvent("nic_prompt:store_on")
AddEventHandler(
    "nic_prompt:store_on",
    function()
        SendNUIMessage(
            {
                type = "store_on",
                display = true
            }
        )
    end
)

RegisterNetEvent("nic_prompt:store_off")
AddEventHandler(
    "nic_prompt:store_off",
    function()
        SendNUIMessage(
            {
                type = "store_off",
                display = false
            }
        )
    end
)


--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

