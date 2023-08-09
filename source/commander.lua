function Commander(posX, posY)
	return {
		position = {x = posX, y = posY},
		orientation = "front",
		texture = {
			front = love.graphics.newImage("resources/commander_front.png"),
			back = love.graphics.newImage("resources/commander_back.png"),
			left = love.graphics.newImage("resources/commander_left.png"),
			right = love.graphics.newImage("resources/commander_right.png")
		},
		move = function(self, direction, dt)
			if direction == "left" then
				self.position.x = self.position.x - COMMANDER_V*dt
				self.orientation = "left"
			end
			if direction == "right" then
				self.position.x = self.position.x + COMMANDER_V*dt
				self.orientation = "right"
			end
			if direction == "back" then
				self.position.y = self.position.y - COMMANDER_V*dt
				self.orientation = "back"
			end
			if direction == "front" then
				self.position.y = self.position.y + COMMANDER_V*dt
				self.orientation = "front"
			end

			self.position.x = math.max(self.position.x, 96)
			self.position.x = math.min(self.position.x, 734)
			self.position.y = math.max(self.position.y, 96)
			self.position.y = math.min(self.position.y, 734)
		end,
		draw = function(self)
			love.graphics.draw(self.texture[self.orientation], self.position.x, self.position.y, 0, 1, 1, 32, 32)
		end
	}
end
