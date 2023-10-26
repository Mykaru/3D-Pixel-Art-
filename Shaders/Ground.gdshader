shader_type spatial;
render_mode cull_disabled;

uniform bool cel_toggle = true;
uniform bool smooth_color = false;
uniform sampler2D color_noise : source_color;
uniform vec3 color_var1 : source_color;
uniform vec3 color_var2 : source_color;
uniform vec3 color_var3 : source_color;
uniform vec3 overlay_color : source_color = vec3(0.675f, 0.83f, 0.4f);

uniform float color_texture_tile_size = 20.0;
varying vec3 final_color;

void vertex() {
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    // Calculate UV coordinates for the noise texture
    vec2 world_uv = world_vert.xz / color_texture_tile_size; // Adjust tile size as needed

    // Sample the noise texture
    float noise_value = textureLod(color_noise, world_uv, 0.0).r;

    // Define your color regions using cutoff values
    float cutoff1 = 0.3;
    float cutoff2 = 0.6;

    // Assign colors based on the noise value
    vec3 color;
    if (noise_value < cutoff1) {
        color = color_var1; // Red
    } else if (noise_value < cutoff2) {
        color = color_var2; // Green
    } else {
        color = color_var3; // Blue
    }
	
	if (smooth_color) {
		color = mix(color_var1, color_var3, noise_value);
	} else {
		color = mix(overlay_color, color, 0.5);
	}
    // Mix the color with the default color to control intensity
    

    // Pass the color variation to the fragment shader
    final_color = color;
}

void fragment() {
	ALBEDO = final_color;
	
 if (!FRONT_FACING) {
 	NORMAL = -NORMAL;
    }
}