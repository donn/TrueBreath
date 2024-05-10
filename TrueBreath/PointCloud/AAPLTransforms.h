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
Contains geometrical transformations for vectors
*/

#ifndef _METAL_MATH_TRANSFORMS_H_
#define _METAL_MATH_TRANSFORMS_H_

#import <simd/simd.h>

#ifdef __cplusplus

namespace AAPL
{
    float radians(const float& degrees);
    
    simd::float4x4 scale(const float& x,
                         const float& y,
                         const float& z);
    
    simd::float4x4 scale(const simd::float3& s);
    
    simd::float4x4 translate(const float& x,
                             const float& y,
                             const float& z);
    
    simd::float4x4 translate(const simd::float3& t);
    
    simd::float4x4 rotate(const float& angle,
                          const float& x,
                          const float& y,
                          const float& z);
    
    simd::float4x4 rotate(const float& angle,
                          const simd::float3& u);
    
    simd::float4x4 frustum(const float& fovH,
                           const float& fovV,
                           const float& near,
                           const float& far);
    
    simd::float4x4 frustum(const float& left,
                           const float& right,
                           const float& bottom,
                           const float& top,
                           const float& near,
                           const float& far);
    
    simd::float4x4 frustum_oc(const float& left,
                              const float& right,
                              const float& bottom,
                              const float& top,
                              const float& near,
                              const float& far);
    
    simd::float4x4 lookAt(const float * const pEye,
                          const float * const pCenter,
                          const float * const pUp);
    
    simd::float4x4 lookAt(const simd::float3& eye,
                          const simd::float3& center,
                          const simd::float3& up);
    
    simd::float4x4 perspective(const float& width,
                               const float& height,
                               const float& near,
                               const float& far);
    
    simd::float4x4 perspective_fov(const float& fovy,
                                   const float& aspect,
                                   const float& near,
                                   const float& far);
    
    simd::float4x4 perspective_fov(const float& fovy,
                                   const float& width,
                                   const float& height,
                                   const float& near,
                                   const float& far);
    
    simd::float4x4 ortho2d_oc(const float& left,
                              const float& right,
                              const float& bottom,
                              const float& top,
                              const float& near,
                              const float& far);
    
    simd::float4x4 ortho2d_oc(const simd::float3& origin,
                              const simd::float3& size);
    
    simd::float4x4 ortho2d(const float& left,
                           const float& right,
                           const float& bottom,
                           const float& top,
                           const float& near,
                           const float& far);
    
    simd::float4x4 ortho2d(const simd::float3& origin,
                           const simd::float3& size);
} // AAPL

#endif

#endif
