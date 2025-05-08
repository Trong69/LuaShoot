function love.load()
    math.randomseed(os.time())
    sprites = {}
    sprites.background = love.graphics.newImage('resource/background.png')
    sprites.bullet = love.graphics.newImage('resource/bullet.png')
    sprites.player = love.graphics.newImage('resource/player.png')
    sprites.zombie = love.graphics.newImage('resource/zombie.png')

    player = {}
    player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()/2 
    
    player.lowHealth = false 
    playerSpeed = 180
    tempRotation = 0

    zombies = {}
    bullets = {}

    myFont = love.graphics.newFont(30)
    gameState = 1
    maxTime = 2 
    timer = maxTime
    score = 0
end

function love.update(dt)
    if gameState == 2 then    
        if love.keyboard.isDown("a") and player.x > 0 then
            player.x = player.x - playerSpeed *dt
        end
        if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
            player.x = player.x + playerSpeed *dt
        end
        if love.keyboard.isDown("w") and player.y > 0 then
            player.y = player.y - playerSpeed *dt
        end
        if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
            player.y = player.y + playerSpeed *dt
        end
    end
    for i, z in ipairs(zombies) do
        z.x = z.x +(math.cos(ZombieAngle(z)) * z.speed * dt)
        z.y = z.y +(math.sin(ZombieAngle(z)) * z.speed * dt)
        if distanceBetween(z.x,z.y,player.x,player.y) <28 and player.lowHealth == false then
            for index, value in ipairs(zombies) do
                table.remove(zombies,i)
                value.hit = true
                player.lowHealth = true
                playerSpeed = 360
            end
        elseif distanceBetween(z.x,z.y,player.x,player.y) <28 and player.lowHealth == true then
            for index, value in ipairs(zombies) do
                zombies[index] = nil
                gameState = 1
                player.x = love.graphics.getWidth()/2
                player.y = love.graphics.getHeight()/2 
                playerSpeed = 180
                player.lowHealth = false
            end
        end
    end

    if love.mouse.isDown(1) and gameState == 2 then
        spawnBullet()
    end
    for i, b in ipairs(bullets) do
        b.x = b.x +(math.cos(b.direction) * b.speed * dt)
        b.y = b.y +(math.sin(b.direction) * b.speed * dt)
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.x <0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets,i)
        end
    end

    for i, z in ipairs(zombies) do
        for j, b in ipairs(bullets) do
            if distanceBetween(z.x,z.y,b.x,b.y) < 20 then
                z.hit = true
                --b.hit = true
            end
        end
    end

    for i = #zombies, 1, -1 do
        local z = zombies[i]
        if z.hit == true then
            table.remove(zombies,i)
            score = score + 1
        end
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.hit == true then
            table.remove(bullets,i)
        end
    end

    if gameState == 2 then
        timer = timer - dt
        if timer <= 0  then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
    

end

function love.mousepressed(x,y, button)
    if button == 1 and gameState == 1 then
        spawnBullet()
        gameState = 2
        maxTime = 2
        timer = maxTime
        score = 0
    end
end

function love.draw()
    --love.graphics.draw(sprites.background)
    if gameState == 1 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Click to begin!", 0,50, love.graphics.getWidth(),"center")
    end

    if gameState == 2 then
        --love.graphics.print(score,0,0)
        if player.lowHealth == true then
            love.graphics.setColor(1, 0, 0)
       -- else 
        --    love.graphics.setColor(1, 1, 1)
        end
       
        love.graphics.draw(sprites.player,player.x,player.y,playerMouseAngle(), nil, nil,
        sprites.player:getWidth()/2,sprites.player:getHeight()/2)

        love.graphics.setColor(1, 1, 1) --color reset 
        --love.graphics.draw(sprites.zombie)
        
        for i,z in ipairs(zombies) do
            love.graphics.draw(sprites.zombie,z.x,z.y,ZombieAngle(z),nil,nil,
                sprites.zombie:getWidth()/2,sprites.zombie:getHeight()/2)
        end

        for i,b in ipairs(bullets) do
            love.graphics.draw(sprites.bullet,b.x,b.y,nil,0.5,0.5,
                sprites.bullet:getWidth()/2,sprites.bullet:getHeight()/2)
        end
    end
    love.graphics.print(score,0,0)
end

function playerMouseAngle()
    return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function ZombieAngle(zombie)
    return math.atan2( player.y-zombie.y, player.x-zombie.x)
end

function spawnZombie()
    local zombie ={}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 135
    zombie.hit = false

    local side = math.random(1,4)
    if side == 1 then
        zombie.x = -20
        zombie.y = math.random(0,love.graphics.getHeight())
    end
    if side == 2 then
        zombie.x = love.graphics.getWidth() + 20
        zombie.y = math.random(0,love.graphics.getHeight())
    end
    if side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -20
    end
    if side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 20
    end
    table.insert(zombies,zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x 
    bullet.y = player.y 
    bullet.speed = 450
    bullet.direction = playerMouseAngle()
    bullet.hit = false
    table.insert(bullets,bullet)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2-y1)^2)
end 