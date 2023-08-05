require "love"
require "source/commander"

C = 64

function love.load()
	player = Commander(416, 416)
	block = love.graphics.newImage("resources/block.png")
	blocks = {
		{x = C*0.5, y = C*0.5},
		{x = C*0.5, y = C*1.5},
		{x = C*0.5, y = C*2.5},
		{x = C*0.5, y = C*3.5},
		{x = C*0.5, y = C*4.5},
		{x = C*0.5, y = C*8.5},
		{x = C*0.5, y = C*9.5},
		{x = C*0.5, y = C*10.5},
		{x = C*0.5, y = C*11.5},
		{x = C*0.5, y = C*12.5},

		{x = C*12.5, y = C*0.5},
		{x = C*12.5, y = C*1.5},
		{x = C*12.5, y = C*2.5},
		{x = C*12.5, y = C*3.5},
		{x = C*12.5, y = C*4.5},
		{x = C*12.5, y = C*8.5},
		{x = C*12.5, y = C*9.5},
		{x = C*12.5, y = C*10.5},
		{x = C*12.5, y = C*11.5},
		{x = C*12.5, y = C*12.5},
	}
end

function love.update(dt)
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isDown("a") then
		player:move("left", dt)
	end
	if love.keyboard.isDown("d") then
		player:move("right", dt)
	end
	if love.keyboard.isDown("w") then
		player:move("back", dt)
	end
	if love.keyboard.isDown("s") then
		player:move("front", dt)
	end
end

function love.draw()
	love.graphics.clear(0.0, 0.1, 0.2)
	player:draw()
	for i, b in pairs(blocks) do
		love.graphics.draw(block, b.x, b.y, 0, 1, 1, 32, 32)
	end
end