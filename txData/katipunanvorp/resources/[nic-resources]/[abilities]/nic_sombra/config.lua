Config = {}

Config.settings = {
    {
        cloneName = "Clone",
        cloneScale = 0.95,  -- default: 1.0

        cloneSpawnType = "manual", -- manual, random, dynamic, healthBased
        numberOfClones = 3,  -- this will only work if cloneSpawnType is set to manual, max: 6

        cloneWeapons = true, -- default: true

        healthBasedClones = true, -- clones count will depend on your health.
        showCloneHealthBar = false, -- default: true
        cloneHealthDisplayType = "bar" -- ring, hearts, simple, plus, dot, core, bar
    }
}


Config.items = {
    [1] =  {["item"] = "pandesal", ["model"] = "s_bit_bread06"},
    [2] =  {["item"] = "banana", ["model"] = "p_banana_day_04x"},
    [3] =  {["item"] = "canteen", ["model"] = "p_cs_canteen_hercule"},
    [4] =  {["item"] = "firstaid", ["model"] = "p_bottlemedicine16x"},
    [5] =  {["item"] = "firstaid-s", ["model"] = "p_bottlemedicine16x"},
    [6] =  {["item"] = "apple", ["model"] = "p_apple02x"},
    [7] =  {["item"] = "cigar", ["model"] = "p_cigarlit01x"},
    [8] =  {["item"] = "cigarette", ["model"] = "p_cigarette_cs01x"},
    [9] =  {["item"] = "carrot", ["model"] = "p_carrot01x"},
    [10] =  {["item"] = "pear", ["model"] = "p_pear_01x"},
    [12] =  {["item"] = "film", ["model"] = "p_cork01x"},
    [13] =  {["item"] = "horse_stim", ["model"] = "p_cs_syringe02x"},
    [14] =  {["item"] = "hamburger", ["model"] = "p_bread05x"},
    [15] =  {["item"] = "monay", ["model"] = "p_bread_13_ab"},
    [16] =  {["item"] = "haycube", ["model"] = "s_horsnack_haycube01x"},
    [18] =  {["item"] = "invi_potion", ["model"] = "s_inv_whiskey02x"},
    [19] =  {["item"] = "tango", ["model"] = "s_inv_orchid_ghost_01bx"},
    [20] =  {["item"] = "canned_sardines", ["model"] = "s_canbeans01x"}
}