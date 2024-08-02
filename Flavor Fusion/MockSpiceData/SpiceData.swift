//
//  SpiceData.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 2/5/24.
//

import Foundation

// Spice Data Model
public struct Spice: Identifiable, Equatable, Hashable {
    public let id = UUID()
    public var name: String
    public var spiceAmount: Double
    public var isSelected: Bool = false
    public var selectedAmount: Double
    public var containerNumber: Int

    public init(name: String, spiceAmount: Double, selectedAmount: Double, containerNumber: Int) {
        self.name = name
        self.spiceAmount = spiceAmount
        self.selectedAmount = selectedAmount
        self.containerNumber = containerNumber
    }
}

// Array of Spice Data
public var spiceData = [
    Spice(name: "Spice 1", spiceAmount: 1.0, selectedAmount: 0.0, containerNumber: 1),
    Spice(name: "Spice 2", spiceAmount: 0.5, selectedAmount: 0.0, containerNumber: 2),
    Spice(name: "Spice 3", spiceAmount: 0.25, selectedAmount: 0.0, containerNumber: 3),
    Spice(name: "Spice 4", spiceAmount: 0.8, selectedAmount: 0.0, containerNumber: 4),
    Spice(name: "Spice 5", spiceAmount: 0.3, selectedAmount: 0.0, containerNumber: 5),
    Spice(name: "Spice 6", spiceAmount: 0.6, selectedAmount: 0.0, containerNumber: 6),
    Spice(name: "Spice 7", spiceAmount: 0.2, selectedAmount: 0.0, containerNumber: 7),
    Spice(name: "Spice 8", spiceAmount: 0.9, selectedAmount: 0.0, containerNumber: 8),
    Spice(name: "Spice 9", spiceAmount: 0.4, selectedAmount: 0.0, containerNumber: 9),
    Spice(name: "Spice 10", spiceAmount: 0.7, selectedAmount: 0.0, containerNumber: 10)
]
