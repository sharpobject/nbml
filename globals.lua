keys = {}
this_frame_keys = {}

object_kinds = {"player", "enemy_bullet", "spawner", "nothing",
            "top_fade", "bot_fade"}

function append(...)
    ret = {}
    for _, tab in ipairs({...}) do
        for __, element in ipairs(tab) do
            ret[#ret+1] = element
        end
    end
    return ret
end

colors = {  red     = {220, 50,  47 },
            orange  = {255, 140, 0  },
            green   = {80,  169, 0  },
            purple  = {168, 128, 192},
            blue    = {38,  139, 210},
            pink    = {211, 68,  134},
            white   = {234, 234, 234},
            black   = {20,  20,  20 },
            dgray   = {28,  28,  28 }}

default_colors = {player         = colors.orange,
                    enemy_bullet = colors.white,
                    nothing      = append(colors.white, {0}),
                    spawner      = append(colors.white, {0}),
                    top_fade     = colors.white,
                    bot_fade     = colors.white}
for a,b in ipairs(object_kinds) do object_kinds[b]=a end

pi              = 3.141592653589793238462643383279502
degrees         = 0.01745329251994329576923690768489
tau             = 6.283185307179586476925286766559
facing_right    = 0.0
facing_up       = 1.5707963267948966192313216916398
facing_left     = 3.141592653589793238462643383279502
facing_down     = 4.7123889803846898576939650749193
rank            = 0

sin     = math.sin
cos     = math.cos
atan2   = math.atan2
sqrt    = math.sqrt
min     = math.min
max     = math.max
abs     = math.abs
floor   = math.floor
ceil    = math.ceil
random  = math.random

gfx_q = Queue()

-- All of these functions assume that "Cartesian" means "screen space."
function get_polar(x, y)
	return sqrt(x*x+y*y), atan2(-y,x)
end

function get_theta(x, y)
	return atan2(-y,x)
end

function get_cartesian(r, theta)
	return r*cos(theta), -r*sin(theta)
end

function get_x_from_polar(r, theta)
	return r*cos(theta)
end

function get_y_from_polar(r, theta)
	return -r*sin(theta)
end

function v_add(a,b)
    return a[1]+b[1], a[2]+b[2]
end

function v_add_polar(a, b)
    return get_polar(a[1]*cos(a[2]) + b[1]*cos(b[2]),
        -a[1]*sin(a[2]) - b[1]*sin(b[2]))
end

-- accepts a table, returns a shuffled copy of the table
-- accepts >1 args, returns a permutation of the args
function shuffle(first_arg, ...)
    local ret = {}
    local tab = {first_arg, ...}
    local is_packed = (#tab > 1)
    if (not is_packed) then
        tab = first_arg
        for i=1,#tab do
            ret[i] = tab[i]
        end
    else
        ret = tab
    end
    local n = #ret
    for i=1,n do
        local j = random(i,n)
        ret[i], ret[j] = ret[j], ret[i]
    end
    if is_packed then
        return unpack(ret)
    end
    return ret
end

function uniformly(t)
    return t[random(#t)]
end
