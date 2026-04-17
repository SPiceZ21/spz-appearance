-- client/main.lua

SPZ = exports["spz-lib"]:GetCoreObject()

SPZ.PedModels = {
  [0] = "mp_m_freemode_01",   -- male
  [1] = "mp_f_freemode_01",   -- female
}

AddEventHandler("SPZ:applyOutfit", function()
  SPZ.Callbacks.Trigger("spz-appearance:getMyOutfit", {}, function(data)
    if data and data.outfit then
      ApplyOutfitToLocalPed(data.outfit)
    end
  end)
end)

AddEventHandler("SPZ:applyCrewOutfit", function(outfit)
  ApplyOutfitToLocalPed(outfit)
end)
