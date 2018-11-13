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

local equip_timer = nil

SuspiciousEquipped = function(script)

    if script.suspicious_equipped == 1 then

        if equip_timer ~= nil then
            script:KillTimedMessage(equip_timer)
        end

        script.suspicious_cooldown = 1
        equip_timer = script:SetTimedMessage('DisableCooldown', 1000, 'OneShot', 'SetSuspiciousCooldown', false)

    end

    return script.suspicious_cooldown == 1

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
        light_multiplier = 40,
        watch_obj = nil
    },
    { 
        priority = 1,
        trigger = InWalkZone,
        value_source = GetSpeed, 
        value_target = 0.085,
        value_max = 0.2,
        light_multiplier = 80,
        watch_obj = nil
    },
    { 
        priority = 2,
        trigger = Trespassing,
        value_source = AlwaysTrue, 
        value_target = 0,
        value_max = 1,
        light_multiplier = 100,
        watch_obj = RestrictedWatchObj
    },
    {
        priority = 3,
        trigger = SuspiciousEquipped,
        value_source = AlwaysTrue, 
        value_target = 0,
        value_max = 1,
        light_multiplier = 100,
        watch_obj = CrimeWatchObj
    }
}