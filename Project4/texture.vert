#version 330 compatibility

out vec2 vTexCoord;
void
main( )
{
	vTexCoord = gl_MultiTexCoord0.rg;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}