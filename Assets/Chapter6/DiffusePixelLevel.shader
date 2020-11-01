// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "UnityShaderBook/Chapter6/Diffuse Pixel-Level"
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
                fixed3 worldNormal: TEXCOORD0;
            };
            
            // 顶点着色器不需要计算光照模型，只需要把世界空间下的法线传递给片元着色器即可
            v2f vert(a2v v)
            {
                v2f o;
                
                // transform the vertex from object space to projection space
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // transform the normal fram object space to world space
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                
                return o;
            }
            // 片元着色器需要计算漫反射光照模型
            fixed4 frag(v2f i): SV_TARGET
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                // get the normal in world space
                fixed3 worldNormal = normalize(i.worldNormal);
                
                // get the light direction in world space
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                // compute diffuse term
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
                
                fixed3 color = ambient + diffuse;
                return fixed4(color, 1.0);
            }
            
            ENDCG
            
        }
    }
}