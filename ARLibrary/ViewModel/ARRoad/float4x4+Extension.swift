//
//  float4x4+Extension.swift
//  FindBook
//
//  Created by 吕丁阳 on 2019/7/20.
//  Copyright © 2019 吕丁阳. All rights reserved.
//

import Foundation
import SceneKit

internal extension float4x4 {
    
    var translation: SIMD3<Float> {
        get {
            let translation = columns.3
            return SIMD3<Float>(translation.x, translation.y, translation.z)
        }
        set(newValue) {
            columns.3 = SIMD4<Float>(newValue.x, newValue.y, newValue.z, columns.3.w)
        }
    }
    
    var orientation: simd_quatf {
        return simd_quaternion(self)
    }
}
