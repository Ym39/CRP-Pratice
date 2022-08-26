#ifndef CUSTOM_GI_INCLUDED
#define CUSTOM_GI_INCLUDED

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/EntityLighting.hlsl"
TEXTURE2D(unity_Lightmap);
SAMPLER(samplerunity_Lightmap);

#if defined(LIGHTMAP_ON)
   #define GI_ATTRIBUTE_DATA float2 lightMapUV : TEXCOORD1;
   #define GI_VARYINGS_DATA float2 lightMapUV : VAR:LIGHT_MAP_UV;
   #define TRANSFER_GI_DATA(input, output) \
   output.lightMapUV = input.lightMapUV * \
   unity_LightmapST.xy + unity_LightmapST.zw;
   #define GI_FRAGMENT_DATA(input) input.lightMapUV
#else
   #define GI_ATTRIBUTE_DATA
   #define GI_VARYINGS_DATA
   #define TRANSFER_GI_DATA(input, output) 
   #define GI_FRAGMENT_DATA(input) 0.0
#endif

struct GI
{
	float3 diffuse;
};

float3 SampleLightMap(float2 lightMapUV)
{
	#if defined(LIGHTMAP_ON)
	    return SampleSingleLightmap(lightMapUV);
	#else
	    return 0.0;
	#endif
}

GI GetGI(float2 lightMapUV)
{
	GI gi;
	gi.diffuse = SampleLightMap(lightMapUV);
	return gi;
}

#endif

