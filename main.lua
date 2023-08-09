require "love"
require "source/data"
require "source/commander"
require "source/bullet"
require "source/enemy"
require "source/menu"

function love.load()
	math.randomseed(os.time())
	player = Commander(416, 416)
	blockTexture = love.graphics.newImage("resources/block.png")
	enemyTexture = love.graphics.newImage("resources/enemy.png")
	logoTexture = love.graphics.newImage("resources/logo.png")
	projectiles = {}
	enemies = {}
	reload = RELOAD
	enemyTimer = ENEMYTIMER
	game = false
	menu = Menu(logoTexture)
end

function love.keyreleased(key)
	if key == "escape" then
		game = not game
	end
end

function love.update(dt)
	if game then
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

		if enemyTimer >= ENEMYTIMER then
			enemyTimer = 0
			local p = math.random(1, 12)
			table.insert(enemies, Enemy(pep[p].x, pep[p].y, enemyTexture))
		end
		
		local _i = 1
		local _n = table.getn(enemies)
		while _i <= _n do
			enemies[_i]:move(dt, player.position)

			if math.abs(enemies[_i].position.x-player.position.x)<C and math.abs(enemies[_i].position.y-player.position.y)<C then
				love.event.quit()	
			end

			local valid = true
			for i, v in pairs(projectiles) do
				if math.abs(enemies[_i].position.x-v.position.x)<C/2 and math.abs(enemies[_i].position.y-v.position.y)<C/2 then
					valid = false
					table.remove(projectiles, i)
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
	else
		if love.keyboard.isDown("q") then
			love.event.quit()
		end
	end
end

function love.draw()
	love.graphics.clear(0.0, 0.1, 0.2)
	player:draw()
	for i, b in pairs(blocks) do
		love.graphics.draw(blockTexture, b.x, b.y, 0, 1, 1, 32, 32)
	end
	love.graphics.setColor(1, 1, 0, 1)
	for i, v in pairs(projectiles) do
		v:draw()
	end
	for i, v in pairs(enemies) do
		v:draw()
	end
	love.graphics.setColor(1, 1, 1, 1)

	if not game then
		menu:draw()
	end
end
