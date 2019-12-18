Shader "Hidden/Custom/BSC"
{
    HLSLINCLUDE

    	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        #define unity_ColorSpaceLuminance half4(0.22, 0.707, 0.071, 0.0) // Legacy: alpha is set to 0.0 to specify gamma mode

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        half _Birghtness;
        half _Saturation;
        half _Contrast;

        half4 Frag(VaryingsDefault i) : SV_Target
        {
            half4 renderTex = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

            // Apply brightness
            half3 finalColor = renderTex.rgb * _Birghtness;

            // Apply saturation
            half luminance = dot(renderTex.rgb, unity_ColorSpaceLuminance.rgb);
            half3 luminanceColor = half3(luminance.xxx);
            finalColor = lerp(luminanceColor, finalColor, _Saturation);

            // Apply contrast
            half3 avgColor = half3(0.5, 0.5, 0.5);
            finalColor = lerp(avgColor, finalColor, _Contrast);

            return half4(finalColor, renderTex.a);
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment Frag

            ENDHLSL
        }
    }
}
