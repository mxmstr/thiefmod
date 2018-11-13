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


function SignalAI(msg)

    print(msg.signal)

    return true

end


function Update()


end