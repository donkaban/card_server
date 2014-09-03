
uniform sampler2D   texture0; // texture
uniform sampler2D   texture1; // specular map
uniform sampler2D   texture2; // normal map
uniform samplerCube cubemap;

uniform vec4  lightDiffuse;        
uniform vec4  lightSpecular;

varying vec2 v_uv;
varying vec3 v_uv3D;  
varying vec3 v_norm;
varying vec3 v_light;

const float SPEC_POWER = 35.0;
const float SPEC_ATTUNE = 1.0; 
const float CUBE_ATTUNE = 0.25; 


void main() 
{
    vec4 color = texture2D(texture0, v_uv);
    vec4 s_map = texture2D(texture1, v_uv);
    vec3 n_map = normalize(2.0 * texture2D (texture2, v_uv).rgb - 1.0);
    vec4 cube  = textureCube(cubemap,v_uv3D) * CUBE_ATTUNE;

    vec4 diff = lightDiffuse  * max(dot(v_norm,v_light),0.2);
    vec4 spec = lightSpecular * pow(max(dot(v_norm,n_map), 0.0), SPEC_POWER) * SPEC_ATTUNE;

    gl_FragColor = vec4((color * diff + spec + cube).rgb,1.0);
}