-- spz-appearance/server/crew_outfit.lua

function PropagateCrewOutfit(crewId, outfit)
    MySQL.update.await(
        "UPDATE crews SET crew_outfit = ? WHERE id = ?",
        { json.encode(outfit), crewId }
    )
    local members = exports["spz-identity"]:GetOnlineCrewMembers(crewId)
    for _, memberSource in ipairs(members) do
        TriggerClientEvent("SPZ:applyCrewOutfit", memberSource, outfit)
    end
end

function GetCrewOutfit(crewId)
    local result = MySQL.query.await(
        "SELECT crew_outfit FROM crews WHERE id = ? LIMIT 1",
        { crewId }
    )
    if result and result[1] and result[1].crew_outfit then
        return json.decode(result[1].crew_outfit)
    end
    return nil
end

function ClearCrewOutfit(crewId)
    MySQL.update.await("UPDATE crews SET crew_outfit = NULL WHERE id = ?", { crewId })
end

exports("PropagateCrewOutfit", PropagateCrewOutfit)
exports("GetCrewOutfit",       GetCrewOutfit)
exports("ClearCrewOutfit",     ClearCrewOutfit)
