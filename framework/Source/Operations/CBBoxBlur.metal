//
//  CBBoxBlur.metal
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

struct BoxBlurUniform
{
    float kernelSize;
    float texelSizeX;
    float texelSizeY;
};

fragment float4 boxBlurFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                texture2d<float> inputTexture [[texture(0)]],
                                constant BoxBlurUniform& uniform [[buffer(1)]])
{
    constexpr sampler sampler2d;
    float2 uv = fragmentInput.textureCoordinate;
    float2 size = float2(uniform.texelSizeX, uniform.texelSizeY);
    float2 texelSize = float2(1.0 / inputTexture.get_width(), 1.0 / inputTexture.get_height()) * size;
    float4 inputColor = inputTexture.sample(sampler2d, uv);

    int kernelSize = uniform.kernelSize * 2 + 1;
    int halfKSize = uniform.kernelSize;
    float4 outputColor = float4(0.0);

    float2 kernelUV = uv;

    float z = float(kernelSize) * float(kernelSize);

    for (int i = -halfKSize; i <= halfKSize; ++i)
    {
        for (int j = -halfKSize; j <= halfKSize; ++j) {
            kernelUV = uv + float2(float(i)*texelSize.x, float(j)*texelSize.y);
            outputColor += inputTexture.sample(sampler2d, kernelUV) / z;
        }
    }

    return float4(float3(outputColor), inputColor.a);
}
