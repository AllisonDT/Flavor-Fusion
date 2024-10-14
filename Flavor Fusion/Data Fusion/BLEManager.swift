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
    @Published var isOrderMixed: Bool = false   // Track whether the spice blend is done being mixed
    @Published var isTrayEmpty: Bool = true    // Track whether the tray is empty

    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var dataCharacteristic: CBCharacteristic?

    var spiceDataViewModel: SpiceDataViewModel

    // HM-10 module UUIDs
    let spiceServiceUUID = CBUUID(string: "FFE0")       // HM-10's service UUID
    let dataCharacteristicUUID = CBUUID(string: "FFE1") // HM-10's data characteristic UUID

    // Specific peripheral UUID
    let targetPeripheralUUID = UUID(uuidString: "CA64A7F2-3E78-05AA-1784-4AF73E3029E3")

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
            // Attempt to retrieve the peripheral with the specific UUID
            if let targetUUID = targetPeripheralUUID {
                let retrievedPeripherals = centralManager.retrievePeripherals(withIdentifiers: [targetUUID])
                if let peripheral = retrievedPeripherals.first {
                    print("Retrieved peripheral with UUID: \(peripheral.identifier)")
                    connectedPeripheral = peripheral
                    peripheral.delegate = self
                    centralManager.connect(peripheral, options: nil)
                    return
                }
            }

            // If not found, start scanning
            print("Starting scan for peripherals...")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available.")
            useExampleDataIfNeeded()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown") with RSSI: \(RSSI)")

        // Check if this is the target peripheral
        if peripheral.identifier == targetPeripheralUUID {
            connectedPeripheral = peripheral
            centralManager.stopScan()
            print("Stopped scanning. Connecting to peripheral: \(peripheral.name ?? "Unknown")")
            centralManager.connect(peripheral, options: nil)
        } else {
            print("Peripheral UUID \(peripheral.identifier) does not match target UUID.")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown"). Discovering services...")
        peripheral.delegate = self
        peripheral.discoverServices([spiceServiceUUID])
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
        // Example messages: "ORDER_MIXED:1", "TRAY_EMPTY:0"
        if message.hasPrefix("ORDER_MIXED:") {
            let value = message.replacingOccurrences(of: "ORDER_MIXED:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            DispatchQueue.main.async { [weak self] in
                self?.isOrderMixed = (value == "1")
                print("Order mixed status updated: \((value == "1"))")
            }
        } else if message.hasPrefix("TRAY_EMPTY:") {
            let value = message.replacingOccurrences(of: "TRAY_EMPTY:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            DispatchQueue.main.async { [weak self] in
                self?.isTrayEmpty = (value == "1")
                print("Tray empty status updated: \((value == "1"))")
            }
        } else {
            print("Unknown message received: \(message)")
        }
    }

    // MARK: - Data Sending Method

    func sendSpiceDataToPeripheral(data: Data) {
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
