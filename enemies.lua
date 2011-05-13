function later(self, time, args)
    wait(time)
    if type(args) == "function" then
        args = {args}
    end
    local func = args[1]
    args[1] = self
    func(unpack(args))
end

function border_of_wave_and_particle(self)
    local theta = 0
    local dtheta = 0
    local ddtheta = 0.2 * degrees
    self.child_color = colors.purple
    while true do
        local n = floor(3+2*rank)
        for i=tau/n, tau, tau/n do
            self:fire({speed=8, direction=theta+i})
        end
        dtheta = dtheta + ddtheta
        theta = (theta + dtheta) % tau
        wait(2)
    end
end

function mokou_wander(self)
    local x, other_x, y, h, accel = {475}, {}, 0, 120, 30
    for i=325,450,25 do other_x[#other_x+1] = i x[#x+1] = i+12.5 end
    while true do
        wait(max(120-45*rank, 0))
        -- Choose a random spot to wander to
        local xx = x[random(#x)]
        local yy = random(h) + y
        local r, theta = get_polar(xx-self.x, yy-self.y)
        self:change_speed(r/accel, accel)
        self:change_direction(theta, 1)
        wait(accel)
        self:change_speed(0, accel)
        wait(accel)
        x, other_x = other_x, x
    end
end

function mokou_197(self)
    local bouncer = function(self) while true do
        wait(1)
        if self.y < 0 or self.y > 600 then
            self.child_color = colors.blue
            self:fire({speed=self.speed/2, direction=self.direction+pi})
            return
        end
    end end
    local spawner = function(self) while true do
        wait(20)
        self.child_color = colors.pink
        self:fire({speed=4, direction=facing_up},   bouncer)
        self:fire({speed=4, direction=facing_down}, bouncer)
    end end
    while true do
        self.child_kind = "spawner"
        self.child_color = nil
        self:fire({speed=1.25, direction=facing_right}, spawner)
        self:fire({speed=1.25, direction=facing_left},  spawner)
        self.child_kind = "enemy_bullet"
        self.child_color = colors.pink
        self:fire({speed=4, direction=facing_up},   bouncer)
        self:fire({speed=4, direction=facing_down}, bouncer)
        wait(180 - min(45*rank,120))
    end
end

function grid(self)
    local trace_b = function(self)
        self.child_color = colors.white
        while true do
            self:fire({}, {later, 120, Object.vanish})
            wait(2)
        end
    end
    local trace_a = function(self) while true do
        self:fire({speed=25, direction=facing_right, kind="spawner"}, trace_b)
        wait(1)
    end end
    --[[local trace_a = function(self) while true do
        self.child_color = {255, 255, 255}
        self:fire(1.5*15, facing_right)
        wait(1)
    end end--]]
    Object({x=-25, y=-50, direction=facing_down, speed=50, kind="spawner"}, trace_a)
end

function add_laters(first, ...)
    stuff = {...}
    for idx,data in ipairs(stuff) do
        stuff[idx] = {later, 30, data}
    end
    return first, unpack(stuff)
end

function stage_one(junk, key)
    local patterns = {
            {{later, 22.5*60, Object.vanish, 60}, border_of_wave_and_particle},
            {{later, 15*60, Object.vanish, 360}, mokou_197, mokou_wander}
            --{{later, 5*60, Object.vanish, 0}, grid}
        }
    local boss = nil
    for idx,data in ipairs(shuffle(patterns)) do
        boss = Object({x=400, y=100, color=colors.green, kind="enemy_bullet"},
            add_laters(unpack(data)))
        wait(data[1][2] + data[1][4])
        for _,kind in ipairs({"enemy_bullet", "spawner"}) do
            for __, obj in ipairs(obj_man.objects[kind]) do
                obj:core_vanish()
            end
        end
    end
    wait(30)
    -- player wins at this point.
    error("victory")
end
