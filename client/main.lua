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
