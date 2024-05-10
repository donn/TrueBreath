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
Metal compute shader that translates depth values to JET RGB values.
*/

#include <metal_stdlib>
using namespace metal;

struct BGRAPixel {
    uchar b;
    uchar g;
    uchar r;
    uchar a;
};

struct JETParams {
    int histogramSize;
    int binningFactor;
};

// Compute kernel
kernel void depthToJET(texture2d<float, access::read>  inputTexture      [[ texture(0) ]],
                       texture2d<float, access::write> outputTexture     [[ texture(1) ]],
                       constant JETParams& params [[ buffer(0) ]],
                       constant float* histogram        [[ buffer(1) ]],
                       constant BGRAPixel *colorTable [[ buffer(2) ]],
                       uint2 gid [[ thread_position_in_grid ]])
{
    // Ensure we don't read or write outside of the texture
    if ((gid.x >= inputTexture.get_width()) || (gid.y >= inputTexture.get_height())) {
        return;
    }
    
    // depthDataType is kCVPixelFormatType_DepthFloat16
    float depth = inputTexture.read(gid).x;
    
    ushort histIndex = (ushort)(depth * params.binningFactor);
    
    // make sure the value is part of the histogram
    if (histIndex >= params.histogramSize) {
        return;
    }
    
    float colorIndex = histogram[histIndex];
    
    BGRAPixel outputColor = colorTable[(int)colorIndex];
    
    outputTexture.write(float4(outputColor.r / 255.0, outputColor.g / 255.0, outputColor.b / 255.0, 1.0), gid);
}
