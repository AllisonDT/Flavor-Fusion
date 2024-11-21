//
//  NewBlendSpiceView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/9/24.
//

import SwiftUI

/// A view that displays a spice item for selection in a new blend.
///
/// `NewBlendSpiceView` shows the spice name and allows users to select the spice
/// and choose an amount if selected. It reflects changes immediately using a binding.
///
/// - Parameters:
///   - spice: A binding to the spice item being displayed.
///   - onSelect: A closure that is called when the spice is selected or deselected.
struct NewBlendSpiceView: View {
    @Binding var spice: Spice
    let onSelect: (Bool) -> Void

    @State private var wholeAmount: Int = 1
    @State private var fraction: String = ""
    @State private var unit: String = "Tsp"
    
    private let wholeAmounts = Array(0...9)
    private let fractions = ["", "⅞", "¾", "⅝", "½", "⅜", "¼", "⅛"]
    private let units = ["Tsp", "Tbsp"]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Button(action: {
                    spice.isSelected.toggle()
                    onSelect(spice.isSelected)
                    if spice.isSelected {
                        updateSpice() // Update spice amount and unit when selected
                    }
                }) {
                    Image(systemName: spice.isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(spice.isSelected ? .green : .gray)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 8)
                }

                Text(spice.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.leading, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 6)
            .padding(.trailing, 8)

            if spice.isSelected {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 0) {
                        Picker("Whole Amount", selection: $wholeAmount) {
                            ForEach(wholeAmounts, id: \.self) { amount in
                                Text("\(amount)")
                                    .tag(amount)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                        .clipped()
                        .onChange(of: wholeAmount) {
                            updateSpice()
                        }
                        
                        Picker("Fractional Amount", selection: $fraction) {
                            ForEach(fractions, id: \.self) { fraction in
                                Text(fraction)
                                    .tag(fraction)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                        .clipped()
                        .onChange(of: fraction) {
                            updateSpice()
                        }
                        
                        Picker("Unit", selection: $unit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit)
                                    .font(.caption) // Make the font smaller
                                    .tag(unit)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                        .clipped()
                        .labelsHidden() // Hide the picker label
                        .onChange(of: unit) {
                            updateSpice()
                        }
                    }
                    
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }
    
    private func updateSpice() {
        let totalAmount = Double(wholeAmount) + fractionValue(fraction: fraction)
        let unitSuffix = unit == "Tsp" ? "t" : "T"
        spice.selectedAmount = totalAmount
        spice.unit = unitSuffix
        
        // Print the selected amount and unit to the console
        print("Selected amount for \(spice.name): \(totalAmount) \(unitSuffix)")
    }

    private func fractionValue(fraction: String) -> Double {
        switch fraction {
        case "0": return 0
        case "½": return 0.5
        case "¼": return 0.25
        case "⅛": return 0.125
        case "⅞": return 0.875
        case "¾": return 0.75
        case "⅝": return 0.625
        case "⅜": return 0.375
        default: return 0
        }
    }
}
