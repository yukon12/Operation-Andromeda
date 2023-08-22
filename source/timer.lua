function Timer(length)
    return {
        value = 0,
        length = length,
        reset = function(self)
            self.value = length
        end,
        update = function(self, dt)
            if self.value <= 0 then
                return true
            else
                self.value = self.value - dt
                return false
            end
        end
    }
end