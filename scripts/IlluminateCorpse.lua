require 'Constants'

local dead = false


function BeginScript(msg)

    script:SetTimedMessage('name', 16, 'Periodic', 'Update')

    return true

end




function Timer(msg)

    local callbacks = {
        ['Update'] = Update
    }

    callbacks[msg.data[1]]()

    --if #msg.data > 0 then
    --    callbacks[msg.data[1]]()
    --end

    return true

end


function Update()

    if property.get(script.ObjId, 'FrobInfo', 'World Action') == 3 then
        if not property.Possessed(script.ObjId, 'SelfLit') then
            property.Add(script.ObjId, 'SelfLit')
            property.Set(script.ObjId, 'SelfLit', 250)
        end
    end

end