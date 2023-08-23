function BigEnemy(posX, posY, texture, array)
	return {
		position = {x = posX, y = posY},
		texture = texture,
		color = {r = 1.0, g = 1.0, b = 1.0},
        health = 3,
        timer = Timer(2.5),
        array = array,
		move = function(self, dt, playerPosition)
			local distance = math.sqrt((self.position.x-playerPosition.x)*(self.position.x-playerPosition.x)+(self.position.y-playerPosition.y)*(self.position.y-playerPosition.y))
			if distance > 150 then
                self.position.x = self.position.x - (self.position.x-playerPosition.x)/distance*BIGENEMY_V*dt
			    self.position.y = self.position.y - (self.position.y-playerPosition.y)/distance*BIGENEMY_V*dt
            end

            if self.timer:update(dt) then
                self.timer:reset()
                table.insert(array, Laser(self.position.x, self.position.y, playerPosition.x, playerPosition.y))
            end
		end,
		draw = function(self)
			love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
			love.graphics.draw(self.texture, self.position.x, self.position.y, 0, 1, 1, 64, 64)
            love.graphics.rectangle("line", self.position.x-64, self.position.y+64, 128, 8)
            love.graphics.rectangle("fill", self.position.x-64, self.position.y+64, 46.67*self.health, 8)
			love.graphics.setColor(1, 1, 1, 1)
		end
	}
end
