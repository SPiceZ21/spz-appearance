-- client/commands.lua

RegisterCommand("saveoutfit", function()
  local outfit = CaptureCurrentOutfit()
  TriggerServerEvent("SPZ:saveOutfit", outfit)
  lib.notify({ description = "Outfit saved", type = "success", duration = 3000 })
end, false)

RegisterCommand("resetoutfit", function()
  TriggerServerEvent("SPZ:resetOutfit")
  lib.notify({ description = "Outfit reset to default", type = "info", duration = 3000 })
end, false)
