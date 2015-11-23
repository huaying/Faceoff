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

class GameScene2: SKScene, SKPhysicsContactDelegate, WeaponDelegate {
    
    
    // Game End
    var gameEnding: Bool = false
    
    // Contact
    var contactQueue = Array<SKPhysicsContact>()
    
    // Bullet type
    enum BulletType: String {
        case ShipFired = "ShipFired"
        case InvaderFired = "InvaderFired"
        case BonusBullet = "BonusBullet"
        var description: String {
            return self.rawValue
        }
        case Bonus
    }
    
    // 3
    let kInvaderName = "invader"
    
    // 4
    let kShipSize = CGSize(width: 30, height: 16)
    let kShipName = "ship"
    
    // 5
    let kScoreHudName = "scoreHud"
    let kHealthHudName = "healthHud"
    
    let kMinInvaderBottomHeight: Float = 32.0
    
    
    // Score and Health
    var score: Int = 0
    var shipHealth: Float = 1.0
    
    // Bullets utils
    let kShipFiredBulletName = "shipFiredBullet"
    let kInvaderFiredBulletName = "invaderFiredBullet"
    let kShipFiredUltimateName = "shipFiredUltimate"
    
    let kBulletSize = CGSize(width:4, height: 8)
    
    // Private GameScene Properties
    
    var contentCreated: Bool = false
    
    var timeOfLastMove: CFTimeInterval = 0.0
    var timePerMove: CFTimeInterval = 1.0
    
    // Accelerometer
    let motionManager: CMMotionManager = CMMotionManager()
    
    // Queue
    var tapQueue: Array<Int> = []
    
    // Object Lifecycle Management
    
    var character: Character!
    var shipVelocity = 500.0
    
    // 集氣用---------------------
    var node: SKSpriteNode? = nil
    var sdfsd: Double = 1.0
    let laser_height = 1000.0
    var laser_width = 400.0
    let action = SKAction.shake(0.5, amplitudeX: 10, amplitudeY: 10)
    //var laser = SKShapeNode(rectOfSize: CGSize(width: 200, height: 400))
    //var laser : SKSpriteNode! = nil
    var mutex = false
    var bulletDidFire = false
    var startMoving = true;
    var lastTimeStamp = 0.0
    var energyBlastAnim = [SKTexture]()
    var animation = SKAction()
    var diff = 0.0
    var laser_final_width = 0.0
    var BGM : AVAudioPlayer! = nil
    var kameCharge : AVAudioPlayer! = nil
    var kameEmmit : AVAudioPlayer! = nil
    var WarningSiren : AVAudioPlayer! = nil
    
    //--------------------------
    
    
    var ultimateTimer : NSTimer! = nil
    var timer2 : NSTimer! = nil
    var mpTimer : NSTimer! = nil
    var oppoMpTimer : NSTimer! = nil
    
    var emitter :SKEmitterNode! = nil
    
    var attackedCount = 0;

    let kBar = "ship"
    var oppoPosHint : SKSpriteNode! = nil
    var ultimateHint : SKSpriteNode! = nil
    
    var fireMutexReady = true
    
    //////bonus bullet//////
    let starBonusName = "starbonusnode"
    let bulletName = "bulletnode"
    let playerName = "playernode"
    let starName = "starnode"
    var weaponType = BulletType.ShipFired
    
    var arr: [String] = []
    
    var weapons: Array<SKSpriteNode>?
    var weaponsStringArray: [String] = ["cure", "energyBlast", "fire", "shotGun", "snow", "spy"]
    
    
    var hp: HPManager?
    var enemyHp: HPManager?
    var mp: MPManager?
    var enemyMp: MPManager?
    
    var weaponManager = WeaponManager()
    var slowUpdateCount = 0
    
    
    let CharacterName = Constants.GameScene.Character
    let FireName = Constants.GameScene.Fire
    let PoweredFire = Constants.GameScene.PoweredFire
    let EnemyName = Constants.GameScene.Enemy
    let EnemyFireName = Constants.GameScene.EnemyFire
    let EnemyPoweredFire = Constants.GameScene.EnemyPoweredFire
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        weaponManager.candidateWeaponTypes = [.Bullet,.Bullet,.Bullet]
        weaponManager.loadWeapons(self)
        
