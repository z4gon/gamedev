Shader "Unlit/Transparent_Unlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _SkyBox ("Sky Box", CUBE) = "cube" {}
        _TransparencyStrength ("Transparency Strength", Range(0,1)) = 0.6
        _RefractionStrength ("Refraction Strength", Range(0,2)) = 0.2
        _ReflectionStrength ("Reflection Strength", Range(0,2)) = 0.3
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Tags { "Queue"="Transparent" }
        LOD 100

        GrabPass {
            "_GrabTexture"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 uv_Normal : TEXCOORD1;
                float4 uv_Grab : TEXCOORD2;
                float3 reflect : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NormalMap;
            float4 _NormalMap_ST;

            samplerCUBE _SkyBox;

            float _TransparencyStrength;
            float _ReflectionStrength;
            float _RefractionStrength;

            sampler2D _GrabTexture;

            v2f vert (appdata v)
            {
                v2f o;

                float4 vertexClipPos = UnityObjectToClipPos(v.vertex);

                o.vertex = vertexClipPos;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv_Normal = TRANSFORM_TEX(v.uv, _NormalMap);

                o.uv_Grab = ComputeGrabScreenPos(vertexClipPos);

                // simple sky box reflection calculation
                float3 viewDir = WorldSpaceViewDir(v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.reflect = reflect(-viewDir, worldNormal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 color = tex2D(_MainTex, i.uv);

                fixed4 normal = tex2D(_NormalMap, i.uv_Normal);
                half4 refraction = normal.rgba;

                i.uv_Grab += refraction * _RefractionStrength;

                fixed4 grabColor = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv_Grab));

                // get the sky box pixel
                fixed4 reflectionColor = texCUBE(_SkyBox, i.reflect);

                color = color * grabColor + (reflectionColor * _ReflectionStrength);

                return lerp(grabColor, color * grabColor, _TransparencyStrength);
            }
            ENDCG
        }
    }
}
