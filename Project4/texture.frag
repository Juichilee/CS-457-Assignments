#version 330 compatibility

uniform sampler2D TexUnit;
in vec2 vTexCoord;

void
main( )
{
	gl_FragColor = texture2D(TexUnit, vTexCoord).rgba;
}