function Title(texture)
	return {
		texture = texture,
		menu = Menu(452, {
			{name = "CONTINUE", available = true, perform = function() mode = "levelChoose" end},
			{name = "MUTE MUSIC", available = true, perform = function() 
				if playMusic then
					playMusic = false
					game.sound.music:stop()
					title.menu.options[2].name = "UNMUTE MUSIC"
				else
					playMusic = true
					game.sound.music:play()
					title.menu.options[2].name = "MUTE MUSIC"
				end
			end},
			{name = "EXIT", available = true, perform = function() love.event.quit() end}
		}),
		draw = function(self)
			love.graphics.print("version "..VERSION)
			love.graphics.draw(self.texture, 416, 288, 0, 1, 1, 160, 160)
			self.menu:draw()
		end
	}
end