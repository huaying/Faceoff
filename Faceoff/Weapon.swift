//
//  Weapon.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/20/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit


class Weapon: NSObject{
    
    var bullet: SKSpriteNode?
    var bulletStart: CGPoint?
    var bulletEnd: CGPoint?
    var bulletImageName: String?
    var firePreparingEmitter: SKEmitterNode!
    
    var sceneNode: SKScene!
    var gameScene: GameScene2?
    
    var isFirePreparing: Bool = false

    
    init(sceneNode :SKScene){
        self.sceneNode = sceneNode
        if let gameScene = sceneNode as? GameScene2 {
            self.gameScene = gameScene
        }
    }
    
    func fire(){}
    func fireFromEnemy(fireInfo :[String]){}
    
    //Powered Fire
    func fire(preparingTime: NSTimeInterval?){}
    func effect(character:CharacterNode){}
    func firePreparingAction(){}
    func stopFirePreparingAction() {}
    func getDamage() -> Double { return 0 }
    func getManaUse() -> Double { return 0 }
    
    func getCharacter() -> SKSpriteNode? {
        return gameScene!.character
    }
}


class Armor: Bullet {
    
    var armor: SKSpriteNode?
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
        enableArmor()
    }
    
    func enableArmor(){
        
        armor = SKSpriteNode(imageNamed: Constants.Weapon.WeaponImage.Armor)
        let character = getCharacter()!
        character.name = Constants.Weapon.WeaponImage.Armor
        armor!.size.height = character.size.height * 2.5
        armor!.size.width = character.size.width * 2.5
        armor?.zPosition = character.zPosition+1
        character.addChild(armor!)
        
    }
    func disableArmor(){
        armor?.removeFromParent()
    }
    
    deinit {
        disableArmor()
    }
}



