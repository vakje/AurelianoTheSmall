local Camera = {}
Camera.__index = Camera
-- for scaling window
function Camera.new(virtualWidth, virtualHeight, windowWidth, windowHeight)
    local self = setmetatable({}, Camera)
    self.vw, self.vh = virtualWidth, virtualHeight
    self.ww, self.wh = windowWidth, windowHeight
    self.scaleX = windowWidth / virtualWidth
    self.scaleY = windowHeight / virtualHeight
    self.scale = math.min(self.scaleX, self.scaleY)
    self.offsetX = (windowWidth - virtualWidth * self.scale) / 2
    self.offsetY = (windowHeight - virtualHeight * self.scale) / 2
    return self
end

function Camera:start()
    love.graphics.push()
    love.graphics.translate(self.offsetX, self.offsetY)
    love.graphics.scale(self.scale)
end

function Camera:stop()
    love.graphics.pop()
end

return Camera