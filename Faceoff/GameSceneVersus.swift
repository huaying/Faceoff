//
//  GameSceneVersus.swift
//  Faceoff
//
//  Created by Huaying Tsai on 12/8/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

class GameSceneVersus: GameScene {
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateByInfoOfEnemy:"), name: "getInfoOfEnemy", object: nil)

    }
    
    func updateByInfoOfEnemy(notification: NSNotification) {
        
        if isGameStart {
            let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
            //print(userInfo)
            
            if let info: [String] = userInfo["location"] as? [String] {
                if let normalizedX = Double(info[0]) {
                    let x = CGFloat(normalizedX) * self.size.width
                    enemyMark.runAction(SKAction.moveToX(x, duration: 0.2))
                }
            }
                
            else if let info: [String] = userInfo["weapon"] as?
                [String] {
                    let weaponType = info[0]
                    //weaponManager.enemyWeapon = weaponManager.makeWeapon(weaponType)
                    weaponManager.setEnemyWeapon(weaponType)
            }
            else if let info: [String] = userInfo["fire-bullet"] as? [String] {
                weaponManager.fireFromEnemy(info)
            }
            else if let info: [String] = userInfo["fire-multibullet"] as? [String] {
                weaponManager.fireFromEnemy(info)
            }
            else if let info: [String] = userInfo["fire-laser"] as? [String] {
                weaponManager.poweredFireFromEnemy(info)
            }
                
            else if let info: [String] = userInfo["hp"] as? [String] {
                if let hp = Double(info[0]){
                    enemyHp?.powerValue = CGFloat(hp)
                    
                    if hp <= 0 {
                        dispatch_async(dispatch_get_main_queue(),{
                            self.stopGame()
                            self.setupGameEndPanel(true)
                            //you win
                        })
                    }
                }
            }
            else if let info: [String] = userInfo["mp"] as? [String] {
                if let mp = Double(info[0]){
                    enemyMp?.powerValue = CGFloat(mp)
                }
            }
            else if let _: [String] = userInfo["pause"] as? [String] {
                pauseGame()
                
            }
            else if let _: [String] = userInfo["resume"] as? [String] {
                resumeGame()
            }
            
        }
    }
    
    override func updateInfoToEnemy(key: String, data: [String: String] = [String:String]()){
        var needToBeSend = false
        var stringOfData = ""
        
        if key == "location" {
            stringOfData = key + " " + data["x"]! + " " + data["y"]!
        }
        else if key == "pause" {
            stringOfData = key
        }
            
        else if key == "resume" {
            stringOfData = key
        }
            
        else if key == "hp" {
            stringOfData = key + " " + data["hp"]!
            if data["hp"] == "0" {
                needToBeSend = true
            }
        }
            
        else if key == "mp" {
            stringOfData = key + " " + data["mp"]!
        }
            
        else if key == "weapon" {
            needToBeSend = true
            stringOfData = key + " " + data["weapon"]!
        }
            
        else if key == "fire-bullet" {
            stringOfData = key + " " + data["x"]!
        }
        else if key == "fire-multibullet" {
            stringOfData = key + " " + data["x"]!
        }
        else if key == "fire-laser" {
            stringOfData = key + " " + data["x"]! + " " + data["laserWidth"]!
        }
        
        if stringOfData != "" {
            if needToBeSend {
                while(!btAdvertiseSharedInstance.updateInfo(stringOfData)){
    
                }
            } else {
                btAdvertiseSharedInstance.updateInfo(stringOfData)
            }
        }
        
    }

}