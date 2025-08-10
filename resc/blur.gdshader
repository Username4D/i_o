// A Customizable Gausian Blur Shader
// Credits to DJBob Gaming YT :D
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int blur_radius : hint_range(1, 32) = 32;
uniform float Darkness : hint_range(0.0,1.0) = 0;
uniform float R : hint_range(0.0,1.0) = 0;
uniform float G : hint_range(0.0,1.0) = 0;
uniform float B : hint_range(0.0,1.0) = 0;
uniform float blur_strength : hint_range(0.1, 10.0) = 0.1;
