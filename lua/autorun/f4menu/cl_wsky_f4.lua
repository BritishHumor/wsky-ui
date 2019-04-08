if CLIENT then
    net.Receive("wskyf4menu", function()
        if(!frame) then
            local frame = vgui.Create("DFrame")
            frame:SetSize(1000, 720)
            frame:Center()
            frame:SetVisible(true)
            frame:MakePopup()
            frame:SetDeleteOnClose(true)
        end
    end)
end