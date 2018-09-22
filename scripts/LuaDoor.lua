--[[
  Implementation of the StdDoor script using LgScript.
--]]

local doorsrv = lgs.DoorSrv
local linksrv = lgs.LinkSrv
local propsrv = lgs.PropertySrv
local soundsrv = lgs.SoundSrv

-- Action strings used for schemas
local DoorAction = {
  [0] = "Open",
  [1] = "Closed",
  [2] = "Opening",
  [3] = "Closing",
  [4] = "Halted"
}

-- Next state to transition to
local TargetState = {
  -- Closed -> Closed
  [0] = 0,
  -- Open -> Open
  [1] = 1,
  -- Closing -> Closed
  [2] = 0,
  -- Opening -> Open
  [3] = 1,
  -- Halted -> Halted
  [4] = 4
}

-- Constructs the appropriate schema tags
local function StateChangeTags(status, oldstatus)
  local tags = ("Event StateChange, OpenState %s, OldOpenState %s")
               :format(DoorAction[status], DoorAction[oldstatus])
  if script:IsScriptDataSet("PlayerFrob") then
    tags = tags .. ", CreatureType Player"
    -- The flag is saved while opening or closing, so the final schema will also be from the Player
    if status ~= 2 and status ~= 3 then
      script:ClearScriptData("PlayerFrob")
    end
  end
  return tags
end

-- Send a SynchUp message to the door's mate.
local function PingDoubles()
  -- The LinkService is kind enough to filter based on the link data.
  linksrv.BroadcastOnAllLinks(script.objid, "SynchUp", "ScriptParams", "Double")
  linksrv.BroadcastOnAllLinks(script.objid, "SynchUp", "~ScriptParams", "Double")
end

local function StopCloseTimer(kill)
  if script:IsScriptDataSet("CloseTimer") then
    if kill then
      script:KillTimedMessage(script:GetScriptData("CloseTimer"))
    end
    script:ClearScriptData("CloseTimer")
  end
end

-- Make doors close automatically after being opened.
local function SetCloseTimer()
  local timing
  if propsrv.Possessed(script.objid, "ScriptTiming") then
    timing = propsrv.get(script.objid, "ScriptTiming")
  end
  if timing and timing > 0 then
    StopCloseTimer(true)
    script.CloseTimer = 
      script:SetTimedMessage("Close", timing)
  end
end

-- Retuns the rooms on either side of this door.
local function GetRooms(door)
  -- It's actually not all that hard to get the field name for a property.
  -- It's the label Dromed uses for the dialog, spaces and all.
  if propsrv.Possessed(door, "RotDoor") then
    local r1,r2 = propsrv.Get(door, "RotDoor", "Room ID #1"),
                  propsrv.Get(door, "RotDoor", "Room ID #2")
    if r1 < r2 then
      return r1,r2
    else
      return r2,r1
    end
  elseif propsrv.Possessed(door, "TransDoor") then
    local r1,r2 = propsrv.Get(door, "TransDoor", "Room ID #1"),
                  propsrv.Get(door, "TransDoor", "Room ID #2")
    if r1 < r2 then
      return r1,r2
    else
      return r2,r1
    end
  end
end

