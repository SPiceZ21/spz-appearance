-- spz-appearance/config.lua
Config = {}

Config.DefaultOutfit = {

  [0] = {   -- Male uniform
    gender     = 0,
    components = {
      [3]  = { 1,  0, 0 },   -- arms
      [4]  = { 5,  0, 0 },   -- legs
      [6]  = { 13, 0, 0 },   -- shoes
      [11] = { 375, 0, 0 },  -- jacket
    },
    props = {
      [0] = { 53, 0 },       -- hat/helmet
      [1] = { 1, 0 },        -- glasses
      [6] = { 1, 0 },        -- watch
      [7] = { 1, 0 },        -- bracelet
    }
  },

  [1] = {   -- Female uniform
    gender     = 1,
    components = {
      [1]  = { 169, 0, 0 },  -- mask
      [3]  = { 14, 0, 0 },   -- arms
      [4]  = { 44, 0, 0 },   -- legs
      [6]  = { 68, 0, 0 },   -- shoes
      [8]  = { 14, 0, 0 },   -- undershirt
      [11] = { 392, 0, 0 },  -- jacket
    },
    props = {
      [0] = { 50, 0 },       -- hat/helmet
    }
  }

}

Config.Debug = false
