shader_type canvas_item;

uniform vec2 center = vec2(0.5);
uniform vec2 size = vec2(1.0);
uniform float corner_radius = 0.25;
uniform float border_width = 0.08;
uniform float anim_speed = 0.5;
uniform vec4 modulate : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D border_ramp;

float round_rect(vec2 pt, vec2 cen, vec2 s, float cr, float blurr){
	vec2 halfsize = s * 0.5;
	vec2 p = abs(pt-cen);
	float m = length(max(p-halfsize+vec2(cr),vec2(0.0)))-cr;
	return 1.0-smoothstep(0.0, blurr, m);
}

void fragment(){
	float avg_size = (size.x + size.y) * 0.5;
	vec4 border_color = textureLod(border_ramp, vec2(fract((TIME * anim_speed - UV.x - UV.y)), 0.0), 0.0);
	vec4 col1 = vec4(border_color.rgb, round_rect(UV, center, size, corner_radius, 0.01) * modulate.a);
	vec4 col2 = vec4(modulate.rgb, round_rect(UV, center, size-(2.0*border_width), corner_radius-border_width, 0.01) * modulate.a);

	COLOR = mix(col1, col2, col2.a);
//	COLOR = vec4(1.0,1.0,1.0,round_rect2(UV, center, size, corner_radius, 0.01));
}