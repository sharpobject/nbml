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
