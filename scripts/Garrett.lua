require 'Constants'
require 'SuspiciousActions'

local starting_point = nil
local crime = DefaultCrime


function BeginScript(msg)

    script.current_room = nil
    script:SetTimedMessage('name', 16, 'Periodic', 'Update')
    --script:SetTimedMessage('name', 500, 'Periodic', 'Fire')
    
    starting_point = object.Named('StartingPoint')


    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 0)

    return true

end


function SetRoom(msg)

    --local rule = object.GetName(msg.data[1])--property.Get(msg.data[1], 'DesignNote')
    --script.room_rule = _G[rule]

    script.current_room = msg.data[1]

    return true

end


function Timer(msg)

    local callbacks = {
        ['Update'] = Update,
        ['Fire'] = Fire
    }

    callbacks[msg.data[1]]()

    return true

end


function Fire()

    phys.LaunchProjectile(script.ObjId, -6830)

end


function Update()

    object.Teleport(starting_point, script.ObjId)


    local min_priority = 0
    local min_value = 0

    for key, action in pairs(actions) do

        local mult = action['light_multiplier']
        local trigger = action['trigger']
        local priority = action['priority']
        
        if trigger(script) and priority >= min_priority then

            local value = action['value_source'](script)
            value = abs(value - action['value_target'])
            value = value / action['value_max']
            value = value * mult

            if value >= min_value then
                property.Set(script.ObjId, 'SelfLit', value)
                min_priority = priority
                min_value = value
            end

        end
        
    end

end