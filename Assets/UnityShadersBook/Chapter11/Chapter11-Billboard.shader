// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shaders Book/Chapter11/Billboard"
{
    Properties
    {
        _MainTex ("Base Layer (RGB)", 2D) = "white" {}
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _VerticalBillboarding ("Vertical Restraints", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "DisableBatching"="True"}
        Pass
        {
            Tags { "LightMode"="ForwardBase" }

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _VerticalBillboarding;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;

                float3 center = float3(0, 0, 0);
                float3 viewer = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;

                float3 normalDir = viewer - center;
                normalDir.y *= _VerticalBillboarding;
                normalDir = normalize(normalDir);
                
                float3 upDir = abs(normalDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
                float3 rightDir = normalize(cross(upDir, normalDir));
                upDir = normalize(cross(normalDir, rightDir));

                float3 centerOffs = v.vertex.xyz - center;
                //float3 localPos = center + rightDir * centerOffs.x + upDir * centerOffs.y + normalDir * centerOffs.z;
                float4 r1 = float4(rightDir.x, upDir.x, normalDir.x, center.x);
                float4 r2 = float4(rightDir.y, upDir.y, normalDir.y, center.y);
                float4 r3 = float4(rightDir.z, upDir.z, normalDir.z, center.z);
                float4 r4 = float4(0,          0,       0,           1);
                float4x4 rotation = float4x4(r1, r2, r3, r4);
                float3 localPos = mul(rotation, float4(centerOffs, 1)).xyz;

                o.pos = UnityObjectToClipPos(localPos);

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed4 c = tex2D(_MainTex, i.uv);
                c.rgb *= _Color.rgb;

                return c;
            }

            ENDCG
        }
    }
    FallBack "Transparent/VertexLit"
}
