//
//  BlendingView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 7/13/24.
//

import SwiftUI

/// A view that displays a blending progress message and a button to complete the blending process.
///
/// `BlendingView` shows a "Blending..." message, a progress indicator, and listens for a boolean from the Arduino
/// to trigger the blend completion process.
struct BlendingView: View {
    let spiceName: String
    let servings: Int
    let ingredients: [Ingredient]
    let onComplete: () -> Void
    
    @EnvironmentObject var bleManager: BLEManager  // Access the BLEManager instance

    var body: some View {
        VStack {
            Text("Blending...")
                .font(.largeTitle)
                .padding(.top)

            ProgressView()
                .padding()

            Spacer()
        }
        .padding()
        .onAppear {
            bleManager.isOrderMixed = false
            print("Spice Name: \(spiceName)")
            print("Servings: \(servings)")
            print("Ingredients:")
            for ingredient in ingredients {
                print("- \(ingredient.name): \(ingredient.amount) \(ingredient.unit)")

                // Convert to ounces before serialization
                let amountInOunces = convertToOunces(amount: ingredient.amount, unit: ingredient.unit)
                print("- Converted amount in ounces: \(amountInOunces)")
            }

            // Serialize the ingredients array to a custom delimited string in ounces
            let serializedIngredients = ingredients.map { "\(String(describing: $0.containerNumber)):\(convertToOunces(amount: $0.amount, unit: $0.unit))" }.joined(separator: ";")

            // Append the end marker "#END" to signal completion
            let fullSerializedIngredients = serializedIngredients + ";#END"

            print("Serialized Ingredients String: \(fullSerializedIngredients)")
            print("Size of Serialized String in bytes: \(fullSerializedIngredients.lengthOfBytes(using: .utf8))")

            // Send the serialized string over Bluetooth using BLEManager
            if let serializedData = fullSerializedIngredients.data(using: .utf8) {
                bleManager.sendSpiceDataToPeripheral(data: serializedData)
            } else {
                print("Failed to encode ingredients string.")
            }
        }

        .onChange(of: bleManager.isOrderMixed) {
            if bleManager.isOrderMixed {
                // If the boolean becomes true, schedule the blend completion notification and call onComplete()
                scheduleBlendCompletionNotification()
                onComplete()
            }
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
    
    // Function to schedule the blend completion notification
    private func scheduleBlendCompletionNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Blend Complete!"
        content.body = "Your blend is ready. Have a spicy day!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Immediate notification
        let request = UNNotificationRequest(identifier: "BlendCompleteNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}

#Preview {
    BlendingView(spiceName: "Example Spice", servings: 1, ingredients: [
        Ingredient(name: "Salt", amount: 1.0, unit: "T", containerNumber: 1)
    ], onComplete: {})
        .environmentObject(BLEManager(spiceDataViewModel: SpiceDataViewModel()))
}
