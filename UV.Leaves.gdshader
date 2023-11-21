shader_type spatial;
render_mode shadows_disabled, cull_disabled;

uniform sampler2D alphaTexture;
uniform vec4 leavesColor : source_color;
uniform float alphaThreshold = 0.645;

//WindShader
global uniform float WindScale;
global uniform float WindSpeed;
global uniform float WindStrength;
global uniform float WindDensity;
uniform bool deactiveGlobalVariation;



void vertex(){
	//Wind
	float clampTop = 1.0;
	float clampBottom = 0.0;
	vec3 world_pos = (MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
	float contribution = 1.0 * (1.0 - float(deactiveGlobalVariation));
	vec3 world_pos_eff = world_pos * contribution;
	float positional_influence = - VERTEX.x + VERTEX.z - world_pos_eff.x + world_pos_eff.z;
	float offset = fract(positional_influence * (1.0/WindScale) + (TIME * WindScale/1000.0));
	offset = min(1.0 - offset, offset);
	offset = (1.0 - offset) * offset * 2.0;
	
	float t = TIME + sin(TIME + offset + cos(TIME + offset * WindStrength * 2.0) * WindStrength);
	float mask = clamp(VERTEX.y * WindDensity,0.0, 1.0) * (clampTop - clampBottom) + clampBottom;
	
	float si = sin(t) / 20.0 * WindStrength * offset;
	float csi = cos(t) / 20.0 * WindStrength * offset;
	
	vec3 wind_offset = vec3(VERTEX.x * si * mask, VERTEX.y * si * mask, VERTEX.z * csi * mask);
	
	VERTEX += wind_offset;
	
	
	}
	
	
void fragment() {
	vec3 albedo = vec3(leavesColor.xyz);

	ALBEDO = vec3(leavesColor.xyz);
	ALPHA = texture(alphaTexture,UV).x;
	ALPHA_SCISSOR_THRESHOLD = alphaThreshold;
	
	if (!FRONT_FACING) {
        NORMAL = -NORMAL;
    }
	


}