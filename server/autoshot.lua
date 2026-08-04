-- server/autoshot.lua
-- Receives clothing/prop thumbnails captured by client/autoshot.lua and writes
-- them into the fivem-appearance resource (images/<sub>/), where the appearance
-- ThumbGrid loads them over cfx-nui. Inspired by uz_AutoShot, but stripped to
-- the essentials: base64 → file, no chroma/node pipeline.

local B64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- Decode a base64 string to a raw binary string.
local function b64decode(data)
    data = string.gsub(data, '[^' .. B64 .. '=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (B64:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

-- Only "clothing" or "props" subfolders are allowed; filename must be simple.
local function safe(sub, name)
    if sub ~= 'clothing' and sub ~= 'props' then return nil end
    if type(name) ~= 'string' or not name:match('^[%w_%-]+$') then return nil end
    return ('images/%s/%s.png'):format(sub, name)
end

RegisterNetEvent('spz-appearance:saveShot', function(sub, name, dataUri)
    local src = source
    if type(dataUri) ~= 'string' then return end

    local path = safe(sub, name)
    if not path then return end

    -- Strip the data-URI header, decode, write into fivem-appearance.
    local b64 = dataUri:gsub('^data:image/[%w%+%-%.]+;base64,', '')
    local bytes = b64decode(b64)
    if #bytes < 64 then TriggerClientEvent('spz-appearance:shotSaved', src, false); return end

    local ok = SaveResourceFile('fivem-appearance', path, bytes, #bytes)
    TriggerClientEvent('spz-appearance:shotSaved', src, ok == true or ok == 1)
end)
