struct v2f
{
    // Cg Semantics
    //      Binds Shader input/output to rendering hardware
    //      - SV_POSITION means system value position in DX10, corresponds to vertex position
    //      - TEXCOORDn means custom data

    float4 vertex: SV_POSITION; // From Object-Space to Clip-Space
    float displacement: TEXCOORD2;
    float4 position: TEXCOORD1;
    float4 uv: TEXCOORD0;
};

struct v2f_lit
{
    // Cg Semantics
    //      Binds Shader input/output to rendering hardware
    //      - SV_POSITION means system value position in DX10, corresponds to vertex position
    //      - TEXCOORDn means custom data

    float4 vertex: SV_POSITION; // From Object-Space to Clip-Space
    // float4 position: TEXCOORD1;
    // float4 uv: TEXCOORD0;
    fixed4 diff: COLOR0; // diffuse lighting color
};
