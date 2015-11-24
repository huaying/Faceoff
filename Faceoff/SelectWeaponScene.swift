//
//  SelectWeaponScene.swift
//  Select_Weapons
//
//  Created by Shao-Hsuan Liang on 9/26/15.
//  Copyright (c) 2015 Liang. All rights reserved.
//


//need constrant confirm button

import SpriteKit

class SelectWeaponScene: SKScene {
    
    let background: SKNode! = SKSpriteNode(imageNamed: "spaceship3.jpg")
    var WEAPONS:[SKNode] = [SKNode]()
    var forward_btn: SKNode! = nil
    var back_btn: SKNode! = nil
    //var select_btn: SKNode! = nil
    var confirm_btn: SKNode! = nil
    
    var box1: SKNode! = nil
    var box2: SKNode! = nil
    var box3: SKNode! = nil
    
    var select_count: Int = 0;
    
    var Weapon1: SKSpriteNode! = nil
    var Weapon2: SKSpriteNode! = nil
    var Weapon3: SKSpriteNode! = nil
    
    var weaponArray:[String?] = [nil,nil,nil]
    
    var count: Int = 0;
    var did_tap: Bool = false;

    
    var did_shrink: NSInteger = 0;
    var arrayOfStrings: [String] = Constants.Weapon.Sets
    var arrayOfDescription: [String] = Constants.Weapon.SetsDescription
    
    
    var descrioptionLable: SKLabelNode! = nil
    
    var Img: UIImage! = nil
    
