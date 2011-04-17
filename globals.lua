keys = {}
this_frame_keys = {}

object_kinds = {"player", "enemy_bullet"}
for a,b in ipairs(object_types) do object_types[b]=a end

pi              = 3.141592653589793238462643383279502
degrees         = 0.01745329251994329576923690768489
tau             = 6.283185307179586476925286766559
facing_right    = 0.0
facing_up       = 1.5707963267948966192313216916398
facing_left     = 3.141592653589793238462643383279502
facing_down     = 4.7123889803846898576939650749193

sin     = math.sin
cos     = math.cos
atan2   = math.atan2
sqrt    = math.sqrt
min     = math.min
max     = math.max

gfx_q = Queue()
