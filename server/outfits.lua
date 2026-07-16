-- server/outfits.lua

function GetSavedOutfit(source)
  local profile = exports["spz-identity"]:GetProfile(source)
  if not profile then return nil end

  -- await (not Sync): sync variants block the whole server thread
  local outfit = MySQL.scalar.await(
    "SELECT outfit FROM player_outfits WHERE player_id = ? LIMIT 1",
    { profile.id }
  )
  return outfit and json.decode(outfit) or nil
end

RegisterNetEvent("SPZ:saveOutfit", function(outfit)
  local source  = source
  local profile = exports["spz-identity"]:GetProfile(source)

  -- Write personal outfit
  exports.oxmysql:execute(
    [[INSERT INTO player_outfits (player_id, outfit)
      VALUES (?, ?)
      ON DUPLICATE KEY UPDATE outfit = VALUES(outfit)]],
    { profile.id, json.encode(outfit) }
  )

  -- If this player is a crew owner, propagate to crew members
  if profile.crew_id then
    local crew = exports["spz-identity"]:GetCrew(profile.crew_id)
    if crew and crew.owner_id == profile.id then
      PropagateCrewOutfit(profile.crew_id, outfit)
    end
  end
end)

RegisterNetEvent("SPZ:resetOutfit", function()
  local source = source
  local profile = exports["spz-identity"]:GetProfile(source)
  exports.oxmysql:execute(
    "DELETE FROM player_outfits WHERE player_id = ?",
    { profile.id }
  )

  -- Re-apply — will now fall through to crew or default
  TriggerClientEvent("SPZ:applyOutfit", source)
end)

function SaveOutfit(source, outfit)
  local profile = exports["spz-identity"]:GetProfile(source)
  if not profile then return end

  exports.oxmysql:execute(
    [[INSERT INTO player_outfits (player_id, outfit)
      VALUES (?, ?)
      ON DUPLICATE KEY UPDATE outfit = VALUES(outfit)]],
    { profile.id, json.encode(outfit) }
  )

  if profile.crew_id then
    local crew = exports["spz-identity"]:GetCrew(profile.crew_id)
    if crew and crew.owner_id == profile.id then
      PropagateCrewOutfit(profile.crew_id, outfit)
    end
  end
end

function ResetOutfit(source)
  local profile = exports["spz-identity"]:GetProfile(source)
  if not profile then return end

  exports.oxmysql:execute(
    "DELETE FROM player_outfits WHERE player_id = ?",
    { profile.id }
  )
  TriggerClientEvent("SPZ:applyOutfit", source)
end

exports("GetSavedOutfit", GetSavedOutfit)
exports("SaveOutfit", SaveOutfit)
exports("ResetOutfit", ResetOutfit)
