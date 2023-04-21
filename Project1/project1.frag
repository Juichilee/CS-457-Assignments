#version 330 core

uniform float uTol;
uniform float uBd;
uniform float uAd;
uniform float uSpaceA;
uniform float uSpaceB;
uniform vec4 color1;
uniform vec4 color2;

in vec3  vMCposition;
in float vLightIntensity; 
in vec2 vST;

layout(location = 0) out vec4 color;

void main()
{
   float Ar = uAd/2.0f;
   float Br = uBd/2.0f;

   int numins = int(vST.s / uAd);
   int numint = int(vST.t / uBd);
   
   float sc = (numins * uAd + Ar);
   float tc = (numint * uBd + Br);

   float ellipse_result = ((vST.s - sc)/Ar * uSpaceA) * ((vST.s - sc)/Ar * uSpaceA) + ((vST.t - tc)/Br* uSpaceB) * ((vST.t - tc)/Br* uSpaceB);

   float t = smoothstep(1.0-uTol, 1.0+uTol, ellipse_result);
   
   vec3 rgb = vLightIntensity * mix(color1.rgb, color2.rgb, t);   
   color = vec4(rgb, 1.0);
};