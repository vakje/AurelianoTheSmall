local Coin = {}
Coin.__index = Coin

function Coin.new(x, y)
    local self = setmetatable({}, Coin)
    self.x, self.y = x, y
    self.width, self.height = 16, 16
    self.baseY = y 
    self.timer = math.random() * 2 * math.pi 
    return self
end

function Coin:update(dt)
    self.timer = self.timer + dt * 3 
    -- siplle vertical floating anmatiion
    self.y = self.baseY + math.sin(self.timer) * 3
end

function Coin:draw()
    love.graphics.setColor(1, 0.8, 0) 
    local centerX = self.x + self.width / 2
    local centerY = self.y + self.height / 2
    local radius = self.width / 2
    
  
    love.graphics.setLineWidth(2)
    love.graphics.setColor(1, 0.9, 0.4, 1)
    love.graphics.circle("fill", centerX, centerY, radius)
    love.graphics.setColor(0.8, 0.5, 0, 1)
    love.graphics.circle("line", centerX, centerY, radius - 1)

    love.graphics.setColor(1, 1, 1) 
    love.graphics.setLineWidth(1)
end

return Coin