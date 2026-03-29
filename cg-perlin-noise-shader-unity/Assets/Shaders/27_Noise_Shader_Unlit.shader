Shader "Unlit/27_Noise_Shader_Unlit"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "./shared/SimpleV2F.cginc"
            #include "./shared/Random.cginc"

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 color = random(i.uv, _Time.x) * fixed3(1,1,1);
                return fixed4(color,1);
            }
            ENDCG
        }
    }
}
