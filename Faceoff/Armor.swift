//
//  Armor.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/29/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

class Armor: Bullet {
    
    var armor: SKSpriteNode?
    var reduce: Double = 0.3
    
    override init(sceneNode :SKScene){
        super.init(sceneNode: sceneNode)
    }
    
    override func positveEffect() {
        enableArmor()
    }
    
    override func getReduce() -> Double {
        return reduce
    }
    
    func enableArmor(){
        
        armor = SKSpriteNode(imageNamed: Constants.Weapon.WeaponImage.Armor)
        let character = getCharacter()!
        
        armor!.name = Constants.Weapon.WeaponImage.Armor
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

