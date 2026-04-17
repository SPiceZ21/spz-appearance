-- spz-appearance/config.lua
Config = {}

Config.DefaultOutfit = {

  [0] = {   -- Male uniform
    gender     = 0,
    components = {
      [3]  = { 15,  0, 0 },   -- arms
      [4]  = { 61,  0, 0 },   -- legs
      [6]  = { 34,  0, 0 },   -- shoes
      [8]  = { 57,  0, 0 },   -- undershirt
      [11] = { 231, 0, 0 },   -- jacket
    },
    props = {
      [0] = { -1, 0 },
      [1] = { -1, 0 },
    }
  },

  [1] = {   -- Female uniform
    gender     = 1,
    components = {
      [3]  = { 15,  0, 0 },
      [4]  = { 61,  0, 0 },
      [6]  = { 34,  0, 0 },
      [8]  = { 57,  0, 0 },
      [11] = { 231, 0, 0 },
    },
    props = {
      [0] = { -1, 0 },
      [1] = { -1, 0 },
    }
  }

}

Config.Debug = false
