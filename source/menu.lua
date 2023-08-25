function Menu(position, options)
    return {
        position = position,
        smallFont = love.graphics.newFont(24),
		bigFont = love.graphics.newFont(32),
        chosen = 1,
        options = options,
        moveUp = function(self)
            self.chosen = self.chosen - 1
            self.chosen = math.max(self.chosen, 1)
        end,
        moveDown = function(self)
            self.chosen = self.chosen + 1
            self.chosen = math.min(self.chosen, table.getn(self.options))
        end,
        draw = function(self)
            local f
            for i = 1, table.getn(options) do
                if i == self.chosen then
                    f = self.bigFont
                else
                    f = self.smallFont       
                end
                if self.options[i].available then
                    love.graphics.setColor(1.0, 1.0, 1.0)
                else
                    love.graphics.setColor(0.5, 0.5, 0.5)
                end
                love.graphics.printf(self.options[i].name, f, love.math.newTransform(216, self.position+48*i), 400, "center")
            end
        end,
        select = function(self)
            if self.options[self.chosen].available then
                self.options[self.chosen].perform()
                game.sound.pop:play()
            end
        end
    }
end