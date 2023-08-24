function Mag(posX, posY)
    t = Timer(5)
    t:reset()
    return {
        position = {x = posX, y = posY},
        timer = t,
        destroyed = false,
        update = function(self, dt)
            if self.timer:update(dt) then
                self.destroyed = true
            end
        end
    }
end