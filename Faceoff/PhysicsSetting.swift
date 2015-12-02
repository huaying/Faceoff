//
//  PhysicsSetting.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/22/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

class PhysicsSetting {
    
    static func setupScene(node: GameScene2) -> GameScene2 {
        
        node.physicsBody = SKPhysicsBody(edgeLoopFromRect: node.frame)
        node.physicsBody!.categoryBitMask = Constants.GameScene.Bitmask.SceneEdge
        
        node.physicsWorld.contactDelegate = node
        return node
    }
    
    static func setupCharacter(node: SKNode) -> SKNode{
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size)
        print("character:", node.frame.size)
        node.physicsBody?.dynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.friction = 0.0
        
        //bitmask setup
        node.physicsBody?.categoryBitMask = Constants.GameScene.Bitmask.Character
        node.physicsBody?.usesPreciseCollisionDetection = true
        node.physicsBody?.collisionBitMask = Constants.GameScene.Bitmask.SceneEdge
        
        return node
    }
    
    static func setupFire(node :SKNode) -> SKNode {
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size)
        node.physicsBody?.dynamic = false
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = Constants.GameScene.Bitmask.Fire
        node.physicsBody?.contactTestBitMask = Constants.GameScene.Bitmask.Enemy
        node.physicsBody?.collisionBitMask = 0x0
        
        return node
    }
    
    static func setupEnemyFire(node :SKNode) -> SKNode {
        
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size)
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = Constants.GameScene.Bitmask.Fire
        node.physicsBody?.contactTestBitMask = Constants.GameScene.Bitmask.Character
        node.physicsBody?.usesPreciseCollisionDetection = true

        
        return node
    }

}