-- client/commands.lua

SPZ = exports["spz-lib"]:GetCoreObject()

RegisterCommand("saveoutfit", function()
  local outfit = CaptureCurrentOutfit()
  TriggerServerEvent("SPZ:saveOutfit", outfit)
  SPZ.Notify("Outfit saved", "success", 3000)
end, false)

RegisterCommand("resetoutfit", function()
  TriggerServerEvent("SPZ:resetOutfit")
  SPZ.Notify("Outfit reset to default", "info", 3000)
end, false)
