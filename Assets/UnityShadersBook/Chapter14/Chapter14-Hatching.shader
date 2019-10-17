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

	HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"		
	ENDHLSL
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}

		UsePass "Unity Shaders Book/Chapter 14/Toon Shading/OUTLINE"

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_fwdbase

				struct a2f
				{
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;
					float3 hatchWeights0 : TEXCOORD1;
					float3 hatchWeights1 : TEXCOORD2;
					float3 worldPos : TEXCOORD3;
				};

				v2f vert (a2v v)
				{
					v2f o;
					o.worldPos = TransformObjectToWorld(o.vertex.xyz);
				}
			ENDHLSL
		}

    }
}
