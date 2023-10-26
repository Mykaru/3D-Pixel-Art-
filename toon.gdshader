shader_type spatial;
render_mode cull_disabled;
//render_mode ambient_light_disabled;


uniform vec4 albedo : source_color = vec4(1.0f);
uniform sampler2D albedo_texture : source_color;
uniform bool clamp_diffuse_to_max = true;

uniform int cuts : hint_range(1, 8) = 3;
uniform float wrap : hint_range(-2.0f, 2.0f) = -0.1f;
uniform float steepness : hint_range(0.1f, 8.0f) = .75f;

uniform bool use_attenuation = true;

uniform bool use_specular = true;
uniform float specular_strength : hint_range(0.0f, 1.0f) = 1.0f;
uniform float specular_shininess : hint_range(0.0f, 32.0f) = 16.0f;
uniform sampler2D specular_map : source_color;

uniform bool use_ramp = false;
uniform sampler2D ramp : source_color;




void vertex() {
	
}

void fragment() {
	ALBEDO = albedo.rgb * texture(albedo_texture, UV).rgb;
	
	if (!FRONT_FACING) {
        NORMAL = -NORMAL;
    }
}

void light() {
	// Attenuation.
	float attenuation = 1.0f;
	if (use_attenuation) {
		attenuation = ATTENUATION;
	}
	
	// Diffuse lighting.
	float NdotL = dot(NORMAL, LIGHT);
	float diffuse_amount = NdotL + (attenuation - 1.0) + wrap;
	//float diffuse_amount = NdotL * attenuation + wrap;
	diffuse_amount *= steepness;
	float cuts_inv = 1.0f / float(cuts);
	float diffuse_stepped = clamp(diffuse_amount + mod(1.0f - diffuse_amount, cuts_inv), 0.0f, 1.0f);

	// Calculate borders.
	float border = 0.0f;
	
	
	// Apply diffuse result to different styles.
	vec3 diffuse = ALBEDO.rgb * LIGHT_COLOR / PI;
	if (use_ramp) {
		diffuse *= texture(ramp, vec2(diffuse_stepped * (1.0f - border), 0.0f)).rgb;
	} else {
		diffuse *= diffuse_stepped * (1.0f - border);
	}
	
	if (clamp_diffuse_to_max) {
		// Clamp diffuse to max for multiple light sources.
		DIFFUSE_LIGHT = max(DIFFUSE_LIGHT, diffuse);
	} else {
		DIFFUSE_LIGHT += diffuse;
	}
	
	
}
