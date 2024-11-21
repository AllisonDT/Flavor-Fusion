//
//  AddRecipeSpiceView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 10/8/24.
//

import SwiftUI

/// A view for selecting and configuring spice amounts for a recipe.
///
/// `AddRecipeSpiceView` allows users to select a spice, specify its amount using whole and fractional values,
/// and choose the unit of measurement. It updates the selected spices with their corresponding amounts
/// and units, maintaining a list of spices and their quantities for the recipe.
///
/// - Parameters:
///   - spice: A binding to the spice being added or edited.
///   - selectedSpices: A binding to a dictionary of selected spices and their corresponding amounts and units.
struct AddRecipeSpiceView: View {
    @Binding var spice: Spice
    @Binding var selectedSpices: [Spice: (Double, String)]

    @State private var wholeAmount = 1
    @State private var fractionalAmount = ""
    
    let spiceQuantities = Array(0...9)
    let fractions = ["", "⅞", "¾", "⅝", "½", "⅜", "¼", "⅛"]
    let fractionValues: [String: Double] = ["⅞": 0.875, "¾": 0.75, "⅝": 0.625, "½": 0.5, "⅜": 0.375, "¼": 0.25, "⅛": 0.125, "": 0]
    let unitOptions: [String]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if self.selectedSpices.keys.contains(spice) {
                        self.selectedSpices.removeValue(forKey: spice)
                    } else {
                        self.selectedSpices[spice] = (1, unitOptions.first ?? "t")
                    }
                }) {
                    Image(systemName: self.selectedSpices.keys.contains(spice) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(self.selectedSpices.keys.contains(spice) ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())

                Text(spice.name)
                    .foregroundColor(.primary)
                    .font(.body)

                Spacer()
            }

            if self.selectedSpices.keys.contains(spice) {
                HStack {
                    Picker(selection: $wholeAmount, label: Text("Whole Amount")) {
                        ForEach(spiceQuantities, id: \.self) { quantity in
                            Text("\(quantity)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .clipped()

                    Picker(selection: $fractionalAmount, label: Text("Fractional Amount")) {
                        ForEach(fractions, id: \.self) { fraction in
                            Text("\(fraction)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .clipped()

                    Picker(selection: Binding(
                        get: { self.selectedSpices[spice]?.1 ?? "t" },
                        set: { self.selectedSpices[spice]?.1 = $0 }
                    ), label: Text("Unit")) {
                        ForEach(unitOptions, id: \.self) { unit in
                            Text(unit == "t" ? "tsp" : "tbsp")
                                .font(.caption)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .clipped()
                    .labelsHidden()
                }
                .onChange(of: wholeAmount) {
                    updateSelectedSpiceAmount()
                }
                .onChange(of: fractionalAmount) {
                    updateSelectedSpiceAmount()
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        )
        .padding(.vertical, 5)
    }

    private func updateSelectedSpiceAmount() {
        let fractionValue = fractionValues[fractionalAmount] ?? 0
        let totalAmount = Double(wholeAmount) + fractionValue
        selectedSpices[spice]?.0 = totalAmount
    }
}
