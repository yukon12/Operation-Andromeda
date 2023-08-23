function Laser(posX, posY, tarX, tarY)
    return {
        position = {x = posX, y = posY},
        target = {x = tarX, y = tarY},
        move = function(self, dt)
            local distance = math.sqrt((self.position.x-self.target.x)*(self.position.x-self.target.x)+(self.position.y-self.target.y)*(self.position.y-self.target.y))
            self.position.x = self.position.x - (self.position.x-self.target.x)/distance*LASER_V*dt
			self.position.y = self.position.y - (self.position.y-self.target.y)/distance*LASER_V*dt
        end,
        draw = function(self)
            love.graphics.setColor(1.0, 0.0, 1.0)
            love.graphics.rectangle("fill", self.position.x, self.position.y, 8, 8, 0, 1, 1, 4, 4)
        end
    }
end