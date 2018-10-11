require 'Constants'


function BeginScript(msg)

    script:SetTimedMessage('name', 1000, 'Periodic', 'Update')

end


function Timer(msg)

    local callbacks = {
        ['Update'] = Update
    }

    callbacks[msg.data[1]]()

    return true

end


function Update()

    script:PostMessage(script.ObjId, 'TurnOff')
    script:PostMessage(script.ObjId, 'TurnOn')

end