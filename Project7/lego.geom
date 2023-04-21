#version 330 compatibility
#extension GL_EXT_gpu_shader4: enable
#extension GL_EXT_geometry_shader4: enable

layout( triangles )  in;
layout( triangle_strip, max_vertices=204 )  out;

uniform bool uModelCoords;
uniform int uLevel;
uniform float uQuantize;
uniform float uLightX;
uniform float uLightY;
uniform float uLightZ;
uniform vec3 uColor; 

in vec3 vNormal[3];
out float gLightIntensity;

vec3 V[3];
vec3 N[3];

float
Quantize( float f )
{
	f *= uQuantize;
	f += .5;		// round-off
	int fi = int( f );
	f = float( fi ) / uQuantize;
	return f;
}

vec3
QuantizedVertex( float s, float t )
{
	vec3 v = V[0] + s*V[1] + t*V[2];		// interpolate the vertex from s and t

	if( uModelCoords == false )
	{
		v = ( gl_ModelViewMatrix * vec4( v, 1 ) ).xyz;
	}

	v.x = Quantize( v.x );
	v.y = Quantize( v.y );
	v.z = Quantize( v.z );
	return v;
}

void
ProduceVertex( float s, float t )
{
	vec3 lightPos = vec3( uLightX, uLightY, uLightZ );

	vec3 v = QuantizedVertex( s, t );

	vec3 n = N[0] + s*N[1] + t*N[2];	// interpolate the normal from s and t
	vec3 tnorm = normalize(gl_NormalMatrix * n);	// transformed normal

	vec4 ECposition;
	if( uModelCoords == true )
	{
		ECposition = gl_ModelViewMatrix * vec4( v, 1. );
	}
	else
	{
		ECposition = vec4( v, 1. );
	}

	gLightIntensity  = abs(dot(normalize(lightPos - ECposition.xyz), tnorm));

	gl_Position = gl_ProjectionMatrix * ECposition;
	EmitVertex();
}

void
main( )
{
	V[1] = (gl_PositionIn[1] - gl_PositionIn[0]).xyz;
	V[2] = (gl_PositionIn[2] - gl_PositionIn[0]).xyz;
	V[0] = gl_PositionIn[0].xyz;

	N[1] = vNormal[1] - vNormal[0];
	N[2] = vNormal[2] - vNormal[0];
	N[0] = vNormal[0];

	int numLayers = 1 << uLevel;
	float dt = 1./float(numLayers);
	float t_top = 1.;

	for(int it = 0; it < numLayers; it++){
		float t_bot = t_top - dt;
		float smax_top = 1. - t_top;
		float smax_bot = 1. - t_bot;

		int nums = it + 1;
		float ds_top = smax_top/float(nums-1);
		float ds_bot = smax_bot/float(nums);

		float s_top = 0.;
		float s_bot = 0.;

		for(int is = 0; is < nums; is++){
			
			ProduceVertex(s_bot, t_bot);
			ProduceVertex(s_top, t_top);
			s_top += ds_top;
			s_bot += ds_bot;
		}

		ProduceVertex(s_bot, t_bot);
		EndPrimitive();

		t_top = t_bot;
		t_bot -= dt;

	}

}