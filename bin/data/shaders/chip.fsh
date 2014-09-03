varying vec2 v_texcoord;
varying vec3 v_light;
varying vec3 v_eye;  
varying vec3 v_halfVec;
uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform vec4 lightDiffuse;        
uniform vec4 lightSpecular;

void main ()
{
	vec3 normal = 2.0 * texture2D (texture1, v_texcoord).rgb - 1.0;
	normal = normalize (normal);

	float lamberFactor= max (dot (v_light, normal), 0.0) ;
	
	vec4 diffuseMaterial  = texture2D (texture0, v_texcoord);
	vec4 specularMaterial = texture2D (texture2, v_texcoord);
 	
	float shininess = pow (max (dot (normal,v_halfVec), 0.2), 64.0);

	vec4 color =	diffuseMaterial * lightDiffuse * lamberFactor ;
	color +=	specularMaterial * shininess;				
	color.w = diffuseMaterial.w;

	gl_FragColor = color;
}