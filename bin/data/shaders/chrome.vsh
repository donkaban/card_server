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
uniform   float time;

#ifndef PLATFORM_ANDROID
    uniform highp mat4  bones[64];
#else
    uniform highp mat4  bones[29];
#endif

varying vec2 v_texcoord;
varying vec3 v_norm;
varying vec3 v_light;
varying vec3 v_eye;   
varying vec3 v_tangent;
varying vec3 v_binormal;
varying vec3 v_halfVec;

highp vec4 getPosition() {return vec4(position,1.0);}
highp vec3 getNormal()   {return normal;}    

void main() 
{
    highp vec4 pos   = getPosition();
    v_texcoord = texcoord;
    highp vec3 p  = vec3(pos * modelMatrix);
    mat3 normalMatrix = mat3(modelMatrix[0].xyz,modelMatrix[1].xyz,modelMatrix[2].xyz);
    v_norm  = normalize(getNormal() * normalMatrix);
    v_light = normalize(lightPosition - p);
    v_eye = normalize(eyePosition   - p);
    v_tangent = normalize(tangent * normalMatrix);
    v_binormal = normalize(binormal * normalMatrix);

    v_halfVec = normalize(lightPosition + eyePosition);  

    gl_Position = pos * modelMatrix * prjViewMatrix;
}