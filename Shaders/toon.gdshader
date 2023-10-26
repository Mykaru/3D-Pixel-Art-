shader_type spatial;
render_mode cull_disabled;

uniform vec3 lit_color : source_color;
uniform vec3 mid_color : source_color;
uniform vec3 shadow_color : source_color;

void fragment() {
    // Calculate shading intensity based on dot product of normal and light direction
    vec3 light_direction = normalize(vec3(1.0, 1.0, 1.0)); // Adjust light direction as needed
    float NdotL = max(dot(NORMAL, light_direction), 0.0);

    // Define the number of shading levels
    float num_levels = 2.0; // You can adjust this as needed for more or fewer levels

    // Calculate shading level
    float shading_level = floor(NdotL * num_levels) / num_levels;

    // Define your palette of colors (light, mid, and shadow)
    vec3 final_color;
    if (shading_level < 1.0 / num_levels) {
        final_color = shadow_color;
    } else if (shading_level < 2.0 / num_levels) {
        final_color = mid_color;
    } else {
        final_color = lit_color;
    }

    ALBEDO = final_color;
	
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}