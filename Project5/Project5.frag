#version 330 compatibility

uniform sampler2D uImageUnit;
in vec2 vTexCoord;

uniform float uSc;
uniform float uTc;
uniform float uDs;
uniform float uDt;
uniform float uMagFactor;
uniform float uRotAngle;
uniform float uSharpFactor;

void
main( )
{
	float radiusx = uDs/2.0;
	float radiusy = uDt/2.0;

	vec2 coord = vTexCoord;

	if(coord.x <= uSc + radiusx && coord.x >= uSc - radiusx
	   && coord.y <= uTc + radiusy && coord.y >= uTc - radiusy){

	   float sine = sin(uRotAngle);
	   float cosine = cos(uRotAngle);

	   // Translate, magnify, and rotate
	   vec2 pivot = vec2(uSc, uTc);
	   vec2 mag = vec2(uMagFactor);
	   coord -= pivot;
	   coord /= mag;
	   coord = mat2(cos(uRotAngle), -sin(uRotAngle), sin(uRotAngle), cos(uRotAngle)) * coord;
	   coord += pivot;

	   // Sharpen
	   ivec2 ires = textureSize(uImageUnit, 0);
	   float ResS = float(ires.s);
	   float ResT = float(ires.t);

	   vec2 stpo = vec2(1./ResS, 0.);
	   vec2 stop = vec2(0., 1./ResT);
	   vec2 stpp = vec2(1./ResS, 1./ResT);
	   vec2 stpm = vec2(1./ResS, -1./ResT);

	   vec3 ioo = texture2D(uImageUnit, coord).rgb;
	   vec3 im1m1 = texture2D(uImageUnit, coord-stpp).rgb;
	   vec3 ip1p1 = texture2D(uImageUnit, coord+stpp).rgb;
	   vec3 im1p1 = texture2D(uImageUnit, coord-stpm).rgb;
	   vec3 ip1m1 = texture2D(uImageUnit, coord+stpm).rgb;
	   vec3 im1o  = texture2D(uImageUnit, coord-stpo ).rgb;
	   vec3 ip1o  = texture2D(uImageUnit, coord+stpo ).rgb;
	   vec3 iom1  = texture2D(uImageUnit, coord-stop ).rgb;
	   vec3 iop1  = texture2D(uImageUnit, coord+stop ).rgb;
	   
	   vec3 target = vec3(0.,0.,0.);
	   target += 1.*(im1m1+ip1m1+ip1p1+im1p1);
	   target += 2.*(im1o+ip1o+iom1+iop1);
	   target += 4.*(ioo);
	   target /= 16.;

	   vec3 irgb = texture2D(uImageUnit, coord).rgb;
	   gl_FragColor = vec4(mix(target, irgb, uSharpFactor), 1.);

	}else{

	   gl_FragColor = texture2D(uImageUnit, vTexCoord.st).rgba;
	}
	
}