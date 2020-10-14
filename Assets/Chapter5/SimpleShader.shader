Shader "UnityShaderBook/Chapter5/SimpleShader"
{
    // Properties 语义块不是必须的，我们可以选择不声明任何材质

    // SubShader语义块
    SubShader {
        Pass {

            // 与 ENDCG 一起包裹CG代码块
            CGPROGRAM

            // 这两行告诉Unity 哪个函数包含了顶点着色器代码，哪个函数包含了片元着色器代码
            // #pragma vertex $name
            // #pragma fragment $name
            // 其中 $name 就是我们指定的函数名，这两个函数名字不一定是vert和frag，他们可以
            // 是任意自定义的合法名字，但我们一般就叫vert和frag来定义这两个函数，因为比较直观
            #pragma vertex vert
            #pragma fragment frag

            // 使用一个结构体来定义顶点着色器的输入
            struct a2v {
                float4 vertex : POSITION;    // POSITION 语义告诉Unity用模型空间的顶点坐标填充
                float3 normal : NORMAL;      // NORMAL 语义告诉Unity，用模型空间的法线方向填充normal变量
                float4 texcoord : TEXCOORD0; // TEXCOORD0 语义告诉Unity，用模型的第一套纹理坐标填充 texcoord 变量
            };


            // 顶点着色器代码，它是逐顶点执行的：
            // 这个函数的输入 v 包含了这个顶点的位置，这是根据 POSITION 语义指定的。
            //
            // 它的返回值是一个 float4 类型的变量，它是该顶点在裁剪空间中的位置。
            // 
            // POSITION 和 SV_POSITION 都是 CG/HLSL 中的语义，它们是不可省略的，这些语义说明需要
            // 哪些输入值，以及输出值是什么。例如这里，POSITION告诉Unity把模型的顶点坐标填充到输入参数 v 中，
            // SV_POSITION 告诉Unity，顶点着色器输出的是裁剪空间中的顶点坐标
            // 
            // 本例中，顶点着色器只包含了一行代码，这一步就是把顶点坐标从模型空间转换到裁剪空间中。
            // UNITY_MATRIX_MVP 矩阵是 Unity内置的 模型⋅观察⋅投影 矩阵
            float4 vert(float4 v : POSITION) : SV_POSITION {
                // Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
                // return mul(UNITY_MATRIX_MVP, v);
                return UnityObjectToClipPos(v);
            }

            // 片元着色器代码：
            // 本例中frag没有任何输入。
            // 
            // 它的输出是一个 fixed4 类型的变量，并且使用了 SV_TARGET 语义限定。SV_TARGET也是HLSL中的一个
            // 系统语义，它等同于告诉渲染器，把用户的输出颜色储到一个渲染目标（render target）中，这里将输出到
            // 默认的帧缓存中。
            // 
            // 片元着色器中的代码很简单，返回了一个表示白色的fixed4变量。片元着色器输出的颜色每个分量范围
            // 在[0, 1]，其中(0,0,0)表示黑色，(1,1,1)表示白色
            fixed4 frag() : SV_TARGET {
                return fixed4(1.0, 1.0, 1.0, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
