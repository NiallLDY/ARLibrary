//
//  SCNVector3+Extensions.swift
//  FindBook
//
//  Created by 吕丁阳 on 2019/7/20.
//  Copyright © 2019 吕丁阳. All rights reserved.
//

import SceneKit

internal extension SCNVector3 {
    
    /// Returns the magnitude of the vector
    var length: Float {
        return sqrtf(self.lenSq)
    }
    
    /// Angle change between two vectors 两个矢量之间的角度变化
    ///
    /// - Parameter vector: vector to compare 输入要比较的向量
    /// - Returns: angle between the vectors 返回向量间夹角
    func angleChange(to vector: SCNVector3) -> Float {
        let dot = self.normalized().dot(vector: vector.normalized())
        return acos(dot / sqrt(self.lenSq * vector.lenSq))
    }
    
    /// Returns the squared magnitude of the vector 返回向量的平方大小
    var lenSq: Float {
        return x*x + y*y + z*z
    }
    
    /// Normalizes the SCNVector
    ///
    /// - Returns: SCNVector3 of length 1.0
    // 返回：长度为1.0的scnvector3
    func normalized() -> SCNVector3 {
        return self / self.length
    }
    
    /// Sets the magnitude of the vector 设置矢量的大小
    ///
    /// - Parameter to: value to set it to 传入要设给它的值
    /// - Returns: A vector pointing in the same direction but set to a fixed magnitude
    // 返回指向同一方向但设置为固定大小的向量
    func setLength(to vector: Float) -> SCNVector3 {
        return self.normalized() * vector
    }
    
    /// Scalar distance between two vectors 两个向量之间的标量距离
    ///
    /// - Parameter vector: vector to compare 传入要比较的向量
    /// - Returns: Scalar distance 返回标量距离
    func distance(vector: SCNVector3) -> Float {
        return (self - vector).length
    }
    
    /// Dot product of two vectors
    ///
    /// - Parameter vector: vector to compare
    /// - Returns: Scalar dot product
    func dot(vector: SCNVector3) -> Float {
        return x * vector.x + y * vector.y + z * vector.z
    }
    
    /// Given a point and origin, rotate along X/Z plane by radian amount
    ///给定一个点和原点，沿X/Z平面按弧度旋转
    /// - parameter origin: Origin for the start point to be rotated about
    /// - parameter by: Value in radians for the point to be rotated by
    /// 传入 旋转原点和旋转弧度
    /// - returns: New SCNVector3 that has the rotation applied 应用了旋转的新scnvector3
    func rotate(about origin: SCNVector3, by rotation: Float) -> SCNVector3 {
        let pointRepositionedXY = [self.x - origin.x, self.z - origin.z]
        let sinAngle = sin(rotation)
        let cosAngle = cos(rotation)
        return SCNVector3(
            x: pointRepositionedXY[0] * cosAngle - pointRepositionedXY[1] * sinAngle + origin.x,
            y: self.y,
            z: pointRepositionedXY[0] * sinAngle + pointRepositionedXY[1] * cosAngle + origin.z
        )
    }
}

// SCNVector3 operator functions

internal func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

internal func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

internal func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

internal func *= (vector: inout SCNVector3, scalar: Float) {
    vector = (vector * scalar)
}

internal func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

internal func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

