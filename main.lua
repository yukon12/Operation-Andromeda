require "love"
require "source/data"
require "source/commander"
require "source/bullet"
require "source/timer"
require "source/laser"
require "source/enemy"
require "source/bigEnemy"
require "source/menu"
require "source/title"
require "source/levelChoose"
require "source/lose"
require "source/win"
require "source/mag"

DEV = true

function restart()
	player.position.x = 416
	player.position.y = 416
	lightning = {x = 0, y = 0}
	projectiles = {}
	enemies = {}
	toBeRemoved = {}
	lasers = {}
	mags = {}

	if level == 1 then
		enemyTimer = Timer(1)
	elseif level == 2 then
		enemyTimer = Timer(1.5)
	elseif level == 3 then
		enemyTimer = Timer(4)
	elseif level == 4 then
		enemyTimer = Timer(6)
	end

	enemyTimer:reset()
	reloadTimer:reset()
	winTimer:reset()
	energyTimer:reset()
	isLightning = false
	ammo = 2
end

function flashlight()
	love.graphics.circle("fill", player.position.x, player.position.y, energyTimer.value*50+100)
end

function love.load()
	math.randomseed(os.time())

	blockTexture = love.graphics.newImage("resources/block.png")
	enemyTexture = {
		love.graphics.newImage("resources/enemy1.png"),
		love.graphics.newImage("resources/enemy2.png"),
		love.graphics.newImage("resources/enemy3.png"),
		love.graphics.newImage("resources/enemy4.png")
	}
	logoTexture = love.graphics.newImage("resources/logo.png")
	lightningTexture = love.graphics.newImage("resources/lightning.png")
	xTexture = love.graphics.newImage("resources/x.png")
	magTexture = love.graphics.newImage("resources/mag.png")
	musicSound = love.audio.newSource("resources/song.wav", "static")
	laserSound = love.audio.newSource("resources/laser.mp3", "static")

	player = Commander(416, 416)
	menu = Menu(logoTexture)
	title = Title(logoTexture)
	lose = Lose()
	win = Win()
	levelChoose = LevelChoose()
	enemyTimer = Timer(1.5)
	reloadTimer = Timer(0.5)
	winTimer = Timer(300)
	energyTimer = Timer(10)

	musicSound:setVolume(0.5)

	projectiles = {}
	enemies = {}
	toBeRemoved = {}
	lightnings = {}
	lasers = {}
	mags = {}

	mode = "title"
	level = 0
	playMusic = true
	isLightning = false
	ammo = 2

	unlocked = {
		true,
		false,
		false,
		false,
		false
	}

	if DEV then
		unlocked = {
			true,
			true,
			true,
			true,
			true
		}
	end
end

function love.keypressed(key)
	if key == "u" and DEV == true then
		winTimer.value = 3
	end

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
			if unlocked[levelChoose.chosen] then
				mode = "game"
				level = levelChoose.chosen
				restart()
			end
		end
		if key == "a" or key == "left" or key == "escape" then
			mode = "title"
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

	if mode == "win" then
		if key == "w" or key == "up" then
			win:moveUp()
		end
		if key == "s" or key == "down" then
			win:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			if win.chosen == 1 then
				mode = "game"
				level = level + 1
				level = math.min(level, 5)
				unlocked[level] = true
				restart()
			elseif win.chosen == 2 then
				mode = "title"
			elseif win.chosen == 3 then
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

	if mode == "game" then
		if winTimer:update(dt) then
			mode = "win"
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

		if reloadTimer:update(dt) and (not level == 4 or ammo > 0) then
			local dirL = love.keyboard.isDown("left")
			local dirR = love.keyboard.isDown("right")
			local dirU = love.keyboard.isDown("up")
			local dirD = love.keyboard.isDown("down")

			if dirL or dirR or dirU or dirD then
				reloadTimer:reset()
				laserSound:play()
				if level == 4 then
					ammo = ammo - 1
				end
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
			if level == 1 then
				local r = math.random(1, 52)
				if r <= 12 then
					table.insert(enemies, Enemy(middleCoords[r].x, middleCoords[r].y, enemyTexture[level]))
				else
					table.insert(enemies, Enemy(cornerCoords[r-12].x, cornerCoords[r-12].y, enemyTexture[level]))
				end
			elseif level == 2  or level == 4 then
				local r = math.random(1, 12)
				table.insert(enemies, Enemy(middleCoords[r].x, middleCoords[r].y, enemyTexture[level]))
			elseif level == 3 then
				local r = math.random(1, 52)
				if r <= 12 then
					table.insert(enemies, BigEnemy(middleCoords[r].x, middleCoords[r].y, enemyTexture[level], lasers))
				else
					table.insert(enemies, BigEnemy(cornerCoords[r-12].x, cornerCoords[r-12].y, enemyTexture[level], lasers))
				end
			end
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
					if level == 1 or level == 2 or level == 4 then
						valid = false
						table.insert(toBeRemoved, i)
						if level == 4 then
							table.insert(mags, Mag(enemies[_i].position.x, enemies[_i].position.y))
						end
						break
					elseif level == 3 then
						enemies[_i].health = enemies[_i].health - 1
						table.insert(toBeRemoved, i)
						if enemies[_i].health <= 0 then
							valid = false
							break
						end
					end
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

		if level == 2 then
			energyTimer:update(dt)

			if isLightning then
				if math.abs(lightning.x-player.position.x) < 64 and math.abs(lightning.y-player.position.y) < 64 then
					isLightning = false
					energyTimer:reset()
				end
			end

			if not isLightning then
				local r = math.random(1, 4)
				isLightning = true
				lightning = lightningCoords[r]
			end
		end

		if level == 3 then
			for i, v in pairs(lasers) do
				v:move(dt)
				if math.abs(v.position.x-v.target.x)<5 and math.abs(v.position.y-v.target.y)<5 then
					table.insert(toBeRemoved, i)
				end
				if math.abs(v.position.x-player.position.x) < 32 and math.abs(v.position.y-player.position.y) < 32 then
					mode = "lose"
				end
			end

			table.sort(toBeRemoved, function(a,b) return a > b end)
			while table.getn(toBeRemoved) > 0 do
				table.remove(lasers, toBeRemoved[1])
				table.remove(toBeRemoved, 1)
			end
		end

		if level == 4 then
			for i, v in pairs(mags) do
				v:update(dt)
				if math.abs(v.position.x-player.position.x)<64 and math.abs(v.position.y-player.position.y)<64 then
					v.destroyed = true
					ammo = ammo + 2
				end
				if v.destroyed then
					table.insert(toBeRemoved, i)
				end
			end

			table.sort(toBeRemoved, function(a,b) return a > b end)
			while table.getn(toBeRemoved) > 0 do
				table.remove(mags, toBeRemoved[1])
				table.remove(toBeRemoved, 1)
			end
		end
	end
