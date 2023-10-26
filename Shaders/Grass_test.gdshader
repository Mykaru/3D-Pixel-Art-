shader_type spatial;
render_mode cull_disabled;

uniform sampler2D color_noise : source_color;
uniform vec3 default_color : source_color;
uniform float color_texture_tile_size = 20.0; //wind texture tile size 
uniform float color_noise_speed = 0.1; //wind speed

varying vec3 color_variation;

void vertex() {
    // Calculate the world position of the current vertex
    vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Calculate UV coordinates for sampling the color noise texture
    vec2 world_uv = world_vert.xz / color_texture_tile_size + TIME * color_noise_speed;

    // Sample the color noise texture to get a noise value
    float noise_value = textureLod(color_noise, world_uv, 0.0).r;

    // Define your color regions using cutoff values
    float cutoff1 = 0.3;
    float cutoff2 = 0.6;

    // Assign colors based on the noise value
    vec3 color;
    if (noise_value < cutoff1) {
        color = vec3(1.0, 0.0, 0.0); // Red
    } else if (noise_value < cutoff2) {
        color = vec3(0.0, 1.0, 0.0); // Green
    } else {
        color = vec3(0.0, 0.0, 1.0); // Blue
    }

    // Mix the color with the default color to control intensity
    color = mix(default_color, color, noise_value);

    // Pass the color variation to the fragment shader
    color_variation = color;
}

void fragment() {
    // Use the color variation in the fragment shader
    ALBEDO = color_variation;

    if (!FRONT_FACING) {
        NORMAL = -NORMAL;
    }
}
