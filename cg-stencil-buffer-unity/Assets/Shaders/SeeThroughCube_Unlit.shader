Shader "Unlit/SeeThroughCube_Unlit"
{
    Properties
    {
        _ColorOuter("Outer Color", Color) = (1,0,0,1)
        _ColorInner("Inner Color", Color) = (0,1,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Stencil
            {
                Ref     1
                Comp    NotEqual
            }

            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "./shared/SimpleV2F.cginc"

            fixed4 _ColorOuter;

            fixed4 frag (v2f i) : SV_Target
            {
                return _ColorOuter;
            }
            ENDCG
        }

        Pass
        {
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "./shared/SimpleV2F.cginc"

            fixed4 _ColorInner;

            fixed4 frag (v2f i) : SV_Target
            {
                return _ColorInner;
            }
            ENDCG
        }
    }
}
