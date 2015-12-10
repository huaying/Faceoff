//
//  BTService.swift
//  bt
//
//  Created by Huaying Tsai on 12/9/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BTService: NSObject, CBPeripheralDelegate {
    
    var peripheral: CBPeripheral?
    var positionCharacteristic: CBCharacteristic?
    
    init(initWithPeripheral peripheral: CBPeripheral) {
        super.init()
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        
        startDiscoveringService()
    }
    
    func startDiscoveringService(){
        print("BTService: start discovering")
        self.peripheral?.discoverServices([BLEServiceUUID])
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        print("BTService: discover services")
        for service in peripheral.services! {
            if service.UUID == BLEServiceUUID {
                peripheral.discoverCharacteristics([PositionCharUUID], forService: service )
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("BTService: discover characteristics")
        if(service.UUID == BLEServiceUUID){
            for characteristic in service.characteristics! {
                if characteristic.UUID == PositionCharUUID {
                    self.positionCharacteristic = characteristic
                    
                    peripheral.setNotifyValue(true, forCharacteristic: self.positionCharacteristic!)
                    
                    let name = UIDevice.currentDevice().name.dataUsingEncoding(NSUTF8StringEncoding)
                    peripheral.writeValue(name!, forCharacteristic: self.positionCharacteristic!, type: CBCharacteristicWriteType.WithResponse)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("allSet", object: self, userInfo: nil)
                }
            }
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral,
        didUpdateValueForCharacteristic characteristic: CBCharacteristic,
        error: NSError?)
    {
        let out = NSString(data:characteristic.value!, encoding:NSUTF8StringEncoding)! as String
        
        if (error != nil) {
            print("BTService: receive updateValue Fail \(error)")
            return
        }
        
        print(out)
        var outArray = out.characters.split { $0 == " " }.map { String($0) }
        
    NSNotificationCenter.defaultCenter().postNotificationName("getInfoOfEnemy", object: self, userInfo: [outArray.removeFirst():outArray])
        
    }
    
    func peripheral(peripheral: CBPeripheral,
        didWriteValueForCharacteristic characteristic: CBCharacteristic,
        error: NSError?)
    {
    }
    
}