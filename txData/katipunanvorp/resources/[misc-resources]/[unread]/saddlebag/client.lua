RegisterNetEvent('bagon')
AddEventHandler('bagon', function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xDF631E4BCE1B1FC4, ped, 0x94504D26, true, true, true) -- REMOVE_SHOP_ITEM_FROM_PED_BY_CATEGORY / Remove Current SATCHEL
    if not bag then
        Citizen.InvokeNative(0x59BD177A1A48600A, ped, 0x94504D26) -- SET_COMPONENT_CATEROGY
        if IsPedMale(ped) then
            Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0xEA272E11, true, true, true) -- SET_PED_COMPONENT_ENABLED
        else
            Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, 0xFCAF241B, true, true, true) -- SET_PED_COMPONENT_ENABLED
        end
    end

    bag = not bag
end)