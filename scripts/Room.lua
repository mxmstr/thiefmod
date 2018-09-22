local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv
local hook = lgs.DarkHookSrv


function BeginScript(msg)

    print('Start')
    
    return true

end


function CreatureRoomEnter(msg)

    print('AI Enter')

    return true

end


function ObjectRoomEnter(msg)

    print('Object Enter')

    return true

end


function PlayerRoomEnter(msg)

    print('Player Enter')

    return true

end