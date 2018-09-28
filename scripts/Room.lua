local network = lgs.NetworkingSrv


function BeginScript(msg)
    
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
    print(network.Broadcast(msg.MoveObjId, 'SetRoomRules', false, msg))

    return true

end


function PlayerRoomExit(msg)

    print('Player Exit')

    return true

end