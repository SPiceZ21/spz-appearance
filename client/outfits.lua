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
    local ped     = PlayerPedId()
    local curModel = GetEntityModel(ped)
    local wantHash = appearance.model and GetHashKey(appearance.model) or curModel

    if wantHash == curModel then
        -- Same model → just paint the appearance onto the existing ped
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
