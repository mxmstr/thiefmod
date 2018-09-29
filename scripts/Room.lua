local network = lgs.NetworkingSrv
local damage = lgs.DamageSrv


function BeginScript(msg)
    
    --prop = 1
    --print(prop)
    return true

end


function CreatureRoomEnter(msg)

    return true

end


function ObjectRoomEnter(msg)

    return true

end


function PlayerRoomEnter(msg)

    print('Player Enter')
    script:PostMessage(msg.MoveObjId, 'SetRoomRule', msg.ToObjId, msg.FromObjId)

    return true

end


function PlayerRoomExit(msg)

    print('Player Exit')

    return true

end