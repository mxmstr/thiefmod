local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv


function BeginScript(msg)

    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 100)
    ui.TextMessage(tostring(property.possessed(msg.to, 'SelfLit')))

    return true

end