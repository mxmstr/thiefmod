require 'Constants'


function BeginScript(msg)

    object.AddMetaProperty(msg.to, -3531)

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


function Update()



end