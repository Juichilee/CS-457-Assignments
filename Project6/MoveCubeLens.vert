#version 330 compatibility

uniform float uXc;
uniform float uYc;
uniform float uZc; 
uniform float uDx; 
uniform float uDy; 
uniform float uDz;

uniform float uXm;	
uniform float uYm;		    
uniform float uZm;		        
uniform float uDmx;			
uniform float uDmy;		
uniform float uDmz;

uniform vec4 uColorm;
uniform float uEdgeMargin;
uniform bool lock;

out float inEdge;
out vec4 vColor;
out vec2 vST;

void
main( )
{    
        inEdge = 1.0;
        vST = gl_MultiTexCoord0.st;
        vColor = vec4(0., 0., 0., 0.);

        vec3 boxPos = vec3(uXc, uYc, uZc);
        float xh = uDx/2.0;
        float yh = uDy/2.0;
        float zh = uDz/2.0;

        float x = gl_Vertex.x;
        float y = gl_Vertex.y;
        float z = gl_Vertex.z;

        // Create Magic Cube

        if(x >= boxPos.x - xh && x <= boxPos.x + xh &&
            y >= boxPos.y - yh && y <= boxPos.y + yh &&
            z >= boxPos.z - zh && z <= boxPos.z + zh){
            
            vColor = vec4(1., 0., 0., 1.);

            if(lock){
                
                vColor = uColorm;

                if(x >= boxPos.x + xh - uEdgeMargin || x <= boxPos.x - xh + uEdgeMargin ||
                    y >= boxPos.y + yh - uEdgeMargin || y <= boxPos.y - yh + uEdgeMargin ||
                    z >= boxPos.z + zh - uEdgeMargin || z <= boxPos.z - zh + uEdgeMargin){
                    inEdge = 0.0;
                    vColor = vec4(0., 0., 0., 0.);
                }
                vec4 newVertex = vec4(x * uDmx, y * uDmy, z * uDmz, 1.0);
                newVertex = vec4(newVertex.x + uXm, newVertex.y + uYm, newVertex.z + uZm, 1.0);
                gl_Position = gl_ModelViewProjectionMatrix * newVertex;
            }else{
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }
        }else if(lock && x >= boxPos.x - xh - uEdgeMargin && x <= boxPos.x + xh + uEdgeMargin &&
            y >= boxPos.y - yh - uEdgeMargin && y <= boxPos.y + yh + uEdgeMargin &&
            z >= boxPos.z - zh - uEdgeMargin && z <= boxPos.z + zh + uEdgeMargin){
            inEdge = 0.0;
            vColor = vec4(0., 0., 0., 0.);
            gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        }else{
            gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
        }

        
        
}