
local Audio = {}
local sounds = {}


-- assets/coin.mp3, assets/hit.mp3, assets/start.mp3
function Audio.load(files)
    for name, path in pairs(files) do
        local source = love.audio.newSource(path, "static")
        sounds[name] = source
    end
end

function Audio.play(name)
    local source = sounds[name]
    if source then
        source:play()
    else
        
    end
end

return Audio