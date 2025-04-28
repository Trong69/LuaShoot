function love.load()
    sprites = {}
    sprites.background = love.graphics.newImage('resource/background.png')
    sprites.bullet = love.graphics.newImage('resource/bullet.png')
    sprites.player = love.graphics.newImage('resource/player.png')
    sprites.zombie = love.graphics.newImage('resource/zombie.png')

    player = {}
    player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()/2 

    playerSpeed = 180
    tempRotation = 0

    zombies ={}
end

function love.update(dt)
    if love.keyboard.isDown("a") then
        player.x = player.x - playerSpeed *dt
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + playerSpeed *dt
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - playerSpeed *dt
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + playerSpeed *dt
    end

    for i, z in ipairs(zombies) do
        z.x = z.x +(math.cos(ZombieAngle(z)) * z.speed * dt)
        z.y = z.y +(math.sin(ZombieAngle(z)) * z.speed * dt)
    end

    
end

function love.keypressed( key)
    if key == "space" then
        spawnZombie()
    end
    
end

function love.draw()
    --love.graphics.draw(sprites.background)
    --love.graphics.draw(sprites.bullet)
    love.graphics.draw(sprites.player,player.x,player.y,playerMouseAngle(), nil, nil,
    sprites.player:getWidth()/2,sprites.player:getHeight()/2)
    --love.graphics.draw(sprites.zombie)
    
    for i,z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie,z.x,z.y,ZombieAngle(z),nil,nil,
            sprites.zombie:getWidth()/2,sprites.zombie:getHeight()/2)
    end

end

function playerMouseAngle()
    return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function ZombieAngle(zombie)
    return math.atan2( player.y-zombie.y, player.x-zombie.x)
end

function spawnZombie()
    local zombie ={}
    zombie.x = math.random(sprites.zombie:getWidth(),
        love.graphics.getWidth() - sprites.zombie:getWidth())
    zombie.y = math.random(sprites.zombie:getHeight(),
        love.graphics.getHeight() - sprites.zombie:getHeight())
    zombie.speed = 135
    table.insert(zombies,zombie)
end