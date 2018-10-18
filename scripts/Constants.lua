
--[[
    Garrett
    - Staring is suspicious
    - Crouching is suspicious
    - Blend in with crowd
    - Carry weapon is suspicious
    AI
    - Delayed alert level 3
    - Order out of restricted area
    - Custom sound schemas
]]

ui = lgs.DarkUISrv
ai = lgs.AISrv
phys = lgs.PhysSrv
object = lgs.ObjectSrv
property = lgs.PropertySrv
link = lgs.LinkSrv
hook = lgs.DarkHookSrv
abs = math.abs
square = math.sqrt

StandOnly = 0
WalkOnly = 1

DefaultCrime = 0
Trespassing = 1
HasWeapon = 2
JustAttacked = 3

AlertCapZero = -3371
NonHostile = -3531
NonHostileUntilThreat = -6832
RespondToDefault = -6833

DanceConv = -6831