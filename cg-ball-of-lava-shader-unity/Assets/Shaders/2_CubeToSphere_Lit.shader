Shader "Unlit/2_CubeToSphere_Lit"
{
    Properties
    {
        _Radius("Radius", Range(0.4, 1.1)) = 0.6
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "./shared/SimpleV2F.cginc"

            float _Radius;

            v2f_lit vert (appdata_base v)
            {
                v2f_lit output;

                // calculate position of vertices in a sphere of radius
                float3 normalizedRadialRay = normalize(v.vertex.xyz);
                float4 spherePos = float4(normalizedRadialRay * _Radius, v.vertex.w);

                // oscillate between the two positions
                float delta = (sin(_Time.w) + 1.0) / 2.0;
                float4 oscillatingPos = lerp(v.vertex * 50.0, spherePos, delta);

                // calculate lighting
                float3 lightDirection = _WorldSpaceLightPos0.xyz;

                float3 lerpedNormal = lerp(v.normal, normalizedRadialRay, delta);
                half3 worldNormal = UnityObjectToWorldNormal(lerpedNormal);

                // dot product between normal and light vector, provide the basis for the lit shading
                half lightInfluence = max(0, dot(worldNormal, lightDirection)); // avoid negative values
                output.diff = lightInfluence * _LightColor0;

                output.vertex = UnityObjectToClipPos(oscillatingPos);
                // output.position = v.vertex;
                // output.uv = v.texcoord;

                return output;
            }

            fixed4 frag (v2f_lit i) : COLOR
            {
                return fixed4(1,1,1,1) * i.diff;
            }
            ENDCG
        }
    }
}
