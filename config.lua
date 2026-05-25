-- spz-appearance/config.lua
Config = {}

-- Default SPZ uniform in illenium-appearance format
Config.DefaultOutfit = {

    [0] = {   -- Male
        model      = "mp_m_freemode_01",
        components = {
            { component_id = 1,  drawable = 0,  texture = 0 },
            { component_id = 3,  drawable = 15, texture = 0 },
            { component_id = 4,  drawable = 61, texture = 0 },
            { component_id = 6,  drawable = 34, texture = 0 },
            { component_id = 7,  drawable = 0,  texture = 0 },
            { component_id = 8,  drawable = 15, texture = 0 },
            { component_id = 11, drawable = 55, texture = 0 },
        },
        props = {
            { prop_id = 0, drawable = -1, texture = 0 },
            { prop_id = 1, drawable = -1, texture = 0 },
            { prop_id = 2, drawable = -1, texture = 0 },
            { prop_id = 6, drawable = -1, texture = 0 },
            { prop_id = 7, drawable = -1, texture = 0 },
        },
    },

    [1] = {   -- Female
        model      = "mp_f_freemode_01",
        components = {
            { component_id = 1,  drawable = 0,  texture = 0 },
            { component_id = 3,  drawable = 15, texture = 0 },
            { component_id = 4,  drawable = 61, texture = 0 },
            { component_id = 6,  drawable = 34, texture = 0 },
            { component_id = 7,  drawable = 0,  texture = 0 },
            { component_id = 8,  drawable = 15, texture = 0 },
            { component_id = 11, drawable = 55, texture = 0 },
        },
        props = {
            { prop_id = 0, drawable = -1, texture = 0 },
            { prop_id = 1, drawable = -1, texture = 0 },
            { prop_id = 2, drawable = -1, texture = 0 },
            { prop_id = 6, drawable = -1, texture = 0 },
            { prop_id = 7, drawable = -1, texture = 0 },
        },
    },

}

Config.Debug = false
