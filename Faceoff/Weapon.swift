//
//  Weapon.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/20/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

protocol WeaponDelegate {
    func decreaseHealth(value: CGFloat)
}

class Weapon: NSObject{
    
    var bullet: SKSpriteNode?
    var bulletStart: CGPoint?
    var bulletEnd: CGPoint?
    var bulletImageName: String?
    var firePreparingEmitter: SKEmitterNode!
    
    var sceneNode: SKScene!
    var delegate: WeaponDelegate?
    
    var isFirePreparing: Bool = false
    
    init(sceneNode :SKScene){
        self.sceneNode = sceneNode
    }
    
    func fire(){}
    func fireFromEnemy(fireInfo :[String]){}
    
    //Powered Fire
    func fire(preparingTime: NSTimeInterval?){}
    func effect(character:Character){}
    func firePreparingAction(){}
    func stopFirePreparingAction() {}
    func getDamage() -> Double { return 0 }
    func getManaUse() -> Double { return 0 }
    
    func getCharacter() -> SKSpriteNode {
        let characterName = Constants.GameScene.Character
        let character = sceneNode.childNodeWithName(characterName) as! SKSpriteNode
        return character
    }
}

class Bullet: Weapon {
    
    var damage: Double = 20.0
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.Bullet
    }
    
    override func fire(){
        super.fire()
        
        let character = getCharacter()
        let bulletPosition = CGPointMake(character.position.x, character.position.y + character.frame.height + 25)
        let bulletVector = CGVectorMake(0, (sceneNode!.size.height))
        fire(bulletPosition,vector: bulletVector)
        
        let normalizedX = 1 - (bulletPosition.x/sceneNode.size.width)
        btAdvertiseSharedInstance.update("fire-bullet",data: ["x":normalizedX.description])
    }
    
    override func fireFromEnemy(fireInfo: [String]) {
        
        if let normalizedX = Double(fireInfo[0]) {
            let x = CGFloat(normalizedX) * sceneNode.size.width
            let bulletPosition = CGPoint(x: CGFloat(x), y: sceneNode!.size.height)
            let bulletVector = CGVectorMake(0, -sceneNode!.size.height)
            fire(bulletPosition,vector: bulletVector,fromEnemy: true)
        }
        
    }
    
    func fire(fromPosition: CGPoint, vector: CGVector, fromEnemy: Bool = false){
        if let bulletImageName = bulletImageName {
            bullet = SKSpriteNode(imageNamed: bulletImageName)
            bullet!.xScale = 0.5
            bullet!.yScale = 0.5
            bullet!.position = fromPosition
            bullet!.name = Constants.GameScene.Fire
            PhysicsSetting.setupFire(bullet!)
            
            if fromEnemy {
                bullet!.yScale = -bullet!.yScale
                bullet!.name = Constants.GameScene.EnemyFire
                PhysicsSetting.setupEnemyFire(bullet!)
            }
            
            let bulletAction = SKAction.sequence([SKAction.moveBy(vector, duration: 1.0), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])

            bullet!.runAction(bulletAction)
            sceneNode.addChild(bullet!)
        }

    }
    override func getDamage() -> Double {
        return damage
    }
    
}

class Laser: Weapon {
    
