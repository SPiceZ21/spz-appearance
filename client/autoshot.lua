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
local cam = 0
local ack = false

RegisterNetEvent('spz-appearance:shotSaved', function()
    ack = true
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
    exports['screenshot-basic']:requestScreenshot({ encoding = 'png' }, function(data)
        TriggerServerEvent('spz-appearance:saveShot', sub, name, data)
    end)
    local deadline = GetGameTimer() + 10000
    while not ack and GetGameTimer() < deadline do Wait(30) end
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
        local model = (GetEntityModel(ped) == `mp_f_freemode_01`) and 'mp_f_freemode_01' or 'mp_m_freemode_01'

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

        local total, done = 0, 0
        for _, id in ipairs(COMPONENTS) do total = total + GetNumberOfPedDrawableVariations(ped, id) end
        for _, id in ipairs(PROPS) do total = total + GetNumberOfPedPropDrawableVariations(ped, id) end

        lib.notify({ title = 'Autoshot', description = ('Capturing %d items for %s…'):format(total, model), type = 'info' })

        -- Clothing
        for _, id in ipairs(COMPONENTS) do
            frameCam(ped, 'body')
            local n = GetNumberOfPedDrawableVariations(ped, id)
            for d = 0, n - 1 do
                SetPedComponentVariation(ped, id, d, 0, 0)
                Wait(120)
                captureAndWait('clothing', ('%s_%d_%d'):format(model, id, d))
                done = done + 1
                if done % 20 == 0 then
                    lib.notify({ description = ('Autoshot %d / %d'):format(done, total), type = 'info', duration = 1500 })
                end
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
                captureAndWait('props', ('%s_p%d_%d'):format(model, id, d))
                done = done + 1
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

        lib.notify({
            title = 'Autoshot complete',
            description = ('%d thumbnails saved. Restart fivem-appearance to serve them.'):format(done),
            type = 'success',
            duration = 9000,
        })
        capturing = false
    end)
end, false)
