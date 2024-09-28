//
// SpiceData.swift
// Flavor Fusion
//
// Created by Allison Turner on 2/5/24.
//

import Foundation
import Combine
import CloudKit

// Spice Data Model
public struct Spice: Identifiable, Equatable, Hashable, Encodable, Decodable {
    public var id: UUID
    public var name: String
    public var spiceAmount: Double
    public var isSelected: Bool
    public var containerNumber: Int
    public var selectedAmount: Double
    public var unit: String
    public var amountInGrams: Double // This field will no longer be used for conversions

    // Initialization with default values
    public init(name: String = "Spice", spiceAmount: Double = 0.0, unit: String = "oz", containerNumber: Int) {
        self.id = UUID()
        self.name = name
        self.spiceAmount = (spiceAmount * 100).rounded() / 100 // Round to two decimals
        self.isSelected = false
        self.containerNumber = containerNumber
        self.selectedAmount = 0.0
        self.unit = unit
        self.amountInGrams = 0.0
    }
    
    // Function to update the spice amount and unit directly
    public mutating func updateSpiceAmount(amount: Double, unit: String) {
        self.spiceAmount = (amount * 100).rounded() / 100 // Round to two decimals
        self.unit = unit
    }
}

// SpiceDataViewModel
public class SpiceDataViewModel: ObservableObject {
    @Published public var spices: [Spice] = []
    private let iCloudStore = NSUbiquitousKeyValueStore.default
    private let userDefaultsKey = "savedSpices"

    public init() {
        self.spices = []
        self.loadSpices()
        NotificationCenter.default.addObserver(self, selector: #selector(icloudStoreDidChange), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: iCloudStore)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func icloudStoreDidChange(notification: NSNotification) {
        self.loadSpicesFromiCloud()
    }
    
    // Save spices to both UserDefaults and iCloud
    public func saveSpices() {
        if let encoded = try? JSONEncoder().encode(spices) {
            // Save to UserDefaults
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("Spices saved successfully to UserDefaults.")
            
            // Save to iCloud
            iCloudStore.set(encoded, forKey: userDefaultsKey)
            iCloudStore.synchronize()
            print("Spices saved successfully to iCloud.")
        } else {
            print("Failed to encode and save spices.")
        }
    }
    
    // Load spices from UserDefaults first, then iCloud if not available
    public func loadSpices() {
        if let savedSpices = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedSpices = try? JSONDecoder().decode([Spice].self, from: savedSpices) {
            self.spices = decodedSpices
            spiceData = decodedSpices
            // print("Spices loaded from UserDefaults: \(spices)")
        } else {
            print("No saved spices found in UserDefaults. Attempting to load from iCloud.")
            loadSpicesFromiCloud()
        }
        
        // Ensure spices array has container numbers 1-10
        ensureDefaultSpices()
    }
    
    // Load spices from iCloud
    public func loadSpicesFromiCloud() {
        if let savedSpicesData = iCloudStore.data(forKey: userDefaultsKey),
           let decodedSpices = try? JSONDecoder().decode([Spice].self, from: savedSpicesData) {
            self.spices = decodedSpices
            spiceData = decodedSpices
            print("Spices loaded from iCloud: \(spices)")
            
            // Save to UserDefaults for local persistence
            UserDefaults.standard.set(savedSpicesData, forKey: userDefaultsKey)
        } else {
            print("No saved spices found in iCloud.")
        }
        
        // Ensure spices array has container numbers 1-10
        ensureDefaultSpices()
    }
    
    // Function to ensure default spices with container numbers 1-10 exist
    private func ensureDefaultSpices() {
        var needsSaving = false
        
        for containerNumber in 1...10 {
            if !spices.contains(where: { $0.containerNumber == containerNumber }) {
                let newSpice = Spice(containerNumber: containerNumber)
                spices.append(newSpice)
                spiceData.append(newSpice)
                needsSaving = true // Mark that we need to save the new default spices
            }
        }
        
        if needsSaving {
            // Sort the spices by container number and save
            spices.sort { $0.containerNumber < $1.containerNumber }
            spiceData.sort { $0.containerNumber < $1.containerNumber }
            saveSpices()
        }
    }
    
    // Function to update the spice name
    public func updateSpiceName(containerNumber: Int, newName: String) {
        if let index = spices.firstIndex(where: { $0.containerNumber == containerNumber }) {
            spices[index].name = newName
            spiceData[index].name = newName
            saveSpices()
            print("Updated spice name to \(newName) for containerNumber \(containerNumber).")
        }
    }
    
    // Function to update a spice amount by container number
    public func updateSpice(containerNumber: Int, newAmount: Double, newUnit: String) {
        if let index = spices.firstIndex(where: { $0.containerNumber == containerNumber }) {
            spices[index].updateSpiceAmount(amount: newAmount, unit: newUnit)
            
            print("Updated spice data:")
            print("Container Number: \(containerNumber)")
            print("Amount: \(newAmount) \(newUnit)")
            
            spiceData[index] = spices[index]
        } else {
            let newSpice = Spice(containerNumber: containerNumber)
            spices.append(newSpice)
            spiceData.append(newSpice)
            
            print("Added new spice:")
            print("Container Number: \(containerNumber)")
            print("Amount: \(newSpice.spiceAmount) \(newSpice.unit)")
        }
        
        // Sort the spices by container number
        spices.sort { $0.containerNumber < $1.containerNumber }
        spiceData.sort { $0.containerNumber < $1.containerNumber }
        
        saveSpices()
    }

    // New function to update a spice amount by container number in ounces
    public func updateSpiceAmountInOunces(containerNumber: Int, newAmountInOunces: Double) {
        updateSpice(containerNumber: containerNumber, newAmount: newAmountInOunces, newUnit: "oz")
    }

    // Function to handle bulk updates of spice data, e.g., when multiple spices are updated
    public func updateAllSpices(newSpiceData: [Spice]) {
        for newSpice in newSpiceData {
            updateSpice(containerNumber: newSpice.containerNumber, newAmount: newSpice.spiceAmount, newUnit: newSpice.unit)
        }
    }
}


// Now you can declare spiceData globally
public var spiceData: [Spice] = []
