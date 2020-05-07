//
//  ARViewController.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/5.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    let coachingOverlay = ARCoachingOverlayView()
    var path: [Point] = [Point]()
    var pathNode = SCNPathNode(path: [])
    let length: Float = 0.01
    
    var selectedBook: Book!
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var popUpViewController: PopUpViewController = {
        return children.lazy.compactMap({ $0 as? PopUpViewController }).first!
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Set the path
        for point in path {
            pathNode.path.append(SCNVector3(Float(point.y) * length, 0.0, Float(-point.x) * length))
        }
        let pathMat = SCNMaterial()
        pathNode.materials = [pathMat]
        pathMat.diffuse.contents = UIImage(named: "lightBluePath")
        pathNode.width = 0.5
        
        setupCoachingOverlay()
        self.blurView.isHidden = true
        
        popUpViewController.cancelHandler = { [unowned self] in
            
            //self.blurView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.blurView.transform = CGAffineTransform(translationX: 8, y: 872)
            }, completion: { s in
                // self.blurView.isHidden = true
            })
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏NavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.detectionImages = referenceImages
        // Run the view's session
        sceneView.session.run(configuration)
        
        
        
    }
    
    
    
}
