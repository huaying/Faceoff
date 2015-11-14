//
//  MainScene.swift
//  Faceoff
//
//  Created by Huaying Tsai on 9/26/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import UIKit
import GLKit
import SpriteKit
import Foundation

class MainScene: SKScene,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var layerView: UIImageView!
    var finalImg : UIImage!
    var imgForPlayer : UIImage!
    
    let logo = UIImage(named: "headdd")!
    let mask = CALayer()
    
    
    var btn:UIButton = UIButton()
    
    var 製造角色按鈕: SKNode! = nil
    var 進入遊戲按鈕: SKNode! = nil
    var 角色們: SKNode! = nil
    var testImage: SKNode! = nil
    let background: SKNode! = SKSpriteNode(imageNamed: "spaceship1.jpg")
    
    var candidateCharacterNodes:[SKSpriteNode] = []
    
    
    override func didMoveToView(view: SKView) {
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.xScale = 0.75
        background.yScale = 0.75
        background.zPosition = -100
        addChild(background)
        
        製造角色按鈕 = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 200, height: 40))
        製造角色按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)+CGFloat(50.0))
        addChild(製造角色按鈕)
        let 製造角色文字 = SKLabelNode(fontNamed:"Chalkduster")
        製造角色文字.text = "Create a character";
        製造角色文字.fontSize = 14;
        製造角色文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        製造角色按鈕.addChild(製造角色文字)
   
        進入遊戲按鈕 = SKSpriteNode(color: UIColor.redColor().colorWithAlphaComponent(0.3), size: CGSize(width: 200, height: 40))
        進入遊戲按鈕.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)-CGFloat(0.0))
        addChild(進入遊戲按鈕)
        
        let 進入遊戲文字 = SKLabelNode(fontNamed:"Chalkduster")
        進入遊戲文字.text = "Play";
        進入遊戲文字.fontSize = 14;
        進入遊戲文字.position = CGPoint(x:CGFloat(0),y:CGFloat(-5))
        
        進入遊戲按鈕.addChild(進入遊戲文字)
        
        loadCharacter()
        
        NSNotificationCenter.defaultCenter().addObserverForName("PhotoPickerFinishedNotification", object:nil, queue:nil, usingBlock: { note in
            self.loadCharacter()
            
        })
    }
    
    
    func loadCharacter(){
        
        if let candidateCharacters: [UIImage] = CharacterManager.getCandidateCharactersFromLocalStorage(){
            if 角色們 != nil && 角色們.parent != nil {
                角色們.removeFromParent()
            }
            角色們 = SKNode()
            candidateCharacterNodes = []
            for (i,candidateCharacter) in candidateCharacters.enumerate() {
                
                let candidateCharacterNode = SKSpriteNode(texture: SKTexture(image: candidateCharacter))
                candidateCharacterNodes.append(candidateCharacterNode)
                
                if i == 0 {
                    chooseCharacter(candidateCharacterNode)
                }
                candidateCharacterNode.position.x = 100.0*CGFloat(i)
                角色們.addChild(candidateCharacterNode)
                
            }
            print(CGRectGetMidX(self.frame),CGRectGetMidX(角色們.frame))
            角色們.position = CGPoint(x:CGRectGetMidX(self.frame)-CGRectGetMidX(角色們.calculateAccumulatedFrame()),y:CGRectGetMidY(self.frame)-CGFloat(100.0))
            addChild(角色們)

        }
    }
    
    func chooseCharacter(character :SKNode){
        
        for candidateCharacterNode in candidateCharacterNodes {
                candidateCharacterNode.removeAllChildren()
        }
        
        let borderWidth:CGFloat = 5.0
        let border = SKShapeNode(circleOfRadius: (character.frame.size.width/2 - borderWidth + 3))
        
        border.lineWidth = borderWidth
        border.strokeColor = UIColor.whiteColor()
        border.zPosition = 1
        character.addChild(border)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInNode(self){
            if 製造角色按鈕.containsPoint(location){
                製造角色按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
                
                let  vc:UIViewController = self.view!.window!.rootViewController!       
                vc.presentViewController(CameraViewController(), animated: false, completion:nil)

            }
                
                
            else if 進入遊戲按鈕.containsPoint(location){
                進入遊戲按鈕.runAction(SKAction.playSoundFileNamed(FaceoffGameSceneEffectAudioName.ButtonAudioName.rawValue, waitForCompletion: false))
                
                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 0.5)
                removeAllChildren()
                let nextScene = PlayModeScene(size: scene!.size)
                nextScene.scaleMode = .AspectFill
                scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
        if let location = touches.first?.locationInNode(角色們){
            
            for (i,candidateCharacterNode) in candidateCharacterNodes.enumerate() {
                if candidateCharacterNode.containsPoint(location){
                    chooseCharacter(candidateCharacterNode)
                }
            }

        }
    }
    
    func imagePickingFinished(){
        loadCharacter()
    }
}