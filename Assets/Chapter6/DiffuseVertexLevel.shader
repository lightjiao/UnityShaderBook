// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnityShaderBook/Chapter6/Diffuse Vertex-Level"
{
    Properties
    {
        // 材质的漫反射颜色, 初始设置为白色
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        pass
        {
            // 指定光照模式
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            fixed4 _Diffuse;
            
            // 定义顶点着色器的输入和输出结构体(输出结构体同时也是片元着色器的输入结构体)
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL; // 顶点的发现
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                fixed3 color: COLOR; // 顶点着色器中计算得到的光照颜色
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                
                // transform the vertex from object space to projection space
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // get ambient term(获得环境条件)
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                // transform the normal fram object to world space
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                
                // get the light direction in world space
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                
                // Computre diffuse term(计算漫反射)
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
                
                o.color = ambient + diffuse;
                
                return o;
            }  
            
            fixed4 frag(v2f i): SV_TARGET
            {
                return fixed4(i.color, 1.0);
            }
            
            ENDCG
            
        }
    }
}