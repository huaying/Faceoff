//
//  CharacterManager.swift
//  BTtest
//
//  Created by Huaying Tsai on 11/10/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import UIKit
import Foundation

class CharacterManager {
    
    enum localStorageKeys {
        static let keyOfPickedCharacterNumber = "keyOfPickedCharacterNumber"
    }
    
    static let maxOfCandidateNumber = Constants.CharacterManager.maxOfCandidateNumber
    
    static func getCandidateCharactersFromLocalStorage() -> [UIImage?] {
        var imagePool:[UIImage?] = []
        for i in 0..<maxOfCandidateNumber {
            if let image = getImageFromLocalStorage("Candidate\(i)") {
                imagePool.append(image)
            }else{
                imagePool.append(nil)
            }
        }
        return imagePool
    }
    
    static func getCharacterFromLocalStorage(index: Int = maxOfCandidateNumber - 1) -> UIImage? {
        return getImageFromLocalStorage("Candidate\(index)")
    }
    
    static func getPickedCharacterFromLocalStorage() -> UIImage?{
        let pickedId = getPickedCharacterNumber()
        return getImageFromLocalStorage("Candidate\(pickedId)")
    }
    
    static func deleteCharacterFromLocalStorage(index: Int) {
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let getImagePath = (paths as NSString).stringByAppendingPathComponent("Candidate\(index).png")
        
        do {
            try fileManager.removeItemAtPath(getImagePath)
            print("File \(getImagePath) is deleted")

        }catch{
            print("File \(getImagePath) cannot be deleted")
        }
    }
    
    static func getImageFromLocalStorage(imageName: String) -> UIImage? {
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // Check file saved successfully
        let getImagePath = (paths as NSString).stringByAppendingPathComponent("\(imageName).png")
    
        if (fileManager.fileExistsAtPath(getImagePath)){
            print("File \(getImagePath) is available")
            let image: UIImage = UIImage(contentsOfFile: getImagePath)!
            return image
        }else{
            print("File \(getImagePath) is not available")
            return nil
        }
    }
    
    static func saveCandidateCharacterToLocalStorage(image: UIImage, index: Int){
        self.saveImageToLocalStorage("Candidate\(index)",image: image)
        setPickedCharacterNumber(index)
    }
    
    static func saveImageToLocalStorage(imageName: String, image: UIImage){
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let filePathToWrite = "\(paths)/"+imageName+".png"
    
        let imageData: NSData = UIImagePNGRepresentation(image)!
        
        fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
    }
    
    
    static func setPickedCharacterNumber(number: Int){
        setLocalValue(localStorageKeys.keyOfPickedCharacterNumber, value: number)
    }
    
    static func getPickedCharacterNumber() -> Int {
        if let number = getLocalValue(localStorageKeys.keyOfPickedCharacterNumber) as? Int {
            return number
        }else{
            return maxOfCandidateNumber - 1
        }
    }
    
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

}