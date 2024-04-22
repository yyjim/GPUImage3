//
//  CBDirectionBlur.metal
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

struct DirectionalBlurUniform
{
    float radian;
    float length;
};

fragment float4 directionBlurFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                      texture2d<float> inputTexture [[texture(0)]],
                                      constant DirectionalBlurUniform& uniform [[buffer(1)]])
{
    constexpr sampler quadSampler;

    float2 uv = fragmentInput.textureCoordinate;
    float4 inputColor = float4(inputTexture.sample(quadSampler, uv));

    float imageWidth = inputTexture.get_width();
    float imageHeight = inputTexture.get_height();

    float ratio = uniform.length * min(imageWidth, imageHeight);

    float steps = 30.0;
    // Aspect ratio adjustment: uniform.length * min(imageWidth, imageHeight) * float2(1.0 / imageWidth, 1.0 / imageHeight)
    float2 direction = float2(sin(uniform.radian), cos(uniform.radian)) * ratio * float2(1.0 / imageWidth, 1.0 / imageHeight) / steps;

    float3 blurredColor = 0.0;
    float weight = 0;
    float curr_weight = 0;

    // Weight: (steps - abs(i))^2 => the closer it is, the greater the weight (fade out)
    for(int i = -steps; i <= steps; i++)
    {
        float2 offset = float2(i) * direction;
        curr_weight = pow(steps - abs(float(i)), 2.0);
        blurredColor += inputTexture.sample(quadSampler, uv + offset).rgb * curr_weight;
        weight += curr_weight;
    }

    return float4(blurredColor / weight, inputColor.a);
}
