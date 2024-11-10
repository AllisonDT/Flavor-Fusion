//
//  BLEManager.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 5/11/24.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isBluetoothConnected: Bool = false // Track Bluetooth connection status
    @Published var isDataRetrievedViaBluetooth: Bool = false
    @Published var isOrderMixed: Bool = false   // Track whether the spice blend is done being mixed
    @Published var isTrayEmpty: Bool = {
        if UserDefaults.standard.object(forKey: "isTrayEmpty") == nil {
            UserDefaults.standard.set(true, forKey: "isTrayEmpty") // Set to empty on first launch
        }
        return UserDefaults.standard.bool(forKey: "isTrayEmpty")
    }()

    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var dataCharacteristic: CBCharacteristic?

    var spiceDataViewModel: SpiceDataViewModel

    let spiceServiceUUID = CBUUID(string: "FFE0")
    let dataCharacteristicUUID = CBUUID(string: "FFE1")
    let targetPeripheralName = "HMSoft"  // The specific peripheral name you're expecting

    init(spiceDataViewModel: SpiceDataViewModel) {
        self.spiceDataViewModel = spiceDataViewModel
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Central Manager initialized.")
    }

    // MARK: - CBCentralManagerDelegate Methods

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central Manager did update state: \(central.state.rawValue)")
        
        if central.state == .poweredOn {
            print("Bluetooth is powered on.")
            // Start scanning for peripherals
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            isBluetoothConnected = false // Reset connection status if Bluetooth is not available
        }
        
        useExampleDataIfNeeded() // Handle fallback data if Bluetooth is not connected
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Check if the discovered peripheral matches the one you're looking for
        if let peripheralName = peripheral.name, peripheralName == targetPeripheralName {
            connectedPeripheral = peripheral
            centralManager.stopScan()  // Stop scanning once the peripheral is found
            centralManager.connect(peripheral, options: nil)  // Connect to the target peripheral
        } else {
            print("Discovered peripheral: \(peripheral.name ?? "Unknown") does not match the target.")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Only update the connection status if connected to your specific peripheral
        if peripheral.name == targetPeripheralName {
            print("Connected to target peripheral: \(peripheral.name ?? "Unknown")")
            isBluetoothConnected = true // Set connected status only for your module
            peripheral.delegate = self
            peripheral.discoverServices([spiceServiceUUID])
        } else {
            isBluetoothConnected = false // Ensure connection status is false for other devices
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral: \(peripheral.name ?? "Unknown").")
        isBluetoothConnected = false // Update connection status when disconnected
        
        // Automatically restart scanning for the peripheral
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Delay a bit before rescanning
            print("Reconnecting... Restarting scan for peripherals.")
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    // MARK: - CBPeripheralDelegate Methods

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
                    peripheral.discoverCharacteristics([dataCharacteristicUUID], for: service)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        print("Discovered characteristics for service: \(service.uuid).")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Characteristic UUID: \(characteristic.uuid)")
                if characteristic.uuid == dataCharacteristicUUID {
                    print("Enabling notifications for characteristic: \(characteristic.uuid)")
                    peripheral.setNotifyValue(true, for: characteristic)
                    self.dataCharacteristic = characteristic // Store the characteristic
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }

        if let data = characteristic.value {
            isDataRetrievedViaBluetooth = true
            // Process data on a background thread to avoid UI lag
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.processData(characteristic: characteristic, data: data)
            }
        } else {
            useExampleDataIfNeeded()
        }
    }

    // MARK: - Data Processing Methods

    private func processData(characteristic: CBCharacteristic, data: Data) {
        if characteristic.uuid == dataCharacteristicUUID {
            if let message = String(data: data, encoding: .utf8) {
                print("Received message: \(message)")
                // Process the message
                parseMessage(message)
            } else {
                print("Failed to decode data as UTF-8 string.")
            }
        }
    }

    private func parseMessage(_ message: String) {
        // Remove any trailing characters after "#" to clean up the message
        let cleanMessage = message.components(separatedBy: "#").first ?? message

        // Example messages: "ORDER_MIXED:1", "TRAY_EMPTY:0"
        if cleanMessage.hasPrefix("ORDER_MIXED:") {
            let value = cleanMessage.replacingOccurrences(of: "ORDER_MIXED:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            DispatchQueue.main.async { [weak self] in
                self?.isOrderMixed = (value == "1")
                print("Order mixed status updated: \((value == "1"))")
            }
        }
        if cleanMessage.hasPrefix("TRAY_EMPTY:") {
            let value = cleanMessage.replacingOccurrences(of: "TRAY_EMPTY:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            let isEmpty = (value == "1")
            DispatchQueue.main.async { [weak self] in
                self?.isTrayEmpty = isEmpty
                UserDefaults.standard.set(isEmpty, forKey: "isTrayEmpty") // Save to UserDefaults
                print("Tray empty status updated: \(isEmpty)")
            }
        }
    }

    // MARK: - Data Sending Method

    func sendSpiceDataToPeripheral(data: Data) {
        isOrderMixed = false
        guard let peripheral = connectedPeripheral else {
            print("No connected peripheral to send data to.")
            return
        }

        guard let dataCharacteristic = self.dataCharacteristic else {
            print("Data characteristic not found.")
            return
        }

        let chunkSize = 20  // BLE characteristic size limit
        var offset = 0

        while offset < data.count {
            let chunkLength = min(chunkSize, data.count - offset)
            let chunk = data.subdata(in: offset..<offset + chunkLength)

            // Send this chunk over Bluetooth
            peripheral.writeValue(chunk, for: dataCharacteristic, type: .withoutResponse)
            print("Sending chunk: \(String(data: chunk, encoding: .utf8) ?? "Error")")

            offset += chunkLength
            // Sleep briefly to prevent overwhelming the peripheral
            usleep(10000) // Sleep for 10ms
        }

        print("All data has been sent.")
    }

    // MARK: - Helper Methods

    private func useExampleDataIfNeeded() {
        if !isDataRetrievedViaBluetooth {
            print("Using example data as no Bluetooth data was retrieved.")
            // Provide example data to spiceDataViewModel if necessary
        }
    }
}
