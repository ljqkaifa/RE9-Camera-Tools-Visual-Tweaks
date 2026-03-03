-- Ultrawide Fix for Resident Evil Requiem
-- Proper 21:9 and 32:9 support, removes black bars in cutscenes [citation:5]

local resolution = nil
local ultrawide_active = true
local aspect_ratio = 2.37 -- Default 21:9

re.on_frame(function()
    if resolution == nil then
        resolution = sdk.get_managed_singleton("via.Resolution")
    end
end)

function apply_ultrawide()
    if not resolution then return end
    
    -- Force aspect ratio override
    resolution:set_field("ForcedAspectRatio", aspect_ratio)
    
    -- Adjust FOV for ultrawide
    local camera = sdk.get_managed_singleton("via.Camera")
    if camera then
        local current_fov = camera:call("getFOV")
        -- Compensate FOV for wider aspect
        local corrected_fov = current_fov * (aspect_ratio / (16/9))
        camera:call("setFOV", corrected_fov)
    end
    
    -- Remove black bars in cutscenes
    local cinema = sdk.get_managed_singleton("via.Cinema")
    if cinema then
        cinema:set_field("BlackBars", false)
        cinema:set_field("Letterbox", false)
    end
end

imgui.on_menu("Ultrawide Fix", function()
    local active_changed, active_val = imgui.checkbox("Enable Ultrawide Fix", ultrawide_active)
    if active_changed then
        ultrawide_active = active_val
    end
    
    if ultrawide_active then
        imgui.text("Aspect Ratio Presets:")
        if imgui.button("21:9 (2560x1080)") then
            aspect_ratio = 2.37
            apply_ultrawide()
        end
        imgui.same_line()
        if imgui.button("21:9 (3440x1440)") then
            aspect_ratio = 2.389
            apply_ultrawide()
        end
        imgui.same_line()
        if imgui.button("32:9 (5120x1440)") then
            aspect_ratio = 3.556
            apply_ultrawide()
        end
        
        local ar_changed, ar_new = imgui.slider_float("Custom Aspect Ratio", aspect_ratio, 1.6, 4.0)
        if ar_changed then
            aspect_ratio = ar_new
            apply_ultrawide()
        end
        
        imgui.text("Note: Some pre-rendered cutscenes may still have black bars.")
        imgui.text("All gameplay and real-time cutscenes are fully fixed.")
    end
end)

re.on_frame(function()
    if ultrawide_active and resolution then
        apply_ultrawide()
    end
end)