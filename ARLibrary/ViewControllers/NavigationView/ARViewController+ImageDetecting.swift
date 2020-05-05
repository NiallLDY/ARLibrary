//
//  ARViewController+ImageDetecting.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/6.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import ARKit

extension ARViewController {
    
    
    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        if referenceImage.name == "start" {
            self.pathNode.position.y = 0
            
            let heght = referenceImage.physicalSize.height
            self.pathNode.position.z = self.pathNode.position.z + Float(heght)/2
            updateQueue.async {
                self.pathNode.opacity = 0.0
                self.pathNode.runAction(self.roadFadein)
                node.addChildNode(self.pathNode)
            }
            return
        }
        updateQueue.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
        }
        DispatchQueue.main.async {
            // let imageName = referenceImage.name ?? ""
            self.popUpViewController.showInformation(book: self.selectedBook)
            
            self.blurView.transform = CGAffineTransform(translationX: 8, y: 872)
            
            UIView.animate(withDuration: 0.7, delay: 1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.blurView.isHidden = false
                self.blurView.transform = .identity
            }, completion: nil)
        }
        
    }
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }
    var roadFadein: SCNAction {
        return .sequence([
            .fadeIn(duration: 0.5)
        ])
    }
}
