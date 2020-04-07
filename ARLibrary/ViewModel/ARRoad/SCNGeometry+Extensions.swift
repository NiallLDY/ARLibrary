//
//  SCNGeometry+Extensions.swift
//  FindBook
//
//  Created by 吕丁阳 on 2019/7/20.
//  Copyright © 2019 吕丁阳. All rights reserved.
//

import SceneKit
import os

//添加指数
private func addTriangleIndices(indices: inout [UInt32], at index: UInt32) {
    indices.append(contentsOf: [
        index - 2, index - 1, index,
        index, index - 1, index + 1
        ])
}

private func addTriangleStripIndices(indices: inout [UInt32], at index: UInt32) {
    indices.append(contentsOf: [index, index + 1])
}

private func distancesBetweenValues(of arr: [SCNVector3]) -> ([CGFloat], CGFloat) {
    var totalDistance: CGFloat = 0
    let myarr = Array(0...Int(arr.count / 2 - 1))
    let vals = myarr.map { (val) -> CGFloat in
        if val == 0 {
            return 0
        }
        let count = val * 2 + 1
        let lCenter = (arr[count] + arr[count - 1]) / 2
        let llCenter = (arr[count - 2] + arr[count - 3]) / 2
        let newDistance = lCenter.distance(vector: llCenter)
        totalDistance += CGFloat(newDistance)
        return totalDistance
    }
    return (vals, totalDistance)
}

private func newTurning(points: [SCNVector3]) -> Float {
    guard points.count == 3 else {
        return 0
    }
    let vec1 = points[1] - points[0]
    let vec2 = points[2] - points[1]
    return atan2(vec1.x * vec2.z - vec1.z * vec2.x, vec1.x * vec2.x + vec1.z * vec2.z)
}

private extension SCNVector3 {
    /// As I'm assuming the path is mostly flat for now, needed this to make the rotations easier
    //因为我假设现在的路径基本上是平的，需要这个来使旋转更容易
    ///
    
    /// - Returns: the same vector with the y value set to 0
    // 返回：y值设置为0的同一向量
    func flattened() -> SCNVector3 {
        return SCNVector3(self.x, 0, self.z)
    }
}

public extension SCNGeometry {
    
    private static var defaultSCNPathMaterial: SCNMaterial {
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor.blue
        return mat
    }
    /// Create your path (triangle strip) from a series of `SCNVector3` points
    /// 从一系列“scnvector3”点创建路径（三角形带）
    /// This path is assumed all normals facing directly up
    // 假定此路径的所有法线都直接朝上
    /// in the positive Y axis for now.现在在正y轴上
    ///
    /// - Parameters:
    ///   - path: Point from which to make the path. 路径：创建路径的点
    ///   - width: Width of your path (default 0.5).  路径宽度，默认为0.5
    ///   - curvePoints: Number of points to make the curve at any turn in the path,
    ///       default to 8. 0 will make sharp corners.
    //      曲线点：在路径的任意转弯处绘制曲线的点的数量，默认为8.0将形成尖角
    ///   - materials: Materials to be used on the geometry. Only the first will be read.
    //    材质：用于几何图形的材质。只有第一个将被读取
    /// - Returns: A new SCNGeometry representing the path for use with any SceneKit Application.
    //      返回：表示任何scenekit应用程序使用的路径的新scngemetry
    class func path(
        path: [SCNVector3], width: Float = 0.5,
        curvePoints: Float = 8, materials: [SCNMaterial] = [],
        curveDistance: Float = 1.5
        ) -> (SCNGeometry?, CGFloat) {
        if path.count < 2 {
            return (nil, 0)
        }
        var materials = materials
        if materials.isEmpty {
            materials.append(SCNGeometry.defaultSCNPathMaterial)
        }
        if curveDistance < 1 {
            os_log(.error, "curve distance is too low, minimum value is 1")
        }
        let curveDistance = max(curveDistance, 1)
        var vertices: [SCNVector3] = []
        var indices: [UInt32] = []
        var texutreCoords: [CGPoint] = []
        let maxIndex = path.count - 1
        var bentBy: Float = 0
        for (index, vert) in path.enumerated() {
            var addVector: SCNVector3!
            if index == 0 {
                // first point
                addVector = SCNVector3(path[index + 1].z - vert.z, 0, vert.x - path[index + 1].x)
            } else if index < maxIndex {
                let toThis = (vert - path[index - 1]).flattened().normalized()
                let fromThis = (path[index + 1] - vert).flattened().normalized()
                bentBy = fromThis.angleChange(to: toThis)
                let resultant = (toThis + fromThis) / 2
                addVector = SCNVector3(resultant.z, 0, -resultant.x)
            } else {
                // last point
                addVector = SCNVector3(vert.z - path[index - 1].z, 0, path[index - 1].x - vert.x)
            }
            addVector = addVector.normalized() * (width / 2)
            if curvePoints > 0, path.count >= index + 2, bentBy > 0.001 {
                let edge1 = vert - addVector
                let edge2 = vert + addVector
                var bendAround = vert - (addVector * curveDistance)
                
                // replace this with quaternions when possible
                if newTurning(points: Array(path[(index-1)...(index+1)])) < 0 { // left turn
                    bendAround = vert + (addVector * curveDistance)
                    bentBy *= -1
                }
                for val in 0...Int(curvePoints) {
                    vertices.append(edge2.rotate(
                        about: bendAround, by: (-0.5 + Float(val) / curvePoints) * bentBy))
                    vertices.append(edge1.rotate(
                        about: bendAround, by: (-0.5 + Float(val) / curvePoints) * bentBy))
                    addTriangleIndices(indices: &indices, at: UInt32(vertices.count - 2))
                    // When the normals are added properly, uncomment this line and the same below
                    //                    vertices.append(contentsOf: vertices[(vertices.count - 2)...])
                    //正确添加法线后，取消对此行和下面相同顶点的注释。append（contentSof:顶点[（vertices.count-2）…]
                }
            } else {
                vertices.append(vert + addVector)
                vertices.append(vert - addVector)
                if index > 0 {
                    addTriangleIndices(indices: &indices, at: UInt32(vertices.count - 2))
                    //                    vertices.append(contentsOf: vertices[(vertices.count - 2)...])
                }
            }
        }
        let (arr, pathLength) = distancesBetweenValues(of: vertices)
        
        for val in arr {
            texutreCoords.append(CGPoint(x: 0, y: val / pathLength))
            texutreCoords.append(CGPoint(x: 1, y: val / pathLength))
        }
        let src = SCNGeometrySource(vertices: vertices)
        let textureMap = SCNGeometrySource(textureCoordinates: texutreCoords)
        
        // assuming the path is just flat for now, even though it can be angled.
        // 假设路径是平的，即使他有倾角
        // the turning part doesn't do anything nice with sloped paths yet.
        // 转弯的那部分对倾斜的路还没有做什么优化的
        let norm = SCNGeometrySource(normals: [SCNVector3](
            repeating: SCNVector3(0, 1, 0), count: vertices.count
        ))
        
        // using triangles instead of triangleStrip for better normals
        // 使用三角形而不是三角形带以获得更好的法线
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        let geo = SCNGeometry(sources: [src, norm, textureMap], elements: [element])
        geo.materials = materials
        return (geo, pathLength)
    }
}

