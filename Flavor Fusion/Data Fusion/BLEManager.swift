//
//  BLEManager.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 5/11/24.
//

import Foundation
import CoreBluetooth

// BLEManager class responsible for managing Bluetooth Low Energy (BLE) communication with Arduino
class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // Properties
    var centralManager: CBCentralManager! // Central manager responsible for scanning and connecting to peripherals
    var peripheral: CBPeripheral! // Peripheral device (Arduino)
    var motorControlCharacteristic: CBCharacteristic! // Characteristic for controlling the motor
    var recipeDoneCharacteristic: CBCharacteristic! // Characteristic indicating the recipe is done
    @Published var isConnected = false // Published property to track connection status
    
    // Initialization
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil) // Initialize central manager
        centralManager.delegate = self
    }
    
    // CBCentralManagerDelegate method called when Bluetooth state changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil) // Start scanning for peripherals
        } else {
            print("Bluetooth is not available")
        }
    }
    
    // CBCentralManagerDelegate method called when a peripheral is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.peripheral.delegate = self
        centralManager.stopScan() // Stop scanning
        centralManager.connect(peripheral, options: nil) // Connect to the discovered peripheral
    }
    
    // CBCentralManagerDelegate method called when peripheral is connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true // Update connection status
        peripheral.discoverServices(nil) // Discover services of the connected peripheral
    }
    
    // CBPeripheralDelegate method called when services are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service) // Discover characteristics of each service
            }
        }
    }
    
    // CBPeripheralDelegate method called when characteristics are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Discovered characteristic: \(characteristic.uuid)")
                // Check for specific characteristics
                if characteristic.uuid == CBUUID(string: "19B10001-E8F2-537E-4F6C-D104768A1214") {
                    motorControlCharacteristic = characteristic // Assign motor control characteristic
                    print("Motor control characteristic found")
                } else if characteristic.uuid == CBUUID(string: "YourRecipeDoneCharacteristicUUID") {
                    recipeDoneCharacteristic = characteristic // Assign recipe done characteristic
                    peripheral.setNotifyValue(true, for: characteristic) // Subscribe to notifications
                    print("Recipe done characteristic found")
                }
            }
        } else {
            print("Error discovering characteristics: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    // CBPeripheralDelegate method called when characteristic value is updated
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic == recipeDoneCharacteristic {
            // Handle recipe done signal received from Arduino
            if let data = characteristic.value {
                // Decode the received data, if needed
                // Example: let signal = String(data: data, encoding: .utf8)
                
                // Call the function to handle the recipe done signal
                handleRecipeDoneSignal()
            }
        }
    }
    
    // Send recipe to Arduino
    func sendRecipe(_ recipe: Recipe) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(recipe)
            if let characteristic = motorControlCharacteristic {
                peripheral.writeValue(data, for: characteristic, type: .withResponse)
                print("Sent recipe to Arduino")
            } else {
                print("Error: Motor control characteristic is nil.")
            }
        } catch {
            print("Error encoding recipe: \(error.localizedDescription)")
        }
    }
    
    // Save recipe to device (to be implemented)
    func saveRecipeToDevice() {
        // To be implemented
    }
    
    // Handle recipe done signal received from Arduino
    func handleRecipeDoneSignal() {
        print("Recipe done signal received from Arduino")
        // Add any actions you want to perform when the recipe is done being mixed
    }
}
