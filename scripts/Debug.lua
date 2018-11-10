require 'Constants'


function BeginScript(msg)

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


function AIModeChange(msg)

    ui.TextMessage(msg.mode)

    return true

end


function Update()


end