    var damage: Double = 0
    var mana: Double = 1.5
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
    }
    override func fire(){
        super.fire()
        bullet!.xScale = 0.2
        bullet!.yScale = 0.2
    }
    
    //Powered Fire
    override func fire(preparingTime: NSTimeInterval?){
        stopFirePreparingAction()
        
        if let preparingTime = preparingTime{
            
            let laserWidth = 400.0
            var laserFinalWidth: Double!
            if preparingTime > 3.0 {
                laserFinalWidth = laserWidth
            }else{
                laserFinalWidth = laserWidth * preparingTime/3.0
            }
            
            let character = getCharacter()
            
            let bulletPosition = CGPoint(x: character.position.x, y: character.position.y + character.size.height/2 + sceneNode!.size.height/2 * 1.5)
            
            fire(bulletPosition,laserWidth: CGFloat(laserFinalWidth))
            
            let normalizedX = 1 - (bulletPosition.x/sceneNode.size.width)
            btAdvertiseSharedInstance.update("fire-laser",data: ["x":normalizedX.description,"laserWidth":laserFinalWidth.description])
        }
    }
    override func fireFromEnemy(fireInfo: [String]) {
        
        if let normalizedX = Double(fireInfo[0]) {
            let x = CGFloat(normalizedX) * sceneNode.size.width
            if let laserWidth = Double(fireInfo[1]) {
                
                let bulletPosition = CGPointMake(x, sceneNode!.frame.height/2)
                fire(bulletPosition,laserWidth: CGFloat(laserWidth),fromEnemy: true)
                
                damage = laserWidth/40
            }
        }
        
    }

    
    func fire(fromPosition: CGPoint, laserWidth: CGFloat, fromEnemy: Bool = false){
        
        bullet = SKSpriteNode(imageNamed: "a01")
        
        bullet!.size.width = CGFloat(laserWidth)
        bullet!.size.height = CGFloat(sceneNode!.size.height * 1.5)
        bullet!.name = Constants.GameScene.PoweredFire
        PhysicsSetting.setupFire(bullet!)
        
        if fromEnemy {
            bullet!.yScale = -bullet!.yScale
            bullet!.name = Constants.GameScene.EnemyPoweredFire
            PhysicsSetting.setupEnemyFire(bullet!)
        }
        
        bullet!.position = fromPosition
        
        let ebAtlas = SKTextureAtlas(named: "animation")
        var energyBlastAnim:[SKTexture] = []
        
        for index in 1...ebAtlas.textureNames.count {
            let imgName = String(format: "a%02d", index)
            energyBlastAnim += [ebAtlas.textureNamed(imgName)]
        }
        let animation = SKAction.animateWithTextures(energyBlastAnim, timePerFrame: 0.1)
        bullet!.runAction(animation, completion: {
            self.bullet!.removeFromParent()
        })
        
        sceneNode.addChild(bullet!)
        
    }
    
    
    override func firePreparingAction(){
        
        isFirePreparing = true
        
        let character = getCharacter()
        
        character.runAction(SKAction.waitForDuration(0.3), completion: {
            if self.isFirePreparing {
                
                self.stopFirePreparingAction()
                
                let sksPath = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
                
                self.firePreparingEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(sksPath!) as! SKEmitterNode
                self.firePreparingEmitter!.zPosition = 0;
                self.firePreparingEmitter!.alpha = 0.6
                self.firePreparingEmitter!.particleBirthRate = 500
                
                character.addChild(self.firePreparingEmitter!)
            }
        })
    }

    override func stopFirePreparingAction() {
        isFirePreparing = false
        firePreparingEmitter?.removeFromParent()
    }
    
    override func getDamage() -> Double {
        return damage
    }
    override func getManaUse() -> Double { return mana }
}

class BounsBullet: Weapon{
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.BonusBullet
    }
    override func fire(){
        super.fire()
        bullet!.xScale = 0.2
        bullet!.yScale = 0.2
    }
}

class IceBullet: Weapon {
    
