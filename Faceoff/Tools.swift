//
//  Tools.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/21/15.
//  Copyright © 2015 Liang. All rights reserved.
//


import UIKit
import GLKit
import SpriteKit
import Foundation
import AVFoundation



class Tools {
    
    static func getLocalValue(key :String) -> AnyObject?{
        let defaults = NSUserDefaults.standardUserDefaults()
        if let value: AnyObject = defaults.objectForKey(key){
            return value
        }
        return nil
    }
    
    
    static func setLocalValue(key :String,value :AnyObject){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
    
    static func dictionaryToNSData(dictionary: NSDictionary) -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(dictionary)
    }
    
    static func NSDataToDictionary(nsdata: NSData) -> NSDictionary?{
        return NSKeyedUnarchiver.unarchiveObjectWithData(nsdata) as? NSDictionary
    }

    static func playSound(audioName: String, node: SKNode){
        let sound = SKAction.playSoundFileNamed(audioName, waitForCompletion: false)
        node.runAction(sound,withKey: "soundPlay")
    }
    static func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    static func cropImageToCircle(image: UIImage) -> UIImage{
        let imageView = UIImageView(frame: CGRectMake(0,0,image.size.height,image.size.height))
        imageView.image = image
        imageView.contentMode = .Center
        imageView.layer.cornerRadius = image.size.height/2;
        imageView.layer.masksToBounds = true
        
        var layer1: CALayer = CALayer()
        
        layer1 = imageView.layer
        UIGraphicsBeginImageContext(CGSize(width:image.size.height,height:image.size.height))
        layer1.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    static func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        let url = NSBundle.mainBundle().URLForResource(file as String, withExtension: type as String)
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url!)
        } catch {
            print("NO AUDIO PLAYER")
        }
        
        return audioPlayer!
    }
    
    static func setupBGM(){
        
        musicPlayer = Tools.setupAudioPlayerWithFile("BGM", type: "wav")
        musicPlayer.volume = 0.6
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
        
    }

    static func setupStartBGM(){
        
        musicPlayer = Tools.setupAudioPlayerWithFile("startBGM", type: "wav")
        musicPlayer.volume = 3
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
        
    }

   
    static func pauseBackgroundMusic() {
        if let player = musicPlayer {
            if player.playing {
                player.pause()
            }
        }
    }
    
    static func resumeBackgroundMusic() {
        if let player = musicPlayer {
            if !player.playing {
                player.play()
            }
        }
    }
    
    static func restartBackgroundMusic() {
        if let player = musicPlayer {
            if !player.playing {
                player.currentTime = 0
                player.play()
            }
        }
    }

    

}