    override func didMoveToView(view: SKView) {
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -100
        background.setScale(0.8)
        addChild(background)
        
        descrioptionLable = SKLabelNode (fontNamed: "Chalkduster")
        descrioptionLable.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)*0.25)
        descrioptionLable.fontSize = 20
        addChild(descrioptionLable)
        
        forward_btn = SKSpriteNode(imageNamed:"Forward")
        forward_btn.position = CGPoint(x:CGRectGetMaxX(self.frame)-CGFloat(50.0), y:CGRectGetMidY(self.frame))
        forward_btn.name = "forward_btn"
        forward_btn.zPosition = 1.0
        
        back_btn = SKSpriteNode(imageNamed:"Back")
        back_btn.position = CGPoint(x:CGRectGetMinX(self.frame)+CGFloat(50.0), y:CGRectGetMidY(self.frame))
        back_btn.name = "back_btn"
        back_btn.zPosition = 1.0
        
        box1 = SKSpriteNode(imageNamed:"weapon_box")
        box1.xScale = 0.45
        box1.yScale = 0.45
        box1.position = CGPoint(x:CGRectGetMidX(self.frame)-120, y:CGRectGetMaxY(self.frame)*0.85)
        box1.name = "box1"
        box1.zPosition = 1.0
        
        box2 = SKSpriteNode(imageNamed:"weapon_box")
        box2.xScale = 0.45
        box2.yScale = 0.45
        box2.position = CGPoint(x:CGRectGetMidX(self.frame)+0, y:CGRectGetMaxY(self.frame)*0.85)
        box2.name = "box2"
        box2.zPosition = 1.0
        
        box3 = SKSpriteNode(imageNamed:"weapon_box")
        box3.xScale = 0.45
        box3.yScale = 0.45
        box3.position = CGPoint(x:CGRectGetMidX(self.frame)+120, y:CGRectGetMaxY(self.frame)*0.85)
        box3.name = "box3"
        box3.zPosition = 1.0
        
        
        Weapon1 = SKSpriteNode(imageNamed:"weapon_blank")
        Weapon1.xScale = 0.35
        Weapon1.yScale = 0.35
        Weapon1.position = CGPoint(x:CGRectGetMidX(self.frame)-120, y:CGRectGetMaxY(self.frame)*0.85)
        Weapon1.name = "weapon1"
        Weapon1.zPosition = 1.0
        
        Weapon2 = SKSpriteNode(imageNamed:"weapon_blank")
        Weapon2.xScale = 0.35
        Weapon2.yScale = 0.35
        Weapon2.position = CGPoint(x:CGRectGetMidX(self.frame)+0, y:CGRectGetMaxY(self.frame)*0.85)
        Weapon2.name = "weapon2"
        Weapon2.zPosition = 1.0
        
        Weapon3 = SKSpriteNode(imageNamed:"weapon_blank")
        Weapon3.xScale = 0.35
        Weapon3.yScale = 0.35
        Weapon3.position = CGPoint(x:CGRectGetMidX(self.frame)+120, y:CGRectGetMaxY(self.frame)*0.85)
        Weapon3.name = "weapon3"
        Weapon3.zPosition = 1.0
        
        confirm_btn = SKSpriteNode(imageNamed:"Confirm")
        confirm_btn.xScale = 0.5
        confirm_btn.yScale = 0.5
        confirm_btn.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)*0.1)
        confirm_btn.name = "confirm_btn"
        confirm_btn.zPosition = 1.0
        
        self.addChild(forward_btn)
        self.addChild(back_btn)
        
        self.addChild(box1)
        self.addChild(box2)
        self.addChild(box3)
        
        self.addChild(Weapon1)
        self.addChild(Weapon2)
        self.addChild(Weapon3)
        
        self.addChild(confirm_btn)
        
        for var i=0; i<arrayOfStrings.count; i++ {
            var weapon: SKNode! = nil
            let Te = SKTexture (imageNamed:arrayOfStrings[i])
            weapon = SKSpriteNode(texture:Te, size: CGSize(width: 80, height: 80))
            
            //just for initial scene
            if(i==0){
                weapon.xScale = 0.6
                weapon.yScale = 0.6
            }
            else{
                weapon.xScale = 0.35
                weapon.yScale = 0.35
            }
            
            weapon.position = CGPoint(x:CGRectGetMidX(self.frame)+(CGFloat(i)*120), y:CGRectGetMidY(self.frame));
            weapon.name = arrayOfStrings[i]
            
            WEAPONS.append(weapon)
            self.addChild(weapon)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if forward_btn.containsPoint(location) {
                if(!did_tap){
                    count++;
                    for eachChild in WEAPONS {
                        if(count < arrayOfStrings.count){
                            if(eachChild.name==arrayOfStrings[count]){
                                enlarge_animation(eachChild, RorL:0, distance: 120, duration:0.5)
                            }else{
                                shrink_animation(eachChild, RorL:0, distance: 120, duration:0.5)
                            }
                        }
                        else{
                            scrollToFirst(eachChild, RorL:0, distance: CGFloat(count-1)*120, duration:0.5)
                            if(eachChild.name == arrayOfStrings.first!){
                                let enlarge = SKAction.scaleTo(1.5, duration:0.5)
                                eachChild.runAction(enlarge)
                            }
                            else if(eachChild.name == arrayOfStrings.last!){
                                let shrink = SKAction.scaleTo(0.5, duration:0.5)
                                eachChild.runAction(shrink)
                            }
                        }
                    }
                    if(count >= arrayOfStrings.count) {
                        count = 0;
                    }
                }
                did_tap = true;
            }
            if back_btn.containsPoint(location) {
                if(!did_tap){
                    count--;
                    for eachChild in WEAPONS {
                        if(count >= 0){
                            if(eachChild.name==arrayOfStrings[count]){
                                enlarge_animation(eachChild, RorL:1, distance: 120, duration:0.5)
                            }
                            else {
                                shrink_animation(eachChild, RorL:1, distance: 120, duration:0.5)
                            }
                        }
                        else{
                            scrollToFirst(eachChild, RorL:1, distance: CGFloat(arrayOfStrings.count-1)*120, duration:0.5)
                            if(eachChild.name == arrayOfStrings.last!){
                                let enlarge = SKAction.scaleTo(1.5, duration:0.5)
                                eachChild.runAction(enlarge)
                            }
                            if(eachChild.name == arrayOfStrings.first!){
                                let shrink = SKAction.scaleTo(0.5, duration:0.5)
                                eachChild.runAction(shrink)
                            }
                        }
                    }
                    if(count < 0) {
                        count = arrayOfStrings.count-1;
                    }
                }
                did_tap = true;
            }
            
            if confirm_btn.containsPoint(location) {
                for weapon in weaponArray {
                    if weapon == nil {
                        return
                    }
                }
                let nextScene = GameScene2(size: scene!.size)
                nextScene.scaleMode = SKSceneScaleMode.ResizeFill
                nextScene.weaponManager.candidateWeaponTypes = weaponArray
                
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
                
                removeAllChildren()
                
//                nextScene.userData = NSMutableDictionary()
//                let stringRepresentation = weaponArray.joinWithSeparator("-")
//                nextScene.userData?.setObject(stringRepresentation, forKey: "Ray")
                scene?.view?.presentScene(nextScene, transition: transition)
            }
            
            if(self.nodeAtPoint(location).name != nil && WEAPONS.contains(self.nodeAtPoint(location))){
                let name:String = self.nodeAtPoint(location).name!
                let nameOfIndex = arrayOfStrings.indexOf(name)!
                for eachChild in WEAPONS {
                    if(eachChild.name == name){
                        
                        let move_dis:CGFloat = CGFloat(abs(nameOfIndex-count))*120
                        if(nameOfIndex==count){}
                        else if(nameOfIndex>count){
                            enlarge_animation(eachChild, RorL:0, distance: move_dis, duration:0.5)
                        }
                        else{
                            enlarge_animation(eachChild, RorL:1, distance: move_dis, duration:0.5)
                        }
                        
                        descrioptionLable.text = arrayOfDescription[count]
                        
                        
                        switch(select_count){
                        case 0:
                            Weapon1.texture = SKTexture(imageNamed: name)
                            break
                        case 1:
                            Weapon2.texture = SKTexture(imageNamed: name)
                            break
                        case 2:
                            Weapon3.texture = SKTexture(imageNamed: name)
                            break
                        default:
                            break
                        }
                        
                        weaponArray[select_count] = eachChild.name!
                        select_count = (++select_count) % 3
                        
                    }else{
                        
                        let move_dis2:CGFloat = CGFloat(abs(nameOfIndex-count))*120
                        
                        if(nameOfIndex==count){}
                        else if(nameOfIndex>count){
                            shrink_animation(eachChild, RorL:0, distance: move_dis2, duration:0.5)
                        }
                        else{
                            shrink_animation(eachChild, RorL:1, distance: move_dis2, duration:0.5)
                        }
                    }
                }
                
                let add_count:Int = abs(nameOfIndex-count)
                
                if(nameOfIndex==count){
                }
                else if(nameOfIndex>count){
                    count += add_count
                }
                else{
                    count -= add_count
                }
                
            }
            
        }
    }
    
    func enlarge_animation(weapon: SKNode, RorL: Int, distance: CGFloat, duration: Double){
        
        let moveToRight = SKAction.moveTo(CGPointMake(weapon.position.x+distance,weapon.position.y), duration:duration)
        let moveToLeft = SKAction.moveTo(CGPointMake(weapon.position.x-distance,weapon.position.y), duration:duration)
        
        let enlarge = SKAction.scaleTo(1.5, duration:duration)
        
        weapon.runAction(enlarge);
        
        if(RorL==1){
            weapon.runAction(moveToRight, completion: {
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.did_tap = false;
                    
                }
                
            })
            
        }
        else{
            weapon.runAction(moveToLeft, completion: {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.did_tap = false;
                    
                }
            })
            
        }
        
    }
    func shrink_animation(weapon: SKNode,  RorL: CGFloat, distance: CGFloat, duration: Double){
        
        let moveToRight = SKAction.moveTo(CGPointMake(weapon.position.x+distance,weapon.position.y), duration:duration)
        let moveToLeft = SKAction.moveTo(CGPointMake(weapon.position.x-distance,weapon.position.y), duration:duration)
        
        let shrink = SKAction.scaleTo(0.5, duration:duration)
        
        weapon.runAction(shrink);
        
        if(RorL==1){
            weapon.runAction(moveToRight, completion: {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.did_tap = false;
                    
                }
            })
            
        }
        else{
            weapon.runAction(moveToLeft, completion: {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.did_tap = false;
                    
                }
            })
            
        }
        
        
    }
    func moveToFirst(weapon: SKNode, RorL: CGFloat, distance: CGFloat, duration: Double){
        
        
        let moveToLeft = SKAction.moveTo(CGPointMake(weapon.position.x-distance,weapon.position.y), duration:duration)
        let moveToRight = SKAction.moveTo(CGPointMake(weapon.position.x+distance,weapon.position.y), duration:duration)
        
        if(RorL==1){
            weapon.runAction(moveToLeft)
            weapon.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
            
        }
        else{
            weapon.runAction(moveToRight)
            weapon.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
            
        }
        
    }
    
    func scrollToFirst(weapon: SKNode, RorL: CGFloat, distance: CGFloat, duration: Double){
        
        let moveToLeft = SKAction.moveTo(CGPointMake(weapon.position.x-distance,weapon.position.y), duration:duration)
        let moveToRight = SKAction.moveTo(CGPointMake(weapon.position.x+distance,weapon.position.y), duration:duration)
        
        if(RorL == 1){
            weapon.runAction(moveToLeft, completion: {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.did_tap = false;
                    
                }
            })
            
        }
        else{
            weapon.runAction(moveToRight, completion: {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.did_tap = false;
                    
                }
                
            })
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
