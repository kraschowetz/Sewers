shader_type canvas_item;

uniform float multiplier = 1.0;
uniform float time_mod = 1.0;

void vertex() {
	VERTEX.y += sin(TIME * time_mod) * multiplier;
}

