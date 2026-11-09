-- Animations: soft springs for windows, smooth slides for workspaces.

hl.config({ animations = { enabled = true } })

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 },   { 0.32, 1 } } })
hl.curve("easeInOut",    { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",       { type = "bezier", points = { { 0, 0 },      { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 },  { 0.75, 1 } } })
hl.curve("quick",        { type = "bezier", points = { { 0.15, 0 },   { 0.1, 1 } } })

-- springs: lower dampening = more bounce
hl.curve("leaf", { type = "spring", mass = 1, stiffness = 80, dampening = 14 })
hl.curve("calm", { type = "spring", mass = 1, stiffness = 71.26, dampening = 15.83 })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.4,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.8,  spring = "leaf" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "leaf",   style = "popin 85%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.5,  bezier = "linear", style = "popin 85%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.7,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.5,  bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3,    bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.8,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.8,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.4,  bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 4,    spring = "calm", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, spring = "calm", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })
