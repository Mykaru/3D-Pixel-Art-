shader_type spatial;
render_mode cull_disabled;

uniform bool cel_toggle = true;
uniform bool smooth_color = false;
uniform bool if_ground = false;
uniform sampler2D color_noise : source_color;
uniform vec3 grass_color : source_color;
uniform vec3 grass_color2 : source_color;
uniform vec3 grass_color3 : source_color;
global uniform vec4 GrassOverlay;
//uniform vec3 overlay_color : source_color = vec3(0.675f, 0.83f, 0.4f);
uniform bool billboard;
uniform bool normal_shit;
uniform sampler2D alpha_mask; 

uniform float wind_speed = 0.06;
uniform float wind_strength = 0.4;
// How big, in world space, is the noise texture
// wind will tile every wind_texture_tile_size
uniform float wind_texture_tile_size = 40.0;
uniform float wind_vertical_strength = 0.2;
uniform vec2 wind_horizontal_direction = vec2(1.0, 0.5);

//For final color
varying vec3 color_variation;

// we need a tiling noise here!
uniform sampler2D wind_noise : hint_default_black;
uniform vec3 character_position;
uniform float character_radius = 3.0;
uniform sampler2D character_distance_falloff_curve : hint_default_black;
uniform float character_push_strength = 1.0;
varying float debug_wind;

void vertex() {
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vec2 world_uv2 = world_vert.xz / wind_texture_tile_size;
	
	if (!if_ground) {
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vec2 world_uv2 = world_vert.xz / wind_texture_tile_size;
	
	vec2 normalized_wind_direction = normalize(wind_horizontal_direction);
	vec2 world_uv = world_vert.xz / wind_texture_tile_size + normalized_wind_direction * TIME * wind_speed;
	// we displace only the top part of the mesh
	// note that this means that the mesh needs to have UV in a way that the bottom of UV space
	// is at the top of the mesh
	float displacement_affect = (1.0 - UV.y);
	float wind_noise_intensity = (textureLod(wind_noise, world_uv, 0.0).r - 0.5);

	// We convert the direction of the wind into vertex space from world space
	// if we used it directly in vertex space, rotated blades of grass wouldn't behave properly
	vec2 vert_space_horizontal_dir = 
			(inverse(MODEL_MATRIX) * vec4(wind_horizontal_direction, 0.0, 0.0)).xy;
	
	vert_space_horizontal_dir = normalize(vert_space_horizontal_dir);
	
	vec3 bump_wind = vec3(
		wind_noise_intensity * vert_space_horizontal_dir.x,
		1.0 - wind_noise_intensity,
		wind_noise_intensity * vert_space_horizontal_dir.y);
	
	normalize(bump_wind);
	
	bump_wind *= vec3(wind_strength, wind_vertical_strength, wind_strength);
	
	VERTEX += bump_wind * displacement_affect;
	
	// At the moment the blades are pushed away in a perfectly circular manner.
	// We could distort the distance to the character based on a noise, to break a bit the
	// circular shape. We could distort the falloff by sampling in a noise based on the xz coordinates.
	// The task is left to the reader
	
	vec3 dir_to_character = character_position - MODEL_MATRIX[3].xyz;
	// uncomment the following line to have a horizontal only character push
	//dir_to_character.y = 0.0;
	float distance_to_character = length(dir_to_character);
	float falloff = 1.0 - smoothstep(0.0, 1.0, distance_to_character/character_radius);
	// Because we operate in vertex space, we need to convert the direction to the character
	// in vertex space. Otherwise, it wouldn't work for rotated blades of grass.
	// comment the next line to observe how the blades are not all facing away from the character.
	dir_to_character = (inverse(MODEL_MATRIX) * vec4(dir_to_character, 0.0)).xyz;
	dir_to_character = normalize(dir_to_character);

	// sample the curve based on how far we are from the character, in normalized coordinates
	float falloff_curve = texture(character_distance_falloff_curve, vec2(falloff)).x;
	// direction to character is inverted because we want to point away from it
	VERTEX += normalize(-dir_to_character) * falloff_curve * character_push_strength * displacement_affect;
	}
	
	
	
	
	float noise_value = textureLod(color_noise, world_uv2, 0.0).r;
	// Define your color regions using cutoff values
    float cutoff1 = 0.3;
    float cutoff2 = 0.55;

    // Assign colors based on the noise value
    vec3 color;
    if (noise_value < cutoff1) {
        color = grass_color; // Red
    } else if (noise_value < cutoff2) {
        color = grass_color2; // Green
    } else {
        color = grass_color3; // Blue
    }

    if (smooth_color) {
		float t = smoothstep(cutoff1, cutoff2, noise_value);
		color = mix(grass_color, mix(grass_color2, grass_color3, t), t*1.1);
		vec3 final = mix(GrassOverlay.rgb, color, 0.6);
		color_variation = final;
		
	} else {
		color = mix(GrassOverlay.rgb, color, 0.5);
		color_variation = color;
	}

    // Pass the color variation to the fragment shader
    
	
	
	if (billboard) {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
	
}



void fragment() {
	// Use the color variation in the fragment shader
    if (!FRONT_FACING) {
        NORMAL = -NORMAL;
    }
	
	if (billboard || normal_shit) {
		NORMAL = vec3(0.0, 0.65, 0.65);
	}
	
	//float alpha = textureLod(alpha_mask, UV, 0.0).r;
	 //if (alpha < 0.5) {
        // Discard the current fragment for alpha values below the threshold
       // discard;
    //}
	
	ALBEDO = color_variation;
	
}