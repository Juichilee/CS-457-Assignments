#version 330 compatibility

in vec3	vMC;
in vec3	vNs;
in vec3	vEs;

uniform sampler2D TexUnit;

uniform bool lock;

in float inEdge;
in vec4 vColor;
in vec2 vST;

void
main( )
{
   


   vec4 texColor = texture2D(TexUnit, vST); 

   gl_FragColor = vec4(mix(texColor.rgb, vColor.rgb, vColor.a), inEdge);
   if(inEdge == 0.0){
       discard;
   }

};