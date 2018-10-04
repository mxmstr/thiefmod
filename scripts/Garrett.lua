require 'Constants'
require 'SuspiciousActions'

local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv
local hook = lgs.DarkHookSrv
local abs = math.abs


function BeginScript(msg)

    script.room_rule = StandOnly

    script:SetTimedMessage('name', 16, 'Periodic', 'Update')

    --hook.DarkHookInitialize()
    --hook.InstallPropHook(msg.to, true, 'Position', msg.to)


    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 0)

    return true

end


function SetRoomRule(msg)

    local rule = property.Get(msg.data[1], 'DesignNote')
    script.room_rule = _G[rule]

    return true

end


function Timer(msg)

    if msg.data[1] == 'Update' then
        Update()
    end

end


function Update()

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