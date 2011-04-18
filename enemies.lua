function border_of_wave_and_particle(self)
    local theta = 0
    local dtheta = 0
    local ddtheta = 0.2 * degrees
    while true do
        for i=tau/3, tau, tau/3 do
            self:fire(8, theta + i)
        end
        dtheta = (dtheta + ddtheta) % tau
        theta = theta + dtheta
        wait(2)
    end
end

function wander(self)
    while true do
        wait(120)
        -- Choose a random spot to wander to
        local x = random(300) + 250
        local y = random(200)
        local r, theta = get_polar(x-self.x, y-self.y)
        self:change_speed(r/30, 30)
        self:change_direction(theta, 1)
        wait(30)
        self:change_speed(0, 30)
        wait(30)
    end
end

function fujiwara_197_spawner(self)
    while true do
        wait(20)
        self:fire(4, facing_up,   fujiwara_197_bouncer)
        self:fire(4, facing_down, fujiwara_197_bouncer)
    end
end

function fujiwara_197_bouncer(self)
    while true do
        wait(1)
        if self.y < 0 or self.y > 600 then
            self:fire(self.speed/2, self.direction+pi)
            self:vanish()
        end
    end
end

function fujiwara_197(self)
    while true do
        wait(45)
        self:fire(1.25, facing_right, fujiwara_197_spawner)
        self:fire(1.25, facing_left,  fujiwara_197_spawner)
        self:fire(4, facing_up,   fujiwara_197_bouncer)
        self:fire(4, facing_down, fujiwara_197_bouncer)
        wait(135)
    end
end

function stage_one(junk, key)
    local patterns = {
            {border_of_wave_and_particle},
            {fujiwara_197, wander}
        }
    if key=="1" or key=="2" then
        Object(400, 100, nil, nil, nil, "enemy_bullet",
            unpack(patterns[tonumber(key)]))
    else
        Object(400, 100, nil, nil, nil, "enemy_bullet",
            unpack(uniformly(patterns)))
    end
end
