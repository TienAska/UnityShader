#ifndef MYRP_UNLIT_INCLUDE
#define MYRP_UNLIT_INCLUDE

struct VertexInput
{
    float pos : POSITION;
};

struct VertexOutput
{
    float4 clipPos : SV_POSITION;
};

VertexOutput UnlitPassVertex (VertexInput input)
{
    vertex output;
    output.clipPos = UnityObjectToClipPos(input.pos);
    return output;
}

float4 UnlitPassFragment (VertexOutput input) : SV_TARGET
{
    return 1;
}


#endif // MYRP_UNLIT_INCLUDE