//
//  BuildConnectionScene.swift
//  BTtest
//
//  Created by Sunny Chiu on 10/27/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import CoreBluetooth

import SpriteKit
import MultipeerConnectivity



class BuildConnectionScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var peersName = [String]()
    
    var statusnode: SKLabelNode! = nil
    let background: SKNode! = nil
    var playerListNode: SKSpriteNode! = nil
    var scrollNode = ScrollNode()
    var connectLock = false
    
    var 返回按鈕: SKNode! = nil
    var 遊戲按鈕: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        btAdvertiseSharedInstance = BTAdvertise();
        btDiscoverySharedInstance = BTDiscovery();
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("allSet:"), name: "allSet", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("foundPeer:"), name: "foundPeer", object: nil)
        
        
        
        loadTestButton()
        loadBackground()
        loadBackButton()
        loadPlayerList()
        loadYourDeviceName()
    


    }
    func loadTestButton(){
        遊戲按鈕 = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 50, height: 30))
        遊戲按鈕.position = CGPoint(x:CGRectGetMaxX(self.frame)-40,y:CGRectGetMinY(self.frame)+CGFloat(30.0))
        addChild(遊戲按鈕)
        
        let 遊戲文字 = SKLabelNode(fontNamed:Constants.Font)
        遊戲文字.text = "Go!";
        遊戲文字.fontSize = 14;
        遊戲文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        遊戲按鈕.addChild(遊戲文字)
    }
    func loadBackground(){
        let texture = SKTexture(image: UIImage(named: Constants.BuildConnectionScene.Background)!)
        let background = SKSpriteNode(texture: texture, size: frame.size)
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = -10
        addChild(background)
        
    }
    func loadBackButton(){
        
        let texture = SKTexture(image: UIImage(named: Constants.BuildConnectionScene.BackButton)!)
        返回按鈕 = SKSpriteNode(texture: texture, size: CGSizeMake(CGFloat(Constants.Scene.BackButtonSizeWidth) ,CGFloat(Constants.Scene.BackButtonSizeHeight)))
        返回按鈕.position = CGPoint(x:返回按鈕.frame.width/2,y: 返回按鈕.frame.height/2)
        addChild(返回按鈕)
    }
    
    func loadPlayerList(){
        let image = UIImage(named: Constants.BuildConnectionScene.PlayerList)!
        let texture = SKTexture(image: image)
        let cropNode = SKCropNode()
        playerListNode = SKSpriteNode(texture: texture, size: CGSizeMake(image.size.width * 0.33,image.size.height * 0.33))
        
        scrollNode.setScrollingView(self.view!)
        playerListNode.addChild(scrollNode)

        let crop = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(playerListNode.size.width,playerListNode.size.height))
        
        cropNode.position = CGPoint(x:frame.midX,y: frame.midY)
        cropNode.maskNode = crop
        cropNode.addChild(playerListNode)
        addChild(cropNode)
    }
    func loadYourDeviceName(){
        statusnode = SKLabelNode(fontNamed: Constants.Font)
        statusnode.fontSize = 20
        statusnode.position = CGPointMake(frame.midX, frame.midY-120)
        statusnode.text = "You: "+UIDevice.currentDevice().name
        addChild(statusnode)
    }
    
    func allSet(notification: NSNotification) {
        
    NSNotificationCenter.defaultCenter().removeObserver(self)
        
        

        
        let nextScene = SelectWeaponScene(size: scene!.size)
        transitionForNextScene(nextScene)
        
    }
    
    
    func foundPeer(notification: NSNotification){
        
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        peersName = userInfo["peers"] as! [String]
        
        scrollNode.removeAllChildren()
        for(index, name) in peersName.enumerate(){
            
            let peerNode = SKLabelNode(fontNamed: Constants.Font)
            peerNode.text = name;
            peerNode.fontSize = 25;
            peerNode.position = CGPoint(x:0,y:CGFloat(index * 40))
            scrollNode.addChild(peerNode)
        }
        
    }
    
    func peerConnectDetect(touches: Set<UITouch>){
        if !connectLock {
            if let location = touches.first?.locationInNode(scrollNode){
                let peerNodes = scrollNode.children
                for peerNode in peerNodes{
                    if peerNode.containsPoint(location){
                        let labelNode = peerNode as! SKLabelNode
                        
                        for peerName in peersName {
                            if labelNode.text! == peerName{
                                connectLock = true
                                
                                btDiscoverySharedInstance.connect(peerName)
                                Tools.playSound(Constants.Audio.SelectOpponent, node: self)
                                //                            peerToConnect = peerName
                                break
                            }
                        }
                    }
                }
            }
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        peerConnectDetect(touches)
        
        if let location = touches.first?.locationInNode(self){
            if 返回按鈕.containsPoint(location){
                Tools.playSound(Constants.Audio.TransButton, node: self)
                let nextScene = PlayModeScene(size: scene!.size)
                transitionForNextScene(nextScene)
            }
            
        }
        
        
        if let location = touches.first?.locationInNode(self){
            if 遊戲按鈕.containsPoint(location){
                Tools.playSound(Constants.Audio.TransButton, node: self)
                let nextScene = SelectWeaponScene(size: scene!.size)
                transitionForNextScene(nextScene)
            }
        }
    }
    
    
    
    func transitionForNextScene(nextScene: SKScene){
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
        removeAllChildren()
        nextScene.scaleMode = .AspectFill
        scene?.view?.presentScene(nextScene, transition: transition)
    }
    
//    func connectionChanged(notification: NSNotification) {
//        // Connection status changed. Indicate on GUI.
//        let userInfo = notification.userInfo as! [String: Bool]
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            // Set image based on connection status
//            if let isConnected: Bool = userInfo["isConnected"] {
//                if isConnected {
//                    
//                    if self.peerToConnect != nil{
//                        
//                        btDiscoverySharedInstance.bleService?.writeDeviceName(UIDevice.currentDevice().name)
//                        
//                        self.peerToConnect = nil
//                        
//                        let nextScene = SelectWeaponScene(size: self.scene!.size)
//                        enemyCharacterLoader.preload()
//                        
//                        self.transitionForNextScene(nextScene)
//                    }
//                }
//            }
//        });
//    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
    
}