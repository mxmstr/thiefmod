local object = lgs.ObjectSrv


function BeginScript(msg)

    print('Start '..tostring(msg.to)..' '..tostring(object.GetName(msg.to)))
    
    return true

end


function PhysCollision(msg)

    print('Collision '..tostring(msg.to)..' '..tostring(object.GetName(msg.to)))
    
    return true

end


function PhysContactCreate(msg)

    print('Create '..tostring(msg.to)..' '..tostring(object.GetName(msg.to)))
    
    return true

end


function PhysContactEnter(msg)

    print('Enter '..tostring(msg.to)..' '..tostring(object.GetName(msg.to)))
    
    return true

end


function PhysMadePhysical(msg)

    print('Physical '..tostring(msg.to)..' '..tostring(object.GetName(msg.to)))
    
    return true

end


function PhysWokeUp(msg)

    print('WokeUp '..tostring(msg.to)..' '..tostring(object.GetName(msg.to)))
    
    return true

end