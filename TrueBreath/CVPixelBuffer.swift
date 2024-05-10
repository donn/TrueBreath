//
//  CVPixelBuffer.swift
//  TrueDepthStreamer
//
//  Created by Donn on 15/03/2024.
//  Copyright © 2024 Mohamed Gaber. All rights reserved.
//

import Foundation


extension CVPixelBuffer {
    var width: Int {
        return CVPixelBufferGetWidth(self)
    }
    
    var height: Int {
        return CVPixelBufferGetHeight(self)
    }
    
//    func withLockedBaseAddress<T>(boundTo type: T, cl: (Int, Int, UnsafeMutableBufferPointer<T>) -> ()) {
//        CVPixelBufferLockBaseAddress(self, .readOnly)
//        let rawPtr: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress(self)!
//        let ptr = UnsafeMutableBufferPointer<T>(start: rawPtr.assumingMemoryBound(to: T.self), count: width * height)
//        cl(width, height, ptr)
//        CVPixelBufferUnlockBaseAddress(self, .readOnly)
//    }
    
    func withLockedBaseAddress(_ cl: (UnsafeMutableBufferPointer<UInt16>) -> ()) {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        let rawPtr: UnsafeMutableRawPointer = CVPixelBufferGetBaseAddress(self)!
        let ptr = UnsafeMutableBufferPointer<UInt16>(start: rawPtr.assumingMemoryBound(to: UInt16.self), count: width * height)
        cl(ptr)
        CVPixelBufferUnlockBaseAddress(self, .readOnly)
    }

}
