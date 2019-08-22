Shader "Unity Shaders Book/Chapter13/EdgeDetectNormalsAndDepth"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _EdgeOnly ("Edge Only", Float) = 1.0
        _EdgeColor ("Edge Color", Color) = (0, 0, 0, 1)
        _BackgroundColor ("Background Color", Color) = (1, 1, 1, 1)
        _SampleDistance ("Sample Distance", Float) = 1.0
        _Sensitivity ("Sensitivity", Vector) = (1, 1, 1, 1)
    }

    SubShader
    {
        CGINCLUDE

            #include "UnityCG.cginc"

            float4x4 _FrustumCornersRay;

            sampler2D _MainTex;
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
            };


            v2f vert(appdata_img v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                half2 uv = v.texcoord;
                o.uv[0] = uv;
                
                #if UNITY_UV_STARTS_AT_TOP
                    if(_MainTex_TexelSize.y < 0)
                        uv.y = 1 - uv.y;
                #endif

                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(1, 1) * _SampleDistance;
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(-1, -1) * _SampleDistance;
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(-1, 1) * _SampleDistance;
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(1, -1) * _SampleDistance;

                int index = 0;
                if(v.texcoord.x < 0.5 && v.texcoord.y < 0.5)
                {
                    index = 0;
                }
                else if(v.texcoord.x > 0.5 && v.texcoord.y < 0.5)
                {
                    index = 1;
                }
                else if(v.texcoord.x > 0.5 && v.texcoord.y > 0.5)
                {
                    index = 2;
                }
                else
                {
                    index = 3;
                }

                #if UNITY_UV_STARTS_AT_TOP
                    if(_MainTex_TexelSize.y < 0)
                        index = 3 - index;
                #endif

                o.interpolatedRay = _FrustumCornersRay[index];

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float linearDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth));
                float3 worldPos = _WorldSpaceCameraPos + linearDepth * i.interpolatedRay.xyz;

                float fogDensity = (_FogEnd - worldPos.y) / (_FogEnd - _FogStart);
                fogDensity = saturate(fogDensity * _FogDensity);

                fixed4 finalColor = tex2D(_MainTex, i.uv);
                finalColor.rgb = lerp(finalColor.rgb, _FogColor.rgb, fogDensity);

                return finalColor;
            }
        ENDCG

        Pass
        {
            ZTest Always
            Cull Off
            ZWrite Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            ENDCG
        }
    }
    FallBack Off
}
