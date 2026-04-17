-- server/crew_outfit.lua

function GetCrewOutfit(crewId)
  local result = exports.oxmysql:executeSync(
    "SELECT crew_outfit FROM crews WHERE id = ?",
    { crewId }
  )
  if result and result[1] and result[1].crew_outfit then
    return json.decode(result[1].crew_outfit)
  end
  return nil
end

function PropagateCrewOutfit(crewId, outfit)
  -- Write to crews table
  exports.oxmysql:execute(
    "UPDATE crews SET crew_outfit = ? WHERE id = ?",
    { json.encode(outfit), crewId }
  )

  -- Push to all online crew members
  local members = exports["spz-identity"]:GetOnlineCrewMembers(crewId)
  for _, memberSource in ipairs(members) do
    TriggerClientEvent("SPZ:applyCrewOutfit", memberSource, outfit)
  end
end

exports("GetCrewOutfit", GetCrewOutfit)
