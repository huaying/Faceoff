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
    
    var sceneNode: SKScene!
    var weapon: Weapon?
    var basicWeapon: Weapon?
    var poweredWeapon: Weapon?
    var enemyWeapon: Weapon?
    var enemyPoweredWeapon: Weapon?
    
    var candidateWeapons: [Weapon] = []
    
    //Set this variable from SelectWeaponScene
    var candidateWeaponTypes: [String?]?
    
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
        
        print(candidateWeaponTypes)
        if let candidateWeaponTypes = candidateWeaponTypes {
            for candidateWeaponType in candidateWeaponTypes {
                //candidateWeapons.append(makeWeapon(candidateWeaponType!))
            }
        }
        
        //weapon = candidateWeapons.first
        weapon = makeWeapon(Constants.Weapon.WeaponType.MultiBullet)
        poweredWeapon = makeWeapon(Constants.Weapon.WeaponType.Laser)
        enemyWeapon = makeWeapon(Constants.Weapon.WeaponType.MultiBullet)
        enemyPoweredWeapon = makeWeapon(Constants.Weapon.WeaponType.Laser)
    }
    
    func makeWeapon(weaponType: String) -> Weapon {
        
        var weapon: Weapon!
        
        if weaponType == Constants.Weapon.WeaponType.Bullet{
            weapon = Bullet(sceneNode: sceneNode)
        }
        else if weaponType == Constants.Weapon.WeaponType.BonusBullet{
            weapon = BounsBullet(sceneNode: sceneNode)
        }
        else if weaponType == Constants.Weapon.WeaponType.IceBullet{
            weapon = IceBullet(sceneNode: sceneNode)
        }
        else if weaponType == Constants.Weapon.WeaponType.FireBullet{
            weapon = FireBullet(sceneNode: sceneNode)
        }
        else if weaponType == Constants.Weapon.WeaponType.MultiBullet{
            weapon = MultiBullet(sceneNode: sceneNode)
        }
        else if weaponType == Constants.Weapon.WeaponType.Laser{
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
        return firePreparingEnd_(firePreparingEndTime!)
    }
    
    func firePreparingEnd_(firePreparingEndTime: NSTimeInterval) -> Bool{
        self.firePreparingEndTime = firePreparingEndTime
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
    
    func effect(character: CharacterNode) {
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