// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unity Shaders Book/Chapter10/Refraction"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RefractionColor ("Refraction Color", Color) = (1,1,1,1)
        _RefractionAmount ("Refraction Amount", Range(0,1)) = 1
        _RefractionRatio ("Refraction Ratio", Range(0.1,1)) = 0.5
        _Cubemap ("Refraction Cubemap", Cube) = "_SkyBox" {}
    }

    SubShader
    {
        Pass
        {
            Tags { "RenderType"="Opaque" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            fixed4 _Color;
            fixed4 _RefractionColor;
            float _RefractionAmount;
            float _RefractionRatio;
            samplerCUBE _Cubemap;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 worldViewDir : TEXCOORD2;
                float3 worldRefr : TEXCOORD3;
            };

            v2f vert(a2v v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                o.worldRefr = refract(-normalize(o.worldViewDir), normalize(o.worldNormal), _RefractionRatio);

                TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldViewDir =  normalize(i.worldViewDir);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * saturate(dot(worldNormal, worldLightDir));

                fixed3 refraction = texCUBE(_Cubemap, i.worldRefr).rgb * _RefractionColor.rgb;

                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

                fixed3 color = ambient + lerp(diffuse, refraction, _RefractionAmount) * atten;

                return fixed4(color, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
