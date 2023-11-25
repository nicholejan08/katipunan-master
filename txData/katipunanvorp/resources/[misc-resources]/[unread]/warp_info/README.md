# warp_info
Use an item and get a telegram about what it says as well as on screen notification
* for VORP
#
**HOW TO INSTALL:**

---------------------------
**You need the resource telegram for this to work. If you do not want to use the telegram function, go in the main_c.lua and change telegram = true to telegram = false**

STEP 1) add ensure warp_info into your server.cfg

STEP 2) add warp_info to resources folder

STEP 3) Run the SQL file given into your database, you can change the item names if you wish if you do this make sure to change the names found in main_s.lua as well.

*If you need help, join my discord, I run a RedM server that is in development and can provide support as well and future releases.*

Discord: https://discord.gg/kCeJ7tJPha

---------------------------

USAGE:

* Use the items from your inventory and you will recieve an on screen notification as well as a telegram. 
  * Note: only one telegram is saved per user so if you use multiple of an item you will loose other telegrams from yourself.

* Customize what the item will send to the user via telegram and on screen in the config.lua.
* You can change the item names, if you do this make sure to change the names in the main_s.lua.
* You can disable the telegram functionality if you comment out or remove it, this will result in the user having to write down the reciepe. 
* The telegram gives a rudimentary way for the user to refer back to a reciepe. (Telegram is sent by the user to themselves.)
* You can use any item you want and make it intricate like "rare" reciepes only come from graverobbing due to only finding the specific item there etc.

---------------------------

Changing item names in main_s.lua:

BEFORE: 
```
VorpInv.RegisterUsableItem("book1", function(data)

    VorpInv.subItem(data.source, "book1", 1)
    local Character = VorpCore.getUser(data.source).getUsedCharacter
    local sender1 = Character.firstname 
    local sender2 = Character.lastname
    TriggerClientEvent('warp_info:Vulture', data.source, sender1, sender2)
end)
```

AFTER:
```
VorpInv.RegisterUsableItem("newitemname", function(data)

    VorpInv.subItem(data.source, "newitemname", 1)
    local Character = VorpCore.getUser(data.source).getUsedCharacter
    local sender1 = Character.firstname 
    local sender2 = Character.lastname
    TriggerClientEvent('warp_info:Vulture', data.source, sender1, sender2)
end)
```
* "newitemname" should match whatever item you want to use from your database.


*KNOWN ISSUES:*

none


