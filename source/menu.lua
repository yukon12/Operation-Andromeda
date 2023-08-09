function Menu(logo)
	return {
		texture = logo,
		text = love.graphics.newText(love.graphics.newFont(20), "PRESS Q TO EXIT"),
		draw = function(self)
			love.graphics.draw(self.texture, 416, 288, 0, 1, 1, 160, 160)
			love.graphics.print("version "..VERSION)
			love.graphics.draw(self.text, 416, 480, 0, 1, 1, 64, 0)
		end
	}
end
