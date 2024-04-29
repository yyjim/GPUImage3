//
//  CBErosion.metal
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

struct ErosionUniform
{
    float steps;
    float texelSize;
};

float4 erosionFunction(float4 color1, float4 color2) {
    float4 outputValue = float4(0.0);
    outputValue.r = color2.r > color1.r ? 0.0 : color1.r;
    outputValue.g = color2.g > color1.g ? 0.0 : color1.g;
    outputValue.b = color2.b > color1.b ? 0.0 : color1.b;
    outputValue.a = color2.a > color1.a ? 0.0 : color1.a;

    return outputValue;
}

fragment float4 erosionFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<float> inputTexture [[texture(0)]],
                                constant ErosionUniform& uniform [[buffer(1)]])
{
    constexpr sampler quadSampler;

    float2 uv = fragmentInput.textureCoordinate;
    float4 outputColor = inputTexture.sample(quadSampler, uv);

    for (int i = 0; i < int(uniform.steps); ++i) {
        float4 value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2(-1.0, -1.0));
        outputColor = erosionFunction(outputColor, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2( 0.0, -1.0));
        outputColor = erosionFunction(outputColor, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2( 1.0, -1.0));
        outputColor = erosionFunction(outputColor, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2(-1.0,  0.0));
        outputColor = erosionFunction(outputColor, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2( 1.0,  0.0));
        outputColor = erosionFunction(outputColor, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2(-1.0,  1.0));
        outputColor = erosionFunction(outputColor, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2( 0.0,  1.0));
        outputColor = erosionFunction(outputColor, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * uniform.texelSize * float2( 1.0,  1.0));
        outputColor = erosionFunction(outputColor, value);
    }

    return outputColor;
}
