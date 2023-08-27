function Game()
    return {
        player = Player(416, 416),
        array = {
            projectiles = {},
	        enemies = {},
	        toBeRemoved = {},
	        lasers = {},
	        mags = {}
        },
        sound = {
            music = love.audio.newSource("resources/song.wav", "static"),
            pop = love.audio.newSource("resources/pop.mp3", "static"),
	        fire = love.audio.newSource("resources/laser.mp3", "static")
        },
        texture = {
            block = love.graphics.newImage("resources/block.png"),
            crate = love.graphics.newImage("resources/crate.png"),
            enemy = {
                love.graphics.newImage("resources/enemy1.png"),
		        love.graphics.newImage("resources/enemy2.png"),
		        love.graphics.newImage("resources/enemy3.png"),
		        love.graphics.newImage("resources/enemy4.png"),
		        love.graphics.newImage("resources/enemy5.png")
            },
            lightning = love.graphics.newImage("resources/lightning.png"),
            logo = love.graphics.newImage("resources/logo.png"),
            mag = love.graphics.newImage("resources/mag.png"),
            portal = love.graphics.newImage("resources/portal.png"),
            x = love.graphics.newImage("resources/x.png")
        },
        timer = {
            enemy = Timer(1.5),
            energy = Timer(10),
	        reload = Timer(0.5),
	        win = Timer(90)
        },
        variable = {
            ammo = 2,
            level = 0,
            lightning = {
                exists = false,
                coords = {x = 0, y = 0}
            },
        },
        restart = function(self)
            self.player.position.x = 416
            self.player.position.y = 416
            self.variable.lightning.position = {x = 0, y = 0}
            self.array.projectiles = {}
            self.array.enemies = {}
            self.array.toBeRemoved = {}
            self.array.lasers = {}
            self.array.mags = {}

            if self.variable.level == 1 then
                self.timer.enemy = Timer(1)
            elseif self.variable.level == 2 then
                self.timer.enemy = Timer(1.5)
            elseif self.variable.level == 3 then
                self.timer.enemy = Timer(4)
            elseif self.variable.level == 4 then
                self.timer.enemy = Timer(1.5)
            elseif self.variable.level == 5 then
                self.timer.enemy = Timer(1.5)
            end

            self.timer.enemy:reset()
            self.timer.reload:reset()
            self.timer.win:reset()
            self.timer.energy:reset()
            self.variable.lightning.exists = false
            self.variable.ammo = 2
        end,
        flashlight = function()
            love.graphics.circle("fill", ppx, ppy, tev*50+100)
        end,
        update = function(self, dt)
            --setting global variables for flashlight function
            ppx = self.player.position.x
            ppy = self.player.position.y
            tev = self.timer.energy.value

            --win handling
            if self.timer.win:update(dt) then
                mode = "win"
            end
    
            --player movement
            if love.keyboard.isDown("a") then
                self.player:move("left", dt)
                if self.variable.level == 5 then
                    if self.player.position.x > 288 and self.player.position.x < 352 and self.player.position.y > 224 and self.player.position.y < 352 then
                        self.player.position.x = 352
                    elseif self.player.position.x > 288 and self.player.position.x < 352 and self.player.position.y > 480 and self.player.position.y < 608 then
                        self.player.position.x = 352
                    end
                end
            end
            if love.keyboard.isDown("d") then
                self.player:move("right", dt)
                if self.variable.level == 5 then
                    if self.player.position.x > 480 and self.player.position.x < 544 and self.player.position.y > 224 and self.player.position.y < 352 then
                        self.player.position.x = 480
                    elseif self.player.position.x > 480 and self.player.position.x < 544 and self.player.position.y > 480 and self.player.position.y < 608 then
                        self.player.position.x = 480
                    end
                end
            end
            if love.keyboard.isDown("w") then
                self.player:move("back", dt)
                if self.variable.level == 5 then
                    if self.player.position.y > 288 and self.player.position.y < 352 and (self.player.position.x < 352 or self.player.position.x > 480) then
                        self.player.position.y = 352
                    elseif self.player.position.y > 544 and self.player.position.y < 608 and (self.player.position.x < 352 or self.player.position.x > 480) then
                        self.player.position.y = 608
                    end
                end
            end
            if love.keyboard.isDown("s") then
                self.player:move("front", dt)
                if self.variable.level == 5 then
                    if self.player.position.y > 224 and self.player.position.y < 288 and (self.player.position.x < 352 or self.player.position.x > 480) then
                        self.player.position.y = 224
                    elseif self.player.position.y > 480 and self.player.position.y < 544 and (self.player.position.x < 352 or self.player.position.x > 480) then
                        self.player.position.y = 480
                    end
                end
            end
    
            --player shooting
            if self.timer.reload:update(dt) and (not self.variable.level == 4 or self.variable.ammo > 0) then
                local dirL = love.keyboard.isDown("left")
                local dirR = love.keyboard.isDown("right")
                local dirU = love.keyboard.isDown("up")
                local dirD = love.keyboard.isDown("down")
    
                if dirL or dirR or dirU or dirD then
                    self.timer.reload:reset()
                    self.sound.fire:play()
                    if self.variable.level == 4 then
                        self.variable.ammo = self.variable.ammo - 1
                    end
                end
    
                if dirL and not dirR and not dirU and not dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, -1, 0))
                elseif not dirL and dirR and not dirU and not dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, 1, 0))
                elseif not dirL and not dirR and dirU and not dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, 0, -1))
                elseif not dirL and not dirR and not dirU and dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, 0, 1))
                elseif dirL and not dirR and dirU and not dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, -0.7, -0.7))
                elseif dirL and not dirR and not dirU and dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, -0.7, 0.7))
                elseif not dirL and dirR and dirU and not dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, 0.7, -0.7))
                elseif not dirL and dirR and not dirU and dirD then
                    table.insert(self.array.projectiles, Bullet(self.player.position.x, self.player.position.y, 0.7, 0.7))
                end
            end
    
            --enemy spawning
            if self.timer.enemy:update(dt) then
                self.timer.enemy:reset()
                if self.variable.level == 1 then
                    local r = math.random(1, 52)
                    if r <= 12 then
                        table.insert(self.array.enemies, Enemy(middleCoords[r].x, middleCoords[r].y, self.texture.enemy[self.variable.level]))
                    else
                        table.insert(self.array.enemies, Enemy(cornerCoords[r-12].x, cornerCoords[r-12].y, self.texture.enemy[self.variable.level]))
                    end
                elseif self.variable.level == 2  or self.variable.level == 4 then
                    local r = math.random(1, 12)
                    table.insert(self.array.enemies, Enemy(middleCoords[r].x, middleCoords[r].y, self.texture.enemy[self.variable.level]))
                elseif self.variable.level == 3 then
                    local r = math.random(1, 52)
                    if r <= 12 then
                        table.insert(self.array.enemies, BigEnemy(middleCoords[r].x, middleCoords[r].y, self.texture.enemy[self.variable.level], self.array.lasers))
                    else
                        table.insert(self.array.enemies, BigEnemy(cornerCoords[r-12].x, cornerCoords[r-12].y, self.texture.enemy[self.variable.level], self.array.lasers))
                    end
                elseif self.variable.level == 5 then
                    local r = math.random(1, 4)
                    table.insert(self.array.enemies, Enemy(fourCoords[r].x, fourCoords[r].y, self.texture.enemy[self.variable.level]))
                end
            end
    
            --projectile moving
            for i, v in pairs(self.array.projectiles) do
                v:move(dt)
                if v.position.x < 64 or v.position.x > 768 or v.position.y < 64 or v.position.y > 764 then
                    table.insert(self.array.toBeRemoved, i)
                end
    
                if self.variable.level == 5 then
                    if v.position.x > 0 and v.position.x < 320 and v.position.y > 256 and v.position.y < 320 then
                        table.insert(self.array.toBeRemoved, i)
                    elseif v.position.x > 0 and v.position.x < 320 and v.position.y > 512 and v.position.y < 576 then
                        table.insert(self.array.toBeRemoved, i)
                    elseif v.position.x > 512 and v.position.x < 768 and v.position.y > 256 and v.position.y < 320 then
                        table.insert(self.array.toBeRemoved, i)
                    elseif v.position.x > 512 and v.position.x < 768 and v.position.y > 512 and v.position.y < 576 then
                        table.insert(self.array.toBeRemoved, i)
                    end
                end
            end
    
            --deleting projectiles
            table.sort(self.array.toBeRemoved, function(a,b) return a > b end)
            while table.getn(self.array.toBeRemoved) > 0 do
                table.remove(self.array.projectiles, self.array.toBeRemoved[1])
                table.remove(self.array.toBeRemoved, 1)
            end
            
            --enemy logic
            local _i = 1
            local _n = table.getn(self.array.enemies)
            while _i <= _n do
                self.array.enemies[_i]:move(dt, self.player.position)
    
                if math.abs(self.array.enemies[_i].position.x-self.player.position.x)<64 and math.abs(self.array.enemies[_i].position.y-self.player.position.y)<64 then
                    mode = "lose"
                end
    
                local valid = true
                for i, v in pairs(self.array.projectiles) do
                    if math.abs(self.array.enemies[_i].position.x-v.position.x)<32 and math.abs(self.array.enemies[_i].position.y-v.position.y)<32 then
                        if self.variable.level == 1 or self.variable.level == 2 or self.variable.level == 4 or self.variable.level == 5 then
                            valid = false
                            table.insert(self.array.toBeRemoved, i)
                            if self.variable.level == 4 then
                                table.insert(self.array.mags, Mag(self.array.enemies[_i].position.x, self.array.enemies[_i].position.y))
                            end
                            break
                        elseif self.variable.level == 3 then
                            self.array.enemies[_i].health = self.array.enemies[_i].health - 1
                            table.insert(self.array.toBeRemoved, i)
                            if self.array.enemies[_i].health <= 0 then
                                valid = false
                                break
                            end
                        end
                    end
                end
    
                if valid then
                    _i = _i+1
                else
                    table.remove(self.array.enemies, _i)
                    _n = _n - 1
                    self.sound.pop:play()
                end
            end
    
            --projectile removing
            table.sort(self.array.toBeRemoved, function(a,b) return a > b end)
            while table.getn(self.array.toBeRemoved) > 0 do
                table.remove(self.array.projectiles, self.array.toBeRemoved[1])
                table.remove(self.array.toBeRemoved, 1)
            end
    
            --flashlight logic (l2)
            if self.variable.level == 2 then
                self.timer.energy:update(dt)
    
                if self.variable.lightning.exists then
                    if math.abs(self.variable.lightning.position.x-self.player.position.x) < 64 and math.abs(self.variable.lightning.position.y-self.player.position.y) < 64 then
                        self.variable.lightning.exists = false
                        self.timer.energy:reset()
                    end
                else
                    local r = math.random(1, 4)
                    self.variable.lightning.exists = true
                    self.variable.lightning.position = fourCoords[r]
                end
            end
    
            --laser logic (l3)
            if self.variable.level == 3 then
                for i, v in pairs(self.array.lasers) do
                    v:move(dt)
                    if math.abs(v.position.x-v.target.x)<5 and math.abs(v.position.y-v.target.y)<5 then
                        table.insert(self.array.toBeRemoved, i)
                    end
                    if math.abs(v.position.x-self.player.position.x) < 32 and math.abs(v.position.y-self.player.position.y) < 32 then
                        mode = "lose"
                    end
                end
    
                table.sort(self.array.toBeRemoved, function(a,b) return a > b end)
                while table.getn(self.array.toBeRemoved) > 0 do
                    table.remove(self.array.lasers, self.array.toBeRemoved[1])
                    table.remove(self.array.toBeRemoved, 1)
                end
            end
    
            --ammo logic (l4)
            if self.variable.level == 4 then
                for i, v in pairs(self.array.mags) do
                    v:update(dt)
                    if math.abs(v.position.x-self.player.position.x)<64 and math.abs(v.position.y-self.player.position.y)<64 then
                        v.destroyed = true
                        self.variable.ammo = self.variable.ammo + 2
                    end
                    if v.destroyed then
                        table.insert(self.array.toBeRemoved, i)
                    end
                end
    
                table.sort(self.array.toBeRemoved, function(a,b) return a > b end)
                while table.getn(self.array.toBeRemoved) > 0 do
                    table.remove(self.array.mags, self.array.toBeRemoved[1])
                    table.remove(self.array.toBeRemoved, 1)
                end
            end
        end,
        draw = function(self)
            if self.variable.level == 1 then
                love.graphics.clear(0.5, 0.4, 0.2)
            elseif self.variable.level == 2 then
                love.graphics.clear(0.0, 0.0, 0.0)
                love.graphics.setStencilTest("greater", 0)
                love.graphics.stencil(self.flashlight, "replace", 1, false)
                love.graphics.setColor(0.0, 0.1, 0.2)
                self:flashlight()
            elseif self.variable.level == 3 then
                love.graphics.clear(0.2, 0.1, 0.8)
                for i, v in pairs(self.array.lasers) do
                    v:draw()
                end
            elseif self.variable.level == 4 then
                love.graphics.clear(0.5, 0.6, 0.1)
                if self.variable.ammo > 0 then
                    love.graphics.setColor(1.0, 1.0, 0.0)
                else
                    love.graphics.setColor(1.0, 0.0, 0.0)
                end
                love.graphics.printf(
                    self.variable.ammo..'x',
                    love.graphics.newFont(24),
                    love.math.newTransform(self.player.position.x-32,
                    self.player.position.y-64),
                    64,
                    "center")
                for i, v in pairs(self.array.mags) do
                    local s = math.abs((v.timer.value-math.floor(v.timer.value))-0.5)/4+0.75
                    love.graphics.draw(self.texture.mag, v.position.x, v.position.y, 0, s, s, 32)
                end
            elseif self.variable.level == 5 then
                love.graphics.clear(0.6, 0.1, 0.1)
                for i, v in pairs(fourCoords) do
                    love.graphics.draw(self.texture.portal, v.x, v.y, 0, 1, 1, 32, 32)
                end
                for i, v in pairs(crateCoords) do
                    love.graphics.draw(self.texture.crate, v.x, v.y, 0, 1, 1, 32, 32)
                end
            end
    
            love.graphics.setColor(1.0, 1.0, 1.0)
            self.player:draw()
            for i, b in pairs(cornerCoords) do
                if self.variable.level == 1 or self.variable.level == 3 then
                    love.graphics.draw(self.texture.x, b.x, b.y, 0, 1, 1, 32, 32)
                elseif self.variable.level == 2 or self.variable.level == 4 then
                    love.graphics.draw(self.texture.block, b.x, b.y, 0, 1, 1, 32, 32)
                elseif self.variable.level == 5 then
                    love.graphics.draw(self.texture.crate, b.x, b.y, 0, 1, 1, 32, 32)
                end
            end
            for i, b in pairs(middleCoords) do
                if self.variable.level == 5 then
                    love.graphics.draw(self.texture.crate, b.x, b.y, 0, 1, 1, 32, 32)
                else
                    love.graphics.draw(self.texture.x, b.x, b.y, 0, 1, 1, 32, 32)
                end
            end
            for i, v in pairs(self.array.enemies) do
                v:draw()
            end
            for i, v in pairs(self.array.projectiles) do
                v:draw()
            end
    
            love.graphics.setStencilTest()
    
            love.graphics.setColor(0.0, 1.0, 0.0)
            love.graphics.printf(math.ceil(self.timer.win.value), love.graphics.newFont(32), love.math.newTransform(216, 64), 400, "center")
    
            love.graphics.setColor(1.0, 1.0, 1.0)
            if self.variable.level == 2 and self.variable.lightning.exists then
                love.graphics.draw(self.texture.lightning, self.variable.lightning.position.x, self.variable.lightning.position.y, 0, 1, 1, 32, 32)
            end
        end,
    }
end