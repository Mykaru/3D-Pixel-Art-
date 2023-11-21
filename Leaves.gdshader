shader_type spatial;
render_mode cull_disabled;

uniform vec3 leaves_color : source_color;
uniform sampler2D alpha_mask;

void fragment() {
	if (!FRONT_FACING) {
        NORMAL = -NORMAL;
    }
	
	ALBEDO = leaves_color;
	ALPHA = texture(alpha_mask, UV).x;
	ALPHA_SCISSOR_THRESHOLD = 0.1;
	}
