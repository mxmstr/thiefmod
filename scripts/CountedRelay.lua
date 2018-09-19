------ CountedRelay.lua ------
-- script services
local propsrv = lgs.PropertySrv
local linksrv = lgs.LinkSrv
-- some variables used by our script
-- there's no need for global variables, so use local as much 
-- as possible, your script will perform better
local limit = 3
local count = 0
 
-- Setup the script when the mission begins
function Sim(msg)
    
  if msg.fStarting then
    
    -- if the property isn't set, the default of 3 will be used
    if propsrv.Possessed(script.objid, "ScriptTiming") then
      limit = propsrv.Get(script.objid, "ScriptTiming")
    end
    count = 0
  end
  return true
end
 
-- Each TurnOn will increment the counter
function TurnOn(msg)
    print('turnon')
  count = count + 1
  if count >= 3 then
    count = 0
    linksrv.BroadcastOnAllLinks(script.objid, "TurnOn", "ControlDevice")
    
    end
  return true
end
 
-- A TurnOff decrements the counter
function TurnOff(msg)
    print('turnoff') 
  count = count - 1
  if count < 0 then 
    count = 0
end
  return true
end