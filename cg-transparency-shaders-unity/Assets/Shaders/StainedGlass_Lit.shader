Shader "Unlit/StainedGlass_Unlit"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _AlphaTest("Alpha Test", Float) = 0.7
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Tags { "Queue"="Transparent" }
        LOD 100

        // good practice
        ZWrite Off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        // for nicer looking lighting
        #pragma target 3.0

        struct Input {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = color.rgb;
            o.Alpha = color.a;
        }
        ENDCG

        ColorMask 0

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade alphatest:_AlphaTest addshadow

        // for nicer looking lighting
        #pragma target 3.0

        struct Input {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = color.rgb;
            o.Alpha = color.a;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
