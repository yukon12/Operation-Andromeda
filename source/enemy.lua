function Enemy(posX, posY, texture)
	return {
		position = {x = posX, y = posY},
		texture = texture,
		color = {r = 1.0, g = 1.0, b = 1.0},
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
