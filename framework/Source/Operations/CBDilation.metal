//
//  CBDilation.metal
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

struct DilationUniform
{
    float steps;
    float mode;
    float texelStep;
};

fragment float4 dilationFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                 texture2d<float> inputTexture [[texture(0)]],
                                 constant DilationUniform& uniform [[buffer(1)]])
{
    constexpr sampler quadSampler;

    float2 uv = fragmentInput.textureCoordinate;
    float4 inputColor = inputTexture.sample(quadSampler, uv);
    float4 totalValue = inputColor;
    float4 maxValue = totalValue;

    float2 texelSize = float2(1.0 / inputTexture.get_width() * uniform.texelStep, 1.0 / inputTexture.get_height() * uniform.texelStep);

    for (int i = 0; i < int(uniform.steps); ++i) {
        float4 value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2(-1.0, -1.0));
        totalValue += value;
        maxValue = max(maxValue, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2( 0.0, -1.0));
        totalValue += value;
        maxValue = max(maxValue, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2( 1.0, -1.0));
        totalValue += value;
        maxValue = max(maxValue, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2(-1.0,  0.0));
        totalValue += value;
        maxValue = max(maxValue, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2( 1.0,  0.0));
        totalValue += value;
        maxValue = max(maxValue, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2(-1.0,  1.0));
        totalValue += value;
        maxValue = max(maxValue, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2( 0.0,  1.0));
        totalValue += value;
        maxValue = max(maxValue, value);
        value = inputTexture.sample(quadSampler, uv + float(i) * texelSize * float2( 1.0,  1.0));
        totalValue += value;
        maxValue = max(maxValue, value);
    }

    totalValue /= (uniform.steps * 8.0);

    float4 outputValue = mix(maxValue, totalValue, uniform.mode);
    outputValue.a = inputColor.a;

    return outputValue;
}
