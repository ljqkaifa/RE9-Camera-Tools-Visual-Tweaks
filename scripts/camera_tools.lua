-- Camera Tools for Resident Evil Requiem
-- First-person toggle, FOV control, free camera

local camera = nil
local player = nil
local first_person = false
local freecam_active = false
local fov_value = 80.0
local camera_distance = 2.5

-- Camera state storage
local original_pos = nil
local cam_pos = { x = 0, y = 0, z = 0 }
local cam_rot = { pitch = 0, yaw = 0, roll = 0 }
local move_speed = 0.1

-- Initialize on first frame
re.on_frame(function()
    if camera == nil then
        camera = sdk.get_managed_singleton("via.Camera")
    end
    if player == nil then
        player = sdk.get_managed_singleton("via.Player")
    end
end)

-- Toggle first-person mode
function toggle_first_person()
    first_person = not first_person
    if camera then
        if first_person then
            -- Save third-person distance
            camera_distance = camera:get_field("Distance") or 2.5
            camera:set_field("Distance", 0)
        else
            -- Restore third-person distance
            camera:set_field("Distance", camera_distance)
        end
    end
    log.info("First person: " .. tostring(first_person))
end

-- Toggle free camera
function toggle_freecam()
    freecam_active = not freecam_active
    if freecam_active and camera then
        -- Save original position
        local pos = camera:get_field("Position")
        original_pos = { x = pos.x, y = pos.y, z = pos.z }
        cam_pos = { x = pos.x, y = pos.y, z = pos.z }
        -- Detach from player
        camera:set_field("Target", cam_pos)
    elseif not freecam_active and original_pos then
        -- Restore original position
        camera:set_field("Position", original_pos)
    end
end

-- Freecam movement
function update_freecam()
    if not freecam_active or not camera then return end
    
    -- WASD movement
    if imgui.is_key_down(imgui.key.W) then cam_pos.z = cam_pos.z - move_speed end
    if imgui.is_key_down(imgui.key.S) then cam_pos.z = cam_pos.z + move_speed end
    if imgui.is_key_down(imgui.key.A) then cam_pos.x = cam_pos.x - move_speed end
    if imgui.is_key_down(imgui.key.D) then cam_pos.x = cam_pos.x + move_speed end
    if imgui.is_key_down(imgui.key.Q) then cam_pos.y = cam_pos.y - move_speed end
    if imgui.is_key_down(imgui.key.E) then cam_pos.y = cam_pos.y + move_speed end
    
    -- Apply position
    camera:set_field("Position", cam_pos)
    
    -- Mouse look (hold RMB)
    if imgui.is_mouse_down(1) then
        local delta = imgui.get_mouse_delta()
        cam_rot.yaw = cam_rot.yaw + delta.x * 0.01
        cam_rot.pitch = cam_rot.pitch - delta.y * 0.01
        
        -- Calculate target based on rotation
        local target = {
            x = cam_pos.x + math.sin(cam_rot.yaw) * math.cos(cam_rot.pitch) * 10,
            y = cam_pos.y + math.sin(cam_rot.pitch) * 10,
            z = cam_pos.z + math.cos(cam_rot.yaw) * math.cos(cam_rot.pitch) * 10
        }
        camera:set_field("Target", target)
    end
end

-- FOV control
function set_fov(value)
    if camera then
        camera:call("setFOV", value)
        fov_value = value
    end
end

-- UI Menu
imgui.on_menu("Camera Tools", function()
    -- First-person toggle
    local fp_changed, fp_val = imgui.checkbox("First Person Mode", first_person)
    if fp_changed then
        first_person = fp_val
        toggle_first_person()
    end
    
    -- FOV slider
    local fov_changed, fov_new = imgui.slider_float("Field of View", fov_value, 60.0, 120.0)
    if fov_changed then
        set_fov(fov_new)
    end
    
    -- Camera distance (only in third person)
    if not first_person then
        local dist_changed, dist_new = imgui.slider_float("Camera Distance", camera_distance, 1.0, 5.0)
        if dist_changed then
            camera_distance = dist_new
            camera:set_field("Distance", camera_distance)
        end
    end
    
    imgui.separator()
    
    -- Freecam toggle
    local fc_changed, fc_val = imgui.checkbox("Free Camera Mode", freecam_active)
    if fc_changed then
        freecam_active = fc_val
        toggle_freecam()
    end
    
    if freecam_active then
        imgui.text("Controls: WASD = move, Q/E = up/down, RMB + mouse = look")
        local speed_changed, speed_new = imgui.slider_float("Move Speed", move_speed, 0.01, 1.0)
        if speed_changed then move_speed = speed_new end
        
        if imgui.button("Reset Freecam Position") then
            if original_pos then
                cam_pos = { x = original_pos.x, y = original_pos.y, z = original_pos.z }
                cam_rot = { pitch = 0, yaw = 0, roll = 0 }
            end
        end
    end
    
    imgui.separator()
    
    -- Presets
    if imgui.button("Default (80°, 3rd person)") then
        set_fov(80.0)
        camera_distance = 2.5
        camera:set_field("Distance", camera_distance)
        if first_person then toggle_first_person() end
    end
    imgui.same_line()
    if imgui.button("Immersive (90°, 1st person)") then
        set_fov(90.0)
        if not first_person then toggle_first_person() end
    end
    imgui.same_line()
    if imgui.button("Wide (105°, 3rd person)") then
        set_fov(105.0)
        camera_distance = 3.0
        camera:set_field("Distance", camera_distance)
        if first_person then toggle_first_person() end
    end
end)

-- Update loop
re.on_frame(function()
    update_freecam()
    
    -- Hotkeys
    if imgui.is_key_pressed(imgui.key.F5) then
        toggle_first_person()
    end
    if imgui.is_key_pressed(imgui.key.F6) then
        set_fov(math.min(fov_value + 5, 120))
    end
    if imgui.is_key_pressed(imgui.key.F7) then
        set_fov(math.max(fov_value - 5, 60))
    end
    if imgui.is_key_pressed(imgui.key.F8) then
        set_fov(80.0)
        camera_distance = 2.5
        camera:set_field("Distance", camera_distance)
    end
    if imgui.is_key_pressed(imgui.key.F9) then
        toggle_freecam()
    end
end)

log.info("Camera Tools loaded. Press F5 for 1st/3rd person, F6/F7 for FOV, F9 for freecam.")