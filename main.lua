require("class")
require("queue")
require("globals")
require("objman")
require("object")
require("graphics")
require("mainloop")
require("enemies")

local N_FRAMES = 0

function love.load()
    math.randomseed(os.time(os.date("*t")))
    graphics_init() -- load images and set up stuff
    --skidfin = love.audio.newSource("skidfin.mp3")
    --skidfin:setLooping(true)
    --skidfin:play()
    mainloop = coroutine.create(fmainloop)
end

local oneframe_time = 1/60
local leftover_time = 0

function love.update(dt)
  leftover_time = leftover_time + dt
  for qq=1,3 do
    if leftover_time >= oneframe_time then
      leftover_time = leftover_time - oneframe_time
      gfx_q:clear()
      set_color(unpack(colors.white))
      local status, err, ret = coroutine.resume(mainloop)
      if not status then
          error(err..'\n'..debug.traceback(mainloop))
      end
      if ret then error(tostring(ret)) end
      this_frame_keys = {}
    end
  end
end

function love.draw()
    --love.timer.step()
    --print("update: "..tostring(love.timer.getDelta()*1000))
    love.graphics.setColor(unpack(colors.dgray))
    love.graphics.rectangle("fill",-5,-5,900,900)
    love.graphics.setColor(unpack(colors.white))
    set_color(unpack(colors.white))
    gprint("FPS: ["..love.timer.getFPS().."]", 10, 10)
    for i=gfx_q.first,gfx_q.last do
        print("pring")
        --[[local tab = {}
        tab[love.graphics.print] = "print"
        tab[love.graphics.rectangle] = "rectangle"
        tab[love.graphics.setColor] = "set_color"
        tab[love.graphics.draw] = "draw"
        print(tab[gfx_q[i][1] ], unpack(gfx_q[i][2]))--]]
        gfx_q[i][1](unpack(gfx_q[i][2]))
    end
    --love.timer.step()
    --print("draw: "..tostring(love.timer.getDelta()*1000))
end

function love.keypressed(key, unicode)
    keys[key] = true
    this_frame_keys[key] = true
    if key == "m" then
   --     skidfin:setVolume(1-skidfin:getVolume())
    end
end

function love.keyreleased(key, unicode)
    keys[key] = false
end
