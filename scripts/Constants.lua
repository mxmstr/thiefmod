
--[[
    Garrett
    - Staring is suspicious
    - Crouching is suspicious
    - Blend in with crowd
    X Carry weapon is suspicious
    AI
    X Delayed alert level 3
    X Order out of restricted area
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

GarrettHeight = 6
DefaultObjPos = vector(0, 0, -100)

StartingPoint = 720
RestrictedWatchObj = 2053
CrimeWatchObj = 2054

WalkZone = -6833
StandZone = -6834
RestrictedArea = -6835

DefaultCrime = 0
Trespassing = 1
HasWeapon = 2
JustAttacked = 3

AlertCapZero = -3371
AlertCapTwo = -6836
NonHostile = -3531
NonHostileUntilThreat = -6830
RelaxedAwareness = -6831
FrontGateGuard = -1689
PosedCorpse = -1832

DanceConv = -6831