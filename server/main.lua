-- server/main.lua

function GetOutfitForPlayer(source)
  local profile = Player(source).state.profile
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

  -- Priority 3: default SPiceZ uniform (guard against nil gender from DB errors)
  local gender = profile.gender or 0
  return Config.DefaultOutfit[gender] or Config.DefaultOutfit[0], "default"
end

print("^2[spz-appearance] Server script loading...^7")
SPZ = exports["spz-lib"]:GetCoreObject()
print("^2[spz-appearance] Core object retrieved. Registering callbacks...^7")

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

-- Reactive outfit re-application on statebag change
AddStateBagChangeHandler("crewId", nil, function(bagName, key, value)
  local source = tonumber(bagName:match("player:(%d+)"))
  if not source then return end
  
  -- Brief wait to ensure identity has finished all profile updates
  Citizen.SetTimeout(500, function()
    TriggerClientEvent("SPZ:applyOutfit", source)
  end)
end)

exports("GetOutfitForPlayer", GetOutfitForPlayer)
