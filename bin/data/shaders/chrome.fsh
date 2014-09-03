uniform sampler2D   texture0;
uniform sampler2D   texture1;
uniform samplerCube cubemap;

varying vec2 v_texcoord;
varying vec3 v_norm;
varying vec3 v_light;
varying vec3 v_eye;   
varying vec3 v_tangent;
varying vec3 v_binormal;
varying vec3 v_halfVec;
uniform vec4 lightDiffuse;        
uniform vec4 lightSpecular;

void main() 
{
    vec3 normalDirection  = normalize(v_norm);
    vec3 tangentDirection = normalize(v_tangent);
    vec3 viewDirection    = normalize(v_eye);
    vec3 lightDirection   = normalize(v_light);
 
    vec3 halfwayVector = normalize(lightDirection + viewDirection);
    vec3 binormalDirection = cross(normalDirection, tangentDirection);
    
    float dotLN = dot(lightDirection, normalDirection); 
  
    vec4 ambientLighting = texture2D(texture0, v_texcoord);
    vec4 diffuseReflection = ambientLighting * max(0.3, dotLN);

    float _AlphaX = 0.2;
    float _AlphaY = 0.8;
 
    vec3 specularReflection;
    if (dotLN < 0.2) // light source on the wrong side?
    {
       specularReflection = vec3(0.3, 0.3, 0.1); 
    }
    else // light source on the right side
    {
        float dotHN = dot(halfwayVector, normalDirection);
        float dotVN = dot(viewDirection, normalDirection);
        float dotHTAlphaX = dot(halfwayVector, tangentDirection) / _AlphaX;
        float dotHBAlphaY = dot(halfwayVector, binormalDirection) / _AlphaY;
        float s = sqrt(max(0.3, dotLN / dotVN)) * exp(-2.0 * (dotHTAlphaX * dotHTAlphaX + dotHBAlphaY * dotHBAlphaY) / (1.0 + dotHN));
        specularReflection = vec3(s,s,s);
    }
 
    gl_FragColor = ambientLighting * diffuseReflection + vec4(specularReflection, 1.0);

   
}