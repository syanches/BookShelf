//
//  ARViewController.swift
//  BookShelf
//
//  Created by Артем Мартиросян on 19/06/2019.
//  Copyright © 2019 Артем Мартиросян. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate  {
  
    @IBOutlet weak var sceneView: ARSCNView!
    
    var waitRemoveAction : SCNAction {
        return .sequence([SCNAction.wait(duration: 10.0), .fadeOut(duration: 4.0), .removeFromParentNode()])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
 //       sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        let referenceImage = imageAnchor.referenceImage

        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
        
        let text = SCNText()
        text.extrusionDepth = 0.3
        text.firstMaterial?.diffuse.contents = UIColor.red
        text.flatness = 0.6
        text.containerFrame = CGRect(origin: CGPoint(x: CGFloat(node.position.x - 30), y: CGFloat(node.position.y - 70 )), size: CGSize(width: 100.0, height: 200.0))
        text.isWrapped = true
        text.font = UIFont(name: "body", size: 20)

        switch referenceImage.name {
        case "New world":
            plane.firstMaterial?.diffuse.contents = UIColor.orange
            text.string = "Дата начала прочтения:\n01.05.2018\nДата окончания прочтения:\n19.05.2018"
        //    text.firstMaterial?.diffuse.contents = UIColor.blue
            
        case "monday":
            plane.firstMaterial?.diffuse.contents = UIColor.white
        case "fromm":
            plane.firstMaterial?.diffuse.contents = UIColor.green
    
        default:
            plane.firstMaterial?.diffuse.contents = UIColor.black
        }
        let textNode = SCNNode(geometry: text)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.25
        planeNode.eulerAngles.x = -Float.pi / 2
        
    
        textNode.position = planeNode.position
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        textNode.eulerAngles.x = -Float.pi / 4
        
        
        node.addChildNode(textNode)
        node.addChildNode(planeNode)
        planeNode.runAction(waitRemoveAction)

    }
    
    
}
