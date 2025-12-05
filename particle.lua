local Particle = {}
Particle.__index = Particle

function Particle.new(x, y, color)
    local self = setmetatable({}, Particle)
    self.x, self.y = x, y
    self.color = color or {1, 1, 1, 1}
    self.life = 0.5 
    self.maxLife = self.life
    self.size = math.random(3, 8)
    self.dead = false

 
    self.currentSize = self.size 

 
    local angle = math.random() * 2 * math.pi
    local speed = math.random(50, 150)
    self.vx = math.cos(angle) * speed
    self.vy = math.sin(angle) * speed

    return self
end

function Particle:update(dt)
    self.life = self.life - dt

    if self.life <= 0 then
        self.dead = true
        return
    end

 
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt


    local ratio = self.life / self.maxLife
    self.color[4] = ratio
    self.currentSize = self.size * ratio
end

function Particle:draw()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
 
    love.graphics.circle("fill", self.x, self.y, self.currentSize / 2)
    love.graphics.setColor(1, 1, 1, 1) 
end

return Particle