function love.load()
	math.randomseed(os.time())
	game = Game()
	pause = Pause(game.texture.logo)
	title = Title(game.texture.logo)
	lose = Lose()
	win = Win()
	levelChoose = LevelChoose()

	game.sound.fire:setVolume(0.5)
	game.sound.pop:setVolume(0.3)
	game.sound.music:setVolume(0.3)

	mode = "title"
	playMusic = true
end

function love.keypressed(key)
	if mode == "title" then
		if key == "w" or key == "up" then
			title.menu:moveUp()
		end
		if key == "s" or key == "down" then
			title.menu:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			title.menu:select()
		end
		return
	end

	if mode == "levelChoose" then
		if key == "w" or key == "up" then
			levelChoose.menu:moveUp()
		end
		if key == "s" or key == "down" then
			levelChoose.menu:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			levelChoose.menu:select()
		end
		if key == "a" or key == "left" or key == "escape" then
			mode = "title"
		end
		return
	end

	if mode == "lose" then
		if key == "w" or key == "up" then
			lose.menu:moveUp()
		end
		if key == "s" or key == "down" then
			lose.menu:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			lose.menu:select()
		end
		return
	end

	if mode == "win" then
		if key == "w" or key == "up" then
			win.menu:moveUp()
		end
		if key == "s" or key == "down" then
			win.menu:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			game.variable.level = game.variable.level + 1
			game.variable.level = math.min(game.variable.level, 5)
			levelChoose.menu.options[game.variable.level].available = true
			win.menu:select()
		end
		return
	end

	if mode == "pause" then
		if key == "w" or key == "up" then
			pause.menu:moveUp()
		end
		if key == "s" or key == "down" then
			pause.menu:moveDown()
		end
		if key == "d" or key == "right" or key == "return" then
			pause.menu:select()
		end
		if key == "a" or key == "left" or key == "escape" then
			mode = "game"
		end
		return
	end

	if mode == "game" then
		if key == "escape" then
			mode = "pause"
		end
		return
	end
end

function love.update(dt)
	if not game.sound.music:isPlaying() and playMusic then
		game.sound.music:play()
	end

	if mode == "game" then
		game:update(dt)
	end
end

function love.draw()
	love.graphics.clear(0.0, 0.0, 0.0)

	if mode == "game" then
		game:draw()
	elseif mode == "pause" then
		game:draw()
		pause:draw()
	elseif mode == "title" then
		title:draw()
	elseif mode == "levelChoose" then
		levelChoose:draw(unlocked)
	elseif mode == "lose" then
		lose:draw()
	elseif mode == "win" then
		win:draw()
	end
end