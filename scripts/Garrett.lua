local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv
local hook = lgs.DarkHookSrv


function BeginScript(msg)

    hook.DarkHookInitialize()
    hook.InstallPropHook(msg.to, true, 'Position', msg.to)


    property.Add(msg.to, 'SelfLit')
    print(property.Set(msg.to, 'SelfLit', 0))
    --ui.TextMessage(tostring(property.possessed(msg.to, 'SelfLit')))

    return true

end


function PhysicsMessages(msg)

    --tostring(msg.to)..tostring(mgs.from))

    return true

end


function DHNotify(msg)

    print(tostring(property.Get(msg.to, 'Position')))

    return true

end