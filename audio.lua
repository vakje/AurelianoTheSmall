-- Audio utility for simplified sound management
local Audio = {}
local sounds = {}

-- Requires simple WAV files in the assets folder:
-- assets/coin.wav, assets/hit.wav, assets/start.wav
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
        -- print("Warning: Sound " .. name .. " not found.")
    end
end

return Audio