function LevelChoose()
    return {
		menu = Menu(200, {
			{name = "LEVEL 1", available = true, perform = function()
				mode = "game"
				game.variable.level = 1
				game:restart()
			end},
			{name = "LEVEL 2", available = false, perform = function()
				mode = "game"
				game.variable.level = 2
				game:restart()
			end},
			{name = "LEVEL 3", available = false, perform = function()
				mode = "game"
				game.variable.level = 3
				game:restart()
			end},
			{name = "LEVEL 4", available = false, perform = function()
				mode = "game"
				game.variable.level = 4
				game:restart()
			end},
			{name = "LEVEL 5", available = false, perform = function()
				mode = "game"
				game.variable.level = 5
				game:restart()
			end}
		}),
		draw = function(self)
			self.menu:draw()
		end,
    }
end