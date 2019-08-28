Shader "Hidden/Custom/Outline"
{
    HLSLINCLUDE

    	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        half _EdgeOnly;
        half4 _EdgeColor;
        half4 _BackgroundColor;
        float _SampleDistance;
        half4 _Senitivity;
        sampler2D _CameraDepthNormalsTexture;

        struct a2v
        {
            float4 vertex : POSITION;
            half2 texcoord : TEXCOORD0;
        };

        struct v2f
        {
            float4 pos : SV_POSITION;
            half2 uv : TEXCOORD0; 
        };

        v2f vert(a2v v)
        {
            v2f o;
            o.pos = mul(unity_MatrixVP, mul(unity_ObjectToWorld, v.vertex));
            o.uv = v.texcoord;

            return o;
        }

        half4 frag(v2f i) : SV_Target
        {
            half4 renderTex = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);

            return renderTex;
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex vert
                #pragma fragment frag

            ENDHLSL
        }
    }
}
