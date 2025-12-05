local Button = {}
Button.__index = Button

function Button.new(x, y, w, h, text, callback)
    local self = setmetatable({}, Button)
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.text = text
    self.callback = callback
    self.isHovered = false
    self.baseColor = {0.1, 0.1, 0.3} -- Dark blue
    self.hoverColor = {0.3, 0.3, 0.6} -- Lighter blue
    return self
end

function Button:update(dt)
    
end

function Button:checkHover(mx, my)
    self.isHovered = (mx >= self.x and mx <= self.x + self.w and
                     my >= self.y and my <= self.y + self.h)
end

function Button:checkClick(mx, my)
    if self.isHovered then
        self.callback()
        return true
    end
    return false
end

function Button:draw()
    local color = self.isHovered and self.hoverColor or self.baseColor
    
   
    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 0, 0, 0.5) 
    love.graphics.rectangle("fill", self.x + 2, self.y + 2, self.w, self.h, 5, 5)

    love.graphics.setColor(color[1], color[2], color[3], 1)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 5, 5)

    love.graphics.setColor(1, 1, 1) 
    love.graphics.printf(self.text, self.x, self.y + self.h / 4, self.w, "center")
    
    love.graphics.setLineWidth(1)
end

return Button