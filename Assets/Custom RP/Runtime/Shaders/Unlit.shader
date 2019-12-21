Shader"Custom RP/Unlit"
{
    Properties
    {
		_BaseColor ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }

    SubShader
    {
        Pass
        {
            HLSLPROGRAM
            
			#pragma target 3.5

			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling

            #pragma vertex UnlitPassVertex
            #pragma fragment UnlitPassFragment

            #include "../ShaderLibrary/UnlitPass.hlsl"

            

            ENDHLSL
        }
    }
}