Shader "Unlit/XRayWindow_Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        Tags { "Queue"="Geometry-1" }
        LOD 100

        ColorMask 0
        ZWrite Off

        Stencil {
            Ref     1
            Comp    Always
            Pass    Replace
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "./shared/SimpleV2F.cginc"

            fixed4 _Color;

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
