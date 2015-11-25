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

let enemyCharacterLoader = EnemyCharacterLoader()

class BuildConnectionScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var scrollnode = ScrollNode()
    var peers = [CBPeripheral]()
    var peerName = [String]()
    
    var peerToConnect: CBPeripheral?
    var centralManager: CBCentralManager!
    
    var statusnode = SKLabelNode(fontNamed: "Chalkduster")
    
    let background: SKNode! = SKSpriteNode(imageNamed: "spaceship4.jpg")

    var 返回按鈕: SKNode! = nil
    var 遊戲按鈕: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scene?.size = frame.size
        background.setScale(0.5)
        background.zPosition = -100
        
        addChild(background)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
        
        // Start the Bluetooth advertise process
        btAdvertiseSharedInstance
        
        // Start the Bluetooth discovery process
        btDiscoverySharedInstance
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("allSet:"), name: "allSet", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getCentral:"), name: "getCentral", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getPeripheral:"), name: "getPeripheral", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getPeripheralName:"), name: "getPeripheralName", object: nil)
        
        
        
        返回按鈕 = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 50, height: 30))
        返回按鈕.position = CGPoint(x:CGRectGetMinX(self.frame)+40,y:CGRectGetMinY(self.frame)+CGFloat(30.0))
        addChild(返回按鈕)
        
        let 返回文字 = SKLabelNode(fontNamed:"Chalkduster")
        返回文字.text = "Back";
        返回文字.fontSize = 14;
        返回文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        返回按鈕.addChild(返回文字)
        
        
        遊戲按鈕 = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 50, height: 30))
        遊戲按鈕.position = CGPoint(x:CGRectGetMaxX(self.frame)-40,y:CGRectGetMinY(self.frame)+CGFloat(30.0))
        addChild(遊戲按鈕)
        
        let 遊戲文字 = SKLabelNode(fontNamed:"Chalkduster")
        遊戲文字.text = "Go!";
        遊戲文字.fontSize = 14;
        遊戲文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        遊戲按鈕.addChild(遊戲文字)
        
        
        
        
        
        addChild(scrollnode)
        
        
        statusnode.fontSize = 30
        statusnode.position = CGPointMake(frame.midX, frame.midY-100)
        statusnode.text = UIDevice.currentDevice().name
        addChild(statusnode)
        scrollnode.setScrollingView(view)
        
        //updateScene()
        
    }
    
    
    func allSet(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let deviceName: String = userInfo["peripheralName"] as! String
        
        
        for (index,peer) in peers.enumerate() {
            
            
            print(deviceName, peer.name)
            
            if(index < peerName.count && peerName[index] == deviceName ){
               
                print(centralManager.description)
                
                btDiscoverySharedInstance.connectToPeripheral(centralManager, peripheral: peers[index])
                
                let nextScene = SelectWeaponScene(size: scene!.size)
                enemyCharacterLoader.preload()
                
                transitionForNextScene(nextScene)
                
                centralManager.stopScan()
                
            }
            
        }
    }
    
    /*
    func updateScene(){
    // peers = connector.getPeers()
    if peers != nil {
    for (i,peer) in peers!.enumerate() {
    let peerNode = SKLabelNode()
    peerNode.text = peer.displayName;
    peerNode.fontSize = 20;
    peerNode.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGFloat(i*40)+50)
    scrollnode.addChild(peerNode)
    }
    }
    }
    */
    
    func statusLabel(statusName: String) -> SKLabelNode{
        
        statusnode.text = statusName
        
        return statusnode
    }
    
    func getCentral(notification: NSNotification){
        
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        centralManager = userInfo["central"] as! CBCentralManager
        
        print("GetCentral!!!")
        
    }
    
    func getPeripheral(notification: NSNotification){
        
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        peers = userInfo["peripheral"] as! [CBPeripheral]
        
        for(index, peripheral) in peers.enumerate(){
            
            print(peripheral.description, "~~~\n")
            let peerNode = SKLabelNode()
            peerNode.text = peripheral.name;
            peerNode.fontSize = 20;
            peerNode.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGFloat(index * 40))
            //scrollnode.addChild(peerNode)
            
            
            // print("Item \(index + 1): \(value)")
            
        }
        
    }
    
    func getPeripheralName(notification: NSNotification){
        
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        peerName = userInfo["peripheralName"] as! [String]
        
        for(index, name) in peerName.enumerate(){
            
            print(name, "~~~\n")
            let peerNode = SKLabelNode()
            peerNode.text = name;
            peerNode.fontSize = 20;
            peerNode.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGFloat(index * 40))
            scrollnode.addChild(peerNode)
            
            
            // print("Item \(index + 1): \(value)")
            
        }
        
    }
    
    /*
    func getPeripheral(notification: NSNotification){
    
    let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
    let string_point: String = userInfo["name"] as! String
    
    let fullNameArr = string_point.characters.split {$0 == " "}.map { String($0) }
    
    for (index, value) in fullNameArr.enumerate() {
    
    let peerNode = SKLabelNode()
    peerNode.text = value;
    peerNode.fontSize = 20;
    peerNode.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGFloat(index * 40)+50)
    scrollnode.addChild(peerNode)
    
    print("Item \(index + 1): \(value)")
    }
    
    statusnode.removeFromParent()
    print("foundPeer",string_point)
    }
    */
    
    
    func foundPeer(notification: NSNotification){
        //updateScene()
        
        //statusLabel("Found Peer")
        
        print("foundPeer",peers)
    }
    func losePeer(notification: NSNotification){
        //updateScene()
        
        statusLabel("Lost Peer")
        
        print("losePeer",peers)
        
    }
    
    func invited(notification: NSNotification){
        //updateScene()
        statusLabel("Invited!")
        
    }
    
    
    func connected(notification: NSNotification){
        print("connected")
        
        statusLabel("Connected")
        
        transitionForNextScene(SelectWeaponScene(size: scene!.size))
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInNode(scrollnode){
            let peerNodes = scrollnode.children
            for peerNode in peerNodes{
                if peerNode.containsPoint(location){
                    for peer in peers {
                        
                        btDiscoverySharedInstance.connectToPeripheral(centralManager, peripheral: peer)
                        
                        peerToConnect = peer
                        
                        print(peerToConnect?.name)
                        //statusLabel("Invite!")
                        
                    }
                }
            }
        }
        
        if let location = touches.first?.locationInNode(self){
            if 返回按鈕.containsPoint(location){
                返回按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
                let nextScene = MainScene(size: scene!.size)
                transitionForNextScene(nextScene)
            }
            
        }
        
        
        if let location = touches.first?.locationInNode(self){
            if 遊戲按鈕.containsPoint(location){
                //遊戲按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
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
    
    func connectionChanged(notification: NSNotification) {
        // Connection status changed. Indicate on GUI.
        let userInfo = notification.userInfo as! [String: Bool]
        
        dispatch_async(dispatch_get_main_queue(), {
            // Set image based on connection status
            if let isConnected: Bool = userInfo["isConnected"] {
                if isConnected {
                    
                    
                    let tit = NSLocalizedString("Alert", comment: "")
                    let msg = NSLocalizedString("Received from Central!", comment: "")
                    let alert:UIAlertView = UIAlertView()
                    alert.title = tit
                    alert.message = msg
                    alert.delegate = self
                    alert.addButtonWithTitle("OK")
                    alert.addButtonWithTitle("Cancel")
                    //alert.show()
                    
                    print("connect!")
                    
                    if self.peerToConnect != nil{
                        
                        btDiscoverySharedInstance.bleService?.writeDeviceName(UIDevice.currentDevice().name)
                        
                        //btDiscoverySharedInstance.bleService?.writeDeviceUUID((UIDevice.currentDevice().identifierForVendor?.UUIDString)!)
                        
                        self.peerToConnect = nil
                        
                        
                        let nextScene = SelectWeaponScene(size: self.scene!.size)
                           // nextScene.readyToReceiveImage()
                        
                        enemyCharacterLoader.preload()
                        
                        self.transitionForNextScene(nextScene)
                    }
                    
                    
                    
                    
                } else {
                    
                    let tit = NSLocalizedString("Alert", comment: "")
                    let msg = NSLocalizedString("Not Connected!", comment: "")
                    let alert:UIAlertView = UIAlertView()
                    alert.title = tit
                    alert.message = msg
                    alert.delegate = self
                    alert.addButtonWithTitle("OK")
                    alert.addButtonWithTitle("Cancel")
                    //alert.show()
                    
                    //self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Disconnected")
                }
            }
        });
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}