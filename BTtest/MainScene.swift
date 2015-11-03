//
//  MainScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/26/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import UIKit
import GLKit
import SpriteKit



class MainScene: SKScene,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var photoView: UIImageView!
    var layerView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    let logo = UIImage(named: "headdd")!
    let mask = CALayer()
    
    var finalImg : UIImage!
    var imgForPlayer : UIImage!
    
    var btn:UIButton = UIButton()
    
    var 製造角色按鈕: SKNode! = nil
    var 進入遊戲按鈕: SKNode! = nil
    var testImage: SKNode! = nil
    let background: SKNode! = SKSpriteNode(imageNamed: "spaceship1.jpg")
    
    override func didMoveToView(view: SKView) {
        
        testImage = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 200, height: 40))
        testImage.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)+CGFloat(75.0))
        addChild(testImage)

        let testtext = SKLabelNode(fontNamed:"Chalkduster")
        testtext.text = "Test Image";
        testtext.fontSize = 14;
        testtext.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        testImage.addChild(testtext)
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.xScale = 0.75
        background.yScale = 0.75
        background.zPosition = -100
        addChild(background)
        
        
  
        製造角色按鈕 = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 200, height: 40))
        製造角色按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)+CGFloat(25.0))
        addChild(製造角色按鈕)
        let 製造角色文字 = SKLabelNode(fontNamed:"Chalkduster")
        製造角色文字.text = "Create a character";
        製造角色文字.fontSize = 14;
        製造角色文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        製造角色按鈕.addChild(製造角色文字)

        
        
        進入遊戲按鈕 = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 200, height: 40))
        進入遊戲按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)-CGFloat(25.0))
        addChild(進入遊戲按鈕)
        
        let 進入遊戲文字 = SKLabelNode(fontNamed:"Chalkduster")
        進入遊戲文字.text = "Play";
        進入遊戲文字.fontSize = 14;
        進入遊戲文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        
        進入遊戲按鈕.addChild(進入遊戲文字)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInNode(self){
            if 製造角色按鈕.containsPoint(location){
                製造角色按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
              
                takePictures()
                print("fuckthecamara")
                
            }
                
            
            else if 進入遊戲按鈕.containsPoint(location){
                進入遊戲按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
                
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
                removeAllChildren()
                let nextScene = PlayModeScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
            else if testImage.containsPoint(location){
                testImage.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
              print("test Image")
//                let Texture = SKTexture(image: finalImg)
//                let TransNode = SKSpriteNode(texture:Texture)
//                TransNode.position = CGPoint(x:CGRectGetMidX(self.frame)+CGFloat(50.0),y:CGRectGetMidY(self.frame))
//                addChild(TransNode)
//                
            }

            
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        layerView.image = UIImage(named: ("player"))
        imagePicker.cameraOverlayView = layerView
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        photoView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //add layer to imageView
        mask.contents = logo.CGImage
        mask.frame = photoView.layer.bounds
        //photoView.layer.masksToBounds = true
        photoView.layer.mask = mask
        
        var layer1: CALayer = CALayer()
        var layer2: CALayer = CALayer()
        
        layer1 = photoView.layer
        UIGraphicsBeginImageContext(photoView.bounds.size)
        layer1.renderInContext(UIGraphicsGetCurrentContext()!)
        finalImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        layerView.image = UIImage(named: ("player"))
        layer2 = layerView.layer
        layer2.frame.size = photoView.frame.size
        UIGraphicsBeginImageContext(photoView.bounds.size)
        layer1.renderInContext(UIGraphicsGetCurrentContext()!)
        layer2.renderInContext(UIGraphicsGetCurrentContext()!)
        imgForPlayer = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        photoView.image = imgForPlayer
        photoView.layer.mask = nil
        
        //imageForPlayer 是头像加宇航服，UIImage格式
        //finalImg 是只有图像，UIImage格式
        
        
    }

    func takePictures(){
    //use camera
    layerView = UIImageView()
    imagePicker =  UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .Camera //UIImagePickerControllerSourceTypeCamera
    imagePicker.allowsEditing = true
    imagePicker.showsCameraControls = true;
    
    //add astronaut layer to camera
    layerView.image = UIImage(named: ("astro"))
    layerView.frame.size.width = self.view!.frame.size.width
    layerView.frame.size.height = self.view!.frame.size.height
    
    
    imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
    imagePicker.cameraOverlayView = layerView //3.0以后可以直接设置cameraOverlayView为overlay
    
    let  vc = self.view?.window?.rootViewController       //.window?.rootViewController
    vc!.presentViewController(imagePicker, animated: true, completion:nil)
    //presentViewController(imagePicker, animated: true , completion: nil)
    //photoView.getMirror()
    }

}