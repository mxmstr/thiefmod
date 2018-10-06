require 'Constants'


function BeginScript(msg)

    ui.TextMessage(tostring(property.Remove(msg.to, 'M-AlertCapZero')))

    script:SetTimedMessage('name', 16, 'Periodic', 'Update')

    return true

end


function Custom(msg)

    --ui.TextMessage('asdf')
    return true

end


function Timer(msg)

    if msg.data[1] == 'Update' then
        Update()
    end

end


function Update()



end