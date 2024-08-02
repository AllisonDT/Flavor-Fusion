//
//  SpiceRow.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/24/24.
//

import SwiftUI

/// A view that displays a row representing a spice.
///
/// `SpiceRow` shows the spice's name, container number, and a fullness indicator.
/// Tapping on the row presents a detailed view in a popup.
///
/// - Parameters:
///   - spice: The spice to display in the row.
///   - isSelecting: A boolean indicating if the selection mode is active.
///   - recipes: A list of recipes that may contain the spice.
///   - onTap: A closure that is called when the spice row is tapped.
struct SpiceRow: View {
    let spice: Spice
    let isSelecting: Bool
    let recipes: [Recipe]
    var onTap: (Bool) -> Void

    @State private var isShowingPopup = false

    var body: some View {
        Button(action: {
            isShowingPopup.toggle()
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(spice.name)
                        .foregroundColor(spice.isSelected ? .blue : .primary)
                    
                    Spacer()
                    
                    // Display container number
                    Text("Container: \(spice.containerNumber)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .padding()
                
                Spacer()
                
                // Fullness indicator resembling a spice bottle
                ZStack(alignment: .bottom) {
                    Capsule()
                        .frame(width: 20, height: 60)
                        .foregroundColor(Color.gray.opacity(0.3))
                    Capsule()
                        .frame(width: 20, height: 60 * CGFloat(spice.spiceAmount))
                        .foregroundColor(Color.blue)
                }
                .padding(.trailing, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 8) // Rounded rectangle shape
                    .fill(Color(UIColor.systemBackground)) // Background color of the rounded rectangle
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $isShowingPopup) {
            SpicePopupView(spice: spice, recipes: recipes, isPresented: $isShowingPopup)
        }
    }
}
