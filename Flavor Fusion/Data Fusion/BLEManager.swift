//
//  BLEManager.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 5/11/24.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isDataRetrievedViaBluetooth: Bool = false
    @Published var isOrderMixed: Bool = false  // Track whether the spice blend is done being mixed
    @Published var isTrayEmpty: Bool = false   // New: Track whether the tray is empty
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    
    var spiceDataViewModel: SpiceDataViewModel

    // Define your service and characteristic UUIDs
    let spiceServiceUUID = CBUUID(string: "180C")
    let serializedIngredientsCharacteristicUUID = CBUUID(string: "2A58")
    let spiceMixedCharacteristicUUID = CBUUID(string: "2A59")  // UUID for spice mixed status
    let trayStatusCharacteristicUUID = CBUUID(string: "19B10002-E8F2-537E-4F6C-D104768A1214")  // New: UUID for tray status

    init(spiceDataViewModel: SpiceDataViewModel) {
        self.spiceDataViewModel = spiceDataViewModel
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Consider checking the state after initialization
        if centralManager.state == .poweredOn {
            // Start scanning or take necessary action
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Bluetooth is available
            centralManager.scanForPeripherals(withServices: [spiceServiceUUID], options: nil)
        case .poweredOff:
            print("Bluetooth is powered off. Please turn it on.")
        case .unauthorized:
            print("This app is not authorized to use Bluetooth.")
        case .unsupported:
            print("Bluetooth is not supported on this device.")
        case .resetting:
            print("Bluetooth is resetting. Please wait.")
        case .unknown:
            print("Bluetooth state is unknown.")
        @unknown default:
            print("A new state was added that is not handled.")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown") with RSSI: \(RSSI)")
        connectedPeripheral = peripheral
        centralManager.stopScan()
        print("Stopped scanning. Connecting to peripheral: \(peripheral.name ?? "Unknown")")
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown"). Discovering services...")
        peripheral.delegate = self
        peripheral.discoverServices([spiceServiceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        print("Discovered services for peripheral: \(peripheral.name ?? "Unknown").")
        if let services = peripheral.services {
            for service in services {
                print("Service UUID: \(service.uuid)")
                if service.uuid == spiceServiceUUID {
                    print("Found spice service. Discovering characteristics...")
                    peripheral.discoverCharacteristics([serializedIngredientsCharacteristicUUID, spiceMixedCharacteristicUUID, trayStatusCharacteristicUUID], for: service)  // Add trayStatusCharacteristicUUID
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        print("Discovered characteristics for service: \(service.uuid).")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Characteristic UUID: \(characteristic.uuid)")
                if characteristic.uuid == spiceMixedCharacteristicUUID || characteristic.uuid == trayStatusCharacteristicUUID {
                    print("Enabling notifications for characteristic: \(characteristic.uuid)")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }
        
        // print("Received update for characteristic: \(characteristic.uuid).")
        if let data = characteristic.value {
            // print("Data received: \(data as NSData)")
            isDataRetrievedViaBluetooth = true
            
            // Process data on a background thread to avoid UI lag
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.processData(characteristic: characteristic, data: data)
            }
        } else {
            print("No data received. Using example data.")
            useExampleDataIfNeeded()
        }
    }

    private func processData(characteristic: CBCharacteristic, data: Data) {
        if characteristic.uuid == spiceMixedCharacteristicUUID {
            // Process the boolean data for spice mixed status
            let isMixed = data[0] != 0
            // print("Processed boolean: is order mixed? \(isMixed)")
            
            // Update UI on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.isOrderMixed = isMixed
                // print("Order mixed status updated: \(isMixed)")
            }
        } else if characteristic.uuid == trayStatusCharacteristicUUID {
            // Process the boolean data for tray status
            let trayEmpty = data[0] != 0
            // print("Processed boolean: is tray empty? \(trayEmpty)")
            
            // Update UI on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.isTrayEmpty = trayEmpty
                // print("Tray empty status updated: \(trayEmpty)")
            }
        }
    }

    private func completeDataTransfer() {
        // Stop notifications
        if let peripheral = connectedPeripheral {
            if let characteristics = peripheral.services?.first(where: { $0.uuid == spiceServiceUUID })?.characteristics {
                for characteristic in characteristics {
                    print("Disabling notifications for characteristic: \(characteristic.uuid)")
                    peripheral.setNotifyValue(false, for: characteristic)
                }
            }
        }
        
        print("All data processed. UI should be updated accordingly.")
    }

    func sendSpiceDataToPeripheral(data: Data) {
        guard let peripheral = connectedPeripheral else {
            print("No connected peripheral to send data to.")
            return
        }
        
        if let serializedIngredientsCharacteristic = getCharacteristic(peripheral: peripheral, uuid: serializedIngredientsCharacteristicUUID) {
            let chunkSize = 20  // Adjust as necessary for your Bluetooth characteristic size
            var offset = 0
            
            while offset < data.count {
                let chunkLength = min(chunkSize, data.count - offset)
                let chunk = data.subdata(in: offset..<offset + chunkLength)
                
                // Send this chunk over Bluetooth
                peripheral.writeValue(chunk, for: serializedIngredientsCharacteristic, type: .withResponse)
                print("Sending chunk: \(String(data: chunk, encoding: .utf8) ?? "Error")")
                
                offset += chunkLength
            }
            
            print("All data has been sent.")
            
        } else {
            print("Could not find characteristic to send serialized ingredients data.")
        }
    }
    
    private func getCharacteristic(peripheral: CBPeripheral, uuid: CBUUID) -> CBCharacteristic? {
        return peripheral.services?
            .first(where: { $0.uuid == spiceServiceUUID })?
            .characteristics?
            .first(where: { $0.uuid == uuid })
    }
    
    private func useExampleDataIfNeeded() {
        if !isDataRetrievedViaBluetooth {
            print("Using example data as no Bluetooth data was retrieved.")
            // Provide example data to spiceDataViewModel if necessary
        }
    }
}
