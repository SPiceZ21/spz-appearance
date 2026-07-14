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

  -- No predefined uniform — keep whatever the player is wearing
  return nil, nil
end

print("^2[spz-appearance] Server script loading...^7")

-- ── Schema bootstrap ──────────────────────────────────────────────────────────
-- Self-create so deployments never depend on install.sql being run manually.
CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS player_outfits (
            id         INT       AUTO_INCREMENT PRIMARY KEY,
            player_id  INT       NOT NULL UNIQUE,
            outfit     JSON      NOT NULL,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]])

    -- crew_outfit column on crews (ignore "duplicate column" on re-runs)
    pcall(function()
        MySQL.query.await("ALTER TABLE crews ADD COLUMN crew_outfit JSON NULL")
    end)

    print("^2[spz-appearance] Schema ready (player_outfits)^7")
end)

lib.callback.register("spz-appearance:getMyOutfit", function(source)
  local outfit, source_type = GetOutfitForPlayer(source)
  return { outfit = outfit, source_type = source_type }
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
