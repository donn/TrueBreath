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
Implements a passthrough shader used for previewing content.
*/

#include <metal_stdlib>
using namespace metal;

// Vertex input/output structure for passing results from vertex shader to fragment shader
struct VertexIO
{
    float4 position [[position]];
    float2 textureCoord [[user(texturecoord)]];
};

// Vertex shader for a textured quad
vertex VertexIO vertexPassThrough(const device packed_float4 *pPosition  [[ buffer(0) ]],
                                  const device packed_float2 *pTexCoords [[ buffer(1) ]],
                                  uint                  vid        [[ vertex_id ]])
{
    VertexIO outVertex;
    
    outVertex.position = pPosition[vid];
    outVertex.textureCoord = pTexCoords[vid];
    
    return outVertex;
}

// Fragment shader for a textured quad
fragment half4 fragmentPassThrough(VertexIO         inputFragment [[ stage_in ]],
                                   texture2d<half> inputTexture  [[ texture(0) ]],
                                   sampler         samplr        [[ sampler(0) ]])
{
    return inputTexture.sample(samplr, inputFragment.textureCoord);
}
