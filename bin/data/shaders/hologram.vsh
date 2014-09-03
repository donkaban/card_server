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
uniform   mat4  inverseViewMatrix; 

uniform   vec3  lightPosition;    
uniform   vec3  eyePosition;    
uniform   float currentTime;

varying vec2 v_texcoord;
varying vec3 v_light;
varying vec3 v_eye;
varying vec3 v_halfVec;
varying mat3 v_normalMatrix;
varying vec3 v_pos;

void main() 
{
   
    v_texcoord = texcoord;
    vec4 pos = vec4(position,1);
    vec3 p  = vec3( pos * modelMatrix);

    v_pos = p;
    mat3 normalMatrix = mat3(modelMatrix[0].xyz,modelMatrix[1].xyz,modelMatrix[2].xyz);
    vec3 v_norm  = normalize(normal * normalMatrix);
    v_light = normalize(lightPosition - p);
    v_eye   = normalize(eyePosition   - p);
    vec3 v_tangent = normalize(tangent * normalMatrix);
    vec3 v_binormal = normalize(binormal * normalMatrix);

    mat3 TBN = mat3(v_tangent, v_binormal, v_norm);
    v_halfVec = normalize(lightPosition + eyePosition)*TBN;  
    v_light   *= TBN; 
    v_eye     *= TBN; 

    v_normalMatrix = mat3(inverseViewMatrix)*TBN;

    gl_Position = pos * modelMatrix * prjViewMatrix;
}