------ Trace.lua ------
local uisrv = lgs.DarkUISrv
 
local function Report(message, id)
  uisrv.TextMessage("Message "..message.." received from "..id.." by "..script.objid)
end
 
function TurnOn(msg)
  Report(msg.message, msg.from)
  return true
end
function TurnOff(msg)
  Report(msg.message, msg.from)
  return true
end