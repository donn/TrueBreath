//
//  FixedWidthInteger.swift
//  TrueDepthStreamer
//
//  Created by Donn on 15/03/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation


extension FixedWidthInteger {
    var bytes: [UInt8] {
        withUnsafeBytes(of: littleEndian, Array.init)
    }
}
