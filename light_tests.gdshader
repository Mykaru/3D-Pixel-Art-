shader_type spatial;

uniform vec3 albedo : source_color;
uniform float emission_intensity : hint_range(0, 2);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec3 emission : source_color = vec3(0.0, 0.0, 0.0); // Adjust the color as needed


void fragment() {
	vec4 albedo_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec3 emitted_light = albedo * emission_intensity;

    ALBEDO = albedo_color.rgb + emission;
}
