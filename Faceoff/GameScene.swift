//
//  GameScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/20/15.
//  Copyright (c) 2015 huaying. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var btns: Array<SKSpriteNode>?
    var otherBtns: Array<SKSpriteNode>?
    var weapons: Array<SKSpriteNode>?
    var boxes = [SKSpriteNode]()
    var weaponsStringArray: [String] = ["Bomb", "Bow", "Grenade", "Katachi", "Cannon"]
    var selected_weapon: SKSpriteNode!
    var weapon1_ori_pos: CGPoint!
    var weapon2_ori_pos: CGPoint!
    var weapon3_ori_pos: CGPoint!

    var bgMusic:AVAudioPlayer = AVAudioPlayer()
    var gameOver = false
    var isBegin = false
    var isEnd = false
    var attackCount = 0
    var alertLight = false
    
    var selfArmedStat = false
    var OppArmedStat = false

    
    override func didMoveToView(view: SKView) {
        start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "losePeer:", name: "losePeerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveRemoteData:", name: "receivedRemoteDataNotification", object: nil)
    }
    func start() {
        loadBackground()
        loadHero()
        //loadButton()
        //loadGameOverLayer()
        
        gameOver = false
        
        if let index = scene!.userData?.valueForKey("Ray") as? String {
            print(index)
            
            let arr = index.componentsSeparatedByString("-")
            print(arr)
            loadWeapons(arr)
        }
    
    }
    func restart() {
        
        attackCount = 0
        isBegin = false
        isEnd = false
        //score = 0
        removeAllChildren()
        start()
    }
    
    //拿來放跳出來的東西 (武器, 道具)
    func addSprite(imageNamed: String, location: CGPoint, scale: CGFloat) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed:imageNamed)
        
        sprite.xScale = scale
        sprite.yScale = scale
        sprite.position = location
        
        //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        //sprite.runAction(SKAction.repeatActionForever(action))
        //sprite.zPosition = -1;
        self.addChild(sprite)
        return sprite
    }

    func losePeer(notification: NSNotification){
        
        /*
        for btn in otherBtns!{
            btn.removeFromParent()
        }
        */
        
        print("QQQQ")
        
    }

    func showAlertLight(){
        let light = SKLightNode();
        light.position = CGPoint(x: frame.midX, y: frame.midY)
        // light.falloff = 1
        // light.ambientColor = ambientColor
        light.lightColor = UIColor.redColor()
        light.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AlertAudioName.rawValue, waitForCompletion: false))
        addChild(light)
        
    }
    
    func attackedCrash(location: CGPoint){
        
        //should be rebuild
        var theCrash = ""
        if (attackCount % 2 == 0) {
            theCrash = "crush"
        }
        else {
            theCrash = "crush2"
        }
        //        else if (attackCount % 4 == 0){
        //            theCrash = "crush3"
        //        }
        //
        
        
        
        
        attackCount++
        //FaceoffScreenCrashEffectAudioName
        let sprite = SKSpriteNode(imageNamed: theCrash)
        sprite.xScale = 2
        sprite.yScale = 2
        sprite.position = location
        
        
        sprite.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.LittleBombName.rawValue, waitForCompletion: false))
        
        self.addChild(sprite)
        
    }

    func receiveRemoteData(notification: NSNotification){
        let receivedData = NSKeyedUnarchiver.unarchiveObjectWithData(notification.object as! NSData) as! Dictionary<String,AnyObject>
        
        if let location = receivedData["location"] as? NSValue{
            attackedCrash(location.CGPointValue())
        }
        
        /*
        if let index = receivedData["index"] as? Int{
            
            for btn in otherBtns! {
                btn.position.y = 450
            }
            if index != -1 {
                otherBtns![otherBtns!.count-1-index].position.y = 400
            }
        }
        */
        
        if let index = receivedData["didSelectWeapon"] as? Int{
            
            if index != -1 {
                OppArmedStat = true
                
                if(selfArmedStat && OppArmedStat){
                    
                    setWeapon(selected_weapon)
                }
            }
        }
        
        if (attackCount > 5){
            showAlertLight()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            //addSpaceship(location)
            //appDelegate.connector.sendData(["location": NSValue(CGPoint: location)])
            var n = true
            
            
            /*
            
            for (index,btn) in btns!.enumerate() {
                if btn.containsPoint(location){
                    appDelegate.connector.sendData(["index": index])
                    n = false
                    btn.position.y = 150
                }else{
                    btn.position.y = 100
                }
            }
            if n {
                appDelegate.connector.sendData(["index": Int(-1)])
            }
*/
            
            
            
            
            for (index,weapon) in weapons!.enumerate() {
                if weapon.containsPoint(location){
                    appDelegate.connector.sendData(["didSelectWeapon": index])
                    n = false
                    selfArmedStat = true
                    
                    weapon.alpha = 1.0
                    selected_weapon = weapon
                    boxGlowing(boxes, box_index: index)

                    
                    if(selfArmedStat == true && OppArmedStat == true){
                        print("Fight!")
                        
                        setWeapon(selected_weapon)
                        
                    }

                }
                else{
                    weapon.alpha = 0.2
                }
            }
            if n {
                boxStopGlowing(boxes)
                appDelegate.connector.sendData(["didSelectWeapon": Int(-1)])
            }
            
            /*
            //let touchLocation = touch.locationInNode(self)
            if location.y < frame.midY {
                oneAttackCircle()
            } else {
                oneDefenseCircle()
            }
            */

        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    /* 準備使用 */
    func oneAttackCircle(){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        
        Circle.position = CGPointMake(frame.midX, frame.midY / 10)  //Middle of Screen
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
        let spiral = SKAction.spiral(startRadius: 50,
            endRadius: 0,
            centerPoint: Circle.position,
            duration: 1.0,
            type: 0)
        Circle.runAction(spiral)
        //Audio Effect
        Circle.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AttackAudioName.rawValue, waitForCompletion: false))
        
        self.addChild(Circle)
    }
    
    func oneDefenseCircle(){
        let Circle = SKShapeNode(circleOfRadius: 50 )
        
        Circle.position = CGPointMake(frame.midX, frame.midY * 9 / 10)  //Middle of Screen
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
    
        let spiral = SKAction.spiral(startRadius: 20,
            endRadius: 0,
            centerPoint: Circle.position,
            duration: 1.0,
            type: 1)
        Circle.runAction(spiral)
        //Audio Effect
        Circle.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.AttackedAudioName.rawValue, waitForCompletion: false))
        self.addChild(Circle)
    }
    
    
}

