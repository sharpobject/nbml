local wait = coroutine.yield

function fmainloop()
    local func = main_menu
    local arg = nil
    while true do
        func,arg = func(arg)
    end
end

function main_menu(message)
    local args = {nil, "50.17.236.201", "50.18.48.184", "127.0.0.1"}
    while true do
        gprint((message or "") .. "Press any key to begin :o", 300, 280)
        for foo,bar in pairs(this_frame_keys) do
            return main_play
        end
        wait()
    end
end

function main_play()
    obj_man = ObjMan()
    obj_man:register(nil, stage_one)
    while true do
        obj_man:run()
        obj_man:draw()
        if #obj_man.objects["player"] == 0 then
            return main_menu, "You died =(\n"
        end
        wait()
    end
end
