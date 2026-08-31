-- client/main.lua

-- ── Customization lock ────────────────────────────────────────────────────────
--
-- While the customiser is open, the ped IS the preview: every drawable on it is
-- something the player is trying on and has not committed to yet. Anything that
-- re-applies the SAVED outfit during that window fights the player directly —
-- they pick a jacket, and a moment later the ped snaps back to the old one.
--
-- That is exactly what was happening. Several things push an outfit without
-- knowing the customiser is up:
--
--   * the `crewId` statebag handler, which fires 500ms after identity writes the
--     profile statebags — which is precisely when character creation opens the
--     customiser;
--   * SPZ:crewChanged;
--   * saving as a crew owner, which propagates the crew outfit back to every
--     member INCLUDING the player who just saved.
--
-- fivem-appearance has its own per-frame hold that re-asserts the preview
-- components, so the two ended up overwriting each other every frame — which is
-- what turned a clean revert into a flicker.
--
-- One flag, checked at the single point where an outfit gets applied. Pushes
-- that arrive during customization are dropped, not queued: whatever the player
-- ends up saving is newer than anything that arrived while they were choosing.

local customizing = false

local function IsCustomizing() return customizing end
exports("IsCustomizing", IsCustomizing)

RegisterNetEvent("SPZ:applyOutfit", function()
    if customizing then return end

    lib.callback("spz-appearance:getMyOutfit", false, function(data)
        -- Re-checked in the callback: this is a server round-trip, so the
        -- customiser can have opened between the request and the reply.
        if customizing then return end
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
    if customizing then return end
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
    --
    -- GetEntityModel returns a HASH. This used to compare it against the model
    -- NAMES as strings, which can never match, so the guard rejected every ped
    -- it was given — including the correct one. The customiser was skipped on
    -- 100% of new characters: the player was never asked, and the flow went
    -- straight to Done. Comparing against the hashes is the whole fix.
    local ped     = PlayerPedId()
    local model   = GetEntityModel(ped)
    local isFreemode = model == GetHashKey('mp_m_freemode_01')
                    or model == GetHashKey('mp_f_freemode_01')

    if not isFreemode then
        print(("^1[spz-appearance] Ped is not a freemode model (hash %s) — skipping customization^7"):format(tostring(model)))
        TriggerEvent("SPZ:applyOutfit")
        TriggerEvent("SPZ:appearanceCustomizationDone")
        return
    end

    -- Claimed BEFORE the settle wait, not after: the pushes this is defending
    -- against are timer-driven and land during exactly this window.
    customizing = true

    -- Let the model swap fully settle before fivem-appearance reads the ped
    Wait(500)

    print("^2[spz-appearance] Starting fivem-appearance customization…^7")
    local ok, err = pcall(function()
        exports["fivem-appearance"]:startPlayerCustomization(function(appearance)
            -- Released first: the branches below apply outfits themselves, and
            -- they must not be swallowed by the lock they are replacing.
            customizing = false

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
        -- The customiser never opened, so the lock must not outlive this call —
        -- leaving it set would silently block every outfit push for the rest of
        -- the session.
        customizing = false
        print("^1[spz-appearance] startPlayerCustomization FAILED: " .. tostring(err) .. "^7")
        TriggerEvent("SPZ:applyOutfit")
        TriggerEvent("SPZ:appearanceCustomizationDone")
    end
end)

RegisterCommand("appearance", function()
    TriggerEvent("SPZ:openAppearanceCustomization")
end, false)

-- Exported for other resources. Carries the same customization lock as the
-- event path — an export is not a licence to overwrite what the player is in
-- the middle of choosing.
local function ReapplyMyOutfit()
    if customizing then return end

    lib.callback("spz-appearance:getMyOutfit", false, function(data)
        if customizing then return end
        if not data or not data.outfit then return end

        if data.source_type == "personal" then
            ApplyFullAppearance(data.outfit)
        else
            ApplyOutfitToLocalPed(data.outfit)
        end
    end, {})
end

exports("ReapplyMyOutfit", ReapplyMyOutfit)
