/*
From TrueDepthStreamer

Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
/*
Abstract:
Shader that blends two input textures.
*/

#include <metal_stdlib>
using namespace metal;

struct VertexIO
{
    float4 position [[position]];
    float2 textureCoord [[user(texturecoord)]];
};

struct mixerParameters
{
    float mixFactor;
};

vertex VertexIO vertexMixer(const device float2 *pPosition [[ buffer(0) ]],
                            uint index               [[ vertex_id ]])
{
    VertexIO outVertex;
    
    outVertex.position.xy  = pPosition[index];
    outVertex.position.z = 0;
    outVertex.position.w = 1.0;
    
    // Convert texture position to texture coordinates
    outVertex.textureCoord.xy = 0.5 + float2(0.5, -0.5) * outVertex.position.xy;
    
    return outVertex;
}

fragment half4 fragmentMixer(VertexIO         inputFragment    [[ stage_in ]],
                             texture2d<half> mixerInput0      [[ texture(0) ]],
                             texture2d<half> mixerInput1      [[ texture(1) ]],
                             const device    mixerParameters& mixerParameters [[ buffer(0) ]],
                             sampler         samplr           [[ sampler(0) ]])
{
    half4 input0 = mixerInput0.sample(samplr, inputFragment.textureCoord);
    half4 input1 = mixerInput1.sample(samplr, inputFragment.textureCoord);
    
    half4 output = mix(input0, input1, half(mixerParameters.mixFactor));
    
    return output;
}
