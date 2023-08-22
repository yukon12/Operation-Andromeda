function Menu(logo)
	return {
		chosen = 1,
		optionTexts = {
			"TITLE SCREEN",
			"CHANGE LEVEL",
			"EXIT"
		},
		smallFont = love.graphics.newFont(24),
		bigFont = love.graphics.newFont(32),
		draw = function(self)
			love.graphics.setColor(0.0, 0.0, 1.0, 1.0)
			love.graphics.rectangle("fill", 200, 248, 400, 150)
			love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
			for i = 1, table.getn(self.optionTexts) do
				local f
				if self.chosen == i then
					f = self.bigFont
				else
					f = self.smallFont
				end
				love.graphics.printf(self.optionTexts[i], f, love.math.newTransform(216, 200+48*i), 400, "center")
			end
		end,
		moveUp = function(self)
			self.chosen = self.chosen - 1
			if self.chosen < 1 then
				self.chosen = table.getn(self.optionTexts)
			end
		end,
		moveDown = function(self)
			self.chosen = self.chosen + 1
			if self.chosen > table.getn(self.optionTexts) then
				self.chosen = 1
			end
		end
    }
end
