function flower_thing(self)
    local dir=-6
    while true do
        for j=0,3 do
            for i=8,1,-1 do
                self:fire(2.5*i,dir*degrees)
            end
            dir=dir+12
            for i=8,1,-1 do
                self:fire(2.5*i,dir*degrees)
            end
            dir = dir + 78
        end
        dir = (dir+15) % 360
        wait(15)
    end
end

function stage_one()
    Object(100, 100, 0, 0, nil, "enemy_bullet", flower_thing)
end
