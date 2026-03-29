Shader "Unlit/3_BlendTexture_Unlit"
{
    Properties
    {
        _TextureA("Texture A", 2D) = "white" {}
        _TextureB("Texture B", 2D) = "white" {}
        [HideInInspector] _StartTime("Start Time", Float) = 0
        _TransitionDuration("Transition Duration", Range(0.2, 6)) = 0.1
        _FadeSmoothness("Fade Smoothness", Range(0.1, 0.5)) = 0.4
        _RippleSize("Ripple Size", Range(0.002, 1)) = 0.03
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

            sampler2D _TextureA;
            sampler2D _TextureB;
            float _StartTime;
            float _TransitionDuration;
            float _FadeSmoothness;
            float _RippleSize;
            float _RippleVelocity;

            fixed4 frag (v2f i) : COLOR
            {
                // use the coordinate system that is centered in (0.5, 0.5)
                float2 pixelPos = i.position.xy * 2.0;

                // FADE HORIZON

                // figure out how much of the transition has elapsed
                float elapsedTime = _Time.y - _StartTime;
                // add an extra second for ripple size to grow larger
                // elapsedTime = clamp(elapsedTime, 0, _TransitionDuration + 1);

                float elapsedPercentage = elapsedTime / _TransitionDuration;

                // calculate how much of each texture should show up
                float currentDistanceOfFade = 1 * elapsedPercentage;
                float distanceToCenter = length(pixelPos);

                float currentFade = smoothstep(
                    currentDistanceOfFade - _FadeSmoothness,
                    currentDistanceOfFade + _FadeSmoothness,
                    distanceToCenter
                );

                // RIPPLE

                // make ripple size grow over time
                float rippleSizeOverTime = lerp(0.02, _RippleSize, elapsedPercentage);

                // get a displacement in the direction of the ray from the center to the pixel
                float2 displacement = (pixelPos / distanceToCenter) * 0.03 * cos(
                    distanceToCenter * (1 / rippleSizeOverTime) - elapsedTime * _RippleVelocity
                );

                // find the texel we want to show
                float2 ripple = i.uv + displacement;

                // BLEND

                // blend the textures given the current fade
                float4 texColorA = tex2D(_TextureA, ripple);
                float4 texColorB = tex2D(_TextureB, ripple);

                float4 blend = lerp(texColorA, texColorB, currentFade);

                fixed3 color = blend.rgb;

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