private extension GameScene {
    func loadBackground() {
        guard let _ = childNodeWithName("background") as! SKSpriteNode? else {
            let texture = SKTexture(image: UIImage(named: "background3.jpg")!)
            let node = SKSpriteNode(texture: texture)
            node.xScale = 1.5
            node.yScale = 1.5
            node.position = CGPoint(x: frame.midX, y: frame.midY)
            node.zPosition = FaceoffGameSceneZposition.BackgroundZposition.rawValue
            //    self.physicsWorld.gravity = CGVectorMake(0, gravity)
            
            addChild(node)
            return
        }
    }
    
    // Just put a rival for demo
    func loadHero() {
        let hero = SKSpriteNode(imageNamed: "cute")
        hero.name = FaceoffGameSceneChildName.HeroName.rawValue
        hero.position = CGPoint(x: frame.midX * 1.5, y: frame.midY * 1.5)
        hero.xScale = 0.25
        hero.yScale = 0.25
        hero.zPosition = FaceoffGameSceneZposition.HeroZposition.rawValue
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 18))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.allowsRotation = false
        
        addChild(hero)
    }
    
    func loadButton() {
        btns = [
            addSprite("Destroyer", location: CGPoint(x: 80.0,y: 100.0),scale: 0.46),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 100.0),scale: 0.7),
            addSprite("Bro2", location: CGPoint(x: 320.0,y: 100.0),scale: 0.7)
        ]
        otherBtns = [
            addSprite("Bro2", location: CGPoint(x: 80.0,y: 450.0),scale: 0.7),
            addSprite("Bro", location: CGPoint(x: 200.0,y: 450.0),scale: 0.7),
            addSprite("Destroyer", location: CGPoint(x: 320.0,y: 450.0),scale: 0.46)
        ]
    }
    
    func loadWeapons(imageName:[String]){
        
    
        boxes = [
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 195.0),scale: 0.4),
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 130.0),scale: 0.4),
            addSprite("weapon_box", location: CGPoint(x: scene!.size.width-40,y: 65.0),scale: 0.4)
        ]
        
        weapons = [
            addSprite(weaponsStringArray[Int(imageName[0])!], location: CGPoint(x: scene!.size.width-40,y: 195.0),scale: 0.5),
            addSprite(weaponsStringArray[Int(imageName[1])!], location: CGPoint(x: scene!.size.width-40,y: 130.0),scale: 0.5),
            addSprite(weaponsStringArray[Int(imageName[2])!], location: CGPoint(x: scene!.size.width-40,y: 65.0),scale: 0.5),

        ]
        

        
    }
    func setWeapon(weapon:SKSpriteNode){
                
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.addQuadCurveToPoint(CGPoint(x: -200, y: 0), controlPoint: CGPoint(x: -100, y: 200))
        
        
        let rotate = SKAction.repeatAction(SKAction.rotateByAngle(CGFloat(M_PI), duration:0.1), count: 10)
        let route = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: false, duration: 1.0)

        let action_array:Array<SKAction> = [route, rotate]
        let combine = SKAction.group(action_array)
        
        weapon1_ori_pos = weapon.position
        
        weapon.runAction(combine)
        
        
        let Ready = SKSpriteNode(imageNamed:"Ready")
        Ready.xScale = 0.5
        Ready.yScale = 0.5
        Ready.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(Ready)

        let ready_action_array:Array<SKAction> = [SKAction.fadeInWithDuration(1.0),
            SKAction.scaleTo(2.0, duration: 2.0),SKAction.fadeOutWithDuration(2.0)]
        let ready_action_combine = SKAction.group(ready_action_array)

        
        Ready.runAction(ready_action_combine) { () -> Void in
            
            let fight_action_array:Array<SKAction> = [SKAction.fadeInWithDuration(1.0),
                SKAction.scaleTo(10.0, duration: 2.0),
                SKAction.fadeOutWithDuration(1.0)]
            let action_combine = SKAction.group(fight_action_array)
            
            let Fight = SKSpriteNode(imageNamed:"Fight")
            Fight.xScale = 0.5
            Fight.yScale = 0.5
            Fight.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            self.addChild(Fight)
            
            Fight.runAction(action_combine) { () -> Void in
                
                //weapon.position = self.weapon1_ori_pos
                weapon.removeFromParent()
                self.selfArmedStat = false;
                self.OppArmedStat = false;
                self.boxStopGlowing(self.boxes)
            }
        }

        
        /*
        let myLabel = SKLabelNode(fontNamed: "Arial")
        myLabel.text = "Ready"
        myLabel.fontSize = 50
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        addChild(myLabel)
        */

    }

    func boxGlowing(boxes:[SKSpriteNode],box_index:Int){
        
        for (index, box) in boxes.enumerate() {
            
            if(index==box_index){
                box.texture = SKTexture(imageNamed: "box_glow")
            }
            else{
                box.texture = SKTexture(imageNamed: "weapon_box")
            }
        }
    }
    
    func boxStopGlowing(boxes:[SKSpriteNode]){
        for box in boxes {
            box.texture = SKTexture(imageNamed: "weapon_box")
        }

    }
    
    func showBeginText(){
        
    }
    
}