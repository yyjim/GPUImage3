//
//  CBHSV.metal
//  GPUImage
//
//  Created by Jim Wang on 2024/3/29.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
#include "Utils.h"
using namespace metal;

struct HSVUniform {
    float value;
};

float3 rgb2hsv(float3 c) {
    float cMax  = max(max(c.r, c.g), c.b);
    float cMin  = min(min(c.r, c.g), c.b);
    float delta = cMax - cMin;
    float3 hsv = float3(0.0, 0.0, cMax);

    if(cMax > cMin){
        hsv.y = delta / cMax;
        if (c.r == cMax) {
            hsv.x = (c.g - c.b) / delta;
        } else if (c.g == cMax) {
            hsv.x = 2.0 + (c.b - c.r) / delta;
        } else {
            hsv.x = 4.0 + (c.r - c.g) / delta;
        }
        hsv.x = fract(hsv.x / 6.0);
    }
    return hsv;
}

fragment float4 hsvFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                            texture2d<half> inputTexture [[texture(0)]],
                            constant HSVUniform& uniform [[buffer(1)]])
{
    constexpr sampler quadSampler;
    float threshold = 0.01;

    float2 uv = fragmentInput.textureCoordinate;
    float4 inputColor = float4(inputTexture.sample(quadSampler, uv));

    float3 hsv = rgb2hsv(inputColor.rgb);
    float value = hsv.z > threshold ? uniform.value : 0.0;
    hsv.z = clamp(hsv.z + value, 0.0, 1.0);
    float3 outputColor = hsv2rgb(hsv);

    return float4(outputColor, inputColor.a);
}
