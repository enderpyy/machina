shader_type canvas_item;

uniform vec4 first_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec4 second_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float inner_radius : hint_range(0.0, 1.0) = 0.0;
uniform float outer_radius : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 mag_vec = vec2(UV.x-0.5, UV.y-0.5);
	float mag = sqrt(pow(mag_vec.x, 2) + pow(mag_vec.y, 2));
	float pos = smoothstep(inner_radius * pow(0.5, 2)*2.0, outer_radius * pow(0.5, 2)*3.0, mag);
	COLOR = mix(first_color, second_color, pos); 
}