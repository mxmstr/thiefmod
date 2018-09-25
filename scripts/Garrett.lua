local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv
local hook = lgs.DarkHookSrv
local round = math.round
local square = math.sqrt

local speed_max = 0.19
local light_max = 12
local light_decay_time_max = 100
local light_decay_time = light_decay_time_max
local last_pos = nil



local GetDistance = function(a, b)

    local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
    return square(x * x + y * y + z * z)

end


function BeginScript(msg)

    hook.DarkHookInitialize()
    hook.InstallPropHook(msg.to, true, 'Position', msg.to)


    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 0)

    return true

end


function DHNotify(msg)

    local new_pos = property.Get(msg.to, 'Position', 'Location')

    if last_pos ~= nil and last_pos ~= new_pos then

        light_decay_time = 0

        local dist = GetDistance(new_pos, last_pos)
        local light = (dist / speed_max) * light_max

        property.Set(msg.to, 'SelfLit', round(light))

    else

        if light_decay_time > light_decay_time_max then
            property.Set(msg.to, 'SelfLit', 0)
        else
            light_decay_time = light_decay_time + 1
        end

    end


    last_pos = new_pos

    return true

end