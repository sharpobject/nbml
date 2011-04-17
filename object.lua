Object = class(function(o, x, y, direction, speed, sprite, kind)
        o.x             = x         or 400
        o.y             = y         or 300
        o.direction     = direction or facing_down
        o.speed         = speed     or 0
        o.img           = img       or nil
        o.kind          = kind      or "enemy"
        o.age           = 0
        o.dead          = false
        o.health        = 1
        o.x_accel       = 0
        o.x_accel_turns = 0
        o.y_accel       = 0
        o.y_accel_turns = 0
        o.accel         = 0
        o.accel_turns   = 0
        o.rot           = 0
        o.rot_turns     = 0
        o.child_img     = o.img
        o.child_kind    = o.kind
        if obj_man then
            obj_man.add(o)
        end
    end)

function Object.run(self)
    -- TODO: x_accel and y_accel
    if self.accel_turns > 0 then
        self.speed = self.speed + self.accel
        self.accel_turns = self.accel_turns - 1
    end
    if self.rot_turns > 0 then
        self.direction = self.direction + self.rotation
        self.rotation_turns = self.rotation_turns - 1
    end
    local dx,dy = get_cartesian(speed, direction)
    self.x = self.x + dx
    self.y = self.y + dy
    -- TODO: don't hard code dimensions of space.
    self.dead = self.dead or self.x < -100 or self.y < -100 or
        self.x > 900 or self.y > 700-- or self.health <= 0
    self.age = self.age + 1
end

function Object.draw(self)
    -- TODO: draw something
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

--function Object.getRank(self){return rank; end

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

--function getID(){return (function)activeObject; end
--function getNewest(){return (function)newestObject; end
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
    direction           = direction % tau;
    self.direction      = self.direction % tau
    self.rotation       = (direction - self.direction)
    self.rotationTurns  = turns
    if direction - self.direction > pi then
        self.rotation = self.rotation - tau
    elseif direction - self.direction < -pi then
        self.rotation = sel.rotation + tau
    end
    self.rotation = self.rotation / turns
end

function Object.aim(self)
    if (not obj_man) or #obj_man.objects["player"] == 0 then
        return facing_down
    end
    local player = obj_man.objects["player"][1]
    return get_theta(player.x-self.x, player.y-self.y)
end

function Object.vanish(self)
    self.dead = true
end

function Object.set_child_img(self, img)
    self.child_img = img
end

function Object.set_child_kind(self, kind)
    self.child_kind = kind
end

function Object.fire(self, r, theta, ...)
    Object(self.x, self.y, theta, r, self.child_img, self.child_kind)
end
