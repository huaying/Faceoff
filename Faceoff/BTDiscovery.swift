//
//  BTDiscovery.swift
//  bt
//
//  Created by Huaying Tsai on 12/9/15.
//  Copyright © 2015 huaying. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

/* Services & Characteristics UUIDs */
let BLEServiceUUID = CBUUID(string: "035A7775-49AA-42BD-BBDB-E2AE77782966")
//let BLEServiceUUID = CBUUID(string: "025A7775-49AA-42BD-BBDB-E2AE77782969")
let PositionCharUUID = CBUUID(string: "F48A2C23-BC54-40FC-BED0-60EDDA139F47")
//let PositionCharUUID = CBUUID(string: "F38A2C23-BC54-40FC-BED0-60EDDA139F49")

class BTDiscovery: NSObject, CBCentralManagerDelegate {
    
    private var centralManager: CBCentralManager?
    var peripheralBLE: CBPeripheral?
    var peers = [String:CBPeripheral]()
    var btService: BTService?
    var isConnectedToOthers = false
    
    override init(){
        super.init()
        
        let centralQueue = dispatch_queue_create("huaying.faceoff", DISPATCH_QUEUE_SERIAL)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
        
        
    }
    
    func startScanning(){
        if let central = centralManager {
            central.scanForPeripheralsWithServices([BLEServiceUUID], options: nil)
        }
    }
    
    func connectToPeripheral(peripheral: CBPeripheral){
        if !isConnectedToOthers {
            centralManager!.connectPeripheral(peripheral, options: nil)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("BTDiscovery: cetralManager discover peripheral")
        
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            
            
                peers[name] = peripheral
                
                let peersInfo = ["peers": Array(peers.keys)]
            NSNotificationCenter.defaultCenter().postNotificationName("foundPeer", object: self, userInfo: peersInfo)
                
                peripheralBLE = peripheral
            
        }
        
    }
    
    func connect(peerName: String){
        connectToPeripheral(peers[peerName]!)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("BTDiscovery: connectPeripheral success")
        
        isConnectedToOthers = true
        btService = BTService(initWithPeripheral: peripheral)
        central.stopScan()
        
        
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("disconnect")
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        switch (central.state) {
            
        case CBCentralManagerState.PoweredOff:
            //self.clearDevices()
            break
            
        case CBCentralManagerState.Unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case CBCentralManagerState.Unknown:
            // Wait for another event
            break
            
        case CBCentralManagerState.PoweredOn:
            self.startScanning()
            break
            
        case CBCentralManagerState.Resetting:
            //self.clearDevices()
            break
            
        case CBCentralManagerState.Unsupported:
            break
        }
    }
    
    
}