require 'SuspiciousActions'

local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv
local hook = lgs.DarkHookSrv
local abs = math.abs
local round = math.round
local square = math.sqrt


function BeginScript(msg)

    hook.DarkHookInitialize()
    hook.InstallPropHook(msg.to, true, 'Position', msg.to)


    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 0)

    return true

end


function GetValue()

    

end


function DHNotify(msg)

    local min_priority = 0
    local min_value = 0

    for key, action in pairs(SuspiciousActions.actions) do

        local mult = action['light_multiplier']
        local trigger = action['trigger']()
        local priority = action['priority']
        local value = best_action['value_source']()
        value = abs(value - best_action['value_target'])
        value = value / best_action['value_max']

        if trigger and priority >= min_priority and value >= min_value then
            min_priority = priority
            min_value = value
            property.Set(msg.to, 'SelfLit', value * mult)
        end
        
    end


    --[[local new_pos = property.Get(msg.to, 'Position', 'Location')

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


    last_pos = new_pos]]

    return true

end