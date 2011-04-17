ObjMan = class(function(o)
        o.objects     = {}
        o.not_objects = {}
        for idx, kind in ipairs(object_kinds) do
            o.objects[kind]     = {}
            o.not_objects[kind] = {}
        end
        -- TODO: give him an image
        o.add(Object(400, 300, facing_up, 0, IMAGELOL, "player"))
    end)

function ObjMan.draw(self)
    for i=1, #self.objects do
        local objects = self.objects[i]
        for j=1, #objects do
            objects[j]:draw()
        end
    end
end

function ObjMan.run(self)
    if #self.objects["player"] then
        local pdx=0, pdy=0
        if keys["up"]    then pdy = pdy - 1 end
        if keys["down"]  then pdy = pdy + 1 end
        if keys["left"]  then pdx = pdx - 1 end
        if keys["right"] then pdx = pdx + 1 end

        local pspeed, pdirection = get_polar(pdx, pdy)
        pspeed = min(1, pspeed)
        pspeed = pspeed * 7
        if keys["lshift"] then pspeed = pspeed * 0.5 end

        objects["player"][1].speed=pspeed;
        if pspeed ~= 0 then objects["player"][1].direction = pdirection end
    end
    -- TODO: resume coroutines??
    for i=1, #self.objects do
        local objects = objects[i]
        for j=1, #objects do
            objects[j]:run()
        end
    end
    self:collision("enemy_bullet", "player")
    -- TODO: cull dead objects.
end
