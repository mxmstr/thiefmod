require 'Constants'

local garrett = nil


function BeginScript(msg)

    garrett = object.Named('NewGarrett')

    object.AddMetaProperty(msg.to, NonHostileUntilThreat)
    --object.AddMetaProperty(msg.to, NonHostile)
    --object.AddMetaProperty(msg.to, InvestigateOnAlert)

    script:SetTimedMessage('name', 16, 'Periodic', 'Update')

    return true

end


function Timer(msg)

    local callbacks = {
        ['Update'] = Update
    }

    callbacks[msg.data[1]]()

    return true

end


function CalmDown(msg)

    ai.ClearAlertness(script.ObjId)

end


function RestartConv()

    --link.

end


function Update()



end