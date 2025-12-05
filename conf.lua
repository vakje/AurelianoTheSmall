function love.conf(t)
    t.window.title = "Aureliano The small - The Chase"
    t.window.width = 1280
    t.window.height = 960
    t.window.vsync = 1
    t.window.resizable = false
    t.window.msaa = 2
    t.window.fullscreen = false

    t.modules.joystick = false
    t.modules.physics  = false
    t.modules.touch    = false
    t.modules.video    = false
end