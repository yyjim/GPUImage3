#include <metal_stdlib>
#include "OperationShaderTypes.h"
using namespace metal;

typedef struct
{
    float intensity;
} UnsharpMaskUniform;

fragment half4 unsharpMaskFragment(TwoInputVertexIO fragmentInput [[stage_in]],
                                   texture2d<half> inputTexture1 [[texture(0)]],
                                   texture2d<half> inputTexture2 [[texture(1)]],
                                   constant UnsharpMaskUniform& uniform [[buffer(1)]])
{
    constexpr sampler quadSampler;
    half4 sharpImageColor = inputTexture1.sample(quadSampler, fragmentInput.textureCoordinate);
    half4 blurredImageColor = inputTexture2.sample(quadSampler, fragmentInput.textureCoordinate);

    half intensity = half(uniform.intensity);
    return half4(sharpImageColor.rgb * intensity + blurredImageColor.rgb * (1.0 - intensity), sharpImageColor.a);
}

/*
varying vec2 textureCoordinate;
varying vec2 textureCoordinate2;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

uniform float intensity;

void main()
{
    vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
    vec3 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2).rgb;

    gl_FragColor = vec4(sharpImageColor.rgb * intensity + blurredImageColor * (1.0 - intensity), sharpImageColor.a);
}
*/
