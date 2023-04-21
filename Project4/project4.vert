#version 330 compatibility

uniform float uK, uP;

out vec3 vNs;
out vec3 vEs;
out vec3 vMC;

const float PI = 3.14159265;
const float Y0 = 1.;

void
main( )
{    
        // Calculating z displacement
        float PI = 3.14159265358;
 	    float x = gl_Vertex.x;	
 	    float y = gl_Vertex.y;
	    float Y0 = 1.0;
        float z = uK * (Y0 - y) * sin(2.0*PI*x/uP);
	    z += gl_Vertex.z;
        vMC = gl_Vertex.xyz;
        vec4 newVertex = gl_Vertex;
        newVertex.z = z;

        vec4 ECposition = gl_ModelViewMatrix * newVertex;
       
        // Recalculating normal using change in z
        float dzdx = uK * (Y0 - y) * (2.0*PI/uP) * cos(2.0*PI*x/uP);
        vec3 xtangent = vec3( 1., 0., dzdx );

        float dzdy = -uK * sin(2.0*PI*x/uP);
        vec3 ytangent = vec3( 0., 1., dzdy );

        vNs = normalize(  cross( xtangent, ytangent )  );
        vEs = ECposition.xyz - vec3( 0., 0., 0. ) ; 
	    
        // vector from the eye position to the point

        gl_Position = gl_ModelViewProjectionMatrix * newVertex;
}