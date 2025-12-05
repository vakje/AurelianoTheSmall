local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.x, self.y = x, y
    self.speed = 200
    self.width, self.height = 32, 32
    self.originalX, self.originalY = x, y


    self.frames = {}
    for i = 1, 6 do
    
        self.frames[i] = love.graphics.newImage(string.format("assets/player-run-%d.png", i))
    end

    self.currentFrame = 1
    self.animationTimer = 0
    self.frameDuration = 0.1

    return self
end

function Player:update(dt)
    local moveX, moveY = 0, 0
    if love.keyboard.isDown("w") then moveY = moveY - 1 end
    if love.keyboard.isDown("s") then moveY = moveY + 1 end
    if love.keyboard.isDown("a") then moveX = moveX - 1 end
    if love.keyboard.isDown("d") then moveX = moveX + 1 end

    local magnitude = math.sqrt(moveX * moveX + moveY * moveY)
    local moving = magnitude > 0

    if moving then
        moveX, moveY = moveX / magnitude, moveY / magnitude
        self.x = self.x + moveX * self.speed * dt
        self.y = self.y + moveY * self.speed * dt

   
        self.x = math.max(0, math.min(self.x, 640 - self.width))
        self.y = math.max(0, math.min(self.y, 480 - self.height))

      
        self.animationTimer = self.animationTimer + dt
        if self.animationTimer >= self.frameDuration then
            self.currentFrame = (self.currentFrame % #self.frames) + 1
            self.animationTimer = 0
        end
    else
      
        self.currentFrame = 1
    end
end

function Player:draw()
    love.graphics.draw(self.frames[self.currentFrame], self.x, self.y)
end

function Player:checkCollision(obj)
 
    return self.x < obj.x + obj.width and
           obj.x < self.x + self.width and
           self.y < obj.y + obj.height and
           obj.y < self.y + self.height
end

function Player:reset()
  
    self.x = self.originalX
    self.y = self.originalY
end

return Player