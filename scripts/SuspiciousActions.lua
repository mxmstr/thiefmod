require 'Constants'

local light_max = 12

-- Triggers

InStandZone = function(script)

    return script.room_rule == StandOnly

end

InWalkZone = function(script)

    return script.room_rule == WalkOnly

end

-- Sources

local last_pos = nil

GetDistance = function(a, b)

    local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
    return square(x * x + y * y + z * z)

end

GetSpeed = function(script)

    local dist = 0
    local new_pos = property.Get(script.ObjId, 'Position', 'Location')

    if last_pos ~= nil then
        dist = GetDistance(new_pos, last_pos)
    end

    last_pos = new_pos

    return dist

end



actions = {
    { 
        priority = 0,
        trigger = InStandZone,
        value_source = GetSpeed, 
        value_target = 0,
        value_max = 0.2,
        light_multiplier = 12 
    },
    { 
        priority = 0,
        trigger = InWalkZone,
        value_source = GetSpeed, 
        value_target = 0.085,
        value_max = 0.2,
        light_multiplier = 12 
    }
}