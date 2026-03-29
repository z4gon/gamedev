Shader "Unlit/CosClipping_Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1,0,0,1)
        _Threshold("Threshold", Range(0, 40)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "./shared/SimpleV2F.cginc"

            fixed4 _Color;
            float _Threshold;

            fixed4 frag (v2f IN) : SV_Target
            {
                float cosY = cos(IN.position.y * _Threshold + _Time.z);

                clip(cosY);

                return fixed4(_Color * IN.diffuse, 1);
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

            struct v2f {
                float4 position: TEXCOORD1;
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v)
            {
                v2f OUT;
                OUT.position = v.vertex;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(OUT)
                return OUT;
            }

            float _Threshold;

            float4 frag(v2f IN) : SV_Target
            {
                float cosY = cos(IN.position.y * _Threshold + _Time.z);

                clip(cosY);

                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
