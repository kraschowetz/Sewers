shader_type canvas_item;

uniform float intensity = 3.0;
uniform float wiggle_time = 1.5;

void vertex() {
	VERTEX.x += sin(TIME * wiggle_time + VERTEX.y * 0.05) * intensity;
}

