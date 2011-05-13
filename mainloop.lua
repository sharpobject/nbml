local wait = coroutine.yield

function fmainloop()
    local func = main_menu
    local arg = "Use arrow keys and left shift key to move.\n"
    while true do
        func,arg = func(arg)
    end
end

function main_menu(message)
    while true do
        for foo,bar in pairs(this_frame_keys) do
            if foo~="lshift" and foo~="up" and foo~="down" and
                foo~="right" and foo~="left" then
                return main_play, foo
            end
        end
        if obj_man then obj_man:draw() end
        set_color(unpack(colors.white))
        gprint((message or "").."Any key: Play 2 unoriginal patterns in a random order.", 300, 280)
        wait()
    end
end

function main_play(key)
    obj_man = ObjMan()
    obj_man:register(nil, {stage_one, key})
    while true do
        obj_man:run()
        if #obj_man.objects["player"] == 0 then
            return main_menu, "You died after "..tostring(floor(obj_man.age/6)/10)
                .." seconds =(\n"
        end
        obj_man:draw()
        wait()
    end
end
