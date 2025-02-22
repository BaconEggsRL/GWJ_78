shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.5, 1.0); // Warm yellow
uniform float radius : hint_range(0.0, 1.0) = 0.5; // Glow size
uniform float intensity : hint_range(0.0, 5.0) = 1.5; // Glow brightness
uniform bool enabled = false;

void fragment() {
	if (!enabled) {
        discard; // Completely removes fragment when disabled (invisible)
    }
    vec2 uv_centered = UV - vec2(0.5); // Center the effect
    float dist = length(uv_centered); // Get distance from center

    // Smooth fade effect
    float glow = 1.0 - smoothstep(radius, radius * 1.5, dist);
    
    // Apply intensity and color
    COLOR = glow_color * glow * intensity;
}
