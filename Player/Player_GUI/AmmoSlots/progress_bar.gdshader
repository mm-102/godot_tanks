shader_type canvas_item;

uniform float value = 0.0;
uniform vec2 center = vec2(0.5);
uniform vec2 size = vec2(1.0);
uniform float corner_radius = 0.25;
uniform float border_width = 0.08;
uniform vec4 modulate : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 modulate_bar : hint_color = vec4(0.0, 0.0, 0.0, 1.0);

float round_rect(vec2 pt, vec2 cen, vec2 s, float cr, float blurr){
	vec2 halfsize = s * 0.5;
	vec2 p = abs(pt-cen);
	float m = length(max(p-halfsize+vec2(cr),vec2(0.0)))-cr;
	return 1.0-smoothstep(0.0, blurr, m);
}

void fragment(){
	float mask = round_rect(UV, center, size-(2.0*border_width), corner_radius-border_width, 0.01);
	float part = smoothstep(0.0, 0.01, UV.y - 1.0 + value);
	vec4 col = vec4(modulate.rgb, mask * modulate.a);
	vec4 col2 = vec4(modulate_bar.rgb, part * modulate_bar.a * mask);

	COLOR = mix(col, col2, col2.a);
}