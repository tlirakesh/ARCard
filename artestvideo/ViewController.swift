//
//  ViewController.swift
//  artestvideo
//
//  Created by Nagaraj, Nivedita on 7/18/18.
//  Copyright © 2018 WellsFargo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Speech
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    var mainNode = SCNNode()

    var label1ARNode = SCNNode()
    var label2ARNode = SCNNode()
    var label3ARNode = SCNNode()
    var label4ARNode = SCNNode()
    
    var videoARNode = SCNNode()
    var webNode = SCNNode()
    
    var webView = UIWebView()
    var videoNode = SKVideoNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        registerGestureRecognizers()
        // Create a new scene
       // let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @IBAction func add(_ sender: Any) {
        self.restartSession()
        
        let mainPlane = SCNPlane(width: 4, height: 3)
        mainPlane.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "texture")
        mainPlane.firstMaterial!.isDoubleSided = true
        mainNode.geometry = mainPlane
        mainNode.name = "Main Node"
        
        let urlStr = Bundle.main.path(forResource: "sample", ofType: "mp4")
        let url = NSURL(fileURLWithPath: urlStr!)
        let player = AVPlayer.init(url: url as URL)
        videoNode = SKVideoNode.init(avPlayer: player)
        let size = CGSize.init(width: self.view.frame.size.width*2, height: self.view.frame.size.height*2)
        videoNode.size = size
        videoNode.zRotation = 0
        videoNode.position = CGPoint(x: size.width/2, y: size.height/2)
        let spriteVideoScene = SKScene(size: size)
        spriteVideoScene.addChild(videoNode)
        let videoPlane = SCNPlane(width: 1.2, height: 0.8)
        videoPlane.firstMaterial?.diffuse.contents = spriteVideoScene
        videoPlane.firstMaterial!.isDoubleSided = true
        videoARNode = SCNNode(geometry: videoPlane)
        videoARNode.position = SCNVector3(1.35,1.0,0.02)
        videoARNode.eulerAngles = SCNVector3(180.degreesToRadians,0,0)
        videoARNode.name = "Video Node"
        videoARNode.isHidden = true
        mainNode.addChildNode(videoARNode)
        
        webView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width:640, height: 480))
        webView.backgroundColor = UIColor.black
        webView.isUserInteractionEnabled = true
        
        let webPlane = SCNPlane(width: 1.2, height: 1.6)
        webPlane.firstMaterial?.diffuse.contents = webView
        webPlane.firstMaterial?.isDoubleSided = true
        webNode = SCNNode(geometry: webPlane)
        webNode.position = SCNVector3(1.35,-0.6,0.02)
        webNode.name = "Web Node"
        webNode.isHidden = true
        mainNode.addChildNode(webNode)
        
        let labelNode1 = SKLabelNode(fontNamed: "Arial")
        labelNode1.position = CGPoint(x: 150, y:90)
        labelNode1.fontColor = UIColor.white
        labelNode1.text = "Load Web"
        labelNode1.fontSize = 40.0
        let spriteLabelScene = SKScene(size: CGSize(width: 300, height: 200))
        spriteLabelScene.backgroundColor = UIColor.blue
        spriteLabelScene.addChild(labelNode1)
        let label1Plane = SCNPlane(width: 0.5, height: 0.3)
        label1Plane.firstMaterial?.diffuse.contents = spriteLabelScene
        label1Plane.cornerRadius = 0.5
        label1Plane.firstMaterial!.isDoubleSided = true
        label1ARNode = SCNNode(geometry: label1Plane)
        label1ARNode.position = SCNVector3Zero//SCNVector3(0.45,-0.4,0.02)
        label1ARNode.eulerAngles = SCNVector3(180.degreesToRadians,0,0)
        label1ARNode.name = "Label1 Node"
        mainNode.addChildNode(label1ARNode)
        
        let labelNode2 = SKLabelNode(fontNamed: "Arial")
        labelNode2.position = CGPoint(x: 150, y:90)
        labelNode2.fontColor = UIColor.white
        labelNode2.text = "Play Video"
        labelNode2.fontSize = 40.0
        let spriteLabelScene2 = SKScene(size: CGSize(width: 300, height: 200))
        spriteLabelScene2.backgroundColor = UIColor.blue
        spriteLabelScene2.addChild(labelNode2)
        let label2Plane = SCNPlane(width: 0.5, height: 0.3)
        label2Plane.firstMaterial?.diffuse.contents = spriteLabelScene2
        label2Plane.cornerRadius = 0.5
        label2Plane.firstMaterial!.isDoubleSided = true
        label2ARNode = SCNNode(geometry: label2Plane)
        label2ARNode.position = SCNVector3Zero//SCNVector3(0.45,0.4,0.02)
        label2ARNode.eulerAngles = SCNVector3(180.degreesToRadians,0,0)
        label2ARNode.name = "Label2 Node"
        mainNode.addChildNode(label2ARNode)
        
        let labelNode3 = SKLabelNode(fontNamed: "Arial")
        labelNode3.position = CGPoint(x: 150, y:90)
        labelNode3.fontColor = UIColor.white
        labelNode3.text = "Pie Chart"
        labelNode3.fontSize = 40.0
        let spriteLabelScene3 = SKScene(size: CGSize(width: 300, height: 200))
        spriteLabelScene3.backgroundColor = UIColor.blue
        spriteLabelScene3.addChild(labelNode3)
        let label3Plane = SCNPlane(width: 0.5, height: 0.3)
        label3Plane.firstMaterial?.diffuse.contents = spriteLabelScene3
        label3Plane.cornerRadius = 0.5
        label3Plane.firstMaterial!.isDoubleSided = true
        label3ARNode = SCNNode(geometry: label3Plane)
        label3ARNode.position = SCNVector3Zero//SCNVector3(-0.45,-0.4,0.02)
        label3ARNode.eulerAngles = SCNVector3(180.degreesToRadians,0,0)
        label3ARNode.addChildNode(label3ARNode)
        label3ARNode.name = "Label3 Node"
        mainNode.addChildNode(label3ARNode)
        
        let labelNode4 = SKLabelNode(fontNamed: "Arial")
        labelNode4.position = CGPoint(x: 150, y:90)
        labelNode4.fontColor = UIColor.white
        labelNode4.text = "Mail to"
        labelNode4.fontSize = 40.0
        let spriteLabelScene4 = SKScene(size: CGSize(width: 300, height: 200))
        spriteLabelScene4.backgroundColor = UIColor.blue
        spriteLabelScene4.addChild(labelNode4)
        let label4Plane = SCNPlane(width: 0.5, height: 0.3)
        label4Plane.firstMaterial?.diffuse.contents = spriteLabelScene4
        label4Plane.cornerRadius = 0.5
        label4Plane.firstMaterial!.isDoubleSided = true
        label4ARNode = SCNNode(geometry: label4Plane)
        label4ARNode.position = SCNVector3Zero//SCNVector3(-0.45,0.4,0.02)
        label4ARNode.eulerAngles = SCNVector3(180.degreesToRadians,0,0)
        label4ARNode.name = "Label4 Node"
        mainNode.addChildNode(label4ARNode)
        
        let profilePicPlane = SCNPlane(width: 0.6, height: 0.6)
        profilePicPlane.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "profilePic")
        profilePicPlane.cornerRadius = 0.5
        profilePicPlane.firstMaterial!.isDoubleSided = true
        let profileARNode = SCNNode(geometry: profilePicPlane)
        profileARNode.position = SCNVector3(0,0,0.02)
        profileARNode.name = "Profile Pic Node"
        mainNode.addChildNode(profileARNode)
        
        guard let currentFrame = self.sceneView.session.currentFrame else { return }
        var translation = matrix_identity_float4x4
        translation.columns.3.x = 0
        translation.columns.3.y = 0
        translation.columns.3.z = -4.0
        mainNode.simdScale = simd_float3(0.25,0.25,0.25)
        mainNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        mainNode.eulerAngles = SCNVector3Zero
        self.sceneView.scene.rootNode.addChildNode(mainNode)
    }
    
    @IBAction func reset(_ sender: Any) {
        self.restartSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    private func registerGestureRecognizers(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.backgroundColor = UIColor.clear
    }

    @objc func tapped(recognizer: UIGestureRecognizer){
 
        let sceneViewTappedOn = recognizer.view as! SCNView
        let touchCoordinates = recognizer.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            
            let results = hitTest.first!
            let node = results.node
            print(node.name ?? "no node")
            if node.name == "Profile Pic Node"
            {
                if node.animationKeys.isEmpty
                {
                    self.animateNode(node: label1ARNode, pos: SCNVector3(0.45,-0.4,0.02))
                    self.animateNode(node: label2ARNode, pos: SCNVector3(0.45,0.4,0.02))
                    self.animateNode(node: label3ARNode, pos: SCNVector3(-0.45,-0.4,0.02))
                    self.animateNode(node: label4ARNode, pos:SCNVector3(-0.45,0.4,0.02))
                    
//                    self.mainNode.simdScale = simd_float3(0.5,0.5,0.5)
                }
            }
            else if node.name == "Label2 Node"
            {
                videoARNode.isHidden = false
                videoNode.play()
            }
            else if node.name == "Label1 Node"
            {
                webNode .isHidden = false
                webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.facebook.com")!))
            }
            else if node.name == "Label3 Node"
            {
                DispatchQueue.main.async {
                                let audioEngine = AVAudioEngine()
                                let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
                                let request = SFSpeechAudioBufferRecognitionRequest()
                                let recordingFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
                                audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, _) in
                                    request.append(buffer)
                                })
                                audioEngine.prepare()
                                do{
                                    try audioEngine.start()
                                }catch{
                                    return print(error)
                                }
                    
                               let _ = speechRecognizer?.recognitionTask(with: request, resultHandler: {result, error in
                                    if let result = result   {
                                        let bestString = result.bestTranscription.formattedString
                                                print(bestString)
                                    }
                                    else if let error = error{
                                        
                                        print(error)
                                    }
                                })
                                    }
//                UIApplication.shared.open(URL.init(string: "tel://9743993385")!, options: [:], completionHandler: { (success) in
//                })
            }
            else if node.name == "Label4 Node"
            {
                UIApplication.shared.open(URL.init(string: "mailto:")!, options: [:], completionHandler: { (success) in
                })
            }
        }
    }
    
    func animateNode(node: SCNNode, pos: SCNVector3)
    {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = pos
        spin.duration = 0.3
        spin.repeatCount = 1
        spin.autoreverses = false
        node.addAnimation(spin, forKey: "postion")
        node.position = pos
    }
    func restartSession() {
        videoNode.pause()
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
//    func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
//        let referenceNodeTransform = matrix_float4x4(referenceNode.transform)
//        
//        // Setup a translation matrix with the desired position
//        var translationMatrix = matrix_identity_float4x4
//        translationMatrix.columns.3.x = position.x
//        translationMatrix.columns.3.y = position.y
//        translationMatrix.columns.3.z = position.z
//        
//        // Combine the configured translation matrix with the referenceNode's transform to get the desired position AND orientation
//        let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
//        node.transform = SCNMatrix4(updatedTransform)
//    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
