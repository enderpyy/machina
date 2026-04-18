shader_type canvas_item;

uniform int PixelSize: hint_range(1, 100, 1) = 20;

void fragment() { //runs for each pixel in texture !??!?
	//float dist_to_y = float(int(FRAGCOORD.y)%sample_size);
	float x = UV.x - float((int(UV.x/TEXTURE_PIXEL_SIZE.x) % PixelSize)-int(floor(float(PixelSize)/2.0)))*TEXTURE_PIXEL_SIZE.x;
	float y = UV.y - float((int(UV.y/TEXTURE_PIXEL_SIZE.y) % PixelSize)-int(floor(float(PixelSize)/2.0)))*TEXTURE_PIXEL_SIZE.y;

	COLOR = texture(TEXTURE, vec2(x, y));

}
