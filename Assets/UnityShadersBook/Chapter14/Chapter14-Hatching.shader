Shader "Custom/Chapter14-Hatching"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _TileFactor ("Tile Factor", Float) = 1
        _Outline ("Outline", Range(0,1)) = 0.1
        _Hatch0 ("Hatch 0", 2D) = "white" {}
        _Hatch1 ("Hatch 1", 2D) = "white" {}
        _Hatch2 ("Hatch 2", 2D) = "white" {}
        _Hatch3 ("Hatch 3", 2D) = "white" {}
        _Hatch4 ("Hatch 4", 2D) = "white" {}
        _Hatch5 ("Hatch 5", 2D) = "white" {}
    }

	//HLSLINCLUDE
 //       #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"		
	//ENDHLSL
  //  SubShader
  //  {
  //      Tags { "RenderType"="Opaque" "Queue"="Geometry"}

		//UsePass "Unity Shaders Book/Chapter 14/Toon Shading/OUTLINE"

		//Pass
		//{
		//	Tags{"LightMode"="ForwardBase"}
		//	HLSLPROGRAM
		//		#pragma vertex vert
		//		#pragma fragment frag
				
		//		#pragma multi_compile_fwdbase

		//		struct a2f
		//		{
		//			float4 vertex : POSITION;
		//			float2 texcoord : TEXCOORD0;
		//		};

		//		struct v2f
		//		{
		//			float4 pos : SV_POSITION;
		//			float2 uv : TEXCOORD0;
		//			float3 hatchWeights0 : TEXCOORD1;
		//			float3 hatchWeights1 : TEXCOORD2;
		//			float3 worldPos : TEXCOORD3;
		//		};

		//		half3 getLightWorldDir(half3 positionLS)
		//		{
		//			half3 lightDir = _MainLightPosition.xyz;

		//		#ifdef _ADDITIONAL_LIGHTS
		//			int perObjectLightIndex = GetPerObjectLightIndex(i);
		//		    float3 lightPositionWS = _AdditionalLightsPosition[perObjectLightIndex].xyz;
					
		//			half3 positionWS = TransformObjectToWorld(positionLS);
		//			float3 lightVector = lightPositionWS - positionWS;
		//			float distanceSqr = max(dot(lightVector, lightVector), HALF_MIN);

		//			lightDir = half3(lightVector * rsqrt(distanceSqr));		
		//		#endif

		//			return lightDir;
		//		}

		//		v2f vert (a2v v)
		//		{
		//			v2f o;
		//			o.worldPos = TransformObjectToWorld(v.vertex.xyz);
		//			o.pos = TransformWorldToHClip(o.worldPos);
		//			o.uv = v.texcoord.xy * _TileFactor;

		//			half3 worldLightDir = normalize(getLightWorldDir(v.vertex.xuz))
		//			half3 worldNormal = TransformObjectToWorldNormal(v.normal);

		//			half diff = saturate(dot(worldLightDir, worldNormal));

		//			o.hatchWeights0 = half3(0,0,0);
		//			o.hatchWeights1 = half3(0,0,0);

		//			float hatchFactor = diff * 7.0f;

		//			switch(ceil(hatchFactor))
		//			{
		//			case 6:
		//				o.hatchWeights0.x = hatchFactor - 5.0f;
		//				break;
		//			case 5:
		//				o.hatchWeights0.x = hatchFactor - 4.0f;
		//				o.hatchWeights0.y = 1.0f - o.hatchWeights0.x;
		//				break;
		//			case 4:
		//				o.hatchWeights0.y = hatchFactor - 3.0f;
		//				o.hatchWeights0.z = 1.0f - o.hatchWeights0.y;
		//				break;
		//			case 3:
		//				o.hatchWeights0.z = hatchFactor - 2.0f;
		//				o.hatchWeights1.x = 1.0f - o.hatchWeights0.z;
		//				break;
		//			case 2:
		//				o.hatchWeights1.x = hatchFactor - 1.0f;
		//				o.hatchWeights1.y = 1.0f - o.hatchWeights1.x;
		//				break;
		//			case 1:
		//				o.hatchWeights1.y = hatchFactor;
		//				o.hatchWeights1.z = 1.0f - o.hatchWeights1.y;
		//				break;
		//			default:
		//				break;
		//			}

		//			return o;
		//		}

		//		fixed4 frag(v2f i) : SV_Target 
		//		{
		//			half4 hatchTex0 = tex2D(_Hatch0, i.uv) * i.hatchWeights0.x;
		//			half4 hatchTex1 = tex2D(_Hatch1, i.uv) * i.hatchWeights0.y;
		//			half4 hatchTex2 = tex2D(_Hatch2, i.uv) * i.hatchWeights0.z;
		//			half4 hatchTex3 = tex2D(_Hatch3, i.uv) * i.hatchWeights1.x;
		//			half4 hatchTex4 = tex2D(_Hatch4, i.uv) * i.hatchWeights1.y;
		//			half4 hatchTex5 = tex2D(_Hatch5, i.uv) * i.hatchWeights1.z;
		//			half4 whitColor = half4(1,1,1,1) * (1 - i.hatchWeights0.x - i.hatchWeights0.y - i.hatchWeights0.z - 
		//			i.hatchWeights1.x - i.hatchWeights1.y - i.hatchWeights1.z);

		//			fixed4 hatchColor = hatchTex0 + hatchTex1 + hatchTex2 + hatchTex3 + hatchTex4 + hatchTex5 + whitColor;

		//			return half4(hatchColor.rgb * _Color.rgb, 1.0);
		//		}
		//	ENDHLSL
		//}
  //  }
	Fallback Off
}
