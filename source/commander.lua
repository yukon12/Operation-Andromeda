VELOCITY = 150

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
		move = function(this, direction, dt)
			if direction == "left" then
				this.position.x = this.position.x - VELOCITY*dt
				this.orientation = "left"
			end
			if direction == "right" then
				this.position.x = this.position.x + VELOCITY*dt
				this.orientation = "right"
			end
			if direction == "back" then
				this.position.y = this.position.y - VELOCITY*dt
				this.orientation = "back"
			end
			if direction == "front" then
				this.position.y = this.position.y + VELOCITY*dt
				this.orientation = "front"
			end

			this.position.x = math.max(this.position.x, 96)
			this.position.x = math.min(this.position.x, 734)
			this.position.y = math.max(this.position.y, 96)
			this.position.y = math.min(this.position.y, 734)
		end,
		draw = function(this)
			love.graphics.draw(this.texture[this.orientation], this.position.x, this.position.y, 0, 1, 1, 32, 32)
		end
	}
end
