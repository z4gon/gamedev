Shader "Unlit/3_BallOfLava"
{
    Properties
    {
        _Displacement("Displacement", Range(0.01, 1)) = 0.4
        _RotationVelocity("Rotation Velocity", Range(0.1, 10)) = 1
        _NoiseVelocity("Noise Velocity", Range(0.1, 10)) = 1
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,0,1)
        _ColorC("Color C", Color) = (1,0,0,1)
        _ColorD("Color D", Color) = (0,0,0,1)
        _ColorStepA("Step A", Range(0, 1)) = 0.1
        _ColorStepB("Step B", Range(0, 1)) = 0.25
        _ColorStepC("Step C", Range(0, 1)) = 0.75
        _ColorStepD("Step D", Range(0, 1)) = 0.9
        _ColorStepSmoothness("Color Step Smoothness", Range(0, 0.4)) = 0.1
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
            #include "UnityLightingCommon.cginc"
            #include "./shared/SimpleV2F.cginc"
            #include "./shared/PerlinNoise.cginc"

            float _Displacement;
            float _RotationVelocity;
            float _NoiseVelocity;
            fixed4 _ColorA;
            fixed4 _ColorB;
            fixed4 _ColorC;
            fixed4 _ColorD;
            float _ColorStepA;
            float _ColorStepB;
            float _ColorStepC;
            float _ColorStepD;
            float _ColorStepSmoothness;

            v2f vert (appdata_base v)
            {
                v2f output;

                // move the uvs to simulate lava flow
                float2 uvs = (v.texcoord + (_Time.x * _RotationVelocity)) % 1.0;

                // use 8x8 grid, with a changing time to animate the lava
                float perlinNoise = perlin(uvs, 12, 12, _Time.y * _NoiseVelocity); // -1.0 to 1.0
                // amplify the noise given parameter
                float displacement = perlinNoise * _Displacement;

                // displace the vertex given the noise function value
                float3 displacedPos = v.vertex * (1 + displacement);
                float4 vertexPosition = float4(displacedPos * 80.0, v.vertex.w);

                output.vertex = UnityObjectToClipPos(vertexPosition);
                output.position = v.vertex;
                output.uv = v.texcoord;
                output.displacement = ((perlinNoise + 1) / 2); // from 0 to 1

                return output;
            }

            fixed4 lerpColor(float displacement)
            {
                fixed4 colors[4] = { _ColorA, _ColorB, _ColorC, _ColorD };
                float steps[4] = { _ColorStepA, _ColorStepB, _ColorStepC, _ColorStepD };

                if(displacement <= steps[0]) { return colors[0]; }
                if(displacement >= steps[3]) { return colors[3]; }

                for (int i = 0; i <= 2; i++) {
                    if (steps[i] <= displacement && displacement <= steps[i+1]) {
                        return lerp(
                            colors[i],
                            colors[i+1],
                            (displacement - steps[i])/(steps[i+1] - steps[i])
                        );
                    }
                }

                // this should never happen
                return fixed4(0,0,0,1);
            }

            fixed4 frag (v2f i) : COLOR
            {
                // create a gradient transitioning between 4 colors.
                float displacement = i.displacement;

                return  lerpColor(displacement);
            }
            ENDCG
        }
    }
}
