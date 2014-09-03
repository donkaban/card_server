
attribute vec3  position;
attribute vec2  texcoord;
attribute vec3  normal;
attribute vec4  bone_id;
attribute vec4  bone_weight;
attribute vec3  tangent;
attribute vec3  binormal; 

uniform   mat4  modelMatrix;
uniform   mat4  prjMatrix;    
uniform   mat4  viewMatrix;  
uniform   mat4  prjViewMatrix;   

uniform   vec3  lightPosition;    
uniform   vec3  eyePosition;    
uniform   float currentTime;
uniform   mat4  inverseViewMatrix; 

uniform vec3  place0; 

varying vec2 v_uv;
varying vec3 v_uv3D;
varying vec3 v_norm;
varying vec3 v_light;

void main() 
{
    vec3 p   = vec3(vec4(position,1.0) * modelMatrix);
    v_uv    = texcoord;
    mat3 normalMatrix = mat3(modelMatrix[0].xyz,modelMatrix[1].xyz,modelMatrix[2].xyz);
    v_norm  = normalize(normal * normalMatrix);
    v_light = normalize(lightPosition - p);

    mat3 rotationMatrixX =mat3(vec3(1.0,0.0,0.0),
                            vec3(0.0,cos(place0.x),-sin(place0.x)),
                            vec3(0.0,sin(place0.x),cos(place0.x)));

    mat3 rotationMatrixY =mat3(vec3(cos(place0.y),0.0,sin(place0.y)),
                            vec3(0.0,1.0,0.0),
                            vec3(-sin(place0.y),0.0,cos(place0.y)));
    v_uv3D = vec3(vec4(reflect(p,normalize(v_norm*rotationMatrixX*rotationMatrixY)),.0) * inverseViewMatrix);
    
    gl_Position = vec4(p,1) * prjViewMatrix;
}







