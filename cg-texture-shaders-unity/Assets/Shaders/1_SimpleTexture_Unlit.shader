Shader "Unlit/1_SimpleTexture_Unlit"
{
    Properties
    {
        _MainTexture("Main Texture", 2D) = "white" {}
        [Toggle] _Grayscale("Grayscale", Float) = 0
        [Toggle] _FlipHorizontal("Flip Horizontal", Float) = 0
        [Toggle] _FlipVertical("Flip Vertical", Float) = 0
        _RotationCenter("Rotation Center", Vector) = (0.5, 0.5, 0, 0)
        _RotationAngle("Rotation Angle", Range(-1, 1)) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "./shared/Matrices.cginc"

            sampler2D _MainTexture;
            bool _Grayscale;
            bool _FlipHorizontal;
            bool _FlipVertical;
            float2 _RotationCenter;
            float _RotationAngle;

            fixed4 frag (v2f_img i) : COLOR
            {
                float2 uv = float2(
                    _FlipHorizontal ? 1 - i.uv.x : i.uv.x,
                    _FlipVertical ? 1 - i.uv.y : i.uv.y
                );

                float2x2 rotation = getRotationMatrix2D(UNITY_PI * _RotationAngle);
                uv = mul(uv - _RotationCenter.xy, rotation) + _RotationCenter.xy;

                float4 texColor = tex2D(_MainTexture, uv);
                fixed3 color = _Grayscale ? texColor.rrr : texColor.rgb;

                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}
