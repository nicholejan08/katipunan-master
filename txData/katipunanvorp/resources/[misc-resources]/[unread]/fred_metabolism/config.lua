Config = {

    ["MSG"] = "Kumonsumo ka ng ", -- Message to display when consumed
    
    -- INITIAL VALUES
    ["InitialFood"] = 100, -- INITIAL FOOD -- MAX VALUE 100%
    ["InitialWater"] = 100, -- INITIAL FOOD -- MAX VALUE 100%
    
    -- TICK: This is the time (rate) it takes to excecute every check 
    -- For e.g: 2 food is drain per tick
    ["Tick"] = 20000, -- 1000 = 1 second; 20000 = 20 seconds; 3600 = 3,5 seconds
    
    -- DRAINS PER TICK
    ["FoodDrainIdle"] = 0.5, -- Food drop rate on stand by
    ["FoodDrainRunning"] = 2, -- Food drop rate while running
    ["FoodDrainWalking"] = 0.5, -- Food drop rate while walking
    ["WaterDrainIdle"] = 0.5, -- Water drop rate on stand by
    ["WaterDrainRunning"] = 3, -- Water drop rate while running
    ["WaterDrainWalking"] = 1, -- Water drio rate while walking
    
    -- HEALTH LOSS STRIPE
    ["HealthLoss"] = 15, -- Health you lose per tick
    ["FoodStripe"] = 20, -- Food stripe that determines when you start to lose health
    ["WaterStripe"] = 20, -- Water stripe that determines when you start to lose health
    
    -- TEMPERATURE DEBUFF STRIPE
    ["MinTemperature"] = -20, -- -20°C From this temperature below, you'll lose more food and water
    ["MaxTemperature"] = 20, -- 20°C From this temperature avobe, you'll lose more food and water
    
    -- FOOD AND WATER DROP RATE FROM TEMPERATURE
    ["WaterHotLoss"] = 3, -- Water drop rate increment for higher temperatures
    ["FoodColdLoss"] = 3, -- Food drop rate increment for lower temperatures
    
    
    }
    
    
    -- JUST ADD YOUR ITEMS HERE WITH THE VALUES YOU WANT
    Config.ItemsToUse = {
    
        --
        -- FOOD
        --
        {
            ["Name"] = "consumable_tango", -- DB NAME
            ["DisplayName"] = "Tango", 
            ["Hunger"] = 5,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 10.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_pandesal", -- DB NAME
            ["DisplayName"] = "Pandesal", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "mushroom", -- DB NAME
            ["DisplayName"] = "Kabute", 
            ["Hunger"] = 50,
            ["Thirst"] = 50,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 50.0,
            ["OuterCoreStaminaGold"] = 50.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_keso_sm", -- DB NAME
            ["DisplayName"] = "Keso (Maliit)", 
            ["Hunger"] = 10,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_keso_ms", -- DB NAME
            ["DisplayName"] = "Keso (Kalahati)", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 100,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_keso_lg", -- DB NAME
            ["DisplayName"] = "Keso (Malaki)", 
            ["Hunger"] = 100,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 100,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_kidneybeans_can", -- DB NAME
            ["DisplayName"] = "De Lata", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_sardinas", -- DB NAME
            ["DisplayName"] = "Sardinas", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_peras", -- DB NAME
            ["DisplayName"] = "Peras", 
            ["Hunger"] = 30,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_spanishbread", -- DB NAME
            ["DisplayName"] = "Spanish Bread", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_monay", -- DB NAME
            ["DisplayName"] = "Monay", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_pandecoco", -- DB NAME
            ["DisplayName"] = "Pan de Coco", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_ensaymada", -- DB NAME
            ["DisplayName"] = "Ensaymada", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_hopia", -- DB NAME
            ["DisplayName"] = "Hopia", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_pan_de_manila", -- DB NAME
            ["DisplayName"] = "Pan de Manila", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_hamburger", -- DB NAME
            ["DisplayName"] = "Hamburger", 
            ["Hunger"] = 80,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_mansanas", -- DB NAME
            ["DisplayName"] = "Mansanas", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_saging", -- DB NAME
            ["DisplayName"] = "Saging", 
            ["Hunger"] = 50,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0.0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
    
        --
        -- DRINKS
        --
        {
            ["Name"] = "consumable_kape", -- DB NAME
            ["DisplayName"] = "Kape", 
            ["Hunger"] = 0,
            ["Thirst"] = 20,
            ["InnerCoreStamina"] = 50,
            ["InnerCoreStaminaGold"] = 100.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 0,
            ["InnerCoreHealthGold"] = 0.0,
            ["OuterCoreHealthGold"] = 0.0,
    
    
        },
        {
            ["Name"] = "consumable_tubig", -- Item DB NAME
            ["DisplayName"] = "Tubig", -- Name on screen (label from DB)
            ["Hunger"] = 0, -- Food it gives
            ["Thirst"] = 100, -- Water it gives
            ["InnerCoreStamina"] = 100, -- Inner Core Stamina effect
            ["InnerCoreStaminaGold"] = 0.0, -- Inner Core Stamina Gold overpower
            ["OuterCoreStaminaGold"] = 0.0, -- Outer Core Stamina Gold overpower
            ["InnerCoreHealth"] = 0, -- Inner Core Health effect
            ["InnerCoreHealthGold"] = 0.0, -- Inner Core Health Gold overpower
            ["OuterCoreHealthGold"] = 0.0, -- Outer Core Health Gold overpower
    
    
        },
    
        --
        -- MEDICINES
        --
        {
            ["Name"] = "paracetamol", -- DB NAME
            ["DisplayName"] = "Paracetamol", 
            ["Hunger"] = 0,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 100.0,
            ["OuterCoreStaminaGold"] = 100.0,
            ["InnerCoreHealth"] = 100.0,
            ["InnerCoreHealthGold"] = 100.0,
            ["OuterCoreHealthGold"] = 100.0,
    
    
        },
        {
            ["Name"] = "ibuprofen", -- DB NAME
            ["DisplayName"] = "Ibuprofen", 
            ["Hunger"] = 0,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 50.0,
            ["InnerCoreHealthGold"] = 50.0,
            ["OuterCoreHealthGold"] = 50.0,
    
    
        },
        {
            ["Name"] = "ascorbicAcid", -- DB NAME
            ["DisplayName"] = "Ascorbic Acid", 
            ["Hunger"] = 0,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 30.0,
            ["InnerCoreHealthGold"] = 30.0,
            ["OuterCoreHealthGold"] = 30.0,
    
    
        },
        {
            ["Name"] = "mefenamic", -- DB NAME
            ["DisplayName"] = "Mefenamic", 
            ["Hunger"] = 0,
            ["Thirst"] = 0,
            ["InnerCoreStamina"] = 0,
            ["InnerCoreStaminaGold"] = 0.0,
            ["OuterCoreStaminaGold"] = 0.0,
            ["InnerCoreHealth"] = 10.0,
            ["InnerCoreHealthGold"] = 10.0,
            ["OuterCoreHealthGold"] = 10.0,
    
    
        },
    
    
    }