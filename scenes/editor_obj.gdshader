shader_type canvas_item;

uniform vec2 scale = vec2(1.0, 1.0);
uniform vec2 regionPosition = vec2(0.0, 0.0);  // sub Image position pixel (for atlas: use same as region XY) / for non atlas keep it 0,0
uniform vec2 regionSize = vec2(64., 64.);  // sub Image size pixel
uniform vec4 tint = vec4(1, 1, 1, 1);


void fragment() {

	// real size of tuxture in pixels
	vec2 texSize = vec2(1,1) / TEXTURE_PIXEL_SIZE; // TEXTURE_PIXEL_SIZE may be for atlas

    float uv_w =  regionSize.x / texSize.x;
    float uv_h =  regionSize.y / texSize.y;
    float uv_x =  regionPosition.x / texSize.x;
    float uv_y =  1.0 - regionPosition.y / texSize.y -uv_h;

	vec2 newUvAtlas = vec2(mod(UV.x * scale.x  , uv_w ) + uv_x  , mod(UV.y * scale.y, uv_h) + uv_y);

    COLOR = texture(TEXTURE, newUvAtlas) * tint;
}
