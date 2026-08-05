-- client/outfits.lua
-- All outfit data uses fivem-appearance format:
--   components = { { component_id, drawable, texture }, ... }
--   props      = { { prop_id, drawable, texture }, ... }
--   + model, headBlend, faceFeatures, headOverlays, hair, tattoos, eyeColor

-- Apply clothing components + props only (crew / default outfit).
-- Preserves each player's face, hair, tattoos.
function ApplyOutfitToLocalPed(outfit)
    local ped = PlayerPedId()
    if outfit.components then
        exports['fivem-appearance']:setPedComponents(ped, outfit.components)
    end
    if outfit.props then
        exports['fivem-appearance']:setPedProps(ped, outfit.props)
    end
end

-- Restore normal player control — belt-and-braces after any appearance apply,
-- which can leave the ped ghosted / frozen if a model swap was involved.
local function RestoreControl()
    local ped = PlayerPedId()
    SetLocalPlayerAsGhost(false)
    SetEntityNoCollisionEntity(ped, ped, true)   -- no-op safeguard
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    SetPlayerControl(PlayerId(), true, 0)
    SetPlayerInvincible(PlayerId(), false)
end

-- Apply full appearance including face/hair/tattoos (personal outfit).
-- Avoid setPlayerAppearance when the model already matches — that path does a
-- full SetPlayerModel swap (new ped handle) which is what left players ghosted
-- and unable to move after spawn.
function ApplyFullAppearance(appearance)
    local ped      = PlayerPedId()
    local curModel = GetEntityModel(ped)

    -- If the ped is ALREADY a freemode model (always true after spawn), paint the
    -- appearance onto the existing ped. NEVER go through setPlayerAppearance here —
    -- that calls SetPlayerModel, which respawns the ped at the world origin (0,0,0)
    -- and drops the player through the map ("spawns fine, then TPs to a random
    -- place and falls"). setPlayerModel is only needed to change the base model,
    -- which spawn already did.
    local isFreemode = curModel == GetHashKey('mp_m_freemode_01')
        or curModel == GetHashKey('mp_f_freemode_01')

    if isFreemode then
        exports['fivem-appearance']:setPedAppearance(ped, appearance)
    else
        exports['fivem-appearance']:setPlayerAppearance(appearance)
    end

    Citizen.SetTimeout(300, RestoreControl)
end

-- Capture complete current appearance via fivem-appearance.
function CaptureCurrentOutfit()
    return exports['fivem-appearance']:getPedAppearance(PlayerPedId())
end

exports("ApplyOutfitToLocalPed", ApplyOutfitToLocalPed)
exports("ApplyFullAppearance",   ApplyFullAppearance)
exports("CaptureCurrentOutfit",  CaptureCurrentOutfit)