    var frozenEffectImg: SKSpriteNode!
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.Bullet
    }
    
    override func effect(character:Character){
        super.effect(character)
        frozenEffectImg = SKSpriteNode(imageNamed: "freeze")
        frozenEffectImg.xScale = 1
        frozenEffectImg.yScale = 1
        frozenEffectImg.zPosition = -2
        
        character.runAction(SKAction.fadeAlphaBy((0.7 / (500 / 25.0)), duration: 1))
        frozenEffectImg.runAction(SKAction.fadeAlphaBy(-(1.0 / (500 / 25.0)), duration: 1))
        frozenEffectImg.runAction(SKAction.scaleBy(1.0 - (0.5 / (500 / 25.0)), duration: 1))
        
        character.addChild(frozenEffectImg)
        
        let frozenTimer = NSTimer(timeInterval: 0.5, target: self, selector: Selector("frozenEffect"), userInfo: 1, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(frozenTimer, forMode: NSDefaultRunLoopMode)
    }
    
    func frozenEffect(){
        let character = getCharacter()
        character.runAction(SKAction.fadeAlphaBy((0.7 / (500 / 25.0)), duration: 1))
        frozenEffectImg.runAction(SKAction.fadeAlphaBy(-(1.0 / (500 / 25.0)), duration: 1))
        frozenEffectImg.runAction(SKAction.scaleBy(1.0 - (0.5 / (500 / 25.0)), duration: 1))
    }
}

class FireBullet: Weapon{
    
    var burnEffectImg: SKSpriteNode!
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.Bullet
    }
    
    override func effect(character:Character){
        super.effect(character)
        
        burnEffectImg = SKSpriteNode(imageNamed: "burn")
        burnEffectImg.zPosition = 1000
        burnEffectImg.alpha = 0.0
        character.addChild(burnEffectImg)
        
        let burnTimer = NSTimer(timeInterval: 2.0, target: self, selector: Selector("burnEffect"), userInfo: 1, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(burnTimer, forMode: NSDefaultRunLoopMode)
    }
    func burnEffect(){
        
        let character = getCharacter()
        let minusLable = SKLabelNode()
        minusLable.text = "-25"
        minusLable.position.x = character.position.x
        minusLable.position.y = character.position.y + 50
        sceneNode.addChild(minusLable)
        
        minusLable.runAction(SKAction.moveToY(character.position.y+150, duration: 1.0))
        minusLable.runAction(SKAction.fadeAlphaTo(0.0, duration: 1.0), completion:{
            minusLable.removeFromParent()
        })
        
        burnEffectImg.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.5), completion:
            {
                self.burnEffectImg.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.5))
        })
        
        delegate?.decreaseHealth(2.5)
    }

}

class MultiBullet: Weapon {
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.Bullet
    }
    override func fire(){
        
        if let bulletImageName = bulletImageName {
            
            var bulletLeft: SKSpriteNode?
            var bulletMiddle: SKSpriteNode?
            var bulletRight: SKSpriteNode?
            
            // use Formal Variable of fireBullet() to control the angle
            bulletLeft = SKSpriteNode(imageNamed: bulletImageName)
            bulletMiddle = SKSpriteNode(imageNamed: bulletImageName)
            bulletRight = SKSpriteNode(imageNamed: bulletImageName)
            
            //setupPhysics()
            
            let character = getCharacter()
            
            bulletLeft!.position = CGPointMake(character.position.x - character.size.width * 0.15, character.position.y + character.size.height)
            bulletMiddle!.position = CGPointMake(character.position.x, character.position.y + character.size.height)
            bulletRight!.position = CGPointMake(character.position.x + character.size.width * 0.15, character.position.y + character.size.height)
            
            let bulletLeftAction = SKAction.sequence([SKAction.moveBy(CGVectorMake(bulletLeft!.size.width * -5, (sceneNode!.size.height)), duration: 1.0), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])
            let bulletMiddleAction = SKAction.sequence([SKAction.moveBy(CGVectorMake(0, (sceneNode!.size.height)), duration: 1.0), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])
            let bulletRightAction = SKAction.sequence([SKAction.moveBy(CGVectorMake(bulletLeft!.size.width * 5, (sceneNode!.size.height)), duration: 1.0), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])
            
            bulletLeft!.runAction(bulletLeftAction)
            bulletMiddle!.runAction(bulletMiddleAction)
            bulletRight!.runAction(bulletRightAction)
            sceneNode.addChild(bulletLeft!)
            sceneNode.addChild(bulletMiddle!)
            sceneNode.addChild(bulletRight!)
        }
    }

    
}