//
//  BlendConfirmationView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/13/24.
//

import SwiftUI

/// A view that displays the spice blend confirmation details and a confirm button.
///
/// `BlendConfirmationView` shows the blend name, the number of servings, and the list of ingredients specified by the user.
/// Below the details, a "Confirm" button allows the user to proceed with the blending process.
///
/// - Parameters:
///   - spiceName: The name of the spice blend provided by the user.
///   - servings: The number of servings selected by the user.
///   - ingredients: The list of ingredients to be included in the blend.
///   - onConfirm: A closure that is called when the "Confirm" button is pressed.
struct BlendConfirmationView: View {
    let spiceName: String
    let servings: Int
    let ingredients: [Ingredient]
    let onConfirm: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var spiceDataViewModel: SpiceDataViewModel
    @EnvironmentObject var bleManager: BLEManager // Inject BLEManager as an environment object
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Blend Created")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    
                    Group {
                        Text("Spice Name")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(spiceName)
                            .font(.title2)
                            .padding(.bottom)
                        
                        Text("Servings")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("\(servings)")
                            .font(.title2)
                            .padding(.bottom)
                        
                        Text("Ingredients")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(ingredients, id: \.name) { ingredient in
                                HStack {
                                    Text("\(ingredient.name):")
                                        .font(.body)
                                    Spacer()
                                    Text("\(formatAmount(amount: ingredient.amount, unit: ingredient.unit))")
                                        .font(.body)
                                }
                                .padding(.leading, 10)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    Spacer()
                    Button(action: {
                        if bleManager.isBluetoothConnected && bleManager.connectedPeripheral != nil {
                            if subtractSpicesInOunces() {
                                onConfirm()
                            } else {
                                showAlert = true
                            }
                        } else {
                            showAlert = true
                            alertMessage = "Please turn on Bluetooth or plug in the device."
                        }
                    }) {
                        Text("Confirm")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Warning"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Confirmation", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }

    private func formatAmount(amount: Double, unit: String) -> String {
        let fraction = convertToFraction(amount: amount)
        return "\(fraction) \(unit == "t" ? "tsp" : "tbsp")"
    }

    private func convertToFraction(amount: Double) -> String {
        let tolerance = 1.0 / 64.0 // To account for rounding errors
        let number = amount
        var lowerNumerator = 0
        var lowerDenominator = 1
        var upperNumerator = 1
        var upperDenominator = 0
        var middleNumerator = 1
        var middleDenominator = 1
        
        while true {
            let middle = Double(middleNumerator) / Double(middleDenominator)
            if abs(middle - number) < tolerance {
                break
            } else if middle < number {
                lowerNumerator = middleNumerator
                lowerDenominator = middleDenominator
            } else {
                upperNumerator = middleNumerator
                upperDenominator = middleDenominator
            }
            middleNumerator = lowerNumerator + upperNumerator
            middleDenominator = lowerDenominator + upperDenominator
        }

        let wholeNumber = Int(amount)
        let remainderNumerator = middleNumerator - wholeNumber * middleDenominator

        if wholeNumber > 0 {
            return remainderNumerator > 0 ? "\(wholeNumber) \(remainderNumerator)/\(middleDenominator)" : "\(wholeNumber)"
        } else {
            return "\(middleNumerator)/\(middleDenominator)"
        }
    }

    private func convertToOunces(amount: Double, unit: String) -> Double {
        switch unit {
        case "t":
            return amount / 6.0 // 1 tsp = 1/6 oz
        case "T":
            return amount / 2.0 // 1 tbsp = 1/2 oz
        default:
            return amount
        }
    }

    private func subtractSpicesInOunces() -> Bool {
        var sufficientSpices = true
        for ingredient in ingredients {
            let amountInOunces = convertToOunces(amount: ingredient.amount, unit: ingredient.unit)
            
            if let spiceIndex = spiceDataViewModel.spices.firstIndex(where: { $0.name == ingredient.name }) {
                let currentAmount = spiceDataViewModel.spices[spiceIndex].spiceAmount
                let updatedAmount = currentAmount - amountInOunces
                
                if updatedAmount >= 0 {
                    spiceDataViewModel.updateSpiceAmountInOunces(containerNumber: spiceDataViewModel.spices[spiceIndex].containerNumber, newAmountInOunces: updatedAmount)
                } else {
                    sufficientSpices = false
                    DispatchQueue.main.async {
                        alertMessage = "Insufficient spice in container \(spiceDataViewModel.spices[spiceIndex].containerNumber) for \(ingredient.name). Please refill the container."
                    }
                    break
                }
            } else {
                sufficientSpices = false
                DispatchQueue.main.async {
                    alertMessage = "Spice \(ingredient.name) not found."
                }
                break
            }
        }
        return sufficientSpices
    }
}
