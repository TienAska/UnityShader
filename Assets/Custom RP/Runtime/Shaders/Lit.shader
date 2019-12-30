Shader"Custom RP/Lit"
{
    Properties
    {
        _BaseMap("Texture", 2D) = "white" {}
		_BaseColor ("Color", Color) = (0.5, 0.5, 0.5, 1)
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "CustomLit" }

            HLSLPROGRAM
            
			#pragma target 3.5

			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling

            #pragma vertex LitPassVertex
            #pragma fragment LitPassFragment

            #include "LitPass.hlsl"

            ENDHLSL
        }
    }
}