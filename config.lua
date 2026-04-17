-- config.lua
Config = {}

-- ── Default uniform ───────────────────────────────────────────────────────
-- Applied to players who have no personal saved outfit and no crew outfit.
-- Component IDs: 1=head 3=arms 4=legs 6=shoes 7=accessories 8=undershirt 11=torso
-- Prop IDs: 0=hat 1=glasses 2=ear 6=watch 7=bracelet  (-1 = none)

Config.DefaultOutfit = {
  [0] = {   -- Male SPiceZ uniform
    gender     = 0,
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
  },
  [1] = {   -- Female SPiceZ uniform
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
  },
}

-- ── Debug ─────────────────────────────────────────────────────────────────
Config.Debug = false
