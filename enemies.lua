function later(self, time, args)
    self:wait(time)
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
        self:wait(2)
    end
end

function mk_wander(x,y,w,h,accel,period)
  x = x or 300
  y = y or 40
  w = w or 200
  h = h or 170
  accel = accel or 30
  period = period or 120
  return function(self)
    while true do
        self:wait(period)
        -- Choose a random spot to wander to
        local xx = random(w) + x
        local yy = random(h) + y
        local r, theta = get_polar(xx-self.x, yy-self.y)
        self:change_speed(r/accel, accel)
        self:change_direction(theta, 1)
        self:wait(accel)
        self:change_speed(0, accel)
        self:wait(accel)
    end
  end
end

function mokou_wander(self)
    local x, other_x, y, h, accel = {}, {475}, 0, 120, 30
    for i=325,450,25 do other_x[#other_x+1] = i x[#x+1] = i+12.5 end
    while true do
        self:wait(max(120-45*rank, 0))
        -- Choose a random spot to wander to
        local xx = x[random(#x)]
        local yy = random(h) + y
        local r, theta = get_polar(xx-self.x, yy-self.y)
        self:change_speed(r/accel, accel)
        self:change_direction(theta, 1)
        self:wait(accel)
        self:change_speed(0, accel)
        self:wait(accel)
        x, other_x = other_x, x
    end
end

function mokou_197(self)
    local bouncer = function(self) while true do
        self:wait(1)
        if self.y < 0 or self.y > 600 then
            self.child_color = colors.blue
            self:fire({speed=self.speed/2, direction=self.direction+pi})
            return
        end
    end end
    local spawner = function(self) while true do
        self:wait(20)
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
        self:wait(180 - min(45*rank,120))
    end
end

function grid(self)
    local trace_b = function(self)
        self.child_color = colors.white
        while true do
            self:fire({}, {later, 120, Object.vanish})
            self:wait(2)
        end
    end
    local trace_a = function(self) while true do
        self:fire({speed=25, direction=facing_right, kind="spawner"}, trace_b)
        self:wait(1)
    end end
    --[[local trace_a = function(self) while true do
        self.child_color = {255, 255, 255}
        self:fire(1.5*15, facing_right)
        self:wait(1)
    end end--]]
    Object({x=-25, y=-50, direction=facing_down, speed=50, kind="spawner"}, trace_a)
end

function archimedes(self)
  local child = function(self, start_angle, b, c)
    local r,theta = 0,0
    c = c/60*tau
    local c_x, c_y = self.x, self.y
    local offset_x, offset_y
    while true do
      theta = theta+c
      r = b*theta
      offset_x,offset_y = get_cartesian(r, theta+start_angle)
      self.x = c_x + offset_x
      self.y = c_y + offset_y
      self:wait(1)
    end
  end
  local c, k, direction = 1/5, 1, 1
  local n = 7
  while true do
    self:wait(max(400*c,7))
    print(max(400*c,7))
    c = 1/5/(1.3+.02*rank*k)
    k = k+1
    direction = -direction
    self.child_color = colors.blue
    for i=0,n-1 do
      self:fire({edge_margin=400}, {child, i*tau/n + direction *k* tau/70, 100, c*direction})
    end
  end
end

function small_adds(self)
  local child = function(self, wait_time)
    self:wait(wait_time)
    local direction = self:aim()
    local gchild = function(self)
      self:change_speed(0,1)
      for i=1,3 do
        self:wait(4)
        self:fire({direction=direction, speed=8})
      end
      self:vanish()
    end
    self:fire({direction=direction-tau/4, speed=25}, gchild)
    self:fire({direction=direction+tau/4, speed=25}, gchild)
    self:vanish()
  end
  while true do
    for i=0,3 do
      self:wait(50)
      self.child_color = colors.white
      self:fire({edge_margin = 200,direction=random()*tau, speed=1/3}, {child, 490-50*i})
    end
  end
end

function add_laters(first, ...)
    stuff = {...}
    for idx,data in ipairs(stuff) do
        stuff[idx] = {later, 30, data}
    end
    return first, unpack(stuff)
end

function zander(self)
  local mkguy = function(k)
    return function(self)
      self:change_speed(0,1)
      self.child_color = colors.white
      while true do
        wait(30)
        local direction = self:aim()
        for j=1,3-abs(k) do
          self:fire({direction=direction+4*degrees*k,speed=5+j})
        end
      end
    end
  end
  local c_x = 400
  local c_y = 400
  local r = 350
  for i=-2,2 do
    --cos = x, -sin = y
    local theta = facing_up + 25*degrees*i
    local my_x,my_y = get_cartesian(r,theta)
    my_x = my_x + c_x
    my_y = my_y + c_y
    local speed,direction = get_polar(my_x - self.x, my_y - self.y)
    self:fire({direction=direction,speed=speed}, mkguy(i))
  end
  self:vanish()
  --[[for i=-2,2 do
    self:fire({direction=facing_left, speed=130*i}, mkguy(3-abs(i)))
  end--]]
  --[[while true do
    wait(30)
    local direction = self:aim()
    for i=-2,2 do
      for j=0,2-abs(i) do
        self:fire({direction=direction+i*4*degrees,speed=6+j})
      end
    end
  end--]]
end

function stage_one(junk, key)
    local patterns = {
            {{later, 30*60, Object.vanish, 0}, zander},
            {{later, 22.5*60, Object.vanish, 60}, border_of_wave_and_particle},
            {{later, 15*60, Object.vanish, 360}, mokou_197, mokou_wander},
            {{later, 5*60, Object.vanish, 0}, grid},
            {{later, 23*60, Object.vanish, 0}, archimedes, mk_wander(), small_adds},
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
