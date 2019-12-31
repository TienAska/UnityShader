#ifndef CUSTOM_LIGHT_INCLUDED
#define CUSTOM_LIGHT_INCLUDED

//#define MAX_VISIBLE_LIGHTS 4

//CBUFFER_START(_LightBuffer)
//    float4 _VisibleLightColors[MAX_VISIBLE_LIGHTS];
//    float4 _VisibleLightDirections[MAX_VISIBLE_LIGHTS];
//CBUFFER_END

//float3 DiffuseLight (int index, float3 normal)
//{
//    float3 lightColor = _VisibleLightColors[index].rgb;
//    float3 lightDirection = _VisibleLightDirections[index].rgb;
//    float diffuse = saturate(dot(normal, lightDirection));
//    return diffuse * lightColor;
//}

CBUFFER_START(_CustomLight)
	float3 _DirectionalLightColors;
	float3 _DirectionalLightDirection;
CBUFFER_END

struct Light
{
	float3 color;
	float3 direction;
};

Light GetDirectionalLight()
{
	Light light;
	light.color = _DirectionalLightColors;
	light.direction = _DirectionalLightDirection;
	return light;
}

#endif // CUSTOM_LIGHT_INCLUDED