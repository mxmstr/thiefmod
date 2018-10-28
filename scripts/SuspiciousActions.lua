require 'Constants'

local light_max = 12

-- Triggers

InStandZone = function(script)

    return script.current_room == nil or object.HasMetaProperty(script.current_room, StandZone)

end

InWalkZone = function(script)

    return script.current_room == nil or object.HasMetaProperty(script.current_room, WalkZone)

end

Trespassing = function(script)

    return script.current_room == nil or object.HasMetaProperty(script.current_room, RestrictedArea)

end

-- Sources

AlwaysTrue = function(script)

    return 1

end

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
        light_multiplier = 30
    },
    { 
        priority = 1,
        trigger = InWalkZone,
        value_source = GetSpeed, 
        value_target = 0.085,
        value_max = 0.2,
        light_multiplier = 60
    },
    { 
        priority = 2,
        trigger = Trespassing,
        value_source = AlwaysTrue, 
        value_target = 0,
        value_max = 1,
        light_multiplier = 100
    }
}