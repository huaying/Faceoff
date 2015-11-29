//
//  MultiBullet.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/28/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

class MultiBullet: Bullet {
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        bulletImageName = Constants.Weapon.WeaponImage.MultiBullet
    }
    override func fire(){
        let character = getCharacter()!
        let bulletPosition = CGPointMake(character.position.x, character.position.y + character.frame.height + 10)
        let bulletVector = CGVectorMake(0, (sceneNode!.size.height))
        fire(bulletPosition,vector: bulletVector)
        
        let normalizedX = 1 - (bulletPosition.x/sceneNode.size.width)
        btAdvertiseSharedInstance.update("fire-multibullet",data: ["x":normalizedX.description])
    }
    
    override func fireFromEnemy(fireInfo: [String]) {
        if let normalizedX = Double(fireInfo[0]) {
            let x = CGFloat(normalizedX) * sceneNode.size.width
            let bulletPosition = CGPoint(x: CGFloat(x), y: sceneNode!.size.height * 1.1)
            let bulletVector = CGVectorMake(0, -sceneNode!.size.height)
            fire(bulletPosition,vector: bulletVector,fromEnemy: true)
        }
    }
    
    override func fire(fromPosition: CGPoint, vector: CGVector, fromEnemy: Bool = false){
        
        if let bulletImageName = bulletImageName {
            var bulletLeft: SKSpriteNode?
            var bulletMiddle: SKSpriteNode?
            var bulletRight: SKSpriteNode?
            
            bulletLeft = SKSpriteNode(imageNamed: bulletImageName)
            bulletMiddle = SKSpriteNode(imageNamed: bulletImageName)
            bulletRight = SKSpriteNode(imageNamed: bulletImageName)
            bulletLeft?.xScale = 0.5
            bulletMiddle?.xScale = 0.5
            bulletRight?.xScale = 0.5
            bulletLeft?.yScale = 0.5
            bulletMiddle?.yScale = 0.5
            bulletRight?.yScale = 0.5
            
            bulletLeft!.name = Constants.GameScene.Fire
            bulletMiddle!.name = Constants.GameScene.Fire
            bulletMiddle!.name = Constants.GameScene.Fire
            
            PhysicsSetting.setupFire(bulletLeft!)
            PhysicsSetting.setupFire(bulletMiddle!)
            PhysicsSetting.setupFire(bulletRight!)
            
            if fromEnemy {
                bulletLeft?.yScale *= -1
                bulletMiddle?.yScale *= -1
                bulletRight?.yScale *= -1
                bulletLeft!.name = Constants.GameScene.EnemyFire
                bulletMiddle!.name = Constants.GameScene.EnemyFire
                bulletRight!.name = Constants.GameScene.EnemyFire
                PhysicsSetting.setupEnemyFire(bulletLeft!)
                PhysicsSetting.setupEnemyFire(bulletMiddle!)
                PhysicsSetting.setupEnemyFire(bulletRight!)
            }
            
            bulletLeft!.position = fromPosition
            bulletMiddle!.position = fromPosition
            bulletRight!.position = fromPosition
            
            let bulletLeftAction = SKAction.sequence([SKAction.moveBy(CGVectorMake(bulletLeft!.size.width * -7, vector.dy), duration: 1.0), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])
            let bulletMiddleAction = SKAction.sequence([SKAction.moveBy(CGVectorMake(0, vector.dy), duration: 1.0), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])
            let bulletRightAction = SKAction.sequence([SKAction.moveBy(CGVectorMake(bulletLeft!.size.width * 7, vector.dy), duration: 1.0), SKAction.waitForDuration(3.0/60.0), SKAction.removeFromParent()])
            
            bulletLeft!.runAction(bulletLeftAction)
            bulletMiddle!.runAction(bulletMiddleAction)
            bulletRight!.runAction(bulletRightAction)
            sceneNode.addChild(bulletLeft!)
            sceneNode.addChild(bulletMiddle!)
            sceneNode.addChild(bulletRight!)
        }
    }
    
    
}