function Bullet(posX, posY, dirX, dirY)
	return {
		position = {x = posX, y = posY},
		vector = {x = dirX, y = dirY},
		move = function(self, dt)
			self.position.x = self.position.x + self.vector.x * dt * BULLET_V
			self.position.y = self.position.y + self.vector.y * dt * BULLET_V
		end,
		draw = function(self)
			love.graphics.circle("fill", self.position.x, self.position.y, 5)
		end
	}
end
