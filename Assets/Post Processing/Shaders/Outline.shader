Shader "Hidden/Custom/Outline"
{
    HLSLINCLUDE

        #include "UnityCG.cginc"

        #define TEXTURE2D_SAMPLER2D(textureName, samplerName) Texture2D textureName; SamplerState samplerName
        #define SAMPLE_TEXTURE2D(textureName, samplerName, coord2) textureName.Sample(samplerName, coord2)

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        half4 _MainTex_TexelSize;
        fixed _EdgeOnly;
        fixed4 _EdgeColor;
        fixed4 _BackgroundColor;
        float _SampleDistance;
        half4 _Sensitivity;
        sampler2D _CameraDepthNormalsTexture;

        struct v2f
        {
            float4 pos : SV_POSITION;
            half2 uv[5] : TEXCOORD0;
            float2 texcoordStereo : TEXCOORD5; 
        };

        v2f vert(appdata_img v)
        {
            v2f o;
            o.pos = float4(v.vertex.xy, 0.0, 1.0);
            
            half2 uv = (v.vertex.xy + 1.0) * 0.5;

            #if UNITY_UV_STARTS_AT_TOP
                uv = uv * float2(1.0, -1.0) + float2(0.0, 1.0);
            #endif

            o.texcoordStereo = TransformStereoScreenSpaceTex(uv, 1.0);

            o.uv[0] = uv;
            o.uv[1] = uv + _MainTex_TexelSize.xy * half2(1, 1) * _SampleDistance;
            o.uv[2] = uv + _MainTex_TexelSize.xy * half2(-1, -1) * _SampleDistance;
            o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 1) * _SampleDistance;
            o.uv[4] = uv + _MainTex_TexelSize.xy * half2(1, 1) * _SampleDistance;

            return o;
        }

        half CheckSame(half4 center, half4 sample)
        {
            half2 centerNormal = center.xy;
            float centerDepth = DecodeFloatRG(center.zw);
            half2 sampleNormal = sample.xy;
            float sampleDepth = DecodeFloatRG(sample.zw);

            half2 diffNormal = abs(centerNormal - sampleNormal) * _Sensitivity.x;
            int isSameNormal = (diffNormal.x + diffNormal.y) < 0.1;

            float diffDepth = abs(centerDepth - sampleDepth) * _Sensitivity.y;
            int isSameDepth = diffDepth < 0.1 * centerDepth;

            return isSameNormal * isSameDepth ? 1.0 : 0.0;
        }

        fixed4 fragRobertCrossDepthAndNormal(v2f i) : SV_TARGET
        {
            half4 sample1= tex2D(_CameraDepthNormalsTexture, i.uv[1]);
            half4 sample2= tex2D(_CameraDepthNormalsTexture, i.uv[2]);
            half4 sample3= tex2D(_CameraDepthNormalsTexture, i.uv[3]);
            half4 sample4= tex2D(_CameraDepthNormalsTexture, i.uv[4]);

            half edge = 1.0f;

            edge *= CheckSame(sample1, sample2);
            edge *= CheckSame(sample3, sample4);

            fixed4 withEdgeColor = lerp(_EdgeColor, SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv[0]), edge);
            fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);

            return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
        }


    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex vert
                #pragma fragment fragRobertCrossDepthAndNormal

            ENDHLSL
        }
    }
}
