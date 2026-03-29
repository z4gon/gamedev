Shader "Unlit/PerlinNoiseClipping_Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1,0,0,1)
        _Threshold("Threshold", Range(-1.0, 1.0)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Off // will render inside too

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "./shared/SimpleV2F.cginc"
            #include "./shared/PerlinNoise.cginc"

            fixed4 _Color;
            float _Threshold;

            fixed4 frag (v2f IN) : SV_Target
            {
                float perlinNoise = perlin(IN.uv, 4, 4, _Time.z);

                clip(perlinNoise + _Threshold);

                return _Color * perlinNoise;
            }
            ENDCG
        }

        // shadow caster rendering pass, implemented manually
        // using macros from UnityCG.cginc
        // https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
        Pass
        {
            Tags {"LightMode"="ShadowCaster"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"
            #include "./shared/PerlinNoise.cginc"

            struct v2f {
                float4 uv: TEXCOORD0;
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v)
            {
                v2f OUT;
                OUT.uv = v.texcoord;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(OUT)
                return OUT;
            }

            float _Threshold;

            float4 frag(v2f IN) : SV_Target
            {
                float perlinNoise = perlin(IN.uv, 4, 4, _Time.z);

                clip(perlinNoise + _Threshold); // to also clip the shadowcaster

                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
