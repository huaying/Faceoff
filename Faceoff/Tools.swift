//
//  Tools.swift
//  Faceoff
//
//  Created by Huaying Tsai on 11/21/15.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation

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
 
}