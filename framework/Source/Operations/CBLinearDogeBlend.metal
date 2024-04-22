//
//  CBLinearDogeBlend.metal
//  GPUImage_iOS
//
//  Created by Jim Wang on 2024/4/22.
//  Copyright © 2024 Red Queen Coder, LLC. All rights reserved.
//

#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

struct BlendUniform
{
    float aspectRatio;
    float assetOpacity;
    float intensity;
};

// LinearDodgeBlend
fragment half4 linearDodgeBlendFragment(TwoInputVertexIO fragmentInput [[ stage_in ]],
                                        texture2d<half> inputTexture [[texture(0)]],
                                        texture2d<half> inputTexture2 [[texture(1)]],
                                        constant BlendUniform& uniform [[ buffer(1) ]] )
{
    constexpr sampler quadSampler;
    half4 base = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);

    float2 texCoord2 = fragmentInput.textureCoordinate;
    // Normalize the asset to fit the aspect ratio of input texture
    if (uniform.aspectRatio < 1.0)
        texCoord2.y = (texCoord2.y - 0.5) * uniform.aspectRatio + 0.5;
    else
        texCoord2.x = (texCoord2.x - 0.5) * uniform.aspectRatio + 0.5;

    half4 overlay = inputTexture2.sample(quadSampler, texCoord2);

    // LinearDodge aka AddBlend
    // takes the alpha into consideration
    half r;
    if (overlay.r * base.a + base.r * overlay.a >= overlay.a * base.a) {
        r = overlay.a * base.a + overlay.r * (1.0h - base.a) + base.r * (1.0h - overlay.a);
    } else {
        r = overlay.r + base.r;
    }

    half g;
    if (overlay.g * base.a + base.g * overlay.a >= overlay.a * base.a) {
        g = overlay.a * base.a + overlay.g * (1.0h - base.a) + base.g * (1.0h - overlay.a);
    } else {
        g = overlay.g + base.g;
    }

    half b;
    if (overlay.b * base.a + base.b * overlay.a >= overlay.a * base.a) {
        b = overlay.a * base.a + overlay.b * (1.0h- base.a) + base.b * (1.0h - overlay.a);
    } else {
        b = overlay.b + base.b;
    }

    half a = overlay.a + base.a - overlay.a * base.a;

    half4 blendColor = half4(r, g, b, a);

    return mix(base, blendColor, uniform.intensity);
}