        if (!self.contentCreated) {
            self.createContent()
            self.contentCreated = true
            
            // Accelerometer starts
            self.motionManager.startAccelerometerUpdates()
            
            // SKScene responds to touches
            self.userInteractionEnabled = true
            
            self.physicsWorld.contactDelegate = self
        }
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateByInfoOfEnemy:"), name: "getInfoOfEnemy", object: nil)
    }
    
    func updateByInfoOfEnemy(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        print(userInfo)
        
        if let info: [String] = userInfo["fire-bullet"] as? [String] {
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
                        self.userInteractionEnabled = false
                        self.removeAllChildren()
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
    
    func createContent() {
        if let index = scene!.userData?.valueForKey("Ray") as? String {
            //print(index)
            
            arr = index.componentsSeparatedByString("-")
            //print(arr)
            loadWeapons(arr)
        }
        
        PhysicsSetting.setupScene(self)
        
        setupShip()
        setupHealthBar()
        setupOpponentHealthBar()
        setupMpBar()
        setupenemyMapBar()
        loadBackground()
        
        
    }
    
    func loadBackground() {
        guard let _ = childNodeWithName("background") as! SKSpriteNode? else {
            let texture = SKTexture(image: UIImage(named: "background4.jpg")!)
            let node = SKSpriteNode(texture: texture)
            node.xScale = 0.5
            node.yScale = 0.5
            node.position = CGPoint(x: frame.midX, y: frame.midY)
            node.zPosition = -100
            //self.physicsWorld.gravity = CGVectorMake(0, gravity)
            
            addChild(node)
            return
        }
    }

    func setupHealthBar() {
        hp = HPManager(view: view!)
        hp!.load(self,positionX: view!.frame.width-(hp!.barWidth)/2.0)
    }
    
    func setupOpponentHealthBar() {
        enemyHp = HPManager(view: view!)
        enemyHp!.load(self)
    }
    
    func setupMpBar() {
        mp = MPManager(view: view!)
        mp!.load(self,positionX: view!.frame.width-(mp!.barWidth))
    }
    
    func setupenemyMapBar() {
        enemyMp = MPManager(view: view!)
        enemyMp!.load(self,positionX: mp!.barWidth)
    }
    
    func setupShip() {
        character = Character(texture: SKTexture(image: CharacterManager.getPickedCharacterFromLocalStorage()!))
        character.setup(self)
        character.getEffect(weaponManager)
    }
    
    func loadWeapons(imageName:[String]){
        
        weapons = [
            addSprite(weaponsStringArray[Int(imageName[0])!], location: CGPoint(x: scene!.size.width-30,y: 195.0),scale: 1, z:-1),
            addSprite(weaponsStringArray[Int(imageName[1])!], location: CGPoint(x: scene!.size.width-30,y: 130.0),scale: 1, z:-1),
            addSprite(weaponsStringArray[Int(imageName[2])!], location: CGPoint(x: scene!.size.width-30,y: 65.0),scale: 1, z:-1),
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
        
        //Contact Detection
        self.processContactsForUpdate(currentTime)
        
        //Character Motion Control
        if(startMoving){
            self.processUserMotionForUpdate(currentTime)
        }
        
        
        //Slower Updateder (1/5)
        if ++slowUpdateCount % 5 == 0 {
            slowUpdateCount = 0
            
//            let x = character.position.x.description
//            let y = character.position.y.description
            //btAdvertiseSharedInstance.update("location",data: ["x":x, "y":y])
            self.processManaForUpdate(currentTime)
            
        }
        
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
        
        //Mana recovered regularly
        self.increaseMana(0.2)
    }
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        
        if let data = self.motionManager.accelerometerData {
            
            let multiplier = shipVelocity
            let x = data.acceleration.x
            let y = data.acceleration.y
            character.physicsBody!.velocity = CGVector(dx: y * multiplier, dy: -x * multiplier )
        }
    }
    
    func processContactsForUpdate(currentTime: CFTimeInterval) {
        for contact in self.contactQueue {
            self.handleContact(contact)
            
            if let index = (self.contactQueue as NSArray).indexOfObject(contact) as Int? {
                self.contactQueue.removeAtIndex(index)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let location = touches.first?.locationInNode(self){
            for node in weapons! {
                if node.containsPoint(location) {
                    if node.name == "cure" {
                        let cd = CDAnimationBuilder()
                        node.runAction(cd.initCdAnimation("cure"))
                    }
                    if node.name == "spy" {
                        let cd = CDAnimationBuilder()
                        node.runAction(cd.initCdAnimation("spy"))
                    }
                    return
                }
            }
        }
        
        weaponManager.firePreparingBegin(touches.first!)
        
        
        startMoving = false;
        self.userInteractionEnabled = false
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        
        if !weaponManager.firePreparingEnd(touches.first!){
            
            if(fireMutexReady == true) {
                fireMutexReady = false
                weaponManager.fireBullet()
                self.runAction(SKAction.waitForDuration(0.2), completion: {
                    self.fireMutexReady = true
                })
            }
        }
        
        self.userInteractionEnabled = true
        startMoving = true
    }
    


    // Physics Contact Helpers
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact as SKPhysicsContact? != nil {
            self.contactQueue.append(contact)
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
            if let damage = weaponManager.fireDamage() {
                decreaseHealth(CGFloat(damage))
            }
            
        }
        else if nodeNames.containsObject(CharacterName) && nodeNames.containsObject(EnemyPoweredFire) {
            
            character?.shake()
            if let damage = weaponManager.poweredFireDamage() {
                decreaseHealth(CGFloat(damage))
            }
        }
    }
    func increaseMana(value : CGFloat){
        mp!.increase(value)
        btAdvertiseSharedInstance.update("mp",data: ["mp":mp!.powerValue.description])
    }
    
    func decreaseMana(value : CGFloat) {
        mp!.decrease(value)
        btAdvertiseSharedInstance.update("mp",data: ["mp":mp!.powerValue.description])
    }
    
    func decreaseHealth( value : CGFloat){
        hp!.decrease(value)
        btAdvertiseSharedInstance.update("hp",data: ["hp":hp!.powerValue.description])
        
        if(hp!.powerValue <= 50 && hp!.powerValue > 0){
            //do something but not profEmitterActionAtPosition
        }
        else if(hp!.powerValue <= 0){
            
            self.userInteractionEnabled = false
            
            self.removeAllChildren()
            let alert = UIAlertView(title: "",
                message: "YOU LOSE!",
                delegate: self,
                cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        self.userInteractionEnabled = true
        createContent()
    }
    
    
}