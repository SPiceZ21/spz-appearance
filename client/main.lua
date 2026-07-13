-- client/main.lua

RegisterNetEvent("SPZ:applyOutfit", function()
    lib.callback("spz-appearance:getMyOutfit", false, function(data)
        if not data or not data.outfit then return end

        if data.source_type == "personal" then
            ApplyFullAppearance(data.outfit)
        else
            ApplyOutfitToLocalPed(data.outfit)
        end
    end, {})
end)

-- Server pushes crew outfit directly — always clothing-only
RegisterNetEvent("SPZ:applyCrewOutfit", function(outfit)
    ApplyOutfitToLocalPed(outfit)
end)

-- Full illenium customization suite (new characters, /appearance).
-- On save the result is stored as the player's personal outfit; on cancel we
-- fall back to whatever outfit routing says (crew / default uniform).
RegisterNetEvent("SPZ:openAppearanceCustomization", function()
    if GetResourceState("illenium-appearance") ~= "started" then
        print("^1[spz-appearance] illenium-appearance is not running — cannot open customization^7")
        TriggerEvent("SPZ:applyOutfit")
        return
    end

    exports["illenium-appearance"]:startPlayerCustomization(function(appearance)
        if appearance then
            TriggerServerEvent("SPZ:saveOutfit", appearance)
        else
            -- Cancelled — dress them in crew/default so they aren't naked
            TriggerEvent("SPZ:applyOutfit")
        end
    end, {
        ped          = true,
        headBlend    = true,
        faceFeatures = true,
        headOverlays = true,
        components   = true,
        props        = true,
        tattoos      = true,
    })
end)

RegisterCommand("appearance", function()
    TriggerEvent("SPZ:openAppearanceCustomization")
end, false)

local function ReapplyMyOutfit()
    lib.callback("spz-appearance:getMyOutfit", false, function(data)
        if not data or not data.outfit then return end

        if data.source_type == "personal" then
            ApplyFullAppearance(data.outfit)
        else
            ApplyOutfitToLocalPed(data.outfit)
        end
    end, {})
end

exports("ReapplyMyOutfit", ReapplyMyOutfit)
