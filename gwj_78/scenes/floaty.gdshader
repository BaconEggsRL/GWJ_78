shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 20.0) = 0.0;
const float speed = 10.0;

uniform vec2 texture_size = vec2(64.0, 64.0); // Set this manually to match your texture
uniform bool enabled = false;
uniform float start_time = 0.0; // This needs to be updated externally

void fragment() {
	if (enabled) {
		float phase = TIME - start_time; // Reset phase when enabled
    	vec2 offset = vec2(0.0, (sin(phase * speed) * amplitude));
    	COLOR = texture(TEXTURE, UV + offset / texture_size);
	}
}
