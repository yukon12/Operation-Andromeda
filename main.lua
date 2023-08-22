require "love"
require "source/data"
require "source/commander"
require "source/bullet"
require "source/enemy"
require "source/menu"
require "source/timer"
require "source/title"
require "source/levelChoose"
require "source/lose"

function restart()
	projectiles = {}
	enemies = {}
	toBeRemoved = {}
	enemyTimer:reset()
	reloadTimer:reset()
	winTimer:reset()
end

function love.load()
	math.randomseed(os.time())

	blockTexture = love.graphics.newImage("resources/block.png")
	enemyTexture = love.graphics.newImage("resources/enemy.png")
	logoTexture = love.graphics.newImage("resources/logo.png")
	musicSound = love.audio.newSource("resources/song.wav", "static")
	laserSound = love.audio.newSource("resources/laser.mp3", "static")

	player = Commander(416, 416)
	menu = Menu(logoTexture)
	title = Title(logoTexture)
	lose = Lose()
	levelChoose = LevelChoose()
	enemyTimer = Timer(1)
	reloadTimer = Timer(0.5)
	winTimer = Timer(300)

	musicSound:setVolume(0.5)

	projectiles = {}
	enemies = {}
	toBeRemoved = {}

	mode = "title"
	level = 0
	playMusic = true
end

function love.keypressed(key)
	if mode == "title" then
		if key == "w" or key == "up" then
			title:moveUp()
		end
		if key == "s" or key == "down" then
			title:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			if title.chosen == 1 then
				mode = "levelChoose"
			elseif title.chosen == 2 then
				if playMusic then
					title.optionTexts[2] = "UNMUTE MUSIC"
					playMusic = false
					musicSound:stop()
				else
					title.optionTexts[2] = "MUTE MUSIC"
					playMusic = true
					musicSound:play()
				end
			elseif title.chosen == 3 then
				love.event.quit()
			end
		end
		return
	end

	if mode == "levelChoose" then
		if key == "w" or key == "up" then
			levelChoose:moveUp()
		end
		if key == "s" or key == "down" then
			levelChoose:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			mode = "game"
			level = levelChoose.chosen
			restart()
		end
		return
	end

	if mode == "lose" then
		if key == "w" or key == "up" then
			lose:moveUp()
		end
		if key == "s" or key == "down" then
			lose:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			if lose.chosen == 1 then
				mode = "game"
				restart()
			elseif lose.chosen == 2 then
				mode = "title"
			elseif lose.chosen == 3 then
				mode = "levelChoose"
			elseif lose.chosen == 4 then
				love.event.quit()
			end
		end
		return
	end

	if mode == "game" then
		if key == "escape" then
			mode = "menu"
		end
		return
	end

	if mode == "menu" then
		if key == "escape" then
			mode = "game"
		end

		if key == "w" or key == "up" then
			menu:moveUp()
		end
		if key == "s" or key == "down" then
			menu:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			if menu.chosen == 1 then
				mode = "title"
			elseif menu.chosen == 2 then
				mode = "levelChoose"
			elseif menu.chosen == 3 then
				love.event.quit()
			end
		end

		return
	end
end

function love.update(dt)
	if not musicSound:isPlaying() and playMusic then
		musicSound:play()
	end

	if mode == "title" then
	elseif mode == "game" then
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

		if reloadTimer:update(dt) then
			local dirL = love.keyboard.isDown("left")
			local dirR = love.keyboard.isDown("right")
			local dirU = love.keyboard.isDown("up")
			local dirD = love.keyboard.isDown("down")

			if dirL or dirR or dirU or dirD then
				reloadTimer:reset()
				laserSound:play()
			end

			if dirL and not dirR and not dirU and not dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, -1, 0))
			elseif not dirL and dirR and not dirU and not dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 1, 0))
			elseif not dirL and not dirR and dirU and not dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 0, -1))
			elseif not dirL and not dirR and not dirU and dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 0, 1))
			elseif dirL and not dirR and dirU and not dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, -0.7, -0.7))
			elseif dirL and not dirR and not dirU and dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, -0.7, 0.7))
			elseif not dirL and dirR and dirU and not dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 0.7, -0.7))
			elseif not dirL and dirR and not dirU and dirD then
				table.insert(projectiles, Bullet(player.position.x, player.position.y, 0.7, 0.7))
			end
		end

		if enemyTimer:update(dt) then
			enemyTimer:reset()
			local r = math.random(1, 12)
			table.insert(enemies, Enemy(middleCoords[r].x, middleCoords[r].y, enemyTexture))
		end

		for i, v in pairs(projectiles) do
			v:move(dt)
			if v.position.x < 64 or v.position.x > 768 or v.position.y < 64 or v.position.y > 764 then
				table.insert(toBeRemoved, i)
			end
		end
		
		local _i = 1
		local _n = table.getn(enemies)
		while _i <= _n do
			enemies[_i]:move(dt, player.position)

			if math.abs(enemies[_i].position.x-player.position.x)<C and math.abs(enemies[_i].position.y-player.position.y)<C then
				mode = "lose"
			end

			local valid = true
			for i, v in pairs(projectiles) do
				if math.abs(enemies[_i].position.x-v.position.x)<C/2 and math.abs(enemies[_i].position.y-v.position.y)<C/2 then
					valid = false
					table.insert(toBeRemoved, i)
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

		table.sort(toBeRemoved, function(a,b) return a > b end)
		while table.getn(toBeRemoved) > 0 do
			table.remove(projectiles, toBeRemoved[1])
			table.remove(toBeRemoved, 1)
		end
	elseif mode == "menu" then
		if love.keyboard.isDown("q") then
			love.event.quit()
		end
	end
end

function love.draw()
	if mode == "menu" or mode == "game" then
		love.graphics.clear(0.0, 0.1, 0.2)
		player:draw()
		for i, b in pairs(cornerCoords) do
			love.graphics.draw(blockTexture, b.x, b.y, 0, 1, 1, 32, 32)
		end
		for i, v in pairs(enemies) do
			v:draw()
		end
		for i, v in pairs(projectiles) do
			v:draw()
		end
		love.graphics.setColor(1, 1, 1, 1)
	end

	if mode == "menu" then
		menu:draw()
	end

	if mode == "title" then
		title:draw()
	end

	if mode == "levelChoose" then
		levelChoose:draw()
	end

	if mode == "lose" then
		lose:draw()
	end
end
