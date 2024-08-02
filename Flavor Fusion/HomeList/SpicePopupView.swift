//
//  SpicePopupView.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI

/// A view that displays detailed information about a selected spice.
///
/// `SpicePopupView` shows the name, container number, and recipes containing the selected spice.
/// It provides a close button to dismiss the view.
///
/// - Parameters:
///   - spice: The selected spice to display details for.
///   - recipes: A list of recipes that may contain the selected spice.
///   - isPresented: A binding to control the presentation of the popup.
struct SpicePopupView: View {
    let spice: Spice
    let recipes: [Recipe]
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    SpiceIndicator(amount: spice.spiceAmount, isSelected: true)
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Spice: \(spice.name)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Text("Container Number: \(spice.containerNumber)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                Text("Recipes:")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(recipes.filter { recipe in
                        recipe.ingredients.contains { ingredient in
                            ingredient.name == spice.name
                        }
                    }) { recipe in
                        Text(recipe.name)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Spice Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}
