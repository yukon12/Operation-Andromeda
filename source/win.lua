function Win()
	return {
		menu = Menu(296, {
			{name = "NEXT LEVEL", available = true, perform = function()
				mode = "game"
				game:restart()
			end},
			{name = "TITLE SCREEN", available = true, perform = function()
				mode = "title"
			end},
			{name = "EXIT", available = true, perform = function()
				love.event.quit()
			end}
		}),
		draw = function(self)
			love.graphics.setColor(0.0, 1.0, 0.0, 1.0)
            love.graphics.printf("YOU HAVE WON", love.graphics.newFont(64), love.math.newTransform(216, 150), 400, "center")
			self.menu:draw()
		end
	}
end