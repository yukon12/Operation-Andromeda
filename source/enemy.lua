function Enemy(posX, posY, txtPointer)
	return {
		position = {x = posX, y = posY},
		texture = txtPointer,
		color = {r = math.random(0,100)/100, g = math.random(0,100)/100, b = math.random(0,100)/100},
		move = function(self, dt, playerPosition)
			local distance = math.sqrt((self.position.x-playerPosition.x)*(self.position.x-playerPosition.x)+(self.position.y-playerPosition.y)*(self.position.y-playerPosition.y))
			self.position.x = self.position.x - (self.position.x-playerPosition.x)/distance*ENEMY_V*dt
			self.position.y = self.position.y - (self.position.y-playerPosition.y)/distance*ENEMY_V*dt
		end,
		draw = function(self)
			love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
			love.graphics.draw(self.texture, self.position.x, self.position.y, 0, 1, 1, 32, 32)
			love.graphics.setColor(1, 1, 1, 1)
		end
	}
end
