shader_type canvas_item;

// https://godotshaders.com/shader/2d-burn-dissolve-from-point-v-1-0/
// credit to enekoassets

uniform vec2 position;
uniform float radius : hint_range(0.0, 1.5, 0.01);
uniform float borderWidth : hint_range(0.0, 0.4, 0.01) = 0.02;
uniform float burnMult : hint_range(0.0, 0.5, 0.001) = 0.135;
uniform sampler2D noiseTexture;
uniform vec4 burnColor : source_color;

void fragment() {
	float dist = length(position - UV) + (texture(noiseTexture, UV).b) * burnMult;
	COLOR.rgb = mix(COLOR.rgb, burnColor.rgb, float(dist<radius+borderWidth));
	COLOR.a *= 1.0-(float(dist<radius));
}