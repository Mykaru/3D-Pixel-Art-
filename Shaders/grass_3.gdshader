shader_type canvas_item;


uniform sampler2D texture_alpha : hint_default_white, repeat_disable;
uniform sampler2D grass_color : hint_default_white, repeat_disable;

void vertex() {
	
}

void fragment() {
	float alpha = texture(texture_alpha, UV).r;
	
	
}
