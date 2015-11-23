//
//  HPManager.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/17/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation
import SpriteKit

class PowerManger {
    let maxOfPower:CGFloat = 100
    let minOfPower:CGFloat = 0
    
    let barWidth:CGFloat = 5
    
    
    var barContainer: SKNode?
    var barBack: SKSpriteNode?
    var bar: SKSpriteNode?
    
    var view: SKView?
    
    var position:CGPoint? {
        set {
            barContainer!.position = newValue!
        }
        get {
            return barContainer!.position
        }
    }
    var powerValue:CGFloat = 0 {
        didSet {
            powerValueReactedToBar()
            
        }
    }

    init(view: SKView){
        self.view = view
    }
    
    func load(node: SKNode,positionX: CGFloat? = nil){
        powerValue = maxOfPower
        makeBar(positionX)
        show(node)
    }
    
    func increase(increasedValue: CGFloat){
        let value = powerValue + increasedValue
        powerValue = min(value,maxOfPower)
        
    }
    
    func decrease(decreasedValue: CGFloat){
        let value = powerValue - decreasedValue
        powerValue = max(value,minOfPower)
    }
    
    
    func makeBar(positionX: CGFloat?){
        barContainer?.removeFromParent()
        bar?.removeFromParent()
        barBack?.removeFromParent()
        barContainer = SKNode()
        
        if positionX != nil {
            barContainer!.position = CGPoint(x:positionX!,y:view!.frame.height/2)
        }else{
            barContainer!.position = CGPoint(x:barWidth/2,y:view!.frame.height/2)
        }
        bar = SKSpriteNode()
        bar!.size = CGSizeMake(barWidth,view!.frame.height)
        barBack = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(barWidth,view!.frame.height))
        
        barContainer!.addChild(barBack!)
        barContainer!.addChild(bar!)
    }
    
    private func powerValueReactedToBar(){
        bar?.size.height = (powerValue/maxOfPower) * view!.frame.height
        bar?.position.y = -(view!.frame.height - bar!.size.height)/2
    }
    
    func show(node: SKNode){
        node.addChild(barContainer!)
        node.zPosition = 10
    }

}

class HPManager: PowerManger{
    
    override func makeBar(positionX: CGFloat?) {
        super.makeBar(positionX)
        bar?.color = UIColor.redColor()
    }
    
}
class MPManager: PowerManger{
    override func makeBar(positionX: CGFloat?) {
        super.makeBar(positionX)
        bar?.color = UIColor.blueColor()
    }
}


