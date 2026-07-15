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

-- Full fivem-appearance customization suite (new characters, /appearance).
-- On save the result is stored as the player's personal outfit; on cancel we
-- fall back to whatever outfit routing says (crew / default uniform).
RegisterNetEvent("SPZ:openAppearanceCustomization", function()
    if GetResourceState("fivem-appearance") ~= "started" then
        print("^1[spz-appearance] fivem-appearance is not running — cannot open customization^7")
        TriggerEvent("SPZ:applyOutfit")
        TriggerEvent("SPZ:appearanceCustomizationDone")
        return
    end

    -- fivem-appearance's UI builds its drawable lists from the ped: it must be a
    -- fully-loaded freemode model with initialised components, or the NUI
    -- crashes with "reading 'masks'/'hats'".
    local ped   = PlayerPedId()
    local model = GetEntityModel(ped)
    if model ~= `mp_m_freemode_01` and model ~= `mp_f_freemode_01` then
        print("^1[spz-appearance] Ped is not a freemode model — skipping customization^7")
        TriggerEvent("SPZ:applyOutfit")
        TriggerEvent("SPZ:appearanceCustomizationDone")
        return
    end

    -- Let the model swap fully settle before fivem-appearance reads the ped
    Wait(500)

    print("^2[spz-appearance] Starting fivem-appearance customization…^7")
    local ok, err = pcall(function()
        exports["fivem-appearance"]:startPlayerCustomization(function(appearance)
            if appearance then
                TriggerServerEvent("SPZ:saveOutfit", appearance)
            else
                -- Cancelled — dress them in crew/default so they aren't naked
                TriggerEvent("SPZ:applyOutfit")
            end

            -- Ensure player state is fully reset (Fix for ghost mode and stuck camera loops)
            local ped = PlayerPedId()
            SetLocalPlayerAsGhost(false)
            SetEntityVisible(ped, true, false)
            FreezeEntityPosition(ped, false)
            RenderScriptCams(false, false, 0, true, true)
            DestroyAllCams(true)

            -- Hand control back to the spawn flow (play menu next)
            TriggerEvent("SPZ:appearanceCustomizationDone")
        end, {
            ped          = true,
            headBlend    = true,
            faceFeatures = true,
            headOverlays = true,
            components   = true,
            props        = true,
            tattoos      = true,
            allowExit    = true,
        })
    end)

    if not ok then
        print("^1[spz-appearance] startPlayerCustomization FAILED: " .. tostring(err) .. "^7")
        TriggerEvent("SPZ:applyOutfit")
        TriggerEvent("SPZ:appearanceCustomizationDone")
    end
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
