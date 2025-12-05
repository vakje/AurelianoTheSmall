local Player = require("Player")
local Enemy  = require("Enemy")
local Coin   = require("Coin")
local Camera = require("Camera")
local Particle = require("Particle") 
local Button = require("Button")     
local Audio  = require("Audio")      


local GameState = {
    MENU = "menu",
    GAMEPLAY = "gameplay",
    GAME_OVER = "game_over"
}
local currentState = GameState.MENU


local player 
local enemies = {}
local coins = {}
local particles = {} 
local menuButtons = {}
local guiFont


local cam
local VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 640, 480
local background


local score = 0
local highScore = 0
local lastEnemyScore = 0


local function spawnCoin()
    local coinSize = 16
    local x = math.random(0, VIRTUAL_WIDTH - coinSize)
    local y = math.random(0, VIRTUAL_HEIGHT - coinSize)
    return Coin.new(x, y)
end

local function spawnEnemy()
    local enemySize = 32
    local x, y
    repeat
        x = math.random(0, VIRTUAL_WIDTH - enemySize)
        y = math.random(0, VIRTUAL_HEIGHT - enemySize)
    
    until not player:checkCollision({x = x, y = y, width = enemySize * 2, height = enemySize * 2})

   
    table.insert(enemies, Enemy.new(x, y, player))
end

local function resetGame()
   
    if player then
        player:reset()
    end
    enemies = {}
    coins = {}
    particles = {}
    score = 0
    lastEnemyScore = 0

  
    table.insert(enemies, Enemy.new(30, 30, player))
    table.insert(enemies, Enemy.new(VIRTUAL_WIDTH - 60, VIRTUAL_HEIGHT - 60, player))

   
    for i = 1, 5 do
        table.insert(coins, spawnCoin())
    end
end

local function setupMenu()
    local centerX = VIRTUAL_WIDTH / 2
    local centerY = VIRTUAL_HEIGHT / 2

    menuButtons = {
        Button.new(centerX - 100, centerY - 50, 200, 40, "Start Game", function()
            currentState = GameState.GAMEPLAY
            resetGame() 
            Audio.play('start')
        end),
        Button.new(centerX - 100, centerY + 10, 200, 40, "Quit", function()
            love.event.quit()
        end),
    }
end


function love.load()
    
    background = love.graphics.newImage("assets/preview.png")
    love.graphics.setDefaultFilter("nearest", "nearest")
    guiFont = love.graphics.newFont(16)
    love.graphics.setFont(guiFont)

   
    player = Player.new(VIRTUAL_WIDTH / 2 - 16, VIRTUAL_HEIGHT / 2 - 16)
    
   
    Audio.load({
        coin = "assets/coin.mp3",
        hit = "assets/hit.mp3",
        start = "assets/start.mp3",
    })

    
    local windowWidth, windowHeight = love.graphics.getDimensions()
    cam = Camera.new(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, windowWidth, windowHeight)
    
   
    local savedHighScore = love.filesystem.read("highscore.txt")
    highScore = tonumber(savedHighScore) or 0

    setupMenu()
end

function love.update(dt)
   
    for i = #particles, 1, -1 do
        particles[i]:update(dt)
        if particles[i].dead then
            table.remove(particles, i)
        end
    end
    
    if currentState == GameState.GAMEPLAY then
        player:update(dt)

    
        for _, enemy in ipairs(enemies) do
            enemy:update(dt, score) 
            
            if player:checkCollision(enemy) then
                Audio.play('hit')
                currentState = GameState.GAME_OVER

               
                if score > highScore then
                    highScore = score
                    love.filesystem.write("highscore.txt", tostring(highScore))
                end
            end
        end

     
        for i = #coins, 1, -1 do
            local coin = coins[i]
            coin:update(dt)
            if player:checkCollision(coin) then
                Audio.play('coin')
                table.remove(coins, i)
                score = score + 1

                table.insert(particles, Particle.new(coin.x + coin.width/2, coin.y + coin.height/2, {1, 1, 0, 1}))
            end
        end

       
        local currentScore = tonumber(score) or 0
        local lastCheckedScore = tonumber(lastEnemyScore) or 0

        if currentScore > 0 and currentScore % 5 == 0 and currentScore ~= lastCheckedScore then
            spawnEnemy()
            lastEnemyScore = currentScore
        end

      
        if #coins == 0 then
            for i = 1, math.max(5, math.floor(currentScore/10)) do 
                table.insert(coins, spawnCoin())
            end
        end
    
    elseif currentState == GameState.MENU then
        
        for _, button in ipairs(menuButtons) do
            button:update(dt)
        end

    elseif currentState == GameState.GAME_OVER then
       
    end
end

function love.draw()
    cam:start()

    love.graphics.draw(background, 0, 0, 0, VIRTUAL_WIDTH / background:getWidth(), VIRTUAL_HEIGHT / background:getHeight())
    
    if currentState == GameState.GAMEPLAY or currentState == GameState.GAME_OVER then
       
        player:draw()
        for _, enemy in ipairs(enemies) do enemy:draw() end
        for _, coin in ipairs(coins) do coin:draw() end
        
       
        for _, p in ipairs(particles) do p:draw() end

       
        love.graphics.setFont(guiFont)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. tostring(score), 10, 10)
        love.graphics.print("High Score: " .. tostring(highScore), 10, 30)

       
        if currentState == GameState.GAME_OVER then
            love.graphics.setColor(0, 0, 0, 0.7)
            love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
            love.graphics.setColor(1, 0.2, 0.2)
            love.graphics.printf("GAME OVER", 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, "center")
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("Press SPACE to return to Menu", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, "center")
        end

    elseif currentState == GameState.MENU then
       
        love.graphics.setColor(0.3, 0.3, 0.5)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.printf("AURELIANO THE SMALL", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, "center")
        
        for _, button in ipairs(menuButtons) do
            button:draw()
        end
    end

    love.graphics.setColor(1, 1, 1)
    cam:stop()
end

function love.mousepressed(x, y, button)
    local virtualX = (x - cam.offsetX) / cam.scale
    local virtualY = (y - cam.offsetY) / cam.scale

    if currentState == GameState.MENU and button == 1 then
        for _, btn in ipairs(menuButtons) do
            btn:checkClick(virtualX, virtualY)
        end
    end
end

function love.mousemoved(x, y)
    local virtualX = (x - cam.offsetX) / cam.scale
    local virtualY = (y - cam.offsetY) / cam.scale

    if currentState == GameState.MENU then
        for _, btn in ipairs(menuButtons) do
            btn:checkHover(virtualX, virtualY)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        if currentState == GameState.GAMEPLAY then
            currentState = GameState.MENU
            setupMenu()
        elseif currentState == GameState.MENU then
            love.event.quit()
        end
    --Handle returning to menu from GAME_OVER state
    elseif key == 'space' and currentState == GameState.GAME_OVER then
        setupMenu()
        currentState = GameState.MENU
    end
end