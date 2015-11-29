//
//  Bullet.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/28/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: Weapon {
    
    var damage: Double = 3.0
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.WeaponImage.Bullet
    }
    
    override func fire(){
        super.fire()
        
        let character = getCharacter()!
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



class BounsBullet: Weapon{
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.WeaponImage.BonusBullet
    }
    override func fire(){
        super.fire()
        bullet!.xScale = 0.2
        bullet!.yScale = 0.2
    }
}