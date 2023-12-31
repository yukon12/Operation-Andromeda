-- function Lose()
--     return {
-- 		chosen = 1,
-- 		optionTexts = {
-- 			"TRY AGAIN",
--             "TITLE SCREEN",
--             "PICK DIFFERENT LEVEL",
--             "EXIT"
-- 		},
-- 		smallFont = love.graphics.newFont(24),
-- 		bigFont = love.graphics.newFont(32),
--         enormousFont = love.graphics.newFont(64),
-- 		draw = function(self)
--             love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
--             love.graphics.printf("YOU HAVE LOST", self.enormousFont, love.math.newTransform(216, 150), 400, "center")
--             love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
-- 			for i = 1, table.getn(self.optionTexts) do
-- 				local f
-- 				if self.chosen == i then
-- 					f = self.bigFont
-- 				else
-- 					f = self.smallFont
-- 				end
-- 				love.graphics.printf(self.optionTexts[i], f, love.math.newTransform(216, 296+48*i), 400, "center")
-- 			end
-- 		end,
-- 		moveUp = function(self)
-- 			self.chosen = self.chosen - 1
-- 			if self.chosen < 1 then
-- 				self.chosen = table.getn(self.optionTexts)
-- 			end
-- 		end,
-- 		moveDown = function(self)
-- 			self.chosen = self.chosen + 1
-- 			if self.chosen > table.getn(self.optionTexts) then
-- 				self.chosen = 1
-- 			end
-- 		end
--     }
-- end

function Lose()
	return {
		menu = Menu(296, {
			{name = "TRY AGAIN", available = true, perform = function()
				mode = "game"
				game:restart()
			end},
			{name = "TITLE SCREEN", available = true, perform = function()
				mode = "title"
			end},
			{name = "PICK DIFFERENT LEVEL", available = true, perform = function()
				mode = "levelChoose"
			end},
			{name = "EXIT", available = true, perform = function()
				love.event.quit()
			end}
		}),
		draw = function(self)
			love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
			love.graphics.printf("YOU HAVE LOST", love.graphics.newFont(64), love.math.newTransform(216, 150), 400, "center")
			self.menu:draw()
		end
	}
end