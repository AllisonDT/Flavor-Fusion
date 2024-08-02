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
    @Binding var spice: Spice // Use Binding to reflect changes immediately
    let onSelect: (Bool) -> Void

    @State private var spiceAmount: Int = 1
    private let spiceAmounts = Array(1...10)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Button(action: {
                    onSelect(!spice.isSelected) // Toggle isSelected state
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

            // Show spice amount picker only when the spice is selected
            if spice.isSelected {
                HStack {
                    Text("Amount:")
                        .font(.subheadline)
                        .padding(.leading, 8)
                    
                    Picker("Amount", selection: $spiceAmount) {
                        ForEach(spiceAmounts, id: \.self) { amount in
                            Text("\(amount)")
                                .tag(amount)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8) // Matching corner radius
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .gray, radius: 2, x: 0, y: 2) // Matching shadow
        )
        .padding(.vertical, 4)
    }
}
