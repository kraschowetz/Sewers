shader_type canvas_item;

void vertex(){
	VERTEX.y += sin(TIME * 1.0 + VERTEX.x * 15.0) * 5.0; 
	VERTEX.x += sin(TIME * 1.0 + VERTEX.y * 2.0) * 1.7; 
}