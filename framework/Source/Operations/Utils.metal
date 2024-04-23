#include <metal_stdlib>
#include "Utils.h"
using namespace metal;

float rand(float2 co)
{
    return fract(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453);
}

float3 hsv2rgb(float3 c)
{
    float4 K = float4(1.,2./3.,1./3.,3.);
    return c.z*mix(K.xxx, saturate(abs(fract(c.x+K.xyz)*6.-K.w)-K.x),c.y);
}
