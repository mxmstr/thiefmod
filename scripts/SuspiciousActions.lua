require 'Constants'

local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local square = math.sqrt

local light_max = 12

-- Triggers

InStandZone = function(script)

    return script.room_rule == StandOnly

end

InWalkZone = function(script)

    return script.room_rule == WalkOnly

end

-- Sources

local dist = 0
local light_decay_time_max = 100
local light_decay_time = light_decay_time_max
local last_pos = nil

GetDistance = function(a, b)

    local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
    return square(x * x + y * y + z * z)

end

GetSpeed = function(id)

    local new_pos = property.Get(id, 'Position', 'Location')

    if last_pos ~= nil and last_pos ~= new_pos then
        light_decay_time = 0
        dist = GetDistance(new_pos, last_pos)
    else
        if light_decay_time < light_decay_time_max then
            light_decay_time = light_decay_time + 1
        else
            dist = 0
        end
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
        value_max = 0.067,
        light_multiplier = 12 
    },
    { 
        priority = 0,
        trigger = InWalkZone,
        value_source = GetSpeed, 
        value_target = 0.028,
        value_max = 0.067,
        light_multiplier = 12 
    }
}