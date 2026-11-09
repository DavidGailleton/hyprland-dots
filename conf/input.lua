-- Input: keyboard, touchpad, gestures.

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_options = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            disable_while_typing = true,
            clickfinger_behavior = true,  -- 2-finger click = right click
            scroll_factor        = 0.6,
        },
    },

    gestures = {
        workspace_swipe_distance = 400,
        workspace_swipe_cancel_ratio = 0.3,
        workspace_swipe_create_new = true,
    },
})

-- 3 fingers left/right: switch workspace
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- 3 fingers up: toggle the scratchpad
hl.gesture({ fingers = 3, direction = "up", action = "special", workspace_name = "magic" })
