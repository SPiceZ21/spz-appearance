-- server/main.lua

function GetOutfitForPlayer(source)
  local profile = exports["spz-identity"]:GetProfile(source)
  if not profile then return nil, nil end

  -- Priority 1: crew outfit
  if profile.crew_id then
    local crewOutfit = GetCrewOutfit(profile.crew_id)
    if crewOutfit then
      return crewOutfit, "crew"
    end
  end

  -- Priority 2: personal saved outfit
  local savedOutfit = GetSavedOutfit(source)
  if savedOutfit then
    return savedOutfit, "personal"
  end

  -- Priority 3: default SPiceZ uniform
  return Config.DefaultOutfit[profile.gender], "default"
end

SPZ = exports["spz-lib"]:GetCoreObject()

SPZ.Callbacks.Register("spz-appearance:getMyOutfit", function(source, cb)
  local outfit, source_type = GetOutfitForPlayer(source)
  cb({ outfit = outfit, source_type = source_type })
end)

AddEventHandler("SPZ:crewChanged", function(source, oldCrewId, newCrewId)
  if newCrewId then
    -- Joined a crew — check for crew outfit
    local crewOutfit = GetCrewOutfit(newCrewId)
    if crewOutfit then
      TriggerClientEvent("SPZ:applyCrewOutfit", source, crewOutfit)
      return
    end
  end
  -- Left crew or crew has no outfit — re-apply normally
  TriggerClientEvent("SPZ:applyOutfit", source)
end)

exports("GetOutfitForPlayer", GetOutfitForPlayer)
