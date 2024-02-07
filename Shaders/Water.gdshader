shader_type canvas_item;

void vertex(){
	VERTEX.y += sin(TIME * 1.0 + VERTEX.x * 15.0) * 12.0; 
	VERTEX.x += sin(TIME) * 10.3;
}

