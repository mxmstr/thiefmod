local ui = lgs.DarkUISrv
local property = lgs.PropertySrv
local link = lgs.LinkSrv
local hook = lgs.DarkHookSrv
local round = math.round
local square = math.sqrt

local last_pos = nil



local GetDistance = function(a, b)

    local num1 = round(a.x, 0)
    local num2 = round(b.x, 0)
    --num1 = num1 + round(a.x)
    ui.TextMessage(a.x - b.x)
    --ui.TextMessage( tostring( + b.x) )

    local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
    return square(x * x + y * y + z * z)

end


function BeginScript(msg)

    --hook.DarkHookInitialize()
    print(hook.InstallPropHook(msg.to, true, 'Position', msg.to))


    property.Add(msg.to, 'SelfLit')
    property.Set(msg.to, 'SelfLit', 0)

    return true

end


function PhysicsMessages(msg)

    --tostring(msg.to)..tostring(mgs.from))

    return true

end


function DHNotify(msg)

    local new_pos = property.Get(msg.to, 'Position')

    
    print('asdf')

    if last_pos ~= nil then
        print(tostring(new_pos))
        print(tostring(last_pos))
        --local dist = GetDistance(new_pos, last_pos)
        --ui.TextMessage(tostring(dist))
    end

    last_pos = new_pos

    return true

end