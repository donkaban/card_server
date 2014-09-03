uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;

uniform vec4 lightDiffuse;        
uniform vec4 lightSpecular;
uniform   mat4  inverseViewMatrix; 
uniform samplerCube cubemap;

uniform vec3  place0;

varying vec2 v_texcoord;
varying vec3 v_light;
varying vec3 v_eye;  
varying vec3 v_halfVec;
varying mat3 v_normalMatrix;
varying vec3 v_pos; 

void main ()
{
    float coeff = 0.03;
	float h = texture2D(texture2, v_texcoord).b / 2.0; 
    float height  = (1.0 - h) * coeff;

    vec2 tex  = v_texcoord.xy - normalize(v_eye).xy * height; /// viewDirection.z;

	// lookup normal from normal map, move from [0,1] to  [-1, 1] range, normalize
	vec3 nT = texture2D (texture1, tex).rgb;

	mat3 rotationMatrixX =mat3(vec3(1.0,0.0,0.0),
                            vec3(0.0,cos(place0.x),-sin(place0.x)),
                            vec3(0.0,sin(place0.x),cos(place0.x)));

    mat3 rotationMatrixY =mat3(vec3(cos(place0.y),0.0,sin(place0.y)),
                            vec3(0.0,1.0,0.0),
                            vec3(-sin(place0.y),0.0,cos(place0.y)));

	vec3 normal = (2.0 * nT - 1.0)*rotationMatrixX*rotationMatrixY;
	vec4 r = vec4(reflect(v_pos,normalize(normal)),0.0);

    vec3 v_texcoord3D  =  vec3(r.xyz * v_normalMatrix);

	// compute diffuse lighting
	float lamberFactor= max (dot (v_light, normal), 0.2) ;
	
	// // compute specular lighting

	vec4 diffuseMaterial = texture2D (texture0, tex);
	float shininess = pow (max (dot (normal,v_halfVec), 0.0), 64.0);

	vec4 color =	diffuseMaterial * lightDiffuse;
	color += (textureCube(cubemap,v_texcoord3D)* 0.6);
	color*=lamberFactor;
	color.w = texture2D(texture2, v_texcoord).r;

	// if(diffuseMaterial.w < 1.0)
	// 	discard;

	gl_FragColor = color;
}