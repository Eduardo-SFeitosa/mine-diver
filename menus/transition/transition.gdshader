shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;
uniform float pixel_size : hint_range(1.0, 64.0) = 1.0;

void fragment() {
	vec2 uv = SCREEN_UV;

	vec2 pixel_count = vec2(pixel_size) * SCREEN_PIXEL_SIZE;
	uv = floor(uv / pixel_count) * pixel_count;

	COLOR = texture(screen_tex, uv);
}
