shader_type canvas_item;

uniform float alpha_control : hint_range(0.0, 1.0); // Controls overall opacity

void fragment() {
    float alpha = texture(TEXTURE, UV).a; // Get the alpha from the source texture
    
    if (alpha < 0.1) {
        discard; // Skip transparent areas
    }

    vec2 uv = UV * 2.0 - 1.0; // Normalize UV to [-1,1]
    uv *= 3.0; // Scale the fingerprint pattern

    float angle = atan(uv.y, uv.x);
    float radius = length(uv);
    
    // Generate fingerprint ridges using sine waves
    float fingerprint = sin(radius * 20.0 + angle * 10.0);
    fingerprint = smoothstep(0.3, 0.6, fingerprint);

    // Add slight noise for a natural effect
    float noise = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
    fingerprint -= noise * 0.1;

    // Apply the original texture's alpha and scale it with alpha_control
    COLOR = vec4(vec3(fingerprint), alpha * alpha_control);
}
