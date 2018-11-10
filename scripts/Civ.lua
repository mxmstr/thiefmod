require 'Constants'


function BeginScript(msg)

    object.AddMetaProperty(msg.to, AlertCapZero)

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

    if msg.mode == 5 then
        property.Add(script.ObjId, 'SelfLit')
        property.Set(script.ObjId, 'SelfLit', 250)
    end

    return true

end


function Update()

end