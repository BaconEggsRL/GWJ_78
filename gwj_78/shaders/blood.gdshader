shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform float blood_coef : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color : source_color = vec4(0.392, 0.0, 0.0, 1.0); // 640000
uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 0.556);  // ffffff8e

uniform bool enabled = false;

void fragment() {
	if (enabled == true) {

	    vec4 curr_texture = texture(TEXTURE, UV);
	    vec4 noise_texture = texture(noise, UV);

	    float is_blood = step(noise_texture.r, blood_coef);
	    noise_texture.r = mix(noise_texture.r, curr_texture.r, is_blood);

	    // Correct blending of colors
	    vec4 blood_output = vec4(noise_texture.rgb * color.rgb, color.a * curr_texture.a);
	    COLOR = mix(curr_texture, blood_output, is_blood);

	    // Proper alpha blending with base_color.a
	    COLOR.a = mix(COLOR.a, base_color.a * curr_texture.a, 1.0);
	}
}
