if SERVER then
    util.AddNetworkString("wskyf4menu")

    function wskyF4Menu(ply)
        net.Start("wskyf4menu")
        net.Send(ply)
    end
    hook.Add( "ShowSpare2", "F4MenuHook", wskyF4Menu)
end

