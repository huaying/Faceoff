//
//  WeaponManager.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/19/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

class WeaponManager: NSObject{
    
    enum WeaponType {
        case Bullet
        case BounsBullet
        case IceBullet
        case FireBullet
        case MultiBullet
        case Laser
    }
    
    var sceneNode: SKScene!
    var weapon: Weapon?
    var basicWeapon: Weapon?
    var poweredWeapon: Weapon?
    var enemyWeapon: Weapon?
    var enemyPoweredWeapon: Weapon?
    
    var candidateWeapons: [Weapon] = []
    
    //Set this variable from SelectWeaponScene
    var candidateWeaponTypes: [WeaponType]?
    
    var firePreparingBeginTime:NSTimeInterval?
    var firePreparingEndTime:NSTimeInterval?
    var firePreparingTime:NSTimeInterval? {
        get {
            if firePreparingEndTime != nil && firePreparingBeginTime != nil {
            return firePreparingEndTime! - firePreparingBeginTime!
            }
            return nil
        }
    }
    
    func loadWeapons(sceneNode :SKScene){
        self.sceneNode = sceneNode
        
        if let candidateWeaponTypes = candidateWeaponTypes {
            for candidateWeaponType in candidateWeaponTypes {
                candidateWeapons.append(makeWeapon(candidateWeaponType))
            }
        }
        
        //weapon = candidateWeapons.first
        weapon = makeWeapon(.Bullet)
        poweredWeapon = makeWeapon(.Laser)
        enemyWeapon = makeWeapon(.Bullet)
        enemyPoweredWeapon = makeWeapon(.Laser)
    }
    
    func makeWeapon(weaponType: WeaponType) -> Weapon {
        
        var weapon: Weapon!
        
        if weaponType == .Bullet{
            weapon = Bullet(sceneNode: sceneNode)
        }
        else if weaponType == .BounsBullet{
            weapon = BounsBullet(sceneNode: sceneNode)
        }
        else if weaponType == .IceBullet{
            weapon = IceBullet(sceneNode: sceneNode)
        }
        else if weaponType == .FireBullet{
            weapon = FireBullet(sceneNode: sceneNode)
        }
        else if weaponType == .MultiBullet{
            weapon = MultiBullet(sceneNode: sceneNode)
        }
        else if weaponType == .Laser{
            weapon = Laser(sceneNode: sceneNode)
        }
        
        return weapon
    }

    func fireBullet(){
        weapon?.fire()
    }
    
    func fireBullet(preparingTime :NSTimeInterval?){
        poweredWeapon?.fire(preparingTime)
    }
    
    func firePreparingBegin(touch: UITouch){
        firePreparingBeginTime = touch.timestamp
        poweredWeapon?.firePreparingAction()
    }
    
    func firePreparingEnd(touch: UITouch) -> Bool{
        firePreparingEndTime = touch.timestamp
        if firePreparingTime > 0.3 {
            poweredWeapon?.fire(firePreparingTime)
            cleanFirePreparingTime()
            return true
        }else{
            poweredWeapon?.stopFirePreparingAction()
            cleanFirePreparingTime()
            return false
        }
    }
    
    func cleanFirePreparingTime(){
        firePreparingBeginTime = nil
        firePreparingEndTime = nil
    }
    func effect(character: Character) {
        enemyWeapon?.effect(character)
    }
    
    func fireFromEnemy(fireInfo :[String]){
        enemyWeapon?.fireFromEnemy(fireInfo)
    }
    
    func poweredFireFromEnemy(fireInfo :[String]){
        enemyPoweredWeapon?.fireFromEnemy(fireInfo)
    }
    
    func fireDamage() -> Double? {
        return enemyWeapon?.getDamage()
    }
    
    func poweredFireDamage() -> Double? {
        return enemyPoweredWeapon?.getDamage()
    }
}