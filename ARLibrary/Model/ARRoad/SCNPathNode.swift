//
//  SCNPathNode.swift
//  Library
//
//  Created by 吕丁阳 on 2019/11/14.
//  Copyright © 2019 吕丁阳. All rights reserved.
//

import SceneKit

/// Subclass of SCNNode, when created holds a geometry representing the path.
// scnnode的子类，创建时包含表示路径的几何体
public class SCNPathNode: SCNNode {
    
    /// The centre points of the path to be drawn
    //要绘制的路径的中心点
    public var path: [SCNVector3] {
        // later this will be a little smarter, calculating the diff from the oldValue
        //稍后，这将变得更智能，计算与旧值的差异
        didSet {
            self.recalcGeometry()
        }
    }
    /// The length of the path with the curvature of any turning points
    // 任何拐点曲率的路径长度
    public private(set) var pathLength: CGFloat = 0
    
    /// Width of the path in meters 路径宽度（米）
    public var width: Float {
        didSet {
            if self.geometry != nil {
                self.recalcGeometry()
            }
        }
    }
    
    /// Whenever a curve is met, how many segments are wanted to curve the corner.
    // 每当遇到一条曲线时，需要多少段来弯曲拐角
    /// This will be a maximum in a later version, so slight bends don't create unecessary vertices.
    // 在以后的版本中，这将是最大值，因此轻微弯曲不会创建不必要的顶点。
    public var curvePoints: Float {
        didSet {
            if self.geometry != nil {
                self.recalcGeometry()
            }
        }
    }
    
    /// An array of SCNMaterial objects that determine the geometry’s appearance when rendered.
    // 确定几何体在渲染时的外观的scn材质对象数组
    public var materials: [SCNMaterial] {
        didSet {
            if let geom = self.geometry {
                geom.materials = materials
            }
        }
    }
    
    /// If the texture is a seamless repeating image use this to say how tall the image should
    /// be if the width = 1.
    ///如果纹理是无缝重复的图像，使用此选项可以说明如果宽度=1，图像应该有多高
    /// - Parameter meters: meters tall the image would be if the width = 1m.
    public var textureRepeats = false {
        didSet {
            if textureRepeats != oldValue {
                if textureRepeats {
                    self.recalcTextureScale()
                } else {
                    self.resetTextureScale()
                }
            }
        }
    }
    
    /// Create the SCNPathNode with the geometry and materials applied.
    //  使用应用的几何图形和材质创建SCNPathNode
    ///
    /// - Parameters:
    ///   - path: Point from which to make the path. 创建路径的点
    ///   - width: Width of your path (default 0.5).
    ///   - curvePoints: Number of points to make the curve at any turn in the path,
    ///       default to 8. 0 will make sharp corners.在任何转弯处绘制路径的点数
    ///   - materials: Materials to be used on the geometry. Only the first will be read.
    public init(
        path: [SCNVector3], width: Float = 0.5,
        curvePoints: Float = 8, materials: [SCNMaterial] = []
        ) {
        self.path = path
        self.width = width
        self.curvePoints = curvePoints
        self.materials = materials
        super.init()
        self.recalcGeometry()
    }
    
    private func resetTextureScale() {
        let contentsTransform = SCNMatrix4Scale(SCNMatrix4Identity, 1, 1, 1)
        self.materials.first?.diffuse.contentsTransform = contentsTransform
    }
    
    private func recalcTextureScale() {
        if let contents = self.materials.first?.diffuse.contents,
            let img = contents as? UIImage {
            let contentsTransform = SCNMatrix4Scale(
                SCNMatrix4Identity,
                1, Float(self.pathLength / (CGFloat(self.width) * img.size.width / img.size.height)), 1)
            self.materials.first?.diffuse.wrapT = .repeat
            self.materials.first?.diffuse.contentsTransform = contentsTransform
        } else {
            self.textureRepeats = false
        }
    }
    
    private func recalcGeometry() {
        (self.geometry, self.pathLength) = SCNGeometry.path(
            path: path, width: self.width,
            curvePoints: curvePoints, materials: self.materials
        )
        if self.textureRepeats {
            self.recalcTextureScale()
        } else {
            self.resetTextureScale()
        }
    }
    
    private override init() {
        self.path = []
        self.width = 0.5
        self.curvePoints = 8
        self.materials = []
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


