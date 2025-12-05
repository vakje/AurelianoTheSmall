local Enemy = {}
Enemy.__index = Enemy

local function pentagonPoints(x, y, size)
    local points = {}
    for i = 0, 4 do
        local angle = (2 * math.pi / 5) * i - math.pi/2
        table.insert(points, x + math.cos(angle) * size)
        table.insert(points, y + math.sin(angle) * size)
    end
    return points
end

function Enemy.new(x, y, playerRef)
    local self = setmetatable({}, Enemy)
    self.x, self.y = x, y
    self.width, self.height = 32, 32
    self.speed = math.random(80, 120) 
    self.player = playerRef 
    self.color = {math.random(), math.random()/2, math.random()/2} 
    self.maxSpeed = 300 
    self.vx, self.vy = 0, 0 
    self.rotation = 0 
    
    return self
end

function Enemy:update(dt, score)
    -- AI DECISION MAKING 
    local targetX = self.player.x + self.player.width / 2
    local targetY = self.player.y + self.player.height / 2
    local centerX = self.x + self.width / 2
    local centerY = self.y + self.height / 2

    local dx = targetX - centerX
    local dy = targetY - centerY
    local dist = math.sqrt(dx*dx + dy*dy)

    if dist > 1 then
        -- Normalize direction vector
        local vx_norm = dx / dist
        local vy_norm = dy / dist

       
        local currentSpeed = math.min(self.maxSpeed, self.speed + score * 5) 

        self.vx = vx_norm * currentSpeed
        self.vy = vy_norm * currentSpeed
        
        self.x = self.x + self.vx * dt
        self.y = self.y + self.vy * dt
    end
    
  
    self.rotation = self.rotation + dt * 2 

    -- Clamp position to boundaries 
    self.x = math.max(0, math.min(self.x, 640 - self.width))
    self.y = math.max(0, math.min(self.y, 480 - self.height))
end

function Enemy:draw()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    local centerX = self.x + self.width/2
    local centerY = self.y + self.height/2
    local radius = math.min(self.width, self.height)/2
    
   
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.polygon("fill", pentagonPoints(centerX + 1, centerY + 1, radius))
    
 
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], 1)
    love.graphics.push()
    love.graphics.translate(centerX, centerY)
    love.graphics.rotate(self.rotation)
    love.graphics.polygon("fill", pentagonPoints(0, 0, radius))
    love.graphics.pop()
    
    love.graphics.setColor(1, 1, 1) -- Reset color
end

return Enemy