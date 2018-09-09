//
//  ViewController.swift
//  FindObjectDemo
//
//  Created by Arpit Shah on 13/06/18.
//  Copyright © 2018 Arpit Shah. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import ARKit
import AVFoundation
import WebKit
import  MessageUI

class AVImageDetaction: UIViewController, ARSCNViewDelegate,ARSKViewDelegate,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var viewObj = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 89))
    var mainNode = SCNNode()
    var webView = UIWebView()
    var webNode = SCNNode()
    var cardPlane = SCNPlane()
    var isFirstTime : Bool = true
    var configuration = ARImageTrackingConfiguration()
    var isWebAdded = false
    
    var logos = ["card","card1"]//["mastercard2","mastercard3","mastercard4","mastercard5","visa1","visa2","visa3","hdfc1","hdfc2","hdfc3","hdfc4","hdfc5"]
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        var logoImages:[ARReferenceImage] = []
        for logo in logos
        {
            let trigger = ARReferenceImage(UIImage(named: logo)!.cgImage!,
                                           orientation: CGImagePropertyOrientation.up,
                                           physicalWidth: 1)
            trigger.name = logo
            logoImages.append(trigger)
        }
        
        configuration.trackingImages = NSSet.init(array: logoImages) as! Set<ARReferenceImage>
        configuration.maximumNumberOfTrackedImages = 1
        // Run the view's session
        sceneView.session.run(configuration)
        self.sceneView.gestureRecognizers?.removeAll()
        self.registerGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Finding Object")
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //        if let imageAnchor = anchor as? ARImageAnchor {
        //            self.mainNode.eulerAngles.x = -.pi / 2
        //            self.mainNode.movabilityHint = .fixed
        //            self.mainNode.position.x = 0.71
        //            self.mainNode.position.z = 0.6
        //        }
    }
    
    @objc func addImage()
    {
        self.cardPlane.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "card1")
    }
    
    //  Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            print(imageAnchor.referenceImage.physicalSize)
            print(imageAnchor.referenceImage.name ?? "")
            DispatchQueue.main.async {
                
                let plane = SCNPlane(width: 3, height:2)
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
                let material = SCNMaterial()
                material.isDoubleSided = true
                material.diffuse.contents = UIColor.clear
                plane.materials = [material]
                self.mainNode = SCNNode(geometry: plane)
                self.mainNode.eulerAngles.x = -.pi / 2
                self.mainNode.movabilityHint = .fixed
                self.mainNode.position.x = 0.99//Float(imageAnchor.referenceImage.physicalSize.width)
                self.mainNode.position.z = 0.68///Float(imageAnchor.referenceImage.physicalSize.height)
                self.mainNode.name = "Main Node"
                self.mainNode.opacity = 1.0
                node.addChildNode(self.mainNode)
                
                self.cardPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                self.cardPlane.firstMaterial?.diffuse.contents = UIColor.yellow
                let cardARNode = SCNNode(geometry: self.cardPlane)
                cardARNode.position = SCNVector3(-0.99,0.68,0.01)
                cardARNode.name = "Card Node"
                cardARNode.opacity = 0.0
                self.mainNode.addChildNode(cardARNode)
                
                self.performSelector(onMainThread: <#T##Selector#>, with: <#T##Any?#>, waitUntilDone: <#T##Bool#>)
                
                var waitDuration = SCNAction.wait(duration: 0.3)
                let fadeIn = SCNAction.fadeOpacity(to: 0.3, duration: 0.3)
                let fadeOut = SCNAction.fadeOpacity(to: 0.0, duration: 0.3)
                cardARNode.runAction(SCNAction.sequence([waitDuration,fadeIn,fadeOut,fadeIn,fadeOut]))
                
                let labelNode1 = SKLabelNode(fontNamed: "Avenir Heavy")
                labelNode1.position = CGPoint(x: 500, y:100)
                labelNode1.fontColor = UIColor.white
                labelNode1.text = "HDFC Prevelige Credit Card"
                labelNode1.fontSize = 70.0
                let spriteLabelScene = SKScene(size: CGSize(width: 1000, height: 250))
                spriteLabelScene.backgroundColor = UIColor.clear
                spriteLabelScene.addChild(labelNode1)
                let label1Plane = SCNPlane(width: 1.0, height: 0.25)
                label1Plane.firstMaterial?.diffuse.contents = spriteLabelScene
                label1Plane.firstMaterial!.isDoubleSided = true
                let label1ARNode = SCNNode(geometry: label1Plane)
                label1ARNode.position = SCNVector3(-1.0,0.85,0.01)
                label1ARNode.eulerAngles = SCNVector3(180.degreesToRadians,0,0)
                label1ARNode.name = "Label1 Node"
                label1ARNode.isHidden = true
                self.mainNode.addChildNode(label1ARNode)
                
                let moveInTitle = SCNAction.move(to: SCNVector3(0,0.85,0.01), duration: 0.5)
                let unHideAction = SCNAction.unhide()
                waitDuration = SCNAction.wait(duration: 1.0)
                label1ARNode.runAction(SCNAction.sequence([waitDuration,unHideAction,moveInTitle]))
                
                let bannerPlane1 = SCNPlane(width: 1, height: 0.2)
                bannerPlane1.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "banner1")
                bannerPlane1.firstMaterial!.isDoubleSided = true
                let bannerARNode1 = SCNNode(geometry: bannerPlane1)
                bannerARNode1.position = SCNVector3(-1.0,0.5,0.01)
                bannerARNode1.name = "Banner1 Node"
                bannerARNode1.opacity = 0.0
                self.mainNode.addChildNode(bannerARNode1)
                
                let bannerPlane2 = SCNPlane(width: 1, height: 0.2)
                bannerPlane2.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "banner3")
                bannerPlane2.firstMaterial!.isDoubleSided = true
                let bannerARNode2 = SCNNode(geometry: bannerPlane2)
                bannerARNode2.position = SCNVector3(-1.0,0.5,0.01)
                bannerARNode2.name = "Banner2 Node"
                bannerARNode2.opacity = 0.0
                self.mainNode.addChildNode(bannerARNode2)
                
                let bannerPlane3 = SCNPlane(width: 1, height: 0.2)
                bannerPlane3.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "banner6")
                bannerPlane3.firstMaterial!.isDoubleSided = true
                let bannerARNode3 = SCNNode(geometry: bannerPlane3)
                bannerARNode3.position = SCNVector3(-1.0,0.5,0.01)
                bannerARNode3.name = "Banner3 Node"
                bannerARNode3.opacity = 0.0
                self.mainNode.addChildNode(bannerARNode3)
                
                let bannerPlane4 = SCNPlane(width: 1, height: 0.2)
                bannerPlane4.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "banner2")
                bannerPlane4.firstMaterial!.isDoubleSided = true
                let bannerARNode4 = SCNNode(geometry: bannerPlane4)
                bannerARNode4.position = SCNVector3(-1.0,0.5,0.01)
                bannerARNode4.name = "Banner4 Node"
                bannerARNode4.opacity = 0.0
               self.mainNode.addChildNode(bannerARNode4)
                
                let bannerPlane5 = SCNPlane(width: 1, height: 0.2)
                bannerPlane5.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "banner5")
                bannerPlane5.firstMaterial!.isDoubleSided = true
                let bannerARNode5 = SCNNode(geometry: bannerPlane5)
                bannerARNode5.position = SCNVector3(-1.0,0.5,0.01)
                bannerARNode5.name = "Banner5 Node"
                bannerARNode5.opacity = 0.0
                self.mainNode.addChildNode(bannerARNode5)
                
                let bannerPlane6 = SCNPlane(width: 1, height: 0.2)
                bannerPlane6.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "banner4")
                bannerPlane6.firstMaterial!.isDoubleSided = true
                let bannerARNode6 = SCNNode(geometry: bannerPlane6)
                bannerARNode6.position = SCNVector3(-1.0,0.5,0.01)
                bannerARNode6.name = "Banner6 Node"
                bannerARNode6.opacity = 0.0
                self.mainNode.addChildNode(bannerARNode6)
                
                let bannerPlane7 = SCNPlane(width: 1, height: 0.2)
                bannerPlane7.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "banner7")
                bannerPlane7.firstMaterial!.isDoubleSided = true
                let bannerARNode7 = SCNNode(geometry: bannerPlane7)
                bannerARNode7.position = SCNVector3(-1.0,0.5,0.01)
                bannerARNode7.name = "Banner7 Node"
                bannerARNode7.opacity = 0.0
                self.mainNode.addChildNode(bannerARNode7)
                
                let scaleInBanner1 = SCNAction.fadeOpacity(to: 1.0, duration: 1.0)
                let moveInBanner1 = SCNAction.move(to: SCNVector3(-1.0,0.28,0.01), duration: 0.2)
                let banner1Action = SCNAction.group([waitDuration,moveInBanner1,scaleInBanner1])
                bannerARNode1.runAction(banner1Action)
                let scaleInBanner2 = SCNAction.fadeOpacity(to: 1.0, duration: 1.0)
                let moveInBanner2 = SCNAction.move(to: SCNVector3(-1.0,0.09,0.01), duration: 0.4)
                let banner2Action = SCNAction.group([waitDuration,moveInBanner2,scaleInBanner2])
                bannerARNode2.runAction(banner2Action)
                let scaleInBanner3 = SCNAction.fadeOpacity(to: 1.0, duration: 1.0)
                let moveInBanner3 = SCNAction.move(to: SCNVector3(-1.0,-0.1,0.01), duration: 0.6)
                let banner3Action = SCNAction.group([waitDuration,moveInBanner3,scaleInBanner3])
                bannerARNode3.runAction(banner3Action)
                let scaleInBanner4 = SCNAction.fadeOpacity(to: 1.0, duration: 1.0)
                let moveInBanner4 = SCNAction.move(to: SCNVector3(-1.0,-0.29,0.01), duration: 0.8)
                let banner4Action = SCNAction.group([waitDuration,moveInBanner4,scaleInBanner4])
                bannerARNode4.runAction(banner4Action)
                let scaleInBanner5 = SCNAction.fadeOpacity(to: 1.0, duration: 1.0)
                let moveInBanner5 = SCNAction.move(to: SCNVector3(-1.0,-0.48,0.01), duration: 1.0)
                let banner5Action = SCNAction.group([waitDuration,moveInBanner5,scaleInBanner5])
                bannerARNode5.runAction(banner5Action)
                let scaleInBanner6 = SCNAction.fadeOpacity(to: 1.0, duration: 1.0)
                let moveInBanner6 = SCNAction.move(to: SCNVector3(-1.0,-0.67,0.01), duration: 1.2)
                let banner6Action = SCNAction.group([waitDuration,moveInBanner6,scaleInBanner6])
                bannerARNode6.runAction(banner6Action)
                let scaleInBanner7 = SCNAction.fadeOpacity(to: 1.0, duration: 1.0)
                let moveInBanner7 = SCNAction.move(to: SCNVector3(-1.0,-0.86,0.01), duration: 1.4)
                let banner7Action = SCNAction.group([waitDuration,moveInBanner7,scaleInBanner7])
                bannerARNode7.runAction(banner7Action)
            }
        }
        return node
    }
    
    @IBAction func reset(_ sender: Any) {
        isWebAdded = false
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func registerGestureRecognizers()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.backgroundColor = UIColor.clear
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer){
        self.mainNode.eulerAngles.x = -.pi / 2
        self.mainNode.movabilityHint = .fixed
        
        let sceneViewTappedOn = recognizer.view as! SCNView
        let touchCoordinates = recognizer.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            DispatchQueue.main.async {
                let results = hitTest.first!
                let node = results.node
                print(node.name ?? "no node")
                if node.name == "Profile Pic Node"
                {
                }
                else if node.name == "Facebook Rakesh"
                {
                    let fadeIn = SCNAction.fadeOpacity(to: 0.3, duration: 0.3)
                    let fadeOut = SCNAction.fadeOpacity(to: 1.0, duration: 0.3)
                    node.runAction(SCNAction.sequence([fadeIn,fadeOut]))
                    if self.isWebAdded == false
                    {
                        let moveInWeb = SCNAction.move(to: SCNVector3(0.8,-0.15,0.01), duration: 1.0)
                        self.webNode.runAction(moveInWeb)
                        self.webNode.isHidden = false
                        self.isWebAdded = true
                    }
                    self.webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.facebook.com/AforAppleMac")!))
                }
                else if node.name == "Facebook Sai"
                {
                    let fadeIn = SCNAction.fadeOpacity(to: 0.3, duration: 0.3)
                    let fadeOut = SCNAction.fadeOpacity(to: 1.0, duration: 0.3)
                    node.runAction(SCNAction.sequence([fadeIn,fadeOut]))
                    
                    if self.isWebAdded == false
                    {
                        let moveInWeb = SCNAction.move(to: SCNVector3(0.8,-0.15,0.01), duration: 1.0)
                        self.webNode.runAction(moveInWeb)
                        self.webNode.isHidden = false
                        self.isWebAdded = true
                    }
                    self.webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.facebook.com/sairam.venkata")!))
                }
                else if node.name == "LinkedIn Rakesh"
                {
                    let fadeIn = SCNAction.fadeOpacity(to: 0.3, duration: 0.3)
                    let fadeOut = SCNAction.fadeOpacity(to: 1.0, duration: 0.3)
                    node.runAction(SCNAction.sequence([fadeIn,fadeOut]))
                    if self.isWebAdded == false
                    {
                        let moveInWeb = SCNAction.move(to: SCNVector3(0.8,-0.15,0.01), duration: 1.0)
                        self.webNode.runAction(moveInWeb)
                        self.webNode.isHidden = false
                        self.isWebAdded = true
                    }
                    self.webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.linkedin.com/in/rakesh-yadalam-95803924/")!))
                }
                else if node.name == "LinkedIn Sai"
                {
                    let fadeIn = SCNAction.fadeOpacity(to: 0.3, duration: 0.3)
                    let fadeOut = SCNAction.fadeOpacity(to: 1.0, duration: 0.3)
                    node.runAction(SCNAction.sequence([fadeIn,fadeOut]))
                    if self.isWebAdded == false
                    {
                        let moveInWeb = SCNAction.move(to: SCNVector3(0.8,-0.15,0.01), duration: 1.0)
                        self.webNode.runAction(moveInWeb)
                        self.webNode.isHidden = false
                        self.isWebAdded = true
                    }
                    self.webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.linkedin.com/in/sai-ram-a135b840/")!))
                }
                else if node.name == "Card Node"
                {
                    
                }
                else if node.name == "Call Node"
                {
                    UIApplication.shared.open(URL.init(string: "tel://9743993385")!, options: [:], completionHandler: { (success) in
                    })
                }
                else if node.name == "Message Node"
                {
                    if let url = URL(string: "sms://9743993385") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
                else if node.name == "Facetime Node"
                {
                    UIApplication.shared.open(URL.init(string: "facetime://9743993385")!, options: [:], completionHandler: nil)
                }
                else if node.name == "Mail Node"
                {
                    UIApplication.shared.open(URL.init(string: "mailto:")!, options: [:], completionHandler: { (success) in
                    })
                }
                else if node.name == "Video Node"
                {
                    
                }
                else
                {
                    node.movabilityHint = .fixed
                }
            }
        }
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
}
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}
