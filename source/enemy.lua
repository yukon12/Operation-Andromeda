ENEMY_V = 100

function Enemy(posX, posY)
	return {
		position = {x = posX, y = posY},
		move = function(self, dt, playerPosition)
			local distance = math.sqrt((self.position.x-playerPosition.x)*(self.position.x-playerPosition.x)+(self.position.y-playerPosition.y)*(self.position.y-playerPosition.y))
			self.position.x = self.position.x - (self.position.x-playerPosition.x)/distance*ENEMY_V*dt
			self.position.y = self.position.y - (self.position.y-playerPosition.y)/distance*ENEMY_V*dt
		end,
		draw = function(self, texture)
			love.graphics.draw(texture, self.position.x, self.position.y, 0, 1, 1, 32, 32)
		end
	}
end
