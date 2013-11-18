Object = class(function(o, ...)
        o:update(...)
    end)

function Object.update(o, a, ...)
    o.x             = a.x           or o.x           or 400
    o.y             = a.y           or o.y           or 300
    o.w             = a.w           or o.w           or 10
    o.direction     = a.direction   or o.direction   or facing_down
    o.speed         = a.speed       or o.speed       or 0
    o.kind          = a.kind        or o.kind        or "enemy_bullet"
    o.color         = a.color       or o.color       or default_colors[o.kind]
    o.parent        = a.parent      or o.parent      or nil
    o.health        = a.health      or o.health      or 1
    o.child_color   = a.child_color or o.child_color or o.color
    o.age           = o.age           or 0
    o.dead          = o.dead          or false
    o.x_accel       = o.x_accel       or 0
    o.x_accel_turns = o.x_accel_turns or 0
    o.y_accel       = o.y_accel       or 0
    o.y_accel_turns = o.y_accel_turns or 0
    o.accel         = o.accel         or 0
    o.accel_turns   = o.accel_turns   or 0
    o.rot           = o.rot           or 0
    o.rot_turns     = o.rot_turns     or 0
    o.child_kind    = a.child_kind    or o.child_kind
    o.top_half      = a.top_half      or o.top_half
    o.edge_margin   = a.edge_margin   or o.edge_margin or 100
    if not o.child_kind and o.kind == "spawner" then
        o.child_kind = "enemy_bullet"
    else
        o.child_kind = o.kind
    end
    if obj_man then
        obj_man:add(o)
        for junk, args in pairs({...}) do
            obj_man:register(o, args)
        end
    end
end

function Object.run(self)
    --[[if self.fade_time ~= 0 then
        self.fade_time = self.fade_time - 1
        if self.parent and not self.dead and self.parent.x and self.parent.y then
            self.x         = self.parent.x
            self.y         = self.parent.y
        end
        if self.dead then
        end
        return
    end--]]
    if self.accel_turns > 0 then
        self.speed = self.speed + self.accel
        self.accel_turns = self.accel_turns - 1
    end
    if self.rot_turns > 0 then
        self.direction = self.direction + self.rot
        self.rot_turns = self.rot_turns - 1
    end
    local dx,dy = get_cartesian(self.speed, self.direction)
    local redo_speed_dir = false
    if self.x_accel_turns > 0 then
        redo_speed_dir = true
        dx = dx + self.x_accel
    end
    if self.y_accel_turns > 0 then
        redo_speed_dir = true
        dy = dy + self.y_accel
    end
    if redo_speed_dir then
        self.speed, self.direction = get_polar(dx, dy)
    end
    self.x = self.x + dx
    self.y = self.y + dy
    -- TODO: don't hard code dimensions of space.
    self.dead = self.dead or self.x < -self.edge_margin or self.y < -self.edge_margin or
        self.x > 800+self.edge_margin or self.y > 600+self.edge_margin
    self.age = self.age + 1
end

function Object.draw(self)
    local r,g,b,a = unpack(self.color)
    local is_player = self.kind == "player"
    local size = is_player and 9 or 16
    local age = (self.kind == "bot_fade" or self.kind == "top_fade")
                and (3-self.age*.4) or self.age
    if age < 6 then
        size = size + 30 * ((6-age) / 6)
        a = (a or 255) - 130 - ((5-age) * 20)
    end
    local x,y,w,h = self.x - size/2, self.y - size/2, size, size
    if self.kind == "bot_fade" then
        y,h = y+h/2, h/2
    elseif self.kind == "top_fade" then
        h = h/2
    end
    set_color(r,g,b,a)
    rectangle(x,y,w,h)
    --print(is_player)
    if(is_player) then
        set_color(255, 255, 255, 255)
        rectangle(self.x-.5, self.y-.5, 1, 1)
    end
end

function Object.get_x(self)
    return self.x
end

function Object.get_y(self)
    return self.y
end

function Object.get_age(self)
    return self.age
end
Object.get_turn = Object.get_age

function Object.get_speed_x(self)
    return get_x_from_polar(self.speed,self.direction)
end

function Object.get_speed_y(self)
    return get_y_from_polar(self.speed,self.direction)
end

function Object.get_direction(self)
    return self.direction
end

function Object.get_speed(self)
    return self.speed
end

function Object.set_speed_polar(self, r, theta)
    self.speed      = r
    self.direction  = theta
end
Object.set_speed = Object.set_speed_polar

function Object.set_speed_cartesian(self, x, y)
    self.speed, self.direction = get_polar(x, y)
end

function Object.change_speed(self, speed, turns)
    self.accel          = (speed-self.speed)/turns;
    self.accel_turns    = turns;
end

function Object.change_direction(self, direction, turns)
    direction      = direction % tau;
    self.direction = self.direction % tau
    self.rot       = (direction - self.direction)
    self.rot_turns = turns
    if direction - self.direction > pi then
        self.rot = self.rot - tau
    elseif direction - self.direction < -pi then
        self.rot = self.rot + tau
    end
    self.rot = self.rot / turns
end

function Object.aim(self)
    if (not obj_man) or #obj_man.objects["player"] == 0 then
        print("oh no!")
        return facing_down
    end
    local player = obj_man.objects["player"][1]
    return get_theta(player.x-self.x, player.y-self.y)
end

function Object.core_vanish(self)
    self.dead = true
end

function Object.vanish(self)
    self:core_vanish()
    -- it's important that we stop running the object's script
    -- in addition to killing the object.
    coroutine.yield(0)
end

function Object.set_child_img(self, img)
    self.child_img = img
end

function Object.set_child_kind(self, kind)
    self.child_kind = kind
end

-- each member of ... should be of form {func, ...}
-- a new routine will be created that runs func(child, ...)
-- they can also just be functions mmkay
function Object.fire(self, a, ...)
    if self.dead then
        return
    end
    a.x      = a.x     or self.x
    a.y      = a.y     or self.y
    a.color  = a.color or self.child_color
    a.kind   = a.kind  or self.child_kind
    a.parent = self
    --a.direction = a.direction or a.theta
    --a.speed     = a.speed     or a.r
    Object(a, ...)
end

function Object.wait(self, how_long)
    wait(how_long)
    if self.dead then
        coroutine.yield(0)
    end
end

function wait(how_long)
    if how_long then
        how_long = floor(how_long)
        if how_long < 1 then
            return
        end
    else
        how_long = 1
    end
    coroutine.yield(how_long)
end
