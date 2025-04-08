// by randomDam
shader_type canvas_item;

uniform float x = 0.0; // variable
uniform float y = 0.0;

void fragment(){
	COLOR = vec4(0,0,0,0.5);
	//COLOR = vec4(UV, 0, 1);  // degradado?       derecha opacidad
}

void vertex() {

	VERTEX.x += cos(TIME) * x;
	VERTEX.y += sin(TIME) * y;
}