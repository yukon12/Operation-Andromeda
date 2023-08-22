function Title(logoTexture)
    return {
        logoTexture = logoTexture,
		chosen = 1,
		optionTexts = {
			"CONTINUE",
			"MUTE MUSIC",
			"EXIT"
		},
		smallFont = love.graphics.newFont(24),
		bigFont = love.graphics.newFont(32),
		draw = function(self)
			love.graphics.print("version "..VERSION)
			love.graphics.draw(self.logoTexture, 416, 288, 0, 1, 1, 160, 160)
			for i = 1, table.getn(self.optionTexts) do
				local f
				if self.chosen == i then
					f = self.bigFont
				else
					f = self.smallFont
				end
				love.graphics.printf(self.optionTexts[i], f, love.math.newTransform(216, 452+48*i), 400, "center")
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