-- client/outfits.lua
-- All outfit data uses illenium-appearance format:
--   components = { { component_id, drawable, texture }, ... }
--   props      = { { prop_id, drawable, texture }, ... }
--   + model, headBlend, faceFeatures, headOverlays, hair, tattoos, eyeColor

-- Apply clothing components + props only (crew / default outfit).
-- Preserves each player's face, hair, tattoos.
function ApplyOutfitToLocalPed(outfit)
    local ped = PlayerPedId()
    if outfit.components then
        exports['illenium-appearance']:setPedComponents(ped, outfit.components)
    end
    if outfit.props then
        exports['illenium-appearance']:setPedProps(ped, outfit.props)
    end
end

-- Apply full appearance including face/hair/tattoos (personal outfit).
function ApplyFullAppearance(appearance)
    exports['illenium-appearance']:setPlayerAppearance(appearance)
end

-- Capture complete current appearance via illenium.
function CaptureCurrentOutfit()
    return exports['illenium-appearance']:getPedAppearance(PlayerPedId())
end

exports("ApplyOutfitToLocalPed", ApplyOutfitToLocalPed)
exports("ApplyFullAppearance",   ApplyFullAppearance)
exports("CaptureCurrentOutfit",  CaptureCurrentOutfit)
