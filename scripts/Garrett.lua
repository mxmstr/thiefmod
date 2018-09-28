require 'SuspiciousActions'

local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv
local hook = lgs.DarkHookSrv
local abs = math.abs


function BeginScript(msg)

    hook.DarkHookInitialize()
    hook.InstallPropHook(msg.to, true, 'Position', msg.to)


    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 0)

    return true

end


function DHNotify(msg)

    local min_priority = 0
    local min_value = 0

    for key, action in pairs(actions) do

        local mult = action['light_multiplier']
        local trigger = action['trigger']
        local priority = action['priority']
        local value = action['value_source'](msg.to)
        value = abs(value - action['value_target'])
        value = value / action['value_max']
        value = value * mult

        if trigger(msg.to) and priority >= min_priority and value >= min_value then
            property.Set(msg.to, 'SelfLit', value)
            min_priority = priority
            min_value = value
        end
        
    end

    return true

end