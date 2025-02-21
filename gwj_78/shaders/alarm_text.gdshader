shader_type canvas_item;

uniform bool enable_flash = true; // Toggle flashing effect

void fragment() {
    vec4 base_color = texture(TEXTURE, UV); // Get original text color
    
    if (enable_flash) {
        float time_mod = abs(sin(TIME * 5.0)); // Flash effect
        vec3 flash_color = mix(base_color.rgb, vec3(1.0, 0.0, 0.0), time_mod); // Blend with red
        COLOR = vec4(flash_color, base_color.a); // Preserve transparency
    } else {
        COLOR = base_color; // Keep original color
    }
}
