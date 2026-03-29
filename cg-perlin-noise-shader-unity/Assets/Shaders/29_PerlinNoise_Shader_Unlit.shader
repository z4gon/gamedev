Shader "Unlit/29_PerlinNoise_Shader_Unlit"
{
    Properties
    {
        _TilingColumns("Tiling Columns", Float) = 10
        _TilingRows("Tiling Rows", Float) = 10
        _Offset("Offset", Range(0, 1)) = 0.5
        [Toggle] _UseTime("UseTime", Float) = 0
        _TimeVelocity("TimeVelocity", Range(0, 10)) = 1
        [Toggle] _DebugSquares("Debug Squares", Float) = 0
        [Toggle] _DebugGradients("Debug Gradients", Float) = 0
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
            #include "./shared/PerlinNoise.cginc"

            int _TilingColumns;
            int _TilingRows;
            float _Offset;
            bool _UseTime;
            float _TimeVelocity;
            bool _DebugSquares;
            bool _DebugGradients;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                fixed4 color = fixed4(1,1,1,1);

                float time = _UseTime ? _Time.y * _TimeVelocity : 1;

                fixed4 noise = perlin(
                    uv,
                    _TilingColumns,
                    _TilingRows,
                    time,
                    _Offset,
                    _DebugSquares,
                    _DebugGradients
                );

                return color * noise;
            }
            ENDCG
        }
    }
}
