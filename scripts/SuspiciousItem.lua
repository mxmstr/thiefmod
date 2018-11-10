require 'Constants'


function BeginScript(msg)

    return true

end


function FrobInvBegin(msg)

    print('FrobInvBegin')

    return true

end


function FrobInvEnd(msg)

    print('FrobInvEnd')

    return true

end
    
    
function FrobToolBegin(msg)

    print('FrobToolBegin')

    return true

end
    
    
function FrobToolEnd(msg)

    print('FrobToolEnd')

    return true

end
    
    
function FrobWorldBegin(msg)

    print('FrobWorldBegin')

    return true

end


function FrobWorldEnd(msg)

    print('FrobWorldEnd')

    return true

end
    
    
function InvDeFocus(msg)

    print('InvDeFocus')

    return true

end
    
    
function InvDeSelect(msg)

    print('InvDeSelect')

    local garrett = object.FindClosestObjectNamed(StartingPoint, 'NewGarrett')
    script:SendMessage(garrett, 'SetSuspiciousInv', false)

    return true

end
        
        
function InvFocus(msg)

    print('InvFocus')

    return true

end

    
function InvSelect(msg)

    print('InvSelect')

    local garrett = object.FindClosestObjectNamed(StartingPoint, 'NewGarrett')
    script:SendMessage(garrett, 'SetSuspiciousInv', true)

    return true

end


function WorldDeFocus(msg)

    print('WorldDeFocus')

    return true

end


function WorldDeSelect(msg)

    print('WorldDeSelect')

    return true

end


function WorldFocus(msg)

    print('WorldFocus')

    return true

end


function WorldSelect(msg)

    print('WorldSelect')

    return true

end