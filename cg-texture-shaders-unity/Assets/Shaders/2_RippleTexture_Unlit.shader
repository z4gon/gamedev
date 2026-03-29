Shader "Unlit/2_RippleTexture_Unlit"
{
    Properties
    {
        _MainTexture("Main Texture", 2D) = "white" {}
        _RippleSize("Ripple Size", Range(0.002, 0.2)) = 0.03
        _RippleVelocity("Ripple Velocity", Range(0, 20.0)) = 4.0

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
            #include "./shared/Matrices.cginc"
            #include "./shared/SimpleV2F.cginc"

            sampler2D _MainTexture;
            float _RippleSize;
            float _RippleVelocity;

            fixed4 frag (v2f i) : COLOR
            {
                // use the coordinate system that is centered in (0.5, 0.5)
                float2 pixelPos = i.position.xy * 2.0;

                // get a displacement in the direction of the ray from the center to the pixel
                float distanceToCenter = length(pixelPos);
                float2 displacement = pixelPos / distanceToCenter * 0.03 * cos(
                    distanceToCenter * (1 / _RippleSize) - _Time.y * _RippleVelocity
                );

                // find the texel we want to show
                float2 ripple = i.uv + displacement;

                float4 texColor = tex2D(_MainTexture, ripple);
                fixed3 color = texColor.rgb;

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
