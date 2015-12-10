//
//  GameViewController.swift
//  BTtest
//
//  Created by Shao-Hsuan Liang on 10/18/15.
//  Copyright (c) 2015 Liang. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit


var musicPlayer:AVAudioPlayer!
var btDiscoverySharedInstance:BTDiscovery!
var btAdvertiseSharedInstance:BTAdvertise!
var enemyCharacterLoader: EnemyCharacterLoader!

class GameViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Tools.setupStartBGM()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        let scene = MainScene(size: view.frame.size)
        scene.scaleMode =  .AspectFill
        skView.presentScene(scene)
        
        
        // Pause the view (and thus the game) when the app is interrupted or backgrounded
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }
    
 
    
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        musicPlayer = setupAudioPlayerWithFile("startBGM", type: "wav")
//        musicPlayer.volume = 4
//        musicPlayer.numberOfLoops = -1
//        musicPlayer.play()
//    }
    
    
    
    
    
    
    func handleApplicationWillResignActive (note: NSNotification) {
        
        let skView = self.view as! SKView
        skView.paused = true
    }
    
    func handleApplicationDidBecomeActive (note: NSNotification) {
        
        let skView = self.view as! SKView
        skView.paused = false
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.LandscapeLeft
    }
    /*
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
    return .AllButUpsideDown
    } else {
    return .All
    }
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
