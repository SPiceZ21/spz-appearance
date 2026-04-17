-- client/outfits.lua

--[[
Outfit table — matches GTA V SetPedComponentVariation and SetPedPropIndex args
{
  gender     = 0,       -- 0=male 1=female — determines which components are valid

  components = {
    -- [componentId] = { drawableId, textureId, paletteId }
    [1]  = { 0,   0, 0 },   -- head
    [3]  = { 15,  0, 0 },   -- arms
    [4]  = { 61,  0, 0 },   -- legs
    [6]  = { 34,  0, 0 },   -- shoes
    [7]  = { 0,   0, 0 },   -- accessories
    [8]  = { 15,  0, 0 },   -- undershirt
    [11] = { 55,  0, 0 },   -- torso / jacket
  },

  props = {
    -- [propId] = { drawableId, textureId }
    -- -1 = clear the prop (no hat, no glasses)
    [0] = { -1, 0 },   -- hat
    [1] = { -1, 0 },   -- glasses
    [2] = { -1, 0 },   -- ear
    [6] = { -1, 0 },   -- watch
    [7] = { -1, 0 },   -- bracelet
  }
}
]]--

function ApplyOutfitToLocalPed(outfit)
  local ped = PlayerPedId()

  -- Reset to defaults first
  SetPedDefaultComponentVariation(ped)

  -- Apply components
  if outfit.components then
    for componentIdStr, comp in pairs(outfit.components) do
      local componentId = tonumber(componentIdStr)
      SetPedComponentVariation(
        ped, componentId,
        comp[1], comp[2], comp[3] or 0
      )
    end
  end

  -- Apply props
  if outfit.props then
    for propIdStr, prop in pairs(outfit.props) do
      local propId = tonumber(propIdStr)
      if prop[1] == -1 then
        ClearPedProp(ped, propId)
      else
        SetPedPropIndex(ped, propId, prop[1], prop[2], true)
      end
    end
  end
end

local function CaptureCurrentOutfit()
  local ped    = PlayerPedId()
  local gender = exports["spz-identity"]:GetClientGender()

  local components = {}
  for _, id in ipairs({ 1, 3, 4, 6, 7, 8, 11 }) do
    components[id] = {
      GetPedDrawableVariation(ped, id),
      GetPedTextureVariation(ped, id),
      GetPedPaletteVariation(ped, id),
    }
  end

  local props = {}
  for _, id in ipairs({ 0, 1, 2, 6, 7 }) do
    local drawable = GetPedPropIndex(ped, id)
    local texture  = drawable ~= -1 and GetPedPropTextureIndex(ped, id) or 0
    props[id] = { drawable, texture }
  end

  return {
    gender     = gender,
    components = components,
    props      = props,
  }
end
