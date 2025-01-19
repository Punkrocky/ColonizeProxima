shader_type canvas_item;

uniform vec4 ActiveColor:source_color;
uniform vec2 MousePos;
varying vec4 MouseScreenPos;

void vertex()
{
	// Called for every vertex the material is visible on.
  VERTEX *= vec2(1.2,1.2);
  MouseScreenPos = vec4(MousePos, 0.0,1.0);
}

void fragment()
{
	// Called for every pixel the material is visible on.
  vec4 tempColor = (COLOR * vec4(0.29,0.54,0.11,1.0)) * ActiveColor;
  //tempColor *= length(FRAGCOORD - vec4(680.0,360.0,0.0,0.0));
  tempColor *= length(FRAGCOORD - MouseScreenPos);
  COLOR = tempColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
