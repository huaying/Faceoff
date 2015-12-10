//
//  BTAdvertise.swift
//  bt
//
//  Created by Huaying Tsai on 12/9/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BTAdvertise: NSObject, CBPeripheralManagerDelegate, CBPeripheralDelegate {
    
    var peripheralManager: CBPeripheralManager!
    var service = CBMutableService(type: BLEServiceUUID, primary: true)
    var characteristic: CBMutableCharacteristic!
    
    override init() {
        super.init()
        let peripheralQueue = dispatch_queue_create("huaying.faceoff", DISPATCH_QUEUE_SERIAL)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: peripheralQueue)
        
    }
    
    //Custom data sending handler
    func update(key: String, data: [String: String] = [String:String]()){
        
        var needToBeSend = false
        var stringOfData = ""
        
        if key == "location" {
            stringOfData = key + " " + data["x"]! + " " + data["y"]!
        }
        else if key == "pause" {
            stringOfData = key
        }
            
        else if key == "resume" {
            stringOfData = key
        }
            
        else if key == "hp" {
            stringOfData = key + " " + data["hp"]!
            print("hp",data["hp"])
            if data["hp"] == "0" {
                needToBeSend = true
            }
        }
            
        else if key == "mp" {
            stringOfData = key + " " + data["mp"]!
        }
            
        else if key == "weapon" {
            needToBeSend = true
            stringOfData = key + " " + data["weapon"]!
        }
            
        else if key == "fire-bullet" {
            stringOfData = key + " " + data["x"]!
        }
        else if key == "fire-multibullet" {
            stringOfData = key + " " + data["x"]!
        }
        else if key == "fire-laser" {
            stringOfData = key + " " + data["x"]! + " " + data["laserWidth"]!
        }
        else if key == "character-image" {
            needToBeSend = true
            stringOfData = key + " " + data["chunkNum"]! + " " + data["chunkData"]!
        }
        else if key == "character-image-finish" {
            needToBeSend = true
            stringOfData = key
        }
            
        else if key == "character-image-ready"  {
            needToBeSend = true
            stringOfData = key
        }
            //beginFight is not useful
        else if key == "beginFight"  {
            needToBeSend = true
            stringOfData = key
        }
        
        
        if stringOfData != "" {
            let _data = stringOfData.dataUsingEncoding(NSUTF8StringEncoding)
            if needToBeSend {
                while(!self.peripheralManager.updateValue(_data!, forCharacteristic: self.characteristic, onSubscribedCentrals: nil)){
                    //print(data["chunkNum"]!,"retry",++i)
                }
            } else {
                self.peripheralManager.updateValue(_data!, forCharacteristic: self.characteristic, onSubscribedCentrals: nil)
            }
        }
    }
    
    func updateInfo(stringOfData: String) -> Bool{
        let _data = stringOfData.dataUsingEncoding(NSUTF8StringEncoding)
        return peripheralManager.updateValue(_data!, forCharacteristic: self.characteristic, onSubscribedCentrals: nil)
    }
    
    
    func peripheralManagerDidUpdateState(peripheral:CBPeripheralManager) {
        
        switch peripheral.state {
            
        case .PoweredOff:
            print("Peripheral - CoreBluetooth BLE hardware is powered off")
            break
        case .PoweredOn:
            print("BTAdvertise: CoreBluetooth BLE hardware is powered on and ready")
            
            let properties = CBCharacteristicProperties.Notify.union(CBCharacteristicProperties.Read).union(CBCharacteristicProperties.Write)
            
            let permissions = CBAttributePermissions.Readable.union( CBAttributePermissions.Writeable)
            self.characteristic = CBMutableCharacteristic(type: PositionCharUUID, properties: properties,
                value: nil, permissions: permissions)
            
            service.characteristics = [characteristic]
            self.peripheralManager.addService(service)
            
            break
        case .Resetting:
            print("Peripheral - CoreBluetooth BLE hardware is resetting")
            break
        case .Unauthorized:
            print("Peripheral - CoreBluetooth BLE state is unauthorized")
            break
        case .Unknown:
            print("Peripheral - CoreBluetooth BLE state is unknown")
            break
        case .Unsupported:
            print("Peripheral - CoreBluetooth BLE hardware is unsupported on this platform")
            break
        }
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        
        if (error != nil) {
            print("BTAdvertise: addService Failed！ error: \(error)")
            return
        }
        
        print("BTAdvertise: addService success！")
        
        self.peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[BLEServiceUUID],CBAdvertisementDataLocalNameKey:UIDevice.currentDevice().name])
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager,
        error: NSError?){
            
            if error == nil {
                print("BTAdvertise: Successfully started advertising our beacon data")
            }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
        print("BTAdvertise: Received wirteValue from Central!!")
        
        for obj in requests {
            if let request:CBATTRequest = obj {
                let name = NSString(data:request.value!, encoding:NSUTF8StringEncoding)! as String
                
                //print(name)
                btDiscoverySharedInstance.connect(name)
            NSNotificationCenter.defaultCenter().postNotificationName("allSet", object: self, userInfo: nil)
            }
        }
        
    }
    
}