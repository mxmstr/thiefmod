require 'Constants'
require 'SuspiciousActions'

local starting_point = nil
local watch_obj = nil


function BeginScript(msg)

    script.current_room = nil
    script.suspicious_equipped = false
    script.suspicious_cooldown = false

    script:SetTimedMessage('Update', 16, 'Periodic', 'Update')
    --script:SetTimedMessage('name', 500, 'Periodic', 'Fire')
    
    starting_point = object.Named('StartingPoint')
    restricted_watch_obj = object.Named('RestrictedWatchObj')


    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 0)

    return true

end


function Timer(msg)

    local callbacks = {
        ['Update'] = Update,
        ['Fire'] = Fire,
        ['SetSuspiciousCooldown'] = SetSuspiciousCooldown
    }

    params = { ['data'] = msg.data }

    callbacks[msg.data[1]](params)

    return true

end


function SetRoom(msg)

    script.current_room = msg.data[1]

    return true

end


function SetSuspiciousInv(msg)

    script.suspicious_equipped = msg.data[1]

    return true

end


function SetSuspiciousCooldown(msg)

    script.suspicious_cooldown = msg.data[1]

    return true

end


function Fire()

    phys.LaunchProjectile(script.ObjId, -6830)

end


function Update()

    object.Teleport(starting_point, script.ObjId)

    if watch_obj ~= nil then
        object.Teleport(
            watch_obj,
            object.Position(script.ObjId) + vector(0.0, 0.0, GarrettHeight / 2)
        )
    end


    local min_priority = 0
    local min_value = 0
    local new_watch_obj = nil

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
                min_priority = priority
                min_value = value
                new_watch_obj = action['watch_obj']
            end

        end
        
    end

    property.Set(script.ObjId, 'SelfLit', min_value)

    if watch_obj ~= new_watch_obj then
        if watch_obj ~= nil then
            object.Teleport(watch_obj, vector(0, 0, 0))
        end
        watch_obj = new_watch_obj
    end

end