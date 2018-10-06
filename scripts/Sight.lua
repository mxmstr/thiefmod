require 'Constants'


function BeginScript(msg)

    phys.SubscribeMsg(msg.to, 'collision')

    script:SetTimedMessage('name', 100, 'Periodic', 'End')

    return true

end


function Timer(msg)

    local callbacks = {
        ['Update'] = Update,
        ['End'] = End
    }

    callbacks[msg.data[1]]()

    return true

end


function End()

    --object.Destroy(script.ObjId)

end


function PhysCollision(msg)

    --ui.TextMessage(msg.collObj)
    return true

end