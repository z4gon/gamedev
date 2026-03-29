struct v2f
{
    // Cg Semantics
    //      Binds Shader input/output to rendering hardware
    //      - SV_POSITION means system value position in DX10, corresponds to vertex position
    //      - TEXCOORDn means custom data

    float4 vertex: SV_POSITION; // From Object-Space to Clip-Space
    float4 position: TEXCOORD1;
    float4 uv: TEXCOORD0;
    fixed3 diffuse: COLOR0; // For lambert lighting
};

v2f vert (appdata_base IN)
{
    v2f OUT;

    OUT.vertex = UnityObjectToClipPos(IN.vertex);
    OUT.position = IN.vertex;
    OUT.uv = IN.texcoord;

    // calculate Lambert lighting -----------------------------------------------------------
    float3 lightDirection = _WorldSpaceLightPos0.xyz;

    half3 worldNormal = UnityObjectToWorldNormal(IN.normal);

    // dot product between normal and light vector, provide the basis for the lit shading
    half lightInfluence = max(0, dot(worldNormal, lightDirection)); // avoid negative values

    OUT.diffuse = lightInfluence * _LightColor0.rgb;

    return OUT;
}
