//
//  GameSceneBeta.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/18/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion
import AVFoundation
import AudioToolbox

class GameScene2: SKScene, SKPhysicsContactDelegate{
    
    var contactQueue = Array<SKPhysicsContact>()
    var contentCreated: Bool = false
    var character: CharacterNode!
    var enemy: SKSpriteNode!
    var enemyMark: SKSpriteNode!
    var enemyImageBase64String = ""
    var fireMutexReady = true
    var startMoving = true;
    var isGameStart = false
    
   // var arr: [String] = []
    
    var weapons: Array<SKSpriteNode>?
    //var weaponsStringArray: [String] = ["cure", "energyBlast", "fire", "shotGun", "snow", "spy"]
    var weaponMutex: [DarwinBoolean] = [true, true, true]
    var hp: HPManager?
    var enemyHp: HPManager?
    var mp: MPManager?
    var enemyMp: MPManager?
    var weaponManager = WeaponManager()
    var slowUpdateCount = 0
    
    let motionManager: CMMotionManager = CMMotionManager()
    var velocityMultiplier = Constants.GameScene.Velocity
    
    let CharacterName = Constants.GameScene.Character
    let FireName = Constants.GameScene.Fire
    let PoweredFire = Constants.GameScene.PoweredFire
    let EnemyName = Constants.GameScene.Enemy
    let EnemyFireName = Constants.GameScene.EnemyFire
    let EnemyPoweredFire = Constants.GameScene.EnemyPoweredFire
    
