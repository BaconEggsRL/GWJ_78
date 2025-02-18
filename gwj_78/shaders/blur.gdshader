shader_type canvas_item;

uniform float lod: hint_range(0.0, 5) = 0.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float wave_amplitude: hint_range(0.0, 0.1) = 0.02;
uniform float wave_frequency: hint_range(0.0, 20.0) = 10.0;
uniform float wave_speed: hint_range(0.0, 10.0) = 2.0;
uniform float time_offset: hint_range(0.0, 10.0) = 0.0;  // For animation timing

void fragment() {
    vec2 uv = SCREEN_UV;

    // Apply sinusoidal distortion to UV coordinates
    float wave = sin(uv.y * wave_frequency + TIME * wave_speed + time_offset);
    uv.x += wave * wave_amplitude;

    // Apply blur with distorted UV
    vec4 color = texture(SCREEN_TEXTURE, uv, lod);

    COLOR = color;
}
