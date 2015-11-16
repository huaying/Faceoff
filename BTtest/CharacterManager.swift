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
        static let keyOfCandidateNumber = "keyOfCandidateNumber"
        static let keyOfPickedCharacterNumber = "keyOfPickedCharacterNumber"
    }
    static let maxOfCandidateNumber = 3
    
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
    
    static func getCharacterFromLocalStorage() -> UIImage?{
        //return getImageFromLocalStorage("User_Image")
        let numberOfCandidateCharacter = getCandidateCharacterNumber()
        let i = (numberOfCandidateCharacter - 1 + maxOfCandidateNumber) % maxOfCandidateNumber
        return getImageFromLocalStorage("Candidate\(i)")
    }
    
    static func getCharacterFromLocalStorage(index: Int) -> UIImage? {
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
    
    static func saveCandidateCharacterToLocalStorage(image: UIImage){
        
        self.saveImageToLocalStorage("Candidate\(self.getCandidateCharacterNumber())",image: image)
        //self.saveCharacterToLocalStorage(image)
        self.increaseCandidateCharacterNumber()
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
            return 0
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
    
    static func setCandidateCharacterNumber(number: Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setInteger(number, forKey: localStorageKeys.keyOfCandidateNumber)
        defaults.synchronize()
    }
    
    static func getCandidateCharacterNumber() -> Int{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let candidateNumber: Int = defaults.integerForKey(localStorageKeys.keyOfCandidateNumber){
            return candidateNumber
        }
        return 0
    }
    
    //increase with loop mode (3)
    static func increaseCandidateCharacterNumber() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let candidateNumber: Int = defaults.integerForKey(localStorageKeys.keyOfCandidateNumber){
            if candidateNumber == maxOfCandidateNumber-1 {
                defaults.setInteger(0, forKey: localStorageKeys.keyOfCandidateNumber)
            }else{
                defaults.setInteger(candidateNumber + 1, forKey: localStorageKeys.keyOfCandidateNumber)
            }
        }else{
            defaults.setInteger(1, forKey: localStorageKeys.keyOfCandidateNumber)
        }
    }
    

}