    enum TouchStatus {
        case Began
        case Ended
        case None
    }
    var touchStatus: TouchStatus = .None
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        if (!self.contentCreated) {
            self.setupGame()
            self.contentCreated = true
            
            // Accelerometer starts
            self.motionManager.startAccelerometerUpdates()
        }
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateByInfoOfEnemy:"), name: "getInfoOfEnemy", object: nil)
        
    }

    func updateByInfoOfEnemy(notification: NSNotification) {
        
        if isGameStart {
            let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
            //print(userInfo)
            
            if let info: [String] = userInfo["location"] as? [String] {
                if let normalizedX = Double(info[0]) {
                    let x = CGFloat(normalizedX) * self.size.width
                    enemyMark.position.x = x
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
                            let alert = UIAlertView(title: "",
                                message: "YOU WIN!",
                                delegate: self,
                                cancelButtonTitle: "OK")
                            alert.show()
                        })
                    }
                }
            }
            else if let info: [String] = userInfo["mp"] as? [String] {
                if let mp = Double(info[0]){
                    enemyMp?.powerValue = CGFloat(mp)
                }
            }
        }
    }
    
    func setupGame() {
       
        PhysicsSetting.setupScene(self)
        weaponManager.loadWeapons(self)
        setupCharacter()
        setupEnemyCharacter()
        setupEnemyMark()
        setupHealthBar()
        setupOpponentHealthBar()
        setupMpBar()
        setupenemyMapBar()
        loadBackground()
        loadWeapons()
        resetMutex()
        userInteractionEnabled = true
        isGameStart = true
    }
    
    func stopGame(){
        isGameStart = false
        weaponManager.cleanWeapons()
        self.removeAllChildren()
    }
    
    func resetMutex() {
        weaponMutex = [true,true,true]
    }
    
    func loadBackground() {
        guard let _ = childNodeWithName(Constants.GameScene.Background) as! SKSpriteNode? else {
            let image = UIImage(named: Constants.GameScene.Background)
            let texture = SKTexture(image: image!)
            let background = SKSpriteNode(texture: texture,size:frame.size)
            background.name = Constants.GameScene.Background
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.zPosition = -100
            
            addChild(background)
            return
        }
    }
    


    
    
    func setupHealthBar() {
        hp = HPManager(view: view!)
        hp!.load(self,enemy: false)
        //hp!.load(self,positionX: view!.frame.width-(hp!.barWidth)/2.0)
        
    }
    
    func setupOpponentHealthBar() {
        enemyHp = HPManager(view: view!)
        enemyHp!.load(self,enemy: true)
        //enemyHp!.load(self)
        
    }
    
    func setupMpBar() {
        mp = MPManager(view: view!)
        mp!.load(self,enemy: false)
        //mp!.load(self,positionX: view!.frame.width-(mp!.barWidth))
    }
    
    func setupenemyMapBar() {
        enemyMp = MPManager(view: view!)
        enemyMp!.load(self,enemy: true)
        //enemyMp!.load(self,positionX: mp!.barWidth)
    }
    
    func setupCharacter() {
        character = CharacterNode(texture: SKTexture(image: CharacterManager.getPickedCharacterFromLocalStorage()!))
        character.setup(self)
        character.getEffect(weaponManager)
    }
    
    func setupEnemyCharacter(){
        
        let image = UIImage(named: Constants.GameScene.EnemySlot)
        let texture = SKTexture(image: image!)
        let enemySlot = SKSpriteNode(texture: texture,size:CGSizeMake(55,55))
        
        enemySlot.position = CGPointMake(self.frame.width - enemySlot.frame.width/2 - 20 ,self.frame.height - enemySlot.frame.height/2 - 5 )
        addChild(enemySlot)
        
        enemy = SKSpriteNode(texture: SKTexture(image: CharacterManager.getEnemyCharacterFromLocalStorage()!),size:CGSizeMake(50,50))
        enemySlot.addChild(enemy)
        
    }
    
    func setupEnemyMark(){
        enemyMark = SKSpriteNode(texture: SKTexture(imageNamed: Constants.GameScene.EnemyMark),size: CGSizeMake(15,10))
        enemyMark.position = CGPointMake(self.frame.midX, self.frame.height - enemyMark.frame.height/2 - 5 )
        addChild(enemyMark)
    }
    
    func loadWeapons(){
        
        weapons = [
            addSprite(weaponManager.candidateWeaponTypes![0]!, location: CGPoint(x: scene!.size.width-30,y: 195.0),scale: 1, z:-1),
            addSprite(weaponManager.candidateWeaponTypes![1]!, location: CGPoint(x: scene!.size.width-30,y: 130.0),scale: 1, z:-1),
            addSprite(weaponManager.candidateWeaponTypes![2]!, location: CGPoint(x: scene!.size.width-30,y: 65.0),scale: 1, z:-1),
        ]
    }
    
    func addSprite(imageNamed: String, location: CGPoint, scale: CGFloat, z:CGFloat) -> SKSpriteNode {
        //print(imageNamed)
        let sprite = SKSpriteNode(imageNamed:imageNamed)
        sprite.name = imageNamed
        sprite.size.height = 35
        sprite.size.width = 35
        sprite.xScale = scale
        sprite.yScale = scale
        sprite.zPosition = z
        sprite.position = location
        self.addChild(sprite)
        return sprite
    }
    
    // Scene Update
    override func update(currentTime: CFTimeInterval) {
        
        if isGameStart {
        
            //Character Motion Control
            if(startMoving){
                self.processUserMotionForUpdate(currentTime)
            }
            
            //Slower Updateder (1/5)
            if ++slowUpdateCount % 10 == 0 {
                slowUpdateCount = 0
                
                self.processLocationSendingForUpdate(currentTime)
                self.processManaForUpdate(currentTime)
            }
        }
    }

    func processLocationSendingForUpdate(currentTime: CFTimeInterval){
        
        //send character's location to enemy
        let x = character.position.x
        let y = character.position.y
        let normalizedX = 1 - (x/size.width)
        let normalizedY = 1 - (y/size.height)
        btAdvertiseSharedInstance.update("location",data: ["x":normalizedX.description, "y":normalizedY.description])
        usleep(10000)
    }
    func processManaForUpdate(currentTime: CFTimeInterval){
        
        if let firePreparingBeginTime = weaponManager.firePreparingBeginTime {
            
            //Check You are using PoweredWeapon
            if currentTime - firePreparingBeginTime > 0.3 {
                if let mana = weaponManager.enemyPoweredWeapon?.getManaUse() {
                    self.decreaseMana(CGFloat(mana))
                }
            }
        }
        if mp?.powerValue <= 0  {
            weaponManager.firePreparingEnd_(currentTime)
        }
        //Mana recovered regularly
        self.increaseMana(0.2)
    }
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        
        if let data = self.motionManager.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            character.physicsBody!.velocity = CGVector(dx: y * velocityMultiplier, dy: -x * velocityMultiplier )
        }
    }
    func processContactsForUpdate(currentTime: CFTimeInterval) {
        for contact in self.contactQueue {
            self.handleContact(contact)
            
//            if let index = (self.contactQueue as NSArray).indexOfObject(contact) as Int? {
//                self.contactQueue.removeAtIndex(index)
//            }

        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if isGameStart {
            if touchStatus == .Began || touchStatus == .None {
                weaponManager.firePreparingBegin(touches.first!)
                
                startMoving = false;
                //self.userInteractionEnabled = false
                
                touchStatus = .Ended
            }
            
            //Here means touchEvent Bug happened
            else {
                touchesEnded(touches,withEvent: event)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        
        if isGameStart {
            if touchStatus == .Ended {
                if !weaponManager.firePreparingEnd(touches.first!){
                    if let location = touches.first?.locationInNode(self) {
                        for (i,node) in weapons!.enumerate() {
                            if node.containsPoint(location) {
                                lockWeapon(i, node: node)
                                //self.userInteractionEnabled = true
                                startMoving = true
                                return
                            }
                        }
                    }
                    if(fireMutexReady == true) {
                        fireMutexReady = false
                        weaponManager.fireBullet()
                        self.runAction(SKAction.waitForDuration(0.2), completion: {
                            self.fireMutexReady = true
                        })
                    }
                }
                
                //self.userInteractionEnabled = true
                startMoving = true
                touchStatus = .Began
            }
        }
    }
    

    func lockWeapon(index: Int, node: SKSpriteNode) {
        
        if(weaponMutex[index]) {
            
            print("lockWeapon is " + String(index))
            weaponMutex[index] = false;
            
            node.runAction(SKAction.scaleTo(1.5, duration: 0.5))
            
            weaponManager.setCharacterWeapon(node.name!)
            //weaponManager.weapon = weaponManager.makeWeapon(node.name!)
            btAdvertiseSharedInstance.update("weapon",data: ["weapon":node.name!])
            
            node.runAction(SKAction.waitForDuration(3.0), completion: {
                
                self.weaponManager.setCharacterWeapon(Constants.Weapon.WeaponType.Bullet)
            //self.weaponManager.weapon = self.weaponManager.makeWeapon(Constants.Weapon.WeaponType.Bullet)
            btAdvertiseSharedInstance.update("weapon",data: ["weapon":Constants.Weapon.WeaponType.Bullet])
                
                node.runAction(SKAction.scaleTo(1, duration: 0.5))
                
                let cd = CDAnimationBuilder()
                let child = SKSpriteNode(texture: nil, size: node.size)
                
                child.zPosition = 5
                node.addChild(child)
                child.runAction(cd.initCdAnimation("cd", time: 3.0), completion: {
                    
                    self.weaponMutex[index] = true;
                    child.removeFromParent()
                })
            })
        }
    }

    // Physics Contact Helpers
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact as SKPhysicsContact? != nil {
            self.handleContact(contact)
        }
    }
    
    func handleContact(contact: SKPhysicsContact) {
        
        if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
            return
        }
        
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!] as NSArray
        
        //Character is attacked
        if nodeNames.containsObject(CharacterName) && nodeNames.containsObject(EnemyFireName) {
            
            if contact.bodyA.node == character {
                contact.bodyB.node!.removeFromParent()
            } else {
                contact.bodyA.node!.removeFromParent()
            }
            
            character?.shake()
            character.getEffect(weaponManager)
            decreaseHealth(CGFloat(weaponManager.fireDamage()))
        }
        else if nodeNames.containsObject(CharacterName) && nodeNames.containsObject(EnemyPoweredFire) {
            
            character?.shake()
            character.getEffect(weaponManager)
            decreaseHealth(CGFloat(weaponManager.poweredFireDamage()))
        }
    }
    
    func increaseMana(value : CGFloat){
        if isGameStart {
            mp!.increase(value)
            if(mp!.powerValue < 100){
                btAdvertiseSharedInstance.update("mp",data: ["mp":mp!.powerValue.description])
            }
        }
    }
    
    func decreaseMana(value : CGFloat) {
        if isGameStart {
            mp!.decrease(value)
            if(mp!.powerValue < 100){
                btAdvertiseSharedInstance.update("mp",data: ["mp":mp!.powerValue.description])
            }
        }
    }
    
    func decreaseHealth( value : CGFloat){
        
        if isGameStart {
            hp!.decrease(value)
            btAdvertiseSharedInstance.update("hp",data: ["hp":hp!.powerValue.description])
            
            if(hp!.powerValue <= 50 && hp!.powerValue > 0){
                //do something but not profEmitterActionAtPosition
            }
            else if(hp!.powerValue <= 0){
                
                stopGame()
                let alert = UIAlertView(title: "",
                    message: "YOU LOSE!",
                    delegate: self,
                    cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        setupGame()
    }
    
    
}