end

function love.draw()
	love.graphics.clear(0.0, 0.0, 0.0)

	if mode == "menu" or mode == "game" then
		if level == 1 then
			love.graphics.clear(0.5, 0.4, 0.2)
		elseif level == 2 then
			love.graphics.clear(0.0, 0.0, 0.0)
			love.graphics.setStencilTest("greater", 0)
			love.graphics.stencil(flashlight, "replace", 1, false)
			love.graphics.setColor(0.0, 0.1, 0.2)
			flashlight()
		elseif level == 3 then
			love.graphics.clear(0.2, 0.1, 0.8)
			for i, v in pairs(lasers) do
				v:draw()
			end
		elseif level == 4 then
			love.graphics.clear(0.5, 0.6, 0.1)
			if ammo > 0 then
				love.graphics.setColor(1.0, 1.0, 0.0)
			else
				love.graphics.setColor(1.0, 0.0, 0.0)
			end
			love.graphics.printf(ammo..'x', love.graphics.newFont(24), love.math.newTransform(player.position.x-32, player.position.y-64), 64, "center")
			for i, v in pairs(mags) do
				local s = math.abs((v.timer.value-math.floor(v.timer.value))-0.5)/4+0.75
				love.graphics.draw(magTexture, v.position.x, v.position.y, 0, s, s, 32)
			end
		end

		love.graphics.setColor(1.0, 1.0, 1.0)
		player:draw()
		for i, b in pairs(cornerCoords) do
			if level == 1 or level == 3 then
				love.graphics.draw(xTexture, b.x, b.y, 0, 1, 1, 32, 32)
			elseif level == 2 or level == 4 then
				love.graphics.draw(blockTexture, b.x, b.y, 0, 1, 1, 32, 32)
			end
		end
		for i, b in pairs(middleCoords) do
			love.graphics.draw(xTexture, b.x, b.y, 0, 1, 1, 32, 32)
		end
		for i, v in pairs(enemies) do
			v:draw()
		end
		for i, v in pairs(projectiles) do
			v:draw()
		end

		love.graphics.setStencilTest()

		love.graphics.setColor(0.0, 1.0, 0.0)
		love.graphics.printf(math.ceil(winTimer.value), love.graphics.newFont(32), love.math.newTransform(216, 64), 400, "center")

		love.graphics.setColor(1.0, 1.0, 1.0)
		if level == 2 and isLightning then
			love.graphics.draw(lightningTexture, lightning.x, lightning.y, 0, 1, 1, 32, 32)
		end
	end

	if mode == "menu" then
		menu:draw()
	end

	if mode == "title" then
		title:draw()
	end

	if mode == "levelChoose" then
		levelChoose:draw(unlocked)
	end

	if mode == "lose" then
		lose:draw()
	end

	if mode == "win" then
		win:draw()
	end
end
