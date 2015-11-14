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
    }
    static let maxOfCandidateNumber = 3
    
    static func getCandidateCharactersFromLocalStorage() -> [UIImage] {
        var imagePool:[UIImage] = []
        let numberOfCandidateCharacter = getCandidateCharacterNumber()
        for i in 0..<maxOfCandidateNumber {
            
            let currentI = (numberOfCandidateCharacter + i) % maxOfCandidateNumber
            
            if let image = getImageFromLocalStorage("Candidate\(currentI)") {
                imagePool.append(image)
            }
        }
        return imagePool.reverse()
    }
    
    static func getCharacterFromLocalStorage() -> UIImage?{
        //return getImageFromLocalStorage("User_Image")
        let numberOfCandidateCharacter = getCandidateCharacterNumber()
        let i = (numberOfCandidateCharacter - 1 + maxOfCandidateNumber) % maxOfCandidateNumber
        return getImageFromLocalStorage("Candidate\(i)")
    }
    
    static func getImageFromLocalStorage(imageName: String) -> UIImage? {
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // Check file saved successfully
        let getImagePath = (paths as NSString).stringByAppendingPathComponent("\(imageName).png")
    
        if (fileManager.fileExistsAtPath(getImagePath)){
            print("FILE AVAILABLE")
            //Pick Image and Use accordingly
            let image: UIImage = UIImage(contentsOfFile: getImagePath)!
            // let data: NSData = UIImagePNGRepresentation(imageis)
            return image
        }else{
            print("FILE NOT AVAILABLE")
            return nil
        }

    }
    
    static func saveCharacterToLocalStorage(image: UIImage){
        
        //self.saveImageToLocalStorage("User_Image",image: image)
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
    
    static func rearrageCandidateCharacters(freshCharacterIndex: Int){
        
    }
}