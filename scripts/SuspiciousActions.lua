local light_max = 12


-- Triggers

local InStandZone = function()

    return true

end

local InWalkZone = function()

    return false

end

-- Sources

local dist = 0
local light_decay_time_max = 100
local light_decay_time = light_decay_time_max
local last_pos = nil

local GetDistance = function(a, b)

    local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
    return square(x * x + y * y + z * z)

end

local GetSpeed = function()

    local new_pos = property.Get(msg.to, 'Position', 'Location')

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



local actions = {
    { 
        priority = 0,
        trigger = InStandZone,
        value_source = GetSpeed, 
        value_target = 0,
        value_max = 0.19,
        light_multiplier = 12 
    },
    { 
        priority = 1,
        trigger = InWalkZone,
        value_source = GetSpeed, 
        value_target = 0.08,
        value_max = 0.19,
        light_multiplier = 12 
    }
}