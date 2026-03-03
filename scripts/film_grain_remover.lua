-- Film Grain Remover for Resident Evil Requiem
-- Completely disables the distracting film grain effect [citation:5]

local render_settings = nil

re.on_frame(function()
    if render_settings == nil then
        render_settings = sdk.get_managed_singleton("via.render")
    end
end)

imgui.on_menu("Film Grain Control", function()
    local enabled = true
    local changed, new_val = imgui.checkbox("Disable Film Grain", true)
    
    imgui.text("Film grain adds visual noise that can be distracting.")
    imgui.text("Disabling gives a cleaner, sharper image.")
    imgui.text("This is especially noticeable at higher resolutions.")
end)

re.on_frame(function()
    if render_settings then
        render_settings:set_field("FilmGrain", false)
        render_settings:set_field("FilmGrainIntensity", 0.0)
    end
end)