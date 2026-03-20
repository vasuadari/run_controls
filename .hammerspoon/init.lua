hs.window.animationDuration = 0

local k = require("modal").init()

hs.loadSpoon('SpeedMenu')
require('screen').init(k)
require('application').init(k)
require('speed_menu').init(k)
require('Caffeine').init(k)

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
