local Animation = require("animation")
local duration = 50    -- ms
local fps = 60         -- frames per second
local easing = require("animation.easing")
local i = 0
local function callback(fraction)
	i = i + 1
end
local animation = Animation(duration, fps, easing.line, callback)
animation:run()
