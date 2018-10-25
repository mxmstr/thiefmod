require 'Constants'

local garrett = nil
local response = nil
local alert_level = 0


function BeginScript(msg)

    garrett = object.Named('NewGarrett')

    --object.AddMetaProperty(msg.to, RespondToDefault)
    --object.AddMetaProperty(msg.to, NonHostileUntilThreat)

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

    local new_level = ai.GetAlertLevel(script.ObjId)

    if new_level == 2 and new_level ~= alert_level then
        
    end

    alert_level = new_level

end