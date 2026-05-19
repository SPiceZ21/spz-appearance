-- spz-appearance/config.lua
Config = {}

Config.DefaultOutfit = {

  [0] = {   -- Male uniform
    gender     = 0,
    components = {
      [1]  = { 0,   0, 0 },   -- head
      [3]  = { 15,  0, 0 },   -- arms
      [4]  = { 61,  0, 0 },   -- legs
      [6]  = { 34,  0, 0 },   -- shoes
      [7]  = { 0,   0, 0 },   -- accessories
      [8]  = { 15,  0, 0 },   -- undershirt
      [11] = { 55,  0, 0 },   -- torso / jacket
    },
    props = {
      [0] = { -1, 0 },   -- hat
      [1] = { -1, 0 },   -- glasses
      [2] = { -1, 0 },   -- ear
      [6] = { -1, 0 },   -- watch
      [7] = { -1, 0 },   -- bracelet
    }
  },

  [1] = {   -- Female uniform
    gender     = 1,
    components = {
      [1]  = { 0,   0, 0 },   -- head
      [3]  = { 15,  0, 0 },   -- arms
      [4]  = { 61,  0, 0 },   -- legs
      [6]  = { 34,  0, 0 },   -- shoes
      [7]  = { 0,   0, 0 },   -- accessories
      [8]  = { 15,  0, 0 },   -- undershirt
      [11] = { 55,  0, 0 },   -- torso / jacket
    },
    props = {
      [0] = { -1, 0 },   -- hat
      [1] = { -1, 0 },   -- glasses
      [2] = { -1, 0 },   -- ear
      [6] = { -1, 0 },   -- watch
      [7] = { -1, 0 },   -- bracelet
    }
  }

}

Config.Debug = false
