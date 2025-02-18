shader_type canvas_item;

uniform float lod: hint_range(0.0, 5) = 0.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float wave_amplitude: hint_range(0.0, 0.1) = 0.02;
uniform float wave_frequency: hint_range(0.0, 20.0) = 10.0;
uniform float wave_speed: hint_range(0.0, 10.0) = 2.0;
uniform float time_offset: hint_range(0.0, 10.0) = 0.0;

uniform float noise_scale: hint_range(0.1, 10.0) = 5.0;
uniform float noise_speed: hint_range(0.1, 5.0) = 0.424;
uniform float noise_blur_amount: hint_range(0.0, 0.05) = 0.005;

uniform float blob_strength: hint_range(0.0, 1.0) = 0.0;

// Smooth noise function using a pseudo-random gradient
float smooth_noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = fract(sin(dot(i + vec2(0.0, 0.0), vec2(12.9898, 78.233))) * 43758.5453);
    float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(12.9898, 78.233))) * 43758.5453);
    float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);
    float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);

    vec2 u = f * f * (3.0 - 2.0 * f);  // Smoothstep interpolation
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Function to create even softer noise blobs by sampling a wider area
float smooth_blob_noise(vec2 uv) {
    float sum = 0.0;
    sum += smooth_noise(uv - vec2(noise_blur_amount, noise_blur_amount));
    sum += smooth_noise(uv + vec2(noise_blur_amount, -noise_blur_amount));
    sum += smooth_noise(uv + vec2(-noise_blur_amount, noise_blur_amount));
    sum += smooth_noise(uv + vec2(noise_blur_amount, noise_blur_amount));
    return sum * 0.25;  // Averaging the samples
}

vec3 hsv_to_rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    vec2 uv = SCREEN_UV;

    // Apply sinusoidal distortion
    float wave = sin(uv.y * wave_frequency + TIME * wave_speed + time_offset);
    uv.x += wave * wave_amplitude;

    // Sample the blurred screen texture
    vec4 color = texture(SCREEN_TEXTURE, uv, lod);

    // Generate animated, smooth blob noise
    vec2 noise_uv = uv * noise_scale + vec2(TIME * noise_speed, TIME * noise_speed * 0.5);
    float n = smooth_blob_noise(noise_uv);

    // Convert noise to smooth, blob-like rainbow colors
    vec3 rainbow = hsv_to_rgb(vec3(fract(n + TIME * 0.05), 1.0, 1.0));

    // Blend the smooth rainbow blobs with the blurred screen texture based on blob_strength
    vec3 final_color = mix(color.rgb, rainbow, blob_strength);

    COLOR = vec4(final_color, color.a);
}
