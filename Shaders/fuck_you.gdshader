shader_type spatial;
render_mode cull_disabled;

uniform vec3 color : source_color;
varying vec3 worldPos;

void vertex() {
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	ALBEDO = color;
	
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}
