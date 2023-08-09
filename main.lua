require "love"
require "source/commander"
require "source/bullet"
require "source/enemy"

C = 64
RELOAD = 0.75
ENEMYTIMER = 1

function love.load()
	math.randomseed(os.time())
	player = Commander(416, 416)
	block = love.graphics.newImage("resources/block.png")
	enemy = love.graphics.newImage("resources/enemy.png")
	blocks = {
		{x = C*0.5, y = C*0.5},
		{x = C*0.5, y = C*1.5},
		{x = C*0.5, y = C*2.5},
		{x = C*0.5, y = C*3.5},
		{x = C*0.5, y = C*4.5},
		{x = C*0.5, y = C*8.5},
		{x = C*0.5, y = C*9.5},
		{x = C*0.5, y = C*10.5},
		{x = C*0.5, y = C*11.5},
		{x = C*0.5, y = C*12.5},

		{x = C*12.5, y = C*0.5},
		{x = C*12.5, y = C*1.5},
		{x = C*12.5, y = C*2.5},
		{x = C*12.5, y = C*3.5},
		{x = C*12.5, y = C*4.5},
		{x = C*12.5, y = C*8.5},
		{x = C*12.5, y = C*9.5},
		{x = C*12.5, y = C*10.5},
		{x = C*12.5, y = C*11.5},
		{x = C*12.5, y = C*12.5},

		{x = C*0.5, y = C*0.5},
		{x = C*1.5, y = C*0.5},
		{x = C*2.5, y = C*0.5},
		{x = C*3.5, y = C*0.5},
		{x = C*4.5, y = C*0.5},
		{x = C*8.5, y = C*0.5},
		{x = C*9.5, y = C*0.5},
		{x = C*10.5, y = C*0.5},
		{x = C*11.5, y = C*0.5},
		{x = C*12.5, y = C*0.5},

		{x = C*0.5, y = C*12.5},
		{x = C*1.5, y = C*12.5},
		{x = C*2.5, y = C*12.5},
		{x = C*3.5, y = C*12.5},
		{x = C*4.5, y = C*12.5},
		{x = C*8.5, y = C*12.5},
		{x = C*9.5, y = C*12.5},
		{x = C*10.5, y = C*12.5},
		{x = C*11.5, y = C*12.5},
		{x = C*12.5, y = C*12.5},
	}

	pep = {
		{x = C*5.5, y = C*0.5},
		{x = C*6.5, y = C*0.5},
		{x = C*7.5, y = C*0.5},

		{x = C*5.5, y = C*12.5},
		{x = C*6.5, y = C*12.5},
		{x = C*7.5, y = C*12.5},

		{x = C*0.5, y = C*5.5},
		{x = C*0.5, y = C*6.5},
		{x = C*0.5, y = C*7.5},

		{x = C*12.5, y = C*5.5},
		{x = C*12.5, y = C*6.5},
		{x = C*12.5, y = C*7.5},
	}
	projectiles = {}
	enemies = {}
	reload = RELOAD
	enemyTimer = ENEMYTIMER
end

function love.update(dt)
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isDown("a") then
		player:move("left", dt)
	end
	if love.keyboard.isDown("d") then
		player:move("right", dt)
	end
	if love.keyboard.isDown("w") then
		player:move("back", dt)
	end
	if love.keyboard.isDown("s") then
		player:move("front", dt)
	end

	enemyTimer = enemyTimer + dt

	if enemyTimer >= ENEMYTIMER then
		enemyTimer = 0
		local p = math.random(1, 12)
		table.insert(enemies, Enemy(pep[p].x, pep[p].y))
	end

	if reload >= RELOAD then
		if love.keyboard.isDown("left") then	
			if love.keyboard.isDown("up") then	
				table.insert(projectiles, Bullet(player.position.x, player.position.y, -0.7, -0.7))
			elseif love.keyboard.isDown("down") then	
				table.insert(projectiles, Bullet(player.position.x, player.position.y, -0.7, 0.7))
			else
				table.insert(projectiles, Bullet(player.position.x, player.position.y, -1, 0))
			end
			reload = 0
		elseif love.keyboard.isDown("right") then
			if love.keyboard.isDown("up") then	
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 0.7, -0.7))
			elseif love.keyboard.isDown("down") then	
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 0.7, 0.7))
			else
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 1, 0))
			end
			reload = 0
		elseif love.keyboard.isDown("up") then
			table.insert(projectiles, Bullet(player.position.x, player.position.y, 0, -1))
			reload = 0
		elseif love.keyboard.isDown("down") then
			table.insert(projectiles, Bullet(player.position.x, player.position.y, 0, 1))
			reload = 0
		end
	else
		reload = reload + dt
	end

	for i, v in pairs(projectiles) do
		v:move(dt)
		if v.position.x < 64 or v.position.x > 768 or v.position.y < 64 or v.position.y > 764 then
			table.remove(projectiles, i)
		end
	end	
	
	local _i = 1
	local _n = table.getn(enemies)
	while _i <= _n do
		enemies[_i]:move(dt, player.position)

		if math.abs(enemies[_i].position.x-player.position.x)<64 and math.abs(enemies[_i].position.y-player.position.y)<64 then
			love.event.quit()	
		end

		local valid = true
		for i, v in pairs(projectiles) do
			if math.abs(enemies[_i].position.x-v.position.x)<32 and math.abs(enemies[_i].position.y-v.position.y)<32 then
				valid = false
				break
			end
		end

		if valid then
			_i = _i+1
		else
			table.remove(enemies, _i)
			_n = _n - 1
		end
	end
end

function love.draw()
	love.graphics.clear(0.0, 0.1, 0.2)
	player:draw()
	for i, b in pairs(blocks) do
		love.graphics.draw(block, b.x, b.y, 0, 1, 1, 32, 32)
	end
	love.graphics.setColor(1, 1, 0, 1)
	for i, v in pairs(projectiles) do
		v:draw()
	end
	for i, v in pairs(enemies) do
		v:draw(enemy)
	end
	love.graphics.setColor(1, 1, 1, 1)
end