--[[ AI get confused when pathfinding through the common point of double-doors.
     (Happens a lot since they're biased towards the center of cells.)
     The AI will attempt to frob both doors, which is essentially frobbing the
     same door twice. So this creates an unrendered object between the doors 
     to, hopefully, force AI to pathfind through either one door or the other.
   ]]
local function PathAvoidDoubles(door1, door2)
  -- Only the door with the higher ID will create the marker.
  if door1 > door2 then
    local rooms1a,rooms1b = GetRooms(door1)
    local rooms2a,rooms2b = GetRooms(door2)
    if not rooms1a or not rooms2b or
       not (rooms1a == rooms2a and rooms1b == rooms2b) then
        return
    end
    if not propsrv.Possessed(door1,"PhysDims") or
       not propsrv.Possessed(door2,"PhysDims") then
      return
    end
    local dim1 = propsrv.Get(door1, "PhysDims", "Size") * 0.5
    local dim2 = propsrv.Get(door2, "PhysDims", "Size") * 0.5
    local objsrv = lgs.ObjectSrv
    local pos1 = objsrv.Position(door1)
    local pos2 = objsrv.Position(door2)
    local mid = (pos1 + pos2) * 0.5
    -- Now test if the doors share a common midpoint.
    local abs = math.abs
    pos1 = mid - pos1
    pos2 = mid - pos2
    if ( abs(pos1.x) - dim1.x < 0.005 or
         abs(pos1.y) - dim1.y < 0.005 or
         abs(pos1.z) - dim1.z < 0.005) and
       ( abs(pos2.x) - dim2.x < 0.005 or
         abs(pos2.y) - dim2.y < 0.005 or
         abs(pos2.z) - dim2.z < 0.005) then
      local sentinal = objsrv.Create( -- maybe objectsrv should magically convert strings
                       objsrv.Named("Marker"))
      objsrv.Teleport(sentinal, mid)
      propsrv.Set(sentinal, "AI_ObjAvoid", "Flags", 2)
      print("Created sentinal @"..tostring(mid))
    end
  end
end

-- Iterate ScriptParams links to see if we need to create path-avoid markers.
local function ScanDoubles()
  local linkcache = {}
  --[[ PathAvoidDoubles is called once for every linked object we find.
       It's safe for both doors to do this, since only the object with the 
       greater ID creates the marker.
     ]]
  local ls = linksrv.GetAll("ScriptParams", script.objid) -- optional destination
  -- The data from the link needs to be read, so we save the link set in a variable.
  for l,dest in ls do
    if not linkcache[dest] and ls:data() == 'Double' then
      linkcache[dest] = true
      PathAvoidDoubles(script.objid, dest)
    end
  end
  -- But notice how you can get the dest and source as part of the for loop.
  ls = linksrv.GetAll("ScriptParams", 0, script.objid)
  for l,_,source in ls do
    if not linkcache[source] and ls:data() == 'Double' then
      linkcache[source] = true
      PathAvoidDoubles(script.objid, source)
    end
  end
end

--[[ Now we get to the actual message handlers.
     Handlers are called with a single argument: the message structure.
     The keys will be different for different messages, but there are a few
     values common to all messages.
     Most handlers will return either true or false depending if the message 
     was handled successfully. Or some messages expect a specific response,
     which can be a basic type: number, string, boolean, or vector.
   ]]


-- Called when a new mission starts and again when it's over.
function Sim(msg)
  print('>>>Sim')
  if msg.fStarting then
    ScanDoubles()
  end
  -- Assigning to script fields preserves the values across saved games.
  script.m_bSim = msg.fStarting
  print('<<<Sim')
  return true
end

-- Scripts will get NowLocked/NowUnlocked even in editor mode
function NowLocked(msg)
  print('>>>NowLocked')
  if script.m_bSim then
    PingDoubles()
    doorsrv.CloseDoor(script.objid)
  end
  print('<<<NowLocked')
  return true
end

function NowUnlocked(msg)
  print('>>>NowUnlocked')
  if script.m_bSim then
    PingDoubles()
    doorsrv.OpenDoor(script.objid)
  end
  print('<<<NowUnlocked')
  return true
end

function Timer(msg)
  print('>>>Timer')
  if msg.name == "Close" then
    StopCloseTimer(false)
    doorsrv.CloseDoor(script.objid)
  end
  print('<<<Timer')
  return true
end

function FrobWorldEnd(msg)
  print('>>>FrobWorldEnd')
  if lgs.LockSrv.IsLocked(script.objid) and
     doorsrv.GetDoorState(script.objid) == 0 -- Closed
     and not lgs.DarkGameSrv.ConfigIsDefined("LockCheat") then
    soundsrv.PlayEnvSchema(script.objid, "Event Reject, Operation OpenDoor", script.objid)
  else
    if msg.Frobber == lgs.ObjectSrv.Named("Player") then
      -- Another way to set persistent script data, this does the same thing as
      --   script.PlayerFrob = true
      -- Methods on the script object are called with a colon
      script:SetScriptData("PlayerFrob", true)
    end
    if script:IsScriptDataSet("BeforeHalt") then
      -- This script data is set when the door halts midway.
      local beforehalt = script.BeforeHalt
      script:ClearScriptData("BeforeHalt")
      if beforehalt == 2 then -- Opening
        doorsrv.CloseDoor(script.objid)
      else
        doorsrv.CloseDoor(script.objid)
      end
    else
      -- No script data. Just toggle the door normally.
      doorsrv.ToggleDoor(script.objid)
    end
  end
  print('<<<FrobWorldEnd')
  return true
end

-- PlayerToolFrob is sent by StdKey
function PlayerToolFrob(msg)
  print('>>>PlayerToolFrob')
  script:SetScriptData("PlayerFrob",true)
  print('<<<PlayerToolFrob')
  return true
end

-- After a door halts unexpectedly, we want a frob to do the reverse of 
-- what it was doing before. Otherwise it would get stuck if there is an 
-- object obstructing the doorway.
function DoorHalt(msg)
  print('>>>DoorHalt')
  -- PingDoubles is not called. You would want to call it here to simulate 
  -- doors that are linked mechanically.
  script:SetScriptData("BeforeHalt", msg.PrevActionType)
  soundsrv.PlayEnvSchema(script.objid, StateChangeTags(msg.ActionType,msg.PrevActionType), script.objid)
  print('<<<DoorHalt')
  return true
end

function DoorOpening(msg)
  print('>>>DoorOpening')
  PingDoubles()
  lgs.DarkGameSrv.FoundObject(script.objid)
  soundsrv.PlayEnvSchema(script.objid, StateChangeTags(msg.ActionType,msg.PrevActionType), script.objid)
  print('<<<DoorOpening')
  return true
end

function DoorClosing(msg)
  print('>>>DoorClosing')
  PingDoubles()
  soundsrv.PlayEnvSchema(script.objid, StateChangeTags(msg.ActionType,msg.PrevActionType), script.objid)
  StopCloseTimer(true)
  print('<<<DoorClosing')
  return true
end

function DoorClose(msg)
  print('>>>DoorClose')
  soundsrv.HaltSchema(script.objid) -- default halts all schemas
  soundsrv.PlayEnvSchema(script.objid, StateChangeTags(msg.ActionType,msg.PrevActionType), script.objid)
  print('<<<DoorClose')
  return true
end

function DoorOpen(msg)
  print('>>>DoorOpen')
  soundsrv.HaltSchema(script.objid) -- default halts all schemas
  soundsrv.PlayEnvSchema(script.objid, StateChangeTags(msg.ActionType,msg.PrevActionType), script.objid)
  SetCloseTimer()
  print('<<<DoorOpen')
  return true
end

function Slain(msg)
  print('>>>Slain')
  -- Doors don't really "die"
  lgs.DamageSrv.Resurrect(script.objid, 0)
  -- Once slain, however, they will be much weaker than before.
  propsrv.Set(script.objid, "HitPoints", 1)
  -- Also, any locks are permanently disabled
  for l in linksrv.GetAll("Lock", script.objid, 0) do
    -- Only the link ID is needed, so the link set is used directly by the 
    -- for loop without needing to be stored in a local variable.
    linksrv.Destroy(l)
  end
  if propsrv.Possessed(script.objid, "Locked") then
    -- Just deleting the property doesn't actually unlock the door.
    propsrv.set(script.objid, "Locked", false)
    propsrv.remove(script.objid, "Locked")
  end
  if propsrv.Possessed(script.objid, "KeyDst") then
    propsrv.Remove(script.objid, "KeyDst")
  end
  doorsrv.OpenDoor(script.objid)
  print('<<<Slain')
  return true
end

function TurnOn(msg)
  print('>>>TurnOn')
  doorsrv.OpenDoor(script.objid)
  return true
end

function TurnOff(msg)
  print('>>>TurnOff')
  doorsrv.CloseDoor(script.objid)
  print('<<<TurnOff')
  return true
end

-- The double-door magic.
-- Mirror the behavior of the other door, and copy it's lock state too.
function SynchUp(msg)
  print('>>>SynchUp')
  local target = TargetState[doorsrv.GetDoorState(msg.from)]
  local state = TargetState[doorsrv.GetDoorState(script.objid)]
  if state ~= target then
    if target == 0 then
      doorsrv.CloseDoor(script.objid)
    else
      doorsrv.OpenDoor(script.objid)
    end
  end
  -- Doesn't look at Lock links. You'll want to link your lock to both doors.
  if propsrv.Possessed(msg.from, "Locked") and 
     propsrv.Possessed(script.objid, "Locked") and
     propsrv.Get(msg.from,"Locked") ~= propsrv.Get(script.objid,"Locked") then
    propsrv.CopyFrom(script.objid, "Locked", msg.from)
  end
  print('<<<SynchUp')
  return true
end

