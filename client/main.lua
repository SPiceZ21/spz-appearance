-- client/main.lua

SPZ = exports["spz-lib"]:GetCoreObject()

-- Outfit source routing:
--   "personal" → full appearance (face + clothing)
--   "crew"     → clothing only   (preserves player's own face/hair)
--   "default"  → clothing only

RegisterNetEvent("SPZ:applyOutfit", function()
    SPZ.Callbacks.Trigger("spz-appearance:getMyOutfit", {}, function(data)
        if not data or not data.outfit then return end

        if data.source_type == "personal" then
            ApplyFullAppearance(data.outfit)
        else
            ApplyOutfitToLocalPed(data.outfit)
        end
    end)
end)

-- Server pushes crew outfit directly — always clothing-only
RegisterNetEvent("SPZ:applyCrewOutfit", function(outfit)
    ApplyOutfitToLocalPed(outfit)
end)

local function ReapplyMyOutfit()
    SPZ.Callbacks.Trigger("spz-appearance:getMyOutfit", {}, function(data)
        if not data or not data.outfit then return end

        if data.source_type == "personal" then
            ApplyFullAppearance(data.outfit)
        else
            ApplyOutfitToLocalPed(data.outfit)
        end
    end)
end

exports("ReapplyMyOutfit", ReapplyMyOutfit)
