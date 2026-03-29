Shader "Unlit/1_CubeToSphere_Unlit"
{
    Properties
    {
        _Radius("Radius", Range(0.4, 1.1)) = 0.6
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

            float _Radius;

            v2f vert (appdata_base v)
            {
                v2f output;

                // calculate position of vertices in a sphere of radius
                float3 normalizedRadialRay = normalize(v.vertex.xyz);
                float4 spherePos = float4(normalizedRadialRay * _Radius, v.vertex.w);

                // oscillate between the two positions
                float delta = (sin(_Time.w) + 1.0) / 2.0;
                float4 oscillatingPos = lerp(v.vertex * 50.0, spherePos, delta);

                output.vertex = UnityObjectToClipPos(oscillatingPos);
                // output.position = v.vertex;
                // output.uv = v.texcoord;

                return output;
            }

            fixed4 frag (v2f i) : COLOR
            {
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
