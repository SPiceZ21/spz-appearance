-- client/autoshot.lua
-- /autoshot — one-time thumbnail generator for the appearance ThumbGrid.
-- Inspired by uz_AutoShot: frames a camera on the ped, cycles every clothing
-- component + prop drawable, screenshots each (screenshot-basic) and ships it to
-- the server, which writes it into fivem-appearance/images/. Run it once per
-- model on a plain backdrop; then restart fivem-appearance to serve the images.

local COMPONENTS = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
local PROPS      = { 0, 1, 2, 6, 7 }
local ALL_COMPS  = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }

local capturing = false
local shooting  = false   -- true during the actual screenshot → hide overlay
local cam = 0
local ack = false
local ackOk = false

-- progress (read by the on-screen bar)
local shotDone, shotTotal, shotLabel = 0, 0, ''
local DEBUG = true

local function dbg(fmt, ...)
    if DEBUG then print(('[autoshot] ' .. fmt):format(...)) end
end

RegisterNetEvent('spz-appearance:shotSaved', function(ok)
    ack = true
    ackOk = ok == true
end)

-- ── On-screen progress bar (top-centre) while capturing ──────────────────────
CreateThread(function()
    while true do
        if capturing and shotTotal > 0 and not shooting then
            local frac = shotDone / shotTotal
            -- track
            DrawRect(0.5, 0.085, 0.32, 0.05, 10, 11, 14, 200)
            -- fill (left-aligned inside the 0.30-wide track)
            DrawRect(0.35 + 0.15 * frac, 0.085, 0.30 * frac, 0.028, 255, 102, 0, 230)
            -- label
            SetTextFont(4)
            SetTextScale(0.42, 0.42)
            SetTextCentre(true)
            SetTextColour(255, 255, 255, 255)
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentSubstringPlayerName(
                ('AUTOSHOT  %d / %d  (%d%%)  %s'):format(shotDone, shotTotal, math.floor(frac * 100), shotLabel))
            EndTextCommandDisplayText(0.5, 0.062)
            Wait(0)
        else
            Wait(300)
        end
    end
end)

-- Camera framed in front of the ped, looking back at it.
local function frameCam(ped, mode)
    local c = GetEntityCoords(ped)
    local rad = math.rad(GetEntityHeading(ped))
    local fx, fy = -math.sin(rad), math.cos(rad)  -- ped forward
    local dist = (mode == 'head') and 0.85 or 1.55
    local eye  = (mode == 'head') and 0.63 or 0.20
    local look = (mode == 'head') and 0.60 or 0.02
    SetCamCoord(cam, c.x + fx * dist, c.y + fy * dist, c.z + eye)
    PointCamAtCoord(cam, c.x, c.y, c.z + look)
    SetCamFov(cam, (mode == 'head') and 26.0 or 42.0)
end

-- Screenshot the current frame and wait for the server to confirm the write.
local function captureAndWait(sub, name)
    ack = false
    ackOk = false
    -- Hide the progress overlay and let one clean frame render before the shot,
    -- so the bar never ends up baked into the thumbnail.
    shooting = true
    Wait(0)
    -- JPG (small) + a LATENT event — a full screenshot is multi-MB and a regular
    -- TriggerServerEvent drops it (that's why every shot returned saved=false).
    exports['screenshot-basic']:requestScreenshot({ encoding = 'jpg', quality = 0.6 }, function(data)
        TriggerLatentServerEvent('spz-appearance:saveShot', 750000, sub, name, data)
    end)
    local deadline = GetGameTimer() + 10000
    while not ack and GetGameTimer() < deadline do Wait(30) end
    shooting = false
end

RegisterCommand('autoshot', function()
    if capturing then
        lib.notify({ description = 'Autoshot already running', type = 'error' })
        return
    end
    if GetResourceState('screenshot-basic') ~= 'started' then
        lib.notify({ description = 'screenshot-basic not running', type = 'error' })
        return
    end

    capturing = true
    CreateThread(function()
        local ped = PlayerPedId()
        local model = (GetEntityModel(ped) == GetHashKey('mp_f_freemode_01')) and 'mp_f_freemode_01' or 'mp_m_freemode_01'

        -- Snapshot current look so we can restore it afterwards.
        local savedC, savedP = {}, {}
        for _, id in ipairs(ALL_COMPS) do savedC[id] = { GetPedDrawableVariation(ped, id), GetPedTextureVariation(ped, id) } end
        for _, id in ipairs(PROPS) do savedP[id] = { GetPedPropIndex(ped, id), GetPedPropTextureIndex(ped, id) } end

        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        ClearPedTasksImmediately(ped)
        SetEntityHeading(ped, GetEntityHeading(ped))

        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        DisplayHud(false)
        DisplayRadar(false)

        local total, done, fails = 0, 0, 0
        for _, id in ipairs(COMPONENTS) do total = total + GetNumberOfPedDrawableVariations(ped, id) end
        for _, id in ipairs(PROPS) do total = total + GetNumberOfPedPropDrawableVariations(ped, id) end
        shotTotal, shotDone, shotLabel = total, 0, ''

        dbg('START model=%s total=%d', model, total)
        lib.notify({ title = 'Autoshot', description = ('Capturing %d items for %s…'):format(total, model), type = 'info' })

        -- Clothing
        for _, id in ipairs(COMPONENTS) do
            frameCam(ped, 'body')
            local n = GetNumberOfPedDrawableVariations(ped, id)
            for d = 0, n - 1 do
                SetPedComponentVariation(ped, id, d, 0, 0)
                Wait(120)
                local name = ('%s_%d_%d'):format(model, id, d)
                shotLabel = ('comp %d.%d'):format(id, d)
                captureAndWait('clothing', name)
                done = done + 1
                shotDone = done
                if not ackOk then fails = fails + 1 end
                dbg('%d/%d  %s  saved=%s', done, total, name, tostring(ackOk))
            end
            SetPedComponentVariation(ped, id, savedC[id][1], savedC[id][2], 0)
        end

        -- Props (head items framed closer)
        for _, id in ipairs(PROPS) do
            frameCam(ped, (id == 0 or id == 1 or id == 2) and 'head' or 'body')
            local n = GetNumberOfPedPropDrawableVariations(ped, id)
            for d = 0, n - 1 do
                SetPedPropIndex(ped, id, d, 0, true)
                Wait(120)
                local name = ('%s_p%d_%d'):format(model, id, d)
                shotLabel = ('prop %d.%d'):format(id, d)
                captureAndWait('props', name)
                done = done + 1
                shotDone = done
                if not ackOk then fails = fails + 1 end
                dbg('%d/%d  %s  saved=%s', done, total, name, tostring(ackOk))
            end
            if savedP[id][1] < 0 then ClearPedProp(ped, id)
            else SetPedPropIndex(ped, id, savedP[id][1], savedP[id][2], true) end
        end

        -- Restore
        for _, id in ipairs(ALL_COMPS) do SetPedComponentVariation(ped, id, savedC[id][1], savedC[id][2], 0) end
        RenderScriptCams(false, false, 0, true, true)
        if cam ~= 0 then DestroyCam(cam, false); cam = 0 end
        DisplayHud(true)
        DisplayRadar(true)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)

        dbg('DONE  saved=%d  failed=%d', done - fails, fails)
        lib.notify({
            title = 'Autoshot complete',
            description = ('%d saved, %d failed. Restart fivem-appearance to serve them.'):format(done - fails, fails),
            type = 'success',
            duration = 9000,
        })
        capturing = false
    end)
end, false)
