shader_type spatial;
render_mode unshaded;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

// Resolution must be divisible by pixel_size
const int pixel_size = 4;

void fragment() {
    ivec2 viewportSize = textureSize(SCREEN_TEXTURE, 0);

    // Calculate the screen pixel coordinates
    ivec2 screenCoord = ivec2(floor(FRAGCOORD.xy / float(pixel_size))) * pixel_size;
    
    // Sample the color texture at the screen pixel coordinates
	    ALBEDO = texture(SCREEN_TEXTURE, vec2(screenCoord) / vec2(viewportSize)).xyz;